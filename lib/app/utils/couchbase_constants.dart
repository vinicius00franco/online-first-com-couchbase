import 'package:flutter_dotenv/flutter_dotenv.dart';

class CouchbaseContants {
  // Credenciais / endpoint
  static String get userName => _required('USER_NAME');
  static String get password => _required('USER_PASSWORD');
  static String get publicConnectionUrl => _required('PUBLIC_CONNECTION_URL');

  // Parametrização de scope, collection e channel via .env (com fallback)
  static String get scope => _optional('SCOPE_NAME', '_default');
  static String get collection => _optional('COLLECTION_NAME', 'checklist_items');
  static String get channel => _optional('CHANNEL', 'checklist_items');

  static String get userCollection => _optional('USER_COLLECTION_NAME', 'users');
  static String get userChannel => _optional('USER_CHANNEL', 'users');

  static String _required(String key) {
    if (!dotenv.isInitialized) {
      throw Exception('dotenv não inicializado para chave $key');
    }
    return dotenv.get(key);
  }

  static String _optional(String key, String fallback) {
    if (!dotenv.isInitialized) {
      return fallback;
    }
    return dotenv.env[key] ?? fallback;
  }
}
