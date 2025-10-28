#!/usr/bin/env bash
set -euo pipefail

# Script para reiniciar Couchbase no Docker
# Repo root (this script is in scripts/)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker/docker-compose.yml"

info() { echo -e "\033[1;34m[INFO]\033[0m $*"; }
warn() { echo -e "\033[1;33m[WARN]\033[0m $*"; }
err()  { echo -e "\033[1;31m[ERR ]\033[0m $*"; }

info "Parando containers do Couchbase e Sync Gateway..."
docker-compose -f "$COMPOSE_FILE" down

info "Removendo volumes para reset completo (opcional - pressione Ctrl+C para cancelar)..."
sleep 3
docker-compose -f "$COMPOSE_FILE" down -v

info "Iniciando serviços novamente..."
docker-compose -f "$COMPOSE_FILE" up -d

info "Aguardando Couchbase ficar saudável..."
sleep 10

info "Verificando status dos containers..."
docker-compose -f "$COMPOSE_FILE" ps

info "✅ Couchbase reiniciado!"
info "   - Couchbase Server: http://localhost:8091"
info "   - Sync Gateway: ws://localhost:4984/checklist_db"
info ""
info "Para configurar usuários e banco, execute:"
info "   ./scripts/dev-sync.sh"