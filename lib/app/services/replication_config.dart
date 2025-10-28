import 'package:checklist/app/utils/couchbase_constants.dart';

class ReplicationConfig {
  final Uri url;
  final String username;
  final String password;
  final String scope;
  final String checklistCollection;
  final String userCollection;
  final String checklistChannel;
  final String userChannel;

  const ReplicationConfig({
    required this.url,
    required this.username,
    required this.password,
    required this.scope,
    required this.checklistCollection,
    required this.userCollection,
    required this.checklistChannel,
    required this.userChannel,
  });

  factory ReplicationConfig.fromEnv({Map<String, String>? override}) {
    final url = Uri.parse(
      override?['PUBLIC_CONNECTION_URL'] ??
          CouchbaseContants.publicConnectionUrl,
    );
    return ReplicationConfig(
      url: url,
      username: override?['USER_NAME'] ?? CouchbaseContants.userName,
      password: override?['USER_PASSWORD'] ?? CouchbaseContants.password,
      scope: override?['SCOPE_NAME'] ?? CouchbaseContants.scope,
      checklistCollection:
          override?['COLLECTION_NAME'] ?? CouchbaseContants.collection,
      userCollection:
          override?['USER_COLLECTION_NAME'] ?? CouchbaseContants.userCollection,
      checklistChannel: override?['CHANNEL'] ?? CouchbaseContants.channel,
      userChannel: override?['USER_CHANNEL'] ?? CouchbaseContants.userChannel,
    );
  }

  /// Validate configuration before attempting network connections.
  /// Throws [StateError] with actionable messages when invalid.
  void validate() {
    // Scheme must be ws or wss
    if (!(url.scheme == 'ws' || url.scheme == 'wss')) {
      throw StateError(
        'PUBLIC_CONNECTION_URL deve usar ws:// ou wss:// (atual: ${url.scheme}://...)',
      );
    }
    // Must include db name in path
    if (url.pathSegments.isEmpty ||
        (url.pathSegments.length == 1 && url.pathSegments.first.isEmpty)) {
      throw StateError(
          'PUBLIC_CONNECTION_URL deve incluir o nome do banco (ex.: ws://host:4984/checklist_db)');
    }
    // Credentials should not be placeholders or empty
    final isPlaceholderUser =
        username.trim().isEmpty || username == 'your_username';
    final isPlaceholderPass =
        password.trim().isEmpty || password == 'your_password';
    if (isPlaceholderUser || isPlaceholderPass) {
      throw StateError(
        'Credenciais inválidas: defina USER_NAME/USER_PASSWORD no .env ou rode scripts/ensure-sg-user-from-env.sh',
      );
    }
  }
}
