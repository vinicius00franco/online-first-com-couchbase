import 'package:flutter_dotenv/flutter_dotenv.dart';

class CouchbaseContants {
  // Credenciais / endpoint
  static String userName = dotenv.get('USER_NAME');
  static String password = dotenv.get('USER_PASSWORD');
  static String publicConnectionUrl = dotenv.get('PUBLIC_CONNECTION_URL');

  // Parametrização de collection e channel via .env (com fallback para checklist_items)
  // Exemplo no .env:
  //   COLLECTION_NAME=testes
  //   CHANNEL=testes
  static String collection = dotenv.env['COLLECTION_NAME'] ?? 'checklist_items';
  static String channel = dotenv.env['CHANNEL'] ?? 'checklist_items';

  // Scope padrão
  static const String scope = '_default';
}
