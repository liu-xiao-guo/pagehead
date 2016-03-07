#include <boost/algorithm/string/trim.hpp>

#include <scope/query.h>

#include <unity/scopes/Annotation.h>
#include <unity/scopes/CategorisedResult.h>
#include <unity/scopes/CategoryRenderer.h>
#include <unity/scopes/QueryBase.h>
#include <unity/scopes/SearchReply.h>

#include <iomanip>
#include <sstream>

#include <unity/scopes/SearchMetadata.h>

#include <QNetworkDiskCache>
#include <QDebug>
#include <QEventLoop>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QDomElement>
#include <QDomDocument>

// You have to apply for your own developer account on dianping website
const QString appkey =  "3562917596";
const QString secret = "091bf584e9d24edbbf48971d65307be3";

const QString BASE_URI = "http://api.dianping.com/v1/business/find_businesses?";
const QString DEPARTMENTS = "http://api.dianping.com/v1/metadata/get_categories_with_businesses?";
const QString DEFAULT_LATITUDE = "39.9698";
const QString DEFAULT_LONGITUDE = "116.446";
auto TOP_DEPT_NAME = "categories";
auto CATEGORY_HEADER = "";
auto CATEGORY_SEARCH = "";
auto ERROR_TITLE = "";
const auto HOME_URL = "http://m.dianping.com/";
auto ERROR_Connection = "Error in connection";

namespace sc = unity::scopes;
namespace alg = boost::algorithm;

using namespace std;
using namespace api;
using namespace scope;
using namespace unity::scopes; // added

#define qstr(s) QString::fromStdString((s))

std::string CR_GRID = R"(
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
})";

//Create a JSON string to be used tro create a category renderer - uses carousel layout
std::string CR_CAROUSEL = R"(
    {
        "schema-version" : 1,
        "template" : {
            "category-layout" : "carousel",
            "card-size": "small",
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

std::string ERROR_GRID = R"(
{
        "schema-version" : 1,
            "template" : {
            "category-layout" : "grid",
            "card-layout": "horizontal",
        "card-size": "small"
        },
        "components" : {
            "title" : "title",
            "mascot":"art2",
            "art" : {
                "field": "art",
                "aspect-ratio": 1.6,
                "fill-mode": "fit"
            }
       }
})";

Query::Query(const sc::CannedQuery &query, const sc::SearchMetadata &metadata, QString const& scopeDir,
        QString const& cacheDir, Config::Ptr config) :
        sc::SearchQueryBase( query, metadata ),
        m_scopeDir( scopeDir ),
        m_cacheDir( cacheDir ),
        m_limit( 20 ),
        client_(config)
{
    qDebug() << "CacheDir: " << m_cacheDir;
    qDebug() << "ScopeDir " <<  m_scopeDir;

    QMap<QString,QString> map;
    map["format"] = "xml";

    m_urlRSS = getUrl(DEPARTMENTS,  map);
    qDebug() << "m_urlRSS: " << m_urlRSS;

    m_errorImage = "file://"+ m_scopeDir + "/images/error.png";
}

void Query::cancelled() {
    client_.cancel();
}

void Query::run(sc::SearchReplyProxy const& reply) {
    qDebug() <<  "Run is started .............................!";

    // Initialize the scopes
    initScope();

    // Get the current location of the search
    auto metadata = search_metadata();
    if ( metadata.has_location() ) {
        qDebug() << "Location is supported!";
        auto location = metadata.location();

        if ( location.has_altitude()) {
            cerr << "altitude: " << location.altitude() << endl;
            cerr << "longitude: " << location.longitude() << endl;
            cerr << "latitude: " << location.latitude() << endl;
            auto latitude = std::to_string(location.latitude());
            auto longitude = std::to_string(location.longitude());
            m_longitude = QString::fromStdString(longitude);
            m_latitude = QString::fromStdString(latitude);
        }

        if ( m_longitude.isEmpty() ) {
            m_longitude = DEFAULT_LONGITUDE;
        }
        if ( m_latitude.isEmpty() ) {
            m_latitude = DEFAULT_LATITUDE;
        }

        qDebug() << "m_longitude1: " << m_longitude;
        qDebug() << "m_latitude1: " << m_latitude;
    } else {
        qDebug() << "Location is not supported!";
        m_longitude = DEFAULT_LONGITUDE;
        m_latitude = DEFAULT_LATITUDE;
    }

//    qDebug() << "locale: " << QString::fromStdString(metadata.locale());
//    qDebug() << "form factor: " << QString::fromStdString(metadata.form_factor());

    // Create an instance of disk cache and set cache directory
    m_diskCache = new QNetworkDiskCache();
    m_diskCache->setCacheDirectory(m_cacheDir);

    QEventLoop loop;

    QNetworkAccessManager managerDepts;
    QObject::connect(&managerDepts, SIGNAL(finished(QNetworkReply*)), &loop, SLOT(quit()));
    QObject::connect(&managerDepts, &QNetworkAccessManager::finished,
                     [reply,this](QNetworkReply *msg){
        if( msg->error()!= QNetworkReply::NoError ){
            qWarning() << "failed to retrieve raw data, error:" << msg->error();
            rssError(reply,ERROR_Connection);
            return;
        }
        QByteArray data = msg->readAll();

        // qDebug() << "XML data is: " << data.data();

        rssDepartments( data, reply );
        QString deptUrl = m_rootUrl;

        CannedQuery cannedQuery = query();
        qDebug() << "to_uri: " << QString::fromStdString(cannedQuery.to_uri());
        qDebug() << "scope_id: " << QString::fromStdString(cannedQuery.scope_id());
        qDebug() << "department_id: " << QString::fromStdString(cannedQuery.department_id());

        QString deptId = qstr(cannedQuery.department_id());
        qDebug() << "department id: " << deptId;

        qDebug() << "deptUrl: " << deptUrl;

        if (!query().department_id().empty()){ // needs departments support
            qDebug() << "it is not empty xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!";
            deptUrl = QString::fromStdString(query().department_id());
            qDebug() << "depatUrl: " << deptUrl;
        } else {
            qDebug() << "It is empty ===================================!";
        }

        if ( deptUrl.isEmpty() )
            return;

        QEventLoop loop;
        QNetworkAccessManager managerRSS;
        QObject::connect( &managerRSS, SIGNAL(finished(QNetworkReply*)), &loop, SLOT(quit()));
        QObject::connect( &managerRSS, &QNetworkAccessManager::finished,
                         [reply,this](QNetworkReply *msg ){
            if( msg->error() != QNetworkReply::NoError ){
                qWarning() << "failed to retrieve specific dept raw data, error:" <<msg->error();
                rssError( reply, ERROR_Connection );
                return;
            }

            QByteArray data = msg->readAll();
            if( query().query_string().empty() ){
                rssImporter( data, reply, CATEGORY_HEADER );
            } else {
                rssImporter( data, reply, CATEGORY_SEARCH );
            }

        });
        managerRSS.setCache( m_diskCache );
        managerRSS.get( QNetworkRequest( QUrl(deptUrl)) );
        loop.exec();

    });
    managerDepts.setCache(m_diskCache);
    managerDepts.get(QNetworkRequest(QUrl(m_urlRSS)));
    loop.exec();
}

void Query::rssError( unity::scopes::SearchReplyProxy const& reply, std::string error_message ) {
    CategoryRenderer rssError( ERROR_GRID );
    auto errorGrid = reply->register_category( "1", ERROR_TITLE, "", rssError );
    CategorisedResult res( errorGrid );
    res.set_uri( HOME_URL );
    res[ "title" ] = error_message;
    res[ "previewTitle" ] = error_message;
    res[ "art2" ] = m_errorImage.toStdString();
    res[ "largepic" ] = m_errorImage.toStdString();
    res.set_dnd_uri( HOME_URL );
    reply->push( res );
}

QString Query::getUrl(QString addr, QMap<QString, QString> map) {
    QCryptographicHash generator(QCryptographicHash::Sha1);

    QString temp;
    temp.append(appkey);
    QMapIterator<QString, QString> i(map);
    while (i.hasNext()) {
        i.next();
        // qDebug() << i.key() << ": " << i.value();
        temp.append(i.key()).append(i.value());
    }

    temp.append(secret);

    qDebug() << temp;

    qDebug() << "UTF-8: " << temp.toUtf8();

    generator.addData(temp.toUtf8());
    QString sign = generator.result().toHex().toUpper();

    QString url;
    url.append(addr);
    url.append("appkey=");
    url.append(appkey);

    url.append("&");
    url.append("sign=");
    url.append(sign);

    i.toFront();
    while (i.hasNext()) {
        i.next();
        // qDebug() << i.key() << ": " << i.value();
        url.append("&").append(i.key()).append("=").append(i.value());
    }

    qDebug() << "Final url: " << url;
    return url;
}

QString Query::getDeptUrl(QString dept)
{
    QMap<QString, QString> map;

    map["category"] = dept;
    map["sort"] = "2";
    map["limit"] = QString::number(m_limit);
    map["platform"] = "2";
    map["format"] = "xml";

    qDebug() << "m_latitude: " << m_latitude;
    qDebug() << "m_longitude: " << m_longitude;

    map["latitude"] = m_latitude;
    map["longitude"] = m_longitude;

    return getUrl( BASE_URI, map );
}

void Query::rssDepartments( QByteArray &data, unity::scopes::SearchReplyProxy const& reply ) {
    QDomElement docElem;
    QDomDocument xmldoc;
    DepartmentList rss_depts;
    QString firstname = "";

    CannedQuery myquery( SCOPE_NAME );
    myquery.set_department_id( TOP_DEPT_NAME );

    Department::SPtr topDept;

    if ( !xmldoc.setContent(data) ) {
        qWarning()<<"Error importing data";
    }

    docElem = xmldoc.firstChildElement("results");
    if (docElem.isNull()) {
        qWarning() << "Error in data," << "results" << " not found";
    }

    docElem = docElem.firstChildElement("categories");
    if ( docElem.isNull() ) {
        qWarning() << "Error in data," << "categories" << " not found";
    }

    docElem = docElem.firstChildElement("category");

    while ( !docElem.isNull() ) {

        QString category = docElem.attribute("name","");
        qDebug() << "category: " << category;

        if ( !category.isEmpty() ) {
            QString url = getDeptUrl(category);

            if (firstname.isEmpty()) {
                //Create the url here
                m_rootUrl = url;
                topDept = move(unity::scopes::Department::create( "",
                                                                  myquery, category.toStdString()));
            } else {
                Department::SPtr aDept = move( unity::scopes::Department::create( url.toStdString(),
                                              myquery, category.toStdString() ) );
                rss_depts.insert( rss_depts.end(), aDept );
            }
        }

        docElem = docElem.nextSiblingElement("category");
    }

    topDept->set_subdepartments( rss_depts );

     try {
        reply->register_departments( topDept );
    } catch (std::exception const& e) {
        qWarning() << "Error happened: " << e.what();
    }
}

void Query::rssImporter(QByteArray &data, unity::scopes::SearchReplyProxy const& reply, QString title) {
    QDomElement docElem;
    QDomDocument xmldoc;
    CannedQuery cannedQuery = query();
    QString query = qstr( cannedQuery.query_string() );

    if ( !xmldoc.setContent( data ) ) {
        qWarning()<<"Error importing data";
        return;
    }

    docElem = xmldoc.documentElement();
    //find result
    docElem = docElem.firstChildElement("businesses");
    if (docElem.isNull()) {
        qWarning()<<"Error in data,"<< "result" <<" not found";
        return;
    }

    CategoryRenderer rdrGrid(CR_GRID);
    CategoryRenderer rdrCarousel(CR_CAROUSEL);

    auto carousel = reply->register_category("dianpingcarousel", title.toStdString(), "", rdrCarousel);
    auto grid = reply->register_category("dianpinggrid", "", "", rdrGrid);
    bool isgrid = false;

    docElem = docElem.firstChildElement("business");

    while (!docElem.isNull()) {
        QString business_id = docElem.firstChildElement("business_id").text();
        // qDebug() << "business_id: " << business_id;

        QString name = docElem.firstChildElement("name").text();
        // qDebug() << "name: "  << name;

        // Let's get rid of the test info in the string
        name = removeTestInfo(name);

        QString branch_name = docElem.firstChildElement("branch_name").text();
        // qDebug() << "branch_name: " << branch_name;

        QString address = docElem.firstChildElement("address").text();
        // qDebug() << "address: " << address;

        QString telephone = docElem.firstChildElement("telephone").text();
        // qDebug() << "telephone: " << telephone;

        QString city = docElem.firstChildElement("city").text();
        // qDebug() << "city: " << city;

        QString photo_url = docElem.firstChildElement("photo_url").text();
        // qDebug() << "photo_url: " << photo_url;

        QString s_photo_url = docElem.firstChildElement("s_photo_url").text();
        // qDebug() << "s_photo_url: " << s_photo_url;

        QString rating_s_img_uri = docElem.firstChildElement("rating_s_img_uri").text();
        // qDebug() << "rating_s_img_uri: " << rating_s_img_uri;

        QString business_url = docElem.firstChildElement("business_url").text();
        // qDebug() << "business_url: " << business_url;

        QDomElement deals = docElem.firstChildElement("deals");
        QDomElement deal = deals.firstChildElement("deal");
        QString summary = deal.firstChildElement("description").text();
        // qDebug() << "Summary: " << summary;

        if ( !query.isEmpty() ) {
            if ( !name.contains( query, Qt::CaseInsensitive ) &&
                 !summary.contains( query, Qt::CaseInsensitive ) &&
                 !address.contains( query, Qt::CaseInsensitive ) ) {
                qDebug() << "it is going to be skipped";
                docElem = docElem.nextSiblingElement("business");
                continue;
            } else {
                qDebug() << "it is going to be listed!";
            }
        }

        docElem = docElem.nextSiblingElement("business");

        // for each result
        const std::shared_ptr<const Category> * top;

        if ( isgrid ) {
          top = &grid;
          isgrid = false;
        } else {
          isgrid = true;
          top = &carousel;
        }

        CategorisedResult catres((*top));

        catres.set_uri(business_url.toStdString());
        catres.set_dnd_uri(business_url.toStdString());
        catres.set_title(name.toStdString());
        catres["subtitle"] = address.toStdString();
        catres["summary"] = summary.toStdString();
        catres["fulldesc"] = summary.toStdString();
        catres.set_art(photo_url.toStdString());
        catres["art2"] = s_photo_url.toStdString();
        catres["address"] = Variant(address.toStdString());
        catres["telephone"] = Variant(telephone.toStdString());

        //push the categorized result to the client
        if (!reply->push(catres)) {
            break; // false from push() means search waas cancelled
        }
    }

    qDebug()<<"parsing ended";
}

// The following method is used to remove the
// "这是一条测试商户数据，仅用于测试开发，开发完成后请申请正式数据..." string
const QString TEST_STRING = "(这是一条测试商户数据，仅用于测试开发，开发完成后请申请正式数据...)";

QString Query::removeTestInfo(QString name)
{
    if ( name.contains(TEST_STRING) ) {
        int index = name.indexOf(TEST_STRING);
        QString newName = name.left(index);
        return newName;
    } else {
        qDebug() << "it does not contain the string";
        return name;
    }
}

// The followoing function is used to retrieve the settings for the scope
void Query::initScope()
{
    qDebug() << "Going to retrieve the settings!";

    unity::scopes::VariantMap config = settings();  // The settings method is provided by the base class
    if (config.empty())
        qDebug() << "CONFIG EMPTY!";

    m_limit = config["limit"].get_double();
    cerr << "limit: " << m_limit << endl;
}
