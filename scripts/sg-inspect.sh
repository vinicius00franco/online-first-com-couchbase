#!/usr/bin/env bash
set -euo pipefail

ADMIN=Administrator:password
BASE=http://localhost:4985
COUCHBASE=http://localhost:8091
DB=checklist_db

section() { echo -e "\n\033[1;36m== $* ==\033[0m"; }

section "Containers"
docker compose -f "$(dirname "$0")/../docker/docker-compose.yml" ps || docker-compose ps || true

section "Buckets"
curl -s -u $ADMIN $COUCHBASE/pools/default/buckets | jq -r '.[].name'

section "Scopes in $DB"
curl -s -u $ADMIN $COUCHBASE/pools/default/buckets/$DB/scopes | jq -r '.scopes[].name'

section "Collections in _default"
curl -s -u $ADMIN $COUCHBASE/pools/default/buckets/$DB/scopes | jq -r '.scopes[] | select(.name=="_default").collections[].name'

section "Sync Gateway status"
curl -s $BASE/

section "Databases"
curl -s -u $ADMIN $BASE/_all_dbs | jq

section "DB config ($DB)"
curl -s -u $ADMIN $BASE/$DB/_config | jq

section "Users"
curl -s -u $ADMIN $BASE/$DB/_user/ | jq

if [[ -n "${1:-}" ]]; then
  section "User $1"
  curl -s -u $ADMIN $BASE/$DB/_user/$1 | jq
fi
