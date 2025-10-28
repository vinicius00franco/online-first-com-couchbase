#!/usr/bin/env bash
set -euo pipefail

# Quick health check for Couchbase + Sync Gateway + Mobile connectivity
# Usage: ./scripts/health-check.sh

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
ok()   { echo -e "\033[1;32m[OK  ]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

echo ""
echo "═══════════════════════════════════════════════════"
echo "   🏥 Couchbase Health Check"
echo "═══════════════════════════════════════════════════"
echo ""

# Load .env if present to get USER_NAME / USER_PASSWORD / PUBLIC_CONNECTION_URL
if [[ -f ".env" ]]; then
  info "Loading .env variables..."
  # shellcheck disable=SC1091
  set -a; source .env; set +a
else
  warn ".env not found, using defaults (your_username/your_password, ws://localhost:4984/checklist_db)"
fi

# Derive DB name from PUBLIC_CONNECTION_URL if set
PUBLIC_URL_DEFAULT="ws://localhost:4984/checklist_db"
PUBLIC_URL="${PUBLIC_CONNECTION_URL:-$PUBLIC_URL_DEFAULT}"
DB_NAME=$(echo "$PUBLIC_URL" | awk -F/ '{print $NF}')
AUTH_USER="${USER_NAME:-your_username}"
AUTH_PASS="${USER_PASSWORD:-your_password}"

# Check Docker containers
info "1. Checking Docker containers..."
if docker ps | grep -q "couchbase-server"; then
  ok "Couchbase Server is running"
else
  err "Couchbase Server is NOT running"
  exit 1
fi

if docker ps | grep -q "sync-gateway"; then
  ok "Sync Gateway is running"
else
  err "Sync Gateway is NOT running"
  exit 1
fi
echo ""

# Check Couchbase Server
info "2. Checking Couchbase Server..."
CB_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8091/ui/index.html)
if [[ "$CB_STATUS" == "200" ]]; then
  ok "Couchbase Server Web UI is accessible (http://localhost:8091)"
else
  err "Couchbase Server Web UI is NOT accessible (HTTP $CB_STATUS)"
fi
echo ""

# Check Sync Gateway Admin
info "3. Checking Sync Gateway Admin API..."
SG_ADMIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:4985/)
if [[ "$SG_ADMIN_STATUS" == "200" || "$SG_ADMIN_STATUS" == "401" ]]; then
  ok "Sync Gateway Admin API is accessible (http://localhost:4985)"
else
  err "Sync Gateway Admin API is NOT accessible (HTTP $SG_ADMIN_STATUS)"
fi
echo ""

# Check Database Configuration
info "4. Checking Database configuration..."
DB_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "Administrator:password" "http://localhost:4985/$DB_NAME/")
if [[ "$DB_STATUS" == "200" ]]; then
  ok "Database '$DB_NAME' is configured"
  
  # Check collections
  COLLECTIONS=$(curl -s -u "Administrator:password" "http://localhost:4985/$DB_NAME/_config" | jq -r '.scopes._default.collections | keys[]' 2>/dev/null)
  if [[ -n "$COLLECTIONS" ]]; then
    ok "Collections configured:"
    echo "$COLLECTIONS" | while read col; do
      echo "   ✓ $col"
    done
  fi
else
  err "Database '$DB_NAME' is NOT configured (HTTP $DB_STATUS)"
  warn "Run: ./scripts/sg-configure-db.sh"
fi
echo ""

# Check Public API
info "5. Checking Sync Gateway Public API..."
SG_PUBLIC_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$AUTH_USER:$AUTH_PASS" "http://localhost:4984/$DB_NAME/")
if [[ "$SG_PUBLIC_STATUS" == "200" ]]; then
  ok "Sync Gateway Public API is accessible (ws://localhost:4984)"
  
  DB_INFO=$(curl -s -u "$AUTH_USER:$AUTH_PASS" "http://localhost:4984/$DB_NAME/")
  UPDATE_SEQ=$(echo "$DB_INFO" | jq -r '.update_seq')
  ok "Database update_seq: $UPDATE_SEQ"
else
  err "Sync Gateway Public API is NOT accessible (HTTP $SG_PUBLIC_STATUS)"
  warn "Run: ./scripts/ensure-sg-user-from-env.sh (or sg-ensure-user.sh $AUTH_USER $AUTH_PASS)"
fi
echo ""

# Check User Configuration
info "6. Checking user configuration..."
USER_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "Administrator:password" "http://localhost:4985/$DB_NAME/_user/$AUTH_USER")
if [[ "$USER_STATUS" == "200" ]]; then
  ok "User '$AUTH_USER' exists"
  
  USER_COLLECTIONS=$(curl -s -u "Administrator:password" "http://localhost:4985/$DB_NAME/_user/$AUTH_USER" | jq -r '.collection_access._default | keys[]' 2>/dev/null)
  if [[ -n "$USER_COLLECTIONS" ]]; then
    ok "User has access to collections:"
    echo "$USER_COLLECTIONS" | while read col; do
      echo "   ✓ $col"
    done
  fi
else
  err "User '$AUTH_USER' does NOT exist (HTTP $USER_STATUS)"
  warn "Run: ./scripts/ensure-sg-user-from-env.sh (or sg-ensure-user.sh $AUTH_USER $AUTH_PASS)"
fi
echo ""

# Check ADB and Device
info "7. Checking ADB and mobile device..."
if command -v adb >/dev/null 2>&1; then
  ok "ADB is installed"
  
  DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" | wc -l)
  if [[ "$DEVICES" -gt 0 ]]; then
    ok "$DEVICES device(s) connected"
    adb devices | grep "device$" | awk '{print "   ✓ " $1}'
    
    # Check reverse port
    if adb reverse --list 2>/dev/null | grep -q "tcp:4984"; then
      ok "ADB reverse tcp:4984 is configured"
    else
      warn "ADB reverse tcp:4984 is NOT configured"
      warn "Run: adb reverse tcp:4984 tcp:4984"
    fi
  else
    warn "No devices connected via ADB"
    warn "Connect your device and enable USB debugging"
  fi
else
  warn "ADB is not installed or not in PATH"
fi
echo ""

# Check data in collections
info "8. Checking data in collections..."
DOC_COUNT=$(curl -s -u "Administrator:password" -X POST "http://localhost:8093/query/service" \
  -H "Content-Type: application/json" \
  -d '{"statement":"SELECT COUNT(*) as count FROM checklist_db._default.checklist_items"}' \
  | jq -r '.results[0].count' 2>/dev/null || echo "0")

if [[ "$DOC_COUNT" -gt 0 ]]; then
  ok "checklist_items has $DOC_COUNT document(s)"
else
  warn "checklist_items collection is empty"
fi
echo ""

# Summary
echo "═══════════════════════════════════════════════════"
echo "   📊 Summary"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Couchbase Server:  http://localhost:8091"
echo "Sync Gateway Admin: http://localhost:4985"
echo "Sync Gateway Public: $PUBLIC_URL"
echo "Username: $AUTH_USER"
echo "Password: $AUTH_PASS"
echo ""
ok "Health check complete!"
echo ""
