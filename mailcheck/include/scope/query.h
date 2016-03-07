#ifndef SCOPE_QUERY_H_
#define SCOPE_QUERY_H_

#include <api/client.h>

#include <unity/scopes/SearchQueryBase.h>
#include <unity/scopes/ReplyProxyFwd.h>

namespace sc = unity::scopes;

#include <QString>
#include <QJsonDocument>
#include <QUrl>
#include <QNetworkRequest>

const QString SCOPENAME = "Mail Check";
const QString SURFACING_LAYOUT = "journal";
const bool BROWSE_AT_ROOT   = false;
const QString BROWSE        = "快递公司";
const QString RESULTS       = "Results:";
const QString IMG_DEFAULT   = "default.png";
const QString IMG_ERROR     = "error.png";
const QString SCOPE_PACKAGE = "com.canonical.scopes.mailcheck";
const QString NO_CONNECTION = "No connection.";
const QString HOME_URL      = "http://www.kuaidi100.com/";
const QString ERROR         = "Error";

namespace scope {

/**
 * Represents an individual query.
 *
 * A new Query object will be constructed for each query. It is
 * given query information, metadata about the search, and
 * some scope-specific configuration.
 */
class Query: public unity::scopes::SearchQueryBase {
public:
    Query(const unity::scopes::CannedQuery &query,
          const unity::scopes::SearchMetadata &metadata,  QString scopePath,
          api::Config::Ptr config);

    ~Query() = default;

    void cancelled() override;

    void run(const unity::scopes::SearchReplyProxy &reply) override;

private:
    std::string getRenderer(QString scopePath, QString name);
    QString readFile(QString path);
    void pushDepartments(const unity::scopes::SearchReplyProxy &reply);
    sc::DepartmentList getDepartments(QJsonDocument document);
    QString getDepartmentsData(QString scopePath);
    sc::Department::SPtr getRootDepartment(sc::DepartmentList &depts);
    sc::DepartmentList getDepartments(QJsonArray data);
    void search(const sc::SearchReplyProxy &reply);
    void getMailInfo(QByteArray &data, const sc::SearchReplyProxy &reply);
    QByteArray get(const sc::SearchReplyProxy &reply, QUrl url) const;
    QByteArray makeRequest(const sc::SearchReplyProxy &reply, QNetworkRequest &request) const;
    void pushError(const sc::SearchReplyProxy &reply, QString error);

private:
    api::Client client_;
};

}

#endif // SCOPE_QUERY_H_


