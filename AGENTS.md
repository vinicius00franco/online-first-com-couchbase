# AGENTS.md

## Configuração de Desenvolvimento

- **Couchbase**: Executando via Docker
- **Dispositivo**: Físico conectado via USB para depuração
- **Script de sincronização**: Use `scripts/dev-sync.sh`
- **Comandos Docker**: Execute no diretório `cd /home/vinicius/Downloads/estudo/mobile/online-first-com-couchbase-flutter/docker`

## Notas Técnicas

**Collection Padrão**: Motivo da mudança: O Sync Gateway 3.3.0 no modo legacy não suporta configuração de collections específicas, então usamos a collection padrão que funciona com qualquer versão.