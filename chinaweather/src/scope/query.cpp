#include <boost/algorithm/string/trim.hpp>

#include <scope/query.h>

#include <unity/scopes/Annotation.h>
#include <unity/scopes/CategorisedResult.h>
#include <unity/scopes/CategoryRenderer.h>
#include <unity/scopes/QueryBase.h>
#include <unity/scopes/SearchReply.h>

#include <iomanip>
#include <sstream>

#include <QDebug>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QCoreApplication>


const QString BASE_URI = "http://api.map.baidu.com/telematics/v3/weather?location=%1&output=xml&ak=DdzwVcsGMoYpeg5xQlAFrXQt";
const QString URI = "http://www.weather.com.cn/html/weather/101010100.shtml";

// add this one to avoid too many typing
using namespace unity::scopes;

namespace sc = unity::scopes;
namespace alg = boost::algorithm;

using namespace std;
using namespace api;
using namespace scope;

/**
 * Define the layout for theresults
 *
 * The icon size is medium, and ask for the card layout
 * itself to be horizontal. I.e. the text will be placed
 * next to the image.
 */
//const static string CATEGORY_TEMPLATE =
//        R"(
//{
//        "schema-version": 1,
//        "template": {
//        "category-layout": "grid",
//        "card-layout": "horizontal",
//        "card-size": "medium"
//        },
//        "components": {
//        "title": "title",
//        "art" : {
//        "field": "art"
//        },
//        "subtitle": "subtitle"
//        }
//        }
//        )";


std::string CAT_GRID = R"(
{
    "schema-version" : 1,
    "template" : {
        "category-layout" : "vertical-journal",
        "card-layout": "horizontal",
        "card-size": "small",
        "collapsed-rows": 0
     },
    "components" : {
        "title" : "title",
        "subtitle":"subtitle",
        "summary":"summary",
        "art":{
            "field": "art2",
            "aspect-ratio": 1
        }
    }
 } )";

//Create a JSON string to be used tro create a category renderer - uses carousel layout
std::string CR_CAROUSEL = R"(
    {
        "schema-version" : 1,
        "template" : {
            "category-layout" : "carousel",
            "card-size": "large",
            "overlay" : true
        },
        "components" : {
            "title" : "title",
            "art" : {
                "field": "art",
                "aspect-ratio": 1.6,
                "fill-mode": "fit"
            }
        }
    }
)";
Query::Query(const sc::CannedQuery &query, const sc::SearchMetadata &metadata,
             Config::Ptr config) :
    sc::SearchQueryBase(query, metadata), client_(config) {
}

void Query::cancelled() {
    client_.cancel();
}

void Query::run(sc::SearchReplyProxy const& reply) {
    /* This is where the actual processing of the current search query takes place.
     * It's where you may want to query a local or remote data source for results
     * matching the query.*/

    // Trim the query string of whitespace
    const CannedQuery &query(sc::SearchQueryBase::query());
    string query_string = alg::trim_copy(query.query_string());

    if ( query_string.empty() ) {
        query_string = "北京";
    }

    QString queryUri = BASE_URI.arg(query_string.c_str());
    qDebug() << "queryUrl: " << queryUri;

    // Generate a network request to the OpenClipArt server and parse the result
    QEventLoop loop;

    QNetworkAccessManager manager;
    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), &loop, SLOT(quit()));
    QObject::connect(&manager, &QNetworkAccessManager::finished,
                     [reply, query_string, this](QNetworkReply *msg){
        QByteArray data = msg->readAll();

        qDebug() << "XML data is: " << data.data();

        Query::rssImporter(data,reply, QString::fromStdString(query_string));

     });

    // The query is the search string and was passed to this Query object's constructor by the client
    // Empty search string yields no results with openclipart API.
    manager.get(QNetworkRequest(QUrl(queryUri)));
    loop.exec();
}

void Query::rssImporter(QByteArray &data, unity::scopes::SearchReplyProxy const& reply, QString title) {
    QDomElement docElem;
    QDomElement rootElem;
    QDomDocument xmldoc;

    QString query = title;
    qDebug() << "query string: " << query;

    if ( !xmldoc.setContent(data) ) {
        qWarning()<<"Error importing data";
        return;
    }

    rootElem = xmldoc.documentElement();

    // Shows the CityWeatherResponse
    qDebug() << "TagName: " << rootElem.tagName();

    // Find CityWeatherResponse
    docElem = rootElem.firstChildElement("date");
    if (docElem.isNull()) {
        qWarning()<< "Error in data," << "CityWeatherResponse" << " not found";
        return;
    }

    QString date = docElem.text();
    qDebug() << "date: " << date;

    int indexYear = date.indexOf("-");
    QString year = date.left(indexYear);

    // Get the month
    int indexMonth = date.indexOf("-", indexYear + 1);
    QString month = date.mid(indexYear + 1, indexMonth - indexYear - 1);
    // Get the day
    QString day = date.right(date.length() - indexMonth - 1);
    QDate qDate( year.toInt(), month.toInt(), day.toInt());
    qDebug() << "Date: " << qDate.toString();

    docElem = rootElem.firstChildElement("results");

    QDomElement sum = docElem.firstChildElement("index");
    QString summary = getSummary(sum);
    qDebug() << "summary: " << summary;

    QString pmiIndex = docElem.firstChildElement("pm25").text();
    qDebug() << "PMI index: "  << pmiIndex;

    QDomElement cityElem = docElem.firstChildElement("currentCity");
    QString city = cityElem.text();
    qDebug() << "city: " << city;

    docElem = docElem.firstChildElement("weather_data");

    QDomNodeList dateList = docElem.elementsByTagName("date");

    // Below is also a way to get the list of the dates
    int count = dateList.count();
    for ( int i = 0; i < count; i ++ ) {
        QDomNode node = dateList.at(i);
        qDebug() << "date: " << node.toElement().text();
    }

    /* We're now registering (creating) two new categoryies, one with grid layout, the other wiht carousel.
     * Categories can be created at any point
     * during query processing inside the run method, but it's recommended
     * to create them as soon as possible (ideally as soon as they are known to the scope) */
    CategoryRenderer rdrGrid(CAT_GRID);
    CategoryRenderer rdrCarousel(CR_CAROUSEL);

    auto catCar = reply->register_category("openclipartcarousel", city.toStdString(), "", rdrCarousel);
    auto catGrid = reply->register_category("Chineweather", "", "", rdrGrid);


    QDomElement result = docElem.firstChildElement("date");
    int index = 0;

    bool done = false;

    while (!result.isNull()) {
        QString date = result.text();
        qDebug() << "date: " << date;

        QString dayPictureUrl = result.nextSiblingElement("dayPictureUrl").text();
        qDebug() << "dayPictureUrl: " << dayPictureUrl;

        QString nightPictureUrl = result.nextSiblingElement("nightPictureUrl").text();
        qDebug() << "nightPictureUrl: " << nightPictureUrl;

        QString weather = result.nextSiblingElement("weather").text();
        qDebug() << "weather: " << weather;

        QString wind = result.nextSiblingElement("wind").text();
        qDebug() << "wind: " << wind;

        QString temperature = result.nextSiblingElement("temperature").text();
        qDebug() << "temperature: " << temperature;

        result = result.nextSiblingElement("date");

        QString daytime;
        daytime.append("白天: ");
        daytime.append(qDate.addDays(index).toString("ddd yyyy.MM.dd"));

        CategorisedResult catres(catCar);

        // Set the picture for the day
        catres.set_uri(URI.toStdString());
        catres.set_dnd_uri(URI.toStdString());

        catres.set_title(daytime.toStdString());
        catres.set_art(dayPictureUrl.toStdString());

        // Add some extra data, and they will be shown in the preview
        catres["weather"] = Variant(weather.toStdString());
        catres["temperature"] = Variant(temperature.toStdString());
        catres["wind"] = Variant(wind.toStdString());

        //push the categorized result to the client
        if (!reply->push(catres)) {
            break; // false from push() means search waas cancelled
        }

        // Set the picture for the night
        catres.set_uri(URI.toStdString());
        catres.set_dnd_uri(URI.toStdString());

        QString nighttime;
        nighttime.append("晚上: ");
        // nighttime.append(date1);
        nighttime.append(qDate.addDays(index).toString("ddd yyyy.MM.dd"));

        catres.set_title(nighttime.toStdString());
        catres.set_art(nightPictureUrl.toStdString());

        //push the categorized result to the client
        if (!reply->push(catres)) {
            break; // false from push() means search waas cancelled
        }

        if ( index == 0 && !done ) {
            CategorisedResult catres(catGrid);

            // we handle it specially for today
            catres.set_uri(URI.toStdString());
            catres.set_art(dayPictureUrl.toStdString());

            QString sub = weather + " " + " " + temperature + " " + wind + "  PMI: " + pmiIndex;
            catres["subtitle"] = sub.toStdString();
            catres["weather"] = Variant(sub.toStdString());
            catres["summary"]= summary.toStdString();
            catres["wind"] = Variant(summary.toStdString());

            QDateTime current = QDateTime::currentDateTime();\
            QTime time = current.time();

            QString daytime;
            if ( time.hour() > 6 && time.hour() < 18 ) {
                catres["art2"] = dayPictureUrl.toStdString();
                daytime.append("白天: ");
                daytime.append(qDate.addDays(index).toString("ddd yyyy.MM.dd"));
            } else {
                catres["art2"] = nightPictureUrl.toStdString();
                daytime.append("晚上: ");
                daytime.append(qDate.addDays(index).toString("ddd yyyy.MM.dd"));
            }

            catres.set_title(daytime.toStdString());

            if (!reply->push(catres)) {
                break; // false from push() means search waas cancelled
            }

            done = true;
            continue;
        }

        index ++;

       qDebug() <<  "============================================";
    }

    qDebug()<<"parsing ended";
}

// This function is used to get the summary of the day
QString Query::getSummary(QDomElement &docElem) {
    QDomElement result = docElem.firstChildElement("title");

    QString summary;
    while (!result.isNull()) {
        summary += result.text() + ": ";
        summary += result.nextSiblingElement("zs").text() + ", ";
        summary += result.nextSiblingElement("tipt").text() + ", ";
        summary += result.nextSiblingElement("des").text() + "\n";

        result = result.nextSiblingElement("title");
    }

    return summary;
}



