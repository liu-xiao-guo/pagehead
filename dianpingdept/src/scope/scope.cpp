#include <scope/scope.h>
#include <scope/query.h>
#include <scope/preview.h>

#include <iostream>
#include <sstream>
#include <fstream>

#include <QCoreApplication> // added

namespace sc = unity::scopes;
using namespace std;
using namespace api;
using namespace scope;

void Scope::start(string const&) {
    config_ = make_shared<Config>();

}

void Scope::stop() {
    /* The stop method should release any resources, such as network connections where applicable */
    delete app;
}

void Scope::run()
{
    int zero = 0;
    app = new QCoreApplication(zero, nullptr);
}

sc::SearchQueryBase::UPtr Scope::search(const sc::CannedQuery &query,
                                        const sc::SearchMetadata &metadata) {

    const QString scopePath = QString::fromStdString(scope_directory());
    const QString cachePath =QString::fromStdString(cache_directory());

    // Boilerplate construction of Query
    return sc::SearchQueryBase::UPtr(new Query(query, metadata, scopePath,cachePath, config_));
}

sc::PreviewQueryBase::UPtr Scope::preview(sc::Result const& result,
                                          sc::ActionMetadata const& metadata) {
    // Boilerplate construction of Preview
    return sc::PreviewQueryBase::UPtr(new Preview(result, metadata));
}

#define EXPORT __attribute__ ((visibility ("default")))

// These functions define the entry points for the scope plugin
extern "C" {

EXPORT
unity::scopes::ScopeBase*
// cppcheck-suppress unusedFunction
UNITY_SCOPE_CREATE_FUNCTION() {
    return new Scope();
}

EXPORT
void
// cppcheck-suppress unusedFunction
UNITY_SCOPE_DESTROY_FUNCTION(unity::scopes::ScopeBase* scope_base) {
    delete scope_base;
}

}

