# AGENTS.md

## Configuração de Desenvolvimento

- **Couchbase**: Executando via Docker
- **Dispositivo**: Físico conectado via USB para depuração
- **Script de sincronização**: Use `scripts/dev-sync.sh`
- **Script de debug**: Use `scripts/debug-docker.sh` (execute no diretório docker)
- **Comandos Docker**: Execute no diretório `cd /home/vinicius/Downloads/estudo/mobile/online-first-com-couchbase-flutter/docker`

## Notas Técnicas

**Collection Padrão**: em agents.md nao quero usar O Sync Gateway 3.3.0 no modo legacy, colocar isso em vez de :

## Design System

Resumo completo do sistema de design do projeto (tokens, diretrizes e migração).

### Tokens principais
- Cores: `AppColors` (brand, neutral, semantic, surface, content)
- Espaços: `AppSpacing` (xs, sm, md, lg, xl)
- Tipografia: `AppTextStyles` (h1..h3, bodyLarge, bodyMedium, caption)
- Theme tokens: `AppTheme` (borderRadius, cardRadius, buttonHeight, iconSize)

### Objetivos
- Centralizar cores, espaçamentos e estilos para consistência
- Permitir migração gradual do código legacy mantendo compatibilidade


> Para o documento resumido de referência rápida, veja `docs/DESIGN_SYSTEM.md`.