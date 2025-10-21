#!/usr/bin/env bash
set -euo pipefail

# Ensure Sync Gateway user has collection-scoped channel access matching the app
# Usage: ./scripts/sg-ensure-user.sh [username] [password]

USERNAME="${1:-your_username}"
PASSWORD="${2:-your_password}"
DB="checklist_db"
ADMIN="Administrator:password"
BASE="http://localhost:4985"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

info "Ensuring user '$USERNAME' exists and has access to _default.checklist_items and _default.testes"

# Create or update user with collection_access
PAYLOAD=$(cat <<JSON
{
  "name": "${USERNAME}",
  "password": "${PASSWORD}",
  "collection_access": {
    "_default": {
      "checklist_items": { "admin_channels": ["checklist_items"] },
      "testes": { "admin_channels": ["testes"] }
    }
  },
  "disabled": false
}
JSON
)

# Try create (POST); if it exists, update (PUT)
CREATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$ADMIN" -H 'Content-Type: application/json' \
  -X POST "$BASE/$DB/_user/" --data "$PAYLOAD" || true)

if [[ "$CREATE_STATUS" == "201" || "$CREATE_STATUS" == "200" ]]; then
  info "User created"
else
  info "User may exist (HTTP $CREATE_STATUS). Trying update..."
  UPDATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$ADMIN" -H 'Content-Type: application/json' \
    -X PUT "$BASE/$DB/_user/$USERNAME" --data "$PAYLOAD" || true)
  if [[ "$UPDATE_STATUS" != "200" ]]; then
    err "Failed to update user ($UPDATE_STATUS). See response below:" && \
    curl -s -u "$ADMIN" -H 'Content-Type: application/json' -X PUT "$BASE/$DB/_user/$USERNAME" --data "$PAYLOAD" && exit 1
  fi
  info "User updated"
fi

info "Current user state:"
curl -s -u "$ADMIN" "$BASE/$DB/_user/$USERNAME" | jq

info "Done. If you changed credentials, update the .env USER_NAME/USER_PASSWORD and restart the app."
