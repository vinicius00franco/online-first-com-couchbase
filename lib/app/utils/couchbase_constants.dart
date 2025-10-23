import 'package:flutter_dotenv/flutter_dotenv.dart';

class CouchbaseContants {
  // Credenciais / endpoint
  static String userName = dotenv.get('USER_NAME');
  static String password = dotenv.get('USER_PASSWORD');
  static String publicConnectionUrl = dotenv.get('PUBLIC_CONNECTION_URL');

  // Parametrização de scope, collection e channel via .env (com fallback)
  static String scope = dotenv.env['SCOPE_NAME'] ?? '_default';
  static String collection = dotenv.env['COLLECTION_NAME'] ?? 'checklist_items';
  static String channel = dotenv.env['CHANNEL'] ?? 'checklist_items';
  static String logCollection = dotenv.env['LOG_COLLECTION'] ?? 'app_logs';
}
