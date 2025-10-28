#!/usr/bin/env bash
set -euo pipefail

# One-shot bootstrap for Couchbase + Sync Gateway + Users
# - Starts docker compose
# - Creates RBAC user for Sync Gateway
# - Restarts Sync Gateway to pick up config
# - Ensures app database user exists with collection access
# - Runs health check

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker/docker-compose.yml"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
ok()   { echo -e "\033[1;32m[OK  ]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

CB_ADMIN_USER=${CB_ADMIN_USER:-Administrator}
CB_ADMIN_PASS=${CB_ADMIN_PASS:-password}
SGW_USER=${SGW_USER:-sgw}
SGW_PASS=${SGW_PASS:-sgwpass}

APP_USER=${USER_NAME:-your_username}
APP_PASS=${USER_PASSWORD:-your_password}

info "Starting Docker services (compose up -d)"
docker compose -f "$COMPOSE_FILE" up -d

info "Waiting for Couchbase UI to respond..."
until curl -s -u "$CB_ADMIN_USER:$CB_ADMIN_PASS" http://localhost:8091/ui/index.html >/dev/null; do
  sleep 2
  warn "Couchbase not ready yet..."
done
ok "Couchbase is responding."

info "Creating/Updating RBAC user for Sync Gateway ($SGW_USER)"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -u "$CB_ADMIN_USER:$CB_ADMIN_PASS" \
  -X PUT "http://localhost:8091/settings/rbac/users/local/$SGW_USER" \
  -d "password=$SGW_PASS&roles=admin&name=Sync%20Gateway")
if [[ "$HTTP_CODE" == "200" || "$HTTP_CODE" == "201" ]]; then
  ok "RBAC user $SGW_USER ready (admin role)"
else
  warn "Failed to ensure RBAC user (HTTP $HTTP_CODE) — continuing"
fi

info "Restarting Sync Gateway to pick up config"
docker compose -f "$COMPOSE_FILE" up -d sync-gateway
sleep 2

info "Ensuring application user exists with collection access"
"$ROOT_DIR/scripts/sg-ensure-user.sh" "$APP_USER" "$APP_PASS" || warn "Could not ensure SG user"

info "Running health check"
"$ROOT_DIR/scripts/health-check.sh" || true

ok "Bootstrap completed."
