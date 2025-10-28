# checklist

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Desenvolvimento com Couchbase via Docker Compose

Este projeto inclui uma configuração opcional para desenvolvimento local com Couchbase Server + Sync Gateway usando Docker Compose (pasta `docker/`).

Passos:

1) Subir serviços:

```
cd docker
docker compose up -d
```

Serviços expostos:
- Couchbase Server UI: http://localhost:8091
- Sync Gateway público: ws://localhost:4984/checklist_db
- Sync Gateway admin: http://localhost:4985

2) Usuários, bucket e coleções

- O bucket `checklist_db` é criado automaticamente no primeiro start.
- As coleções `_default.checklist_items` e `_default.testes` são usadas pelo app e configuradas no Sync Gateway.
- Garanta que o usuário do app tem acesso às coleções e canais. Rode:

```
./scripts/sg-ensure-user.sh your_username your_password
```

Isso cria/atualiza o usuário no Sync Gateway com acesso às coleções e canais necessários.

3) Variáveis de ambiente

O arquivo `.env` aponta para `ws://10.0.2.2:4984/your-database`.

- Emulador Android: `10.0.2.2` referencia o host.
- Dispositivo físico Android: use túnel para a porta 4984 do host:

```
adb reverse tcp:4984 tcp:4984
```

Ou ajuste `PUBLIC_CONNECTION_URL` para o IP da sua rede, ex: `ws://192.168.0.10:4984/checklist_db`.

### Autenticação e gerenciamento de usuários

- A tela inicial exibe o fluxo de login. Use **Criar conta** para cadastrar um usuário localmente.
- As credenciais são persistidas na coleção `_default.users` (configurável via `USER_COLLECTION_NAME`) com hash + salt usando SHA-256.
- Garanta que o usuário do Sync Gateway possui acesso aos canais `checklist_items` e `users` (`USER_CHANNEL`) para permitir sincronização de dados e contas.
- Na checklist, o menu superior permite editar nome/e-mail/senha pela tela de **Perfil** ou encerrar sessão.

4) Permissões Android
5) Dicas de debug

```
./scripts/debug-docker.sh         # Status de containers e configuração do SG
./scripts/sg-inspect.sh           # Inspeção detalhada de bucket/coleções/usuários
./scripts/sg-inspect.sh your_username  # Ver estado do usuário
```

Se o app logar "Erro de replicação", cheque se o usuário possui `collection_access` para `_default.checklist_items` e se o `PUBLIC_CONNECTION_URL` aponta para `ws://localhost:4984/checklist_db` (com `adb reverse` ativo em dispositivo físico).

O `AndroidManifest.xml` inclui `INTERNET`, `ACCESS_NETWORK_STATE` e `android:usesCleartextTraffic="true"` para permitir `ws://` em dev. Em produção, prefira `wss://` e desative cleartext.
