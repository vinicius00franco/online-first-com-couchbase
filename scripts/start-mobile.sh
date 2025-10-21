#!/usr/bin/env bash
set -euo pipefail

# Start local mobile dev environment using existing scripts:
# - Starts Docker (Couchbase Server + Sync Gateway) and sets adb reverse
# - Ensures Sync Gateway user has collection access according to .env
# - Optionally runs the Flutter app
#
# Usage:
#   ./scripts/start-mobile.sh [--no-run] [--device <id>] [--skip-user]
#
# Examples:
#   ./scripts/start-mobile.sh
#   ./scripts/start-mobile.sh --device emulator-5554
#   ./scripts/start-mobile.sh --no-run     # only infra + ensure user
#

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

RUN_APP=true
DEVICE_ID=""
SKIP_USER=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-run)
      RUN_APP=false; shift ;;
    --device)
      DEVICE_ID="${2:-}"; shift 2 ;;
    --skip-user)
      SKIP_USER=true; shift ;;
    -h|--help)
      sed -n '1,50p' "$0" | sed -n '1,25p'; exit 0 ;;
    *)
      warn "Argumento desconhecido: $1"; shift ;;
  esac
done

# Load .env if present to get USER_NAME and USER_PASSWORD
if [[ -f .env ]]; then
  info "Carregando variáveis de .env"
  set -o allexport
  # shellcheck source=/dev/null
  source .env
  set +o allexport
else
  warn ".env não encontrado na raiz do projeto; usando valores padrão."
fi

USERNAME="${USER_NAME:-your_username}"
PASSWORD="${USER_PASSWORD:-your_password}"
PUBLIC_URL="${PUBLIC_CONNECTION_URL:-ws://localhost:4984/checklist_db}"

# Basic checks
for bin in adb flutter; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    warn "'$bin' não encontrado no PATH. Continue apenas se você sabe o que está fazendo."
  fi
done

info "1) Subindo Docker e configurando adb reverse"
"$ROOT_DIR/scripts/dev-sync.sh"

if [[ "$SKIP_USER" == false ]]; then
  info "2) Garantindo usuário no Sync Gateway (USER_NAME=$USERNAME)"
  "$ROOT_DIR/scripts/sg-ensure-user.sh" "$USERNAME" "$PASSWORD"
else
  info "2) Pulando configuração de usuário (solicitado por --skip-user)"
fi

info "3) Flutter pub get"
if command -v flutter >/dev/null 2>&1; then
  flutter pub get
else
  warn "flutter não encontrado; pulando 'flutter pub get'"
fi

if [[ "$RUN_APP" == true ]]; then
  info "4) Iniciando app Flutter (endpoint: $PUBLIC_URL)"
  if [[ -n "$DEVICE_ID" ]]; then
    info "Executando em dispositivo: $DEVICE_ID"
    flutter run -d "$DEVICE_ID"
  else
    flutter run
  fi
else
  info "4) Execução do app pulada (--no-run). Ambiente pronto."
  info "   Dica: rode 'flutter devices' e depois 'flutter run -d <id>'"
fi
