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

`docker/sync-gateway-config.json` provisiona o bucket `your-database`, escopo `app_scope`, coleção `checklist_items` e usuário `your_username/your_password`.

3) Variáveis de ambiente

O arquivo `.env` aponta para `ws://10.0.2.2:4984/your-database`.

- Emulador Android: `10.0.2.2` referencia o host.
- Dispositivo físico Android: use túnel para a porta 4984 do host:

```
adb reverse tcp:4984 tcp:4984
```

Ou ajuste `PUBLIC_CONNECTION_URL` para o IP da sua rede, ex: `ws://192.168.0.10:4984/checklist_db`.

4) Permissões Android

O `AndroidManifest.xml` inclui `INTERNET`, `ACCESS_NETWORK_STATE` e `android:usesCleartextTraffic="true"` para permitir `ws://` em dev. Em produção, prefira `wss://` e desative cleartext.
