#!/usr/bin/env bash
set -euo pipefail

# Repo root (this script is in scripts/)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker/docker-compose.yml"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

info "Starting Docker services (docker-compose up -d)"
docker-compose -f "$COMPOSE_FILE" up -d

info "Containers status (sync-gateway / couchbase-server)"
docker ps --no-trunc --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -E 'sync-gateway|couchbase-server' || true

info "Checking ADB availability"
if ! command -v adb >/dev/null 2>&1; then
  err "adb not found. Install Android platform-tools and try again."
  exit 1
fi

info "Listing connected devices (adb devices)"
adb devices

info "Creating reverse port mapping for Sync Gateway (4984)"
if adb reverse tcp:4984 tcp:4984; then
  info "adb reverse set: device can reach ws://localhost:4984"
else
  warn "Failed to set adb reverse. Ensure device is connected and USB debugging is enabled."
fi

info "Done. If needed, restart your Flutter app to reload .env." 

info "Configuring Sync Gateway database and user..."
"$ROOT_DIR/scripts/sg-configure-db.sh"

# Read credentials from .env if available
if [[ -f "$ROOT_DIR/.env" ]]; then
  source "$ROOT_DIR/.env"
  USER="${USER_NAME:-your_username}"
  PASS="${USER_PASSWORD:-your_password}"
else
  USER="your_username"
  PASS="your_password"
fi

"$ROOT_DIR/scripts/sg-ensure-user.sh" "$USER" "$PASS"

info "✅ Development environment ready!"
info "   - Couchbase Server: http://localhost:8091 (Administrator/password)"
info "   - Sync Gateway Admin: http://localhost:4985"
info "   - Sync Gateway Public: ws://localhost:4984/checklist_db"
info "   - User: $USER"
 
