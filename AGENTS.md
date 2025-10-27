# AGENTS.md

## Configuração de Desenvolvimento

- **Couchbase**: Executando via Docker
- **Dispositivo**: Físico conectado via USB para depuração
- **Script de sincronização**: Use `scripts/dev-sync.sh`
- **Script de debug**: Use `scripts/debug-docker.sh` (execute no diretório docker)
- **Comandos Docker**: Execute no diretório `cd /home/vinicius/Downloads/estudo/mobile/online-first-com-couchbase-flutter/docker`

## Notas Técnicas

**Coleções (não legacy)**: Usamos Couchbase Server 7.x com Sync Gateway 3.3 no modo de Coleções (não legacy). Não utilizar o modo legacy.

- Bucket: `checklist_db`
- Scope: `_default`
- Collections: `checklist_items` (dados da checklist) e `testes`
- Canal (channels): `checklist_items`

Configuração esperada:

- URL pública (WebSocket) do Sync Gateway no .env: `PUBLIC_CONNECTION_URL=ws://localhost:4984/checklist_db`
- Credenciais no .env: `USER_NAME` e `USER_PASSWORD`
- Tokens de coleção no .env (opcional, com defaults no app):
  - `SCOPE_NAME=_default`
  - `COLLECTION_NAME=checklist_items`
  - `CHANNEL=checklist_items`

Provisionamento em desenvolvimento:

- Suba o ambiente: `scripts/dev-sync.sh` (inclui `adb reverse tcp:4984 tcp:4984` para device físico)
- Garanta o usuário no Sync Gateway com acesso por coleção: `scripts/sg-ensure-user.sh <USER_NAME> <USER_PASSWORD>`
  - O usuário precisa de `collection_access` para `_default.checklist_items` (ou demais coleções usadas).

No código, a replicação é definida por coleção (addCollection) e canal, em conformidade com o modo Collections do Sync Gateway 3.3.

## Diretrizes de Código

### Boas Práticas de Arquitetura no Flutter
- **Arquitetura Recomendada**: Camadas inspiradas em Clean Architecture e MVVM para separação de preocupações, testabilidade e escalabilidade.
- **Estrutura de Camadas**:
  - **UI**: Renderiza interface e envia eventos (Views/Widgets).
  - **Apresentação**: Lógica de apresentação e estado (ViewModels, Cubit, Bloc, Provider).
  - **Dados**: Fornece dados (Repositories, Services).
  - **(Opcional) Domínio**: Regras de negócio independentes (Use Cases, Entities).
- **Padrões de Estado**: BLoC/Cubit (Streams), Provider/Riverpod (Injeção), MVVM (ChangeNotifier).

### Boas Práticas de Código e Design
- **Widgets**: Preferir composição a herança; manter widgets pequenos e atômicos; usar `const` para imutabilidade e performance.
- **Nomenclatura (Dart Lints)**: Classes/Enums em PascalCase; funções/variáveis/arquivos em snake_case; usar `final` para imutabilidade.
- **Princípios SOLID**: S (Responsabilidade Única); D (Inversão de Dependência) via interfaces para independência de framework.

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