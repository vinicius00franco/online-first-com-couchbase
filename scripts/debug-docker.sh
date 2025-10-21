#!/bin/bash

# Debug Docker e Couchbase
# Execute no diretório: cd /home/vinicius/Downloads/estudo/mobile/online-first-com-couchbase-flutter/docker

echo "=== Status dos containers ==="
if command -v docker compose >/dev/null 2>&1; then
	docker compose -f "$(dirname "$0")/../docker/docker-compose.yml" ps || true
else
	docker-compose -f "$(dirname "$0")/../docker/docker-compose.yml" ps || true
fi

echo -e "\n=== Buckets disponíveis ==="
curl -s -u Administrator:password http://localhost:8091/pools/default/buckets | jq -r '.[].name'

echo -e "\n=== Scopes do bucket checklist_db ==="
curl -s -u Administrator:password http://localhost:8091/pools/default/buckets/checklist_db/scopes | jq -r '.scopes[].name'

echo -e "\n=== Collections do scope _default ==="
curl -s -u Administrator:password http://localhost:8091/pools/default/buckets/checklist_db/scopes | jq -r '.scopes[] | select(.name=="_default").collections[].name'

echo -e "\n=== Status Sync Gateway ==="
curl -sS http://localhost:4984/

echo -e "\n=== Databases no Sync Gateway ==="
curl -sS -u Administrator:password http://localhost:4985/_all_dbs

echo -e "\n=== Configuração checklist_db ==="
curl -sS -u Administrator:password http://localhost:4985/checklist_db/_config | jq