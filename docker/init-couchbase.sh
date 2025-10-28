#!/usr/bin/env bash
set -euo pipefail

echo "[init] Waiting for Couchbase Server (8091) to be reachable..."
until curl -sSf http://127.0.0.1:8091/ui/index.html >/dev/null 2>&1; do
  sleep 2
done
echo "[init] Couchbase UI is responding. Proceeding with cluster init."

CB_HOST=127.0.0.1
ADMIN=Administrator
PASS=password

# Try cluster init via couchbase-cli (idempotent)
if /opt/couchbase/bin/couchbase-cli cluster-init -c "$CB_HOST" \
  --cluster-username "$ADMIN" --cluster-password "$PASS" \
  --services data,index,query,fts \
  --cluster-ramsize 512 --cluster-index-ramsize 256 >/tmp/cluster-init.log 2>&1; then
  echo "[init] Cluster initialized."
else
  if grep -qi "already initialized" /tmp/cluster-init.log; then
    echo "[init] Cluster already initialized."
  else
    echo "[init] Cluster init may have failed, continuing. Log:"
    cat /tmp/cluster-init.log
  fi
fi

# Create bucket if missing
if ! curl -s -u "$ADMIN:$PASS" http://$CB_HOST:8091/pools/default/buckets | grep -q '"name":"checklist_db"'; then
  echo "[init] Creating bucket checklist_db..."
  /opt/couchbase/bin/couchbase-cli bucket-create -c "$CB_HOST" -u "$ADMIN" -p "$PASS" \
    --bucket checklist_db --bucket-type couchbase --bucket-ramsize 100 --enable-flush 1 || true
else
  echo "[init] Bucket checklist_db already exists."
fi

# Create collections (idempotent)
echo "[init] Ensuring collections exist in _default scope..."
curl -s -u "$ADMIN:$PASS" -X POST \
  http://$CB_HOST:8091/pools/default/buckets/checklist_db/scopes/_default/collections \
  -d name=checklist_items >/dev/null 2>&1 || true

curl -s -u "$ADMIN:$PASS" -X POST \
  http://$CB_HOST:8091/pools/default/buckets/checklist_db/scopes/_default/collections \
  -d name=testes >/dev/null 2>&1 || true

echo "[init] Initialization script complete."