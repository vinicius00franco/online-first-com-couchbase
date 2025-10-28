#!/usr/bin/env bash
set -euo pipefail

# Lê variáveis de .env e garante o usuário no Sync Gateway
# Uso: ./scripts/ensure-sg-user-from-env.sh

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
ENV_FILE="$ROOT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERR ] Arquivo .env não encontrado em $ROOT_DIR. Copie .env.example para .env e ajuste os valores." >&2
  exit 1
fi

# Exporta as variáveis do .env para o ambiente atual
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

if [[ -z "${USER_NAME:-}" || -z "${USER_PASSWORD:-}" ]]; then
  echo "[ERR ] USER_NAME e USER_PASSWORD devem estar definidos no .env" >&2
  exit 1
fi

"$ROOT_DIR/scripts/sg-ensure-user.sh" "$USER_NAME" "$USER_PASSWORD"

echo "[OK ] Usuário '$USER_NAME' garantido no Sync Gateway."
