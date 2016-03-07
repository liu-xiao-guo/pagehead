#include <boost/algorithm/string/trim.hpp>

#include <scope/localization.h>
#include <scope/query.h>

#include <unity/scopes/Annotation.h>
#include <unity/scopes/CategorisedResult.h>
#include <unity/scopes/CategoryRenderer.h>
#include <unity/scopes/QueryBase.h>
#include <unity/scopes/SearchReply.h>

#include <iomanip>
#include <sstream>

#include <QString>
#include <QMap>
#include <QFile>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QCoreApplication>
#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QNetworkReply>

namespace sc = unity::scopes;
namespace alg = boost::algorithm;

using namespace std;
using namespace api;
using namespace scope;
using namespace sc;

QString g_scopePath;
QString g_rootDepartmentId;
QMap<QString, std::string> g_renders;
QString g_userAgent;
QString g_imageDefault;
QString g_imageError;
QMap<QString, QString> g_depts;
QString g_curScopeId;
static QMap<QString, QString> g_deptLayouts;

std::string CAR_GRID = R"(
{
    "schema-version" : 1,
        "template" : {
        "category-layout" : "grid",
        "card-size": "large",
        "overlay": true,
        "non-interactive":"true"
        },
    "components" : {
        "title" : "category",
        "art" : {
        "field": "art2",
        "aspect-ratio": 2.1
    }
  }
})";

#define qstr(s) QString::fromStdString(s)

#define SET_RESULT(key, value) result[key] = value.toStdString()

#define FOREACH_JSON(it, results) QJsonArray::iterator it; \
    for (it = results.begin(); it != results.end(); ++it)

#define LOAD_RENDERER(which) g_renders.insert(which, getRenderer(g_scopePath, which))

Query::Query( const sc::CannedQuery &query, const sc::SearchMetadata &metadata,
             QString scopePath, Config::Ptr config ) :
    sc::SearchQueryBase( query, metadata ), client_( config ) {
    g_scopePath = scopePath;
    g_userAgent = QString("%1 (Ubuntu)").arg(SCOPE_PACKAGE);
    g_imageDefault = QString("file://%1/images/%2").arg(scopePath).arg(IMG_DEFAULT);
    g_imageError = QString("file://%1/images/%2").arg(scopePath).arg(IMG_ERROR);

    // Load all of the predefined rederers. You can comment out the renderers
    // you don't use.
    LOAD_RENDERER( "journal" );
    LOAD_RENDERER( "wide-art" );
    LOAD_RENDERER( "hgrid" );
    LOAD_RENDERER( "carousel" );
    LOAD_RENDERER( "large" );
}

std::string Query::getRenderer( QString scopePath, QString name ) {
    QString renderer = readFile( QString("%1/renderer/%2.json" )
                                .arg(scopePath).arg(name));
    return renderer.toStdString();
}

QString Query::readFile(QString path) {
    QFile file(path);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QString data = file.readAll();
    // qDebug() << "JSON file: " << data;
    file.close();
    return data;
}

void Query::cancelled() {
    client_.cancel();
}

void Query::run(sc::SearchReplyProxy const& reply) {
    try {
        // Start by getting information about the query
        const CannedQuery &query(sc::SearchQueryBase::query());

        // Trim the query string of whitespace
        string query_string = alg::trim_copy(query.query_string());
        QString queryString = QString::fromStdString(query_string);

        qDebug() << "queryString: " << queryString;

        // Only push the departments when the query string is null
        if ( queryString.length() == 0 ) {
            qDebug() << "it is going to push the departments...!";
            pushDepartments( reply );
        }

        search(reply);

    } catch ( domain_error &e ) {
        // Handle exceptions being thrown by the client API
        cerr << e.what() << endl;
        reply->error( current_exception() );
    }
}

void Query::pushDepartments(unity::scopes::SearchReplyProxy const& reply) {
    qDebug() << "gScopePath: "  << g_scopePath;

    QString json = getDepartmentsData( g_scopePath );

    QJsonDocument doc = QJsonDocument::fromJson( json.toUtf8() );
    if (doc.isNull()) {
        qCritical() << "Failed to parse departments JSON!";
        return;
    }

    CannedQuery query = SearchQueryBase::query();
    QString queryString = QString::fromStdString(query.query_string());

    DepartmentList depts = getDepartments( doc );
    Department::SPtr root = getRootDepartment( depts );
    root->set_subdepartments(depts);

    reply->register_departments(root);
}

DepartmentList Query::getDepartments(QJsonDocument document) {
    g_deptLayouts.insert("", SURFACING_LAYOUT);
    QJsonArray jsonDepts = document.array();
    return getDepartments(jsonDepts);
}

QString Query::getDepartmentsData(QString scopePath) {
    QString path = QString("%1/departments.json").arg(scopePath);
    qDebug() << "Departments file path: " << path;

    return readFile(path);
}

Department::SPtr Query::getRootDepartment(DepartmentList &depts) {
    //Department::SPtr top = depts.front();
    std::shared_ptr<const Department> top = depts.front();
    std::string label;

    if (BROWSE_AT_ROOT) {
        label = BROWSE.toStdString();
    } else {
        label = top->label();
        depts.pop_front();
    }
    std::string id = top->id();

    // Idea: We could show last browsed department instead.
    g_curScopeId =QString::fromStdString(id);
    qDebug() << "Init m_curScopeId: " << g_curScopeId;

    g_rootDepartmentId = QString::fromStdString(id);
    qDebug() <<  "Init m_rootDepartmentId: " << g_rootDepartmentId;

    CannedQuery topQuery(SCOPENAME.toStdString());
    topQuery.set_department_id(id);
    Department::SPtr root(Department::create("", topQuery, label));
    return root;
}

#define FOREACH_JSON(it, results) QJsonArray::iterator it; \
    for (it = results.begin(); it != results.end(); ++it)

DepartmentList Query::getDepartments(QJsonArray data) {
    qDebug() << "entering getDepartments";

    DepartmentList depts;

    // Clear the previous departments since the URL may change according to settings
    g_depts.clear();
    qDebug() << "m_depts is being cleared....!";

    int index = 0;
    FOREACH_JSON( json, data ) {
        auto feed = (*json).toObject();
        QString title = feed["title"].toString();
//        qDebug() << "title: " << title;

        QString url = feed["url"].toString();
//        qDebug() << "url: " << url;

        QString pinyin = feed["pinyin"].toString();
//        qDebug() << "pinyin: " << pinyin;

        // This is the default layout otherwise it is defined in the json file
        QString layout = SURFACING_LAYOUT;

        if ( feed.contains( "layout" ) ) {
            layout = feed[ "layout" ].toString();
        }

        g_depts.insert( pinyin, url );
        g_deptLayouts.insert( pinyin, layout );

        CannedQuery query( SCOPENAME.toStdString() );
        query.set_department_id( url.toStdString() );
        query.set_query_string( url.toStdString() );

        Department::SPtr dept( Department::create(
                               pinyin.toStdString(), query, title.toStdString() ) );

        depts.push_back(dept);

        index++;
    }

    // Dump the departments. The map has been sorted out
    QMapIterator<QString, QString> i(g_depts);
    while (i.hasNext()) {
        i.next();
        qDebug() << "scope id: " << i.key() << ": " << i.value();
    }

    qDebug() << "Going to dump tthe department layouts";

    QMapIterator<QString, QString> j( g_deptLayouts );
    while (j.hasNext()) {
        j.next();
        qDebug() << "scope id: " << j.key() << ": " << j.value();
    }

    return depts;
}


void Query::search(sc::SearchReplyProxy const& reply) {
    CategoryRenderer renderer(g_renders.value("journal", ""));
    auto search = reply->register_category(
                "search", RESULTS.toStdString(), "", renderer);

    CannedQuery cannedQuery = SearchQueryBase::query();

    QString deptId = QString::fromStdString(cannedQuery.department_id());
    qDebug() << "deptId: " << deptId;

    qDebug() << "m_rootDepartmentId: " << g_rootDepartmentId;
    QString url;

    qDebug() << "m_curScopeId: " << g_curScopeId;

    if ( !deptId.isEmpty() ) {
        g_curScopeId = deptId;
    }

    if ( deptId.isEmpty() && !g_rootDepartmentId.isEmpty()
         && g_curScopeId == g_rootDepartmentId ) {

        QMapIterator<QString, QString> i(g_depts);
        qDebug() << "m_depts count: "  << g_depts.count();

        qDebug() << "Going to set the surfacing content";

        const CannedQuery &query(sc::SearchQueryBase::query());
        // Trim the query string of whitespace
        string query_string = alg::trim_copy(query.query_string());
        QString queryString = QString::fromStdString(query_string);

        if ( queryString.isEmpty()) {
            url = QString(g_depts[g_rootDepartmentId]).arg(909549396093);
        } else {
            url = QString(g_depts[g_rootDepartmentId]).arg(queryString);
        }
    } else {
        QString queryString = QString::fromStdString(cannedQuery.query_string());
        qDebug() << "queryString: " << queryString;

        // Dump the departments. The map has been sorted out
        QMapIterator<QString, QString> i(g_depts);
        qDebug() << "m_depts count: "  << g_depts.count();

        while (i.hasNext()) {
            i.next();
            qDebug() << "scope id: " << i.key() << ": " << i.value();
        }

        url = g_depts[g_curScopeId].arg(queryString);
    }

    qDebug() << "url: "  << url;
    qDebug() << "m_curScopeId: " << g_curScopeId;

    try {
        QByteArray data = get(reply, QUrl(url));
        getMailInfo(data, reply);
    } catch (domain_error &e ) {
        cerr << e.what() << endl;
        reply->error(current_exception());
    }
}

void Query::getMailInfo(QByteArray &data, SearchReplyProxy const& reply) {
    QJsonParseError e;
    QJsonDocument document = QJsonDocument::fromJson(data, &e);
    if (e.error != QJsonParseError::NoError) {
        throw QString("Failed to parse response: %1").arg(e.errorString());
    }

    // This creates a big picture on the top
    CategoryRenderer rssCAR(CAR_GRID);
    auto catCARR = reply->register_category("A", "", "", rssCAR);
    CategorisedResult res_car(catCARR);
    res_car.set_uri("frontPage");
    QString defaultImage1 ="file://"+ g_scopePath + "/images/" + g_curScopeId + ".jpg";
    qDebug() << "defaultImage1: "  << defaultImage1;
    res_car["largepic"] = defaultImage1.toStdString();
    res_car["art2"] =  res_car["largepic"];
    reply->push(res_car);

    QJsonObject obj = document.object();

    qDebug() << "***********************\r\n";

    if ( obj.contains("data") ) {
        qDebug() << "it has data!";

        QJsonValue data1 = obj.value("data");

        QJsonArray results = data1.toArray();

        qDebug() << "g_curScopeId: " << g_curScopeId;
        QString layout = g_deptLayouts.value( g_curScopeId );
        std::string renderTemplate;

        if (g_renders.contains( layout )) {
            qDebug() << "it has layout: " << layout;
            renderTemplate = g_renders.value( layout, "" );
            // qDebug() << "renderTemplate: " << QString::fromStdString(renderTemplate);
        }
        else {
            qDebug() << "it does not have layout!";
            renderTemplate = g_renders.value( "journal" );
            // qDebug() << "renderTemplate: " << QString::fromStdString(renderTemplate);
        }

        CategoryRenderer grid(renderTemplate);
        std::string categoryId = "root";
        std::string categoryTitle = " "; // #1330899 workaround
        std::string icon = "";
        auto tracking = reply->register_category(categoryId, categoryTitle, icon, grid);

        FOREACH_JSON(result, results) {
            QJsonObject o = (*result).toObject();

            QString time = o.value("time").toString();
//            qDebug() << "time: " << time;

            QString context = o.value("context").toString();
//            qDebug() << "context: " << context;

            QString link = "http://www.kuaidi100.com/";
            QString defaultImage ="file://"+ g_scopePath + "/images/" + g_curScopeId + ".jpg";

            CategorisedResult result(tracking);

            SET_RESULT("uri", link);
            SET_RESULT("image", defaultImage);
            //            SET_RESULT("video", video);
            SET_RESULT("title", time);
            //            SET_RESULT("subtitle", context);
            SET_RESULT("summary", context);
            //            SET_RESULT("full_summary", fullSummary);
            //            result["actions"] = actions.end();

            if (!reply->push(result)) break;
        }
    }
}

QByteArray Query::get(sc::SearchReplyProxy const& reply, QUrl url) const {
    QNetworkRequest request(url);
    QByteArray data = makeRequest(reply, request);
    return data;
}

QByteArray Query::makeRequest(SearchReplyProxy const& reply,QNetworkRequest &request) const {
    int argc = 1;
    char *argv = const_cast<char*>("rss-scope");
    QCoreApplication *app = new QCoreApplication( argc, &argv );

    QNetworkAccessManager manager;
    QByteArray response;
    QNetworkDiskCache *cache = new QNetworkDiskCache();
    QString cachePath = g_scopePath + "/cache";
    //qDebug() << "Cache dir: " << cachePath;
    cache->setCacheDirectory(cachePath);

    request.setRawHeader( "User-Agent", g_userAgent.toStdString().c_str() );
    request.setRawHeader( "Content-Type", "application/rss+xml, text/xml" );
    request.setAttribute( QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::PreferCache );

    QObject::connect(&manager, SIGNAL(finished(QNetworkReply*)), app, SLOT(quit()));
    QObject::connect(&manager, &QNetworkAccessManager::finished,
                     [this, &reply, &response](QNetworkReply *msg) {
        if (msg->error() != QNetworkReply::NoError) {
            qCritical() << "Failed to get data: " << msg->error();
            pushError( reply, NO_CONNECTION );
        } else {
            response = msg->readAll();
        }

        msg->deleteLater();
    });

    manager.setCache( cache );
    manager.get( request );
    app->exec();

    delete cache;
    return response;
}

void Query::pushError(SearchReplyProxy const& reply, QString error) {
    CategoryRenderer renderer(g_renders.value( "hgrid", "" ) );
    auto errors = reply->register_category( "error", "", "", renderer );

    CategorisedResult result( errors );
    result[ "uri" ] = HOME_URL.toStdString();
    result[ "title" ] = ERROR.toStdString();
    result[ "subtitle" ] = error.toStdString();
    result[ "image" ] = g_imageError.toStdString();
    reply->push( result );
}


