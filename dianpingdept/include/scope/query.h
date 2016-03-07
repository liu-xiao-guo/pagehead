#ifndef SCOPE_QUERY_H_
#define SCOPE_QUERY_H_

#include <api/client.h>

#include <unity/scopes/SearchQueryBase.h>
#include <unity/scopes/ReplyProxyFwd.h>

#include <QString>
#include <QMap>
#include <QDomElement>

class QNetworkDiskCache;

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
          const unity::scopes::SearchMetadata &metadata, QString const& scopeDir,
          QString const& cacheDir, api::Config::Ptr config);

    ~Query() = default;

    void cancelled() override;

    void run(const unity::scopes::SearchReplyProxy &reply) override;

private:
    QString getUrl(QString addr, QMap<QString, QString> map);
    QString getDeptUrl(QString dept);
    void rssDepartments(QByteArray &xyml, unity::scopes::SearchReplyProxy const& reply);
    void rssImporter(QByteArray &xyml, unity::scopes::SearchReplyProxy const& reply, QString title);
    void rssError(unity::scopes::SearchReplyProxy const& reply, std::string error_message) ;
    QString removeTestInfo(QString name);
    void initScope();
    unity::scopes::DepartmentList getDeparment(unity::scopes::Department::SPtr topDept,
                                               QDomElement &docElem,
                      unity::scopes::SearchReplyProxy const& reply, bool getRoot);

private:
    QString m_scopeDir;
    QString m_cacheDir;
    QString m_urlRSS;
    QString m_errorImage;
    QString m_longitude;
    QString m_latitude;
    int m_limit;
    // QMap<QString, QString> m_depts;
    QNetworkDiskCache* m_diskCache;

    api::Client client_;
    QString m_rootUrl;
};

}

#endif // SCOPE_QUERY_H_


