#!/usr/bin/env bash
set -euo pipefail

# Configure Sync Gateway database via REST API (persistent config mode)
# Usage: ./scripts/sg-configure-db.sh

DB="checklist_db"
ADMIN="Administrator:password"
BASE="http://localhost:4985"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

info "Waiting for Sync Gateway to be ready..."
until curl -s "$BASE/" >/dev/null 2>&1; do
  info "Sync Gateway not ready, waiting..."
  sleep 2
done
info "Sync Gateway is ready."

info "Configuring database '$DB' with collections..."

# Database configuration with collections
DB_CONFIG=$(cat <<'JSON'
{
  "bucket": "checklist_db",
  "enable_shared_bucket_access": true,
  "import_docs": true,
  "num_index_replicas": 0,
  "scopes": {
    "_default": {
      "collections": {
        "checklist_items": {
          "sync": "function(doc) { channel(doc.channels); }"
        },
        "testes": {
          "sync": "function(doc) { channel(doc.channels); }"
        }
      }
    }
  }
}
JSON
)

# Check if database exists
DB_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" -u "$ADMIN" "$BASE/$DB/")

if [[ "$DB_EXISTS" == "200" ]]; then
  info "Database already exists. Updating configuration..."
  UPDATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$ADMIN" \
    -H 'Content-Type: application/json' \
    -X PUT "$BASE/$DB/_config" --data "$DB_CONFIG")
  
  if [[ "$UPDATE_STATUS" == "200" || "$UPDATE_STATUS" == "201" ]]; then
    info "Database configuration updated successfully"
  else
    err "Failed to update database configuration (HTTP $UPDATE_STATUS)"
    curl -s -u "$ADMIN" -H 'Content-Type: application/json' -X PUT "$BASE/$DB/_config" --data "$DB_CONFIG"
    exit 1
  fi
else
  info "Creating database..."
  CREATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$ADMIN" \
    -H 'Content-Type: application/json' \
    -X PUT "$BASE/$DB/" --data "$DB_CONFIG")
  
  if [[ "$CREATE_STATUS" == "200" || "$CREATE_STATUS" == "201" ]]; then
    info "Database created successfully"
  else
    err "Failed to create database (HTTP $CREATE_STATUS)"
    curl -s -u "$ADMIN" -H 'Content-Type: application/json' -X PUT "$BASE/$DB/" --data "$DB_CONFIG"
    exit 1
  fi
fi

info "Verifying database configuration..."
curl -s -u "$ADMIN" "$BASE/$DB/_config" | jq .

info "Database '$DB' is configured and ready!"
