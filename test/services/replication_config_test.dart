import 'package:checklist/app/services/replication_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReplicationConfig.fromEnv', () {
    test('maps provided variables into ReplicationConfig correctly', () {
      final cfg = ReplicationConfig.fromEnv(override: const {
        'USER_NAME': 'test_user',
        'USER_PASSWORD': 'secret123',
        'PUBLIC_CONNECTION_URL': 'ws://localhost:4984/checklist_db',
        'SCOPE_NAME': '_default',
        'COLLECTION_NAME': 'checklist_items',
        'CHANNEL': 'checklist_items',
        'USER_COLLECTION_NAME': 'users',
        'USER_CHANNEL': 'users',
      });
      expect(cfg.username, 'test_user');
      expect(cfg.password, 'secret123');
      expect(cfg.url.toString(), 'ws://localhost:4984/checklist_db');
      expect(cfg.scope, '_default');
      expect(cfg.checklistCollection, 'checklist_items');
      expect(cfg.userCollection, 'users');
      expect(cfg.checklistChannel, 'checklist_items');
      expect(cfg.userChannel, 'users');
    });

    test('validate throws for placeholder credentials', () {
      final cfg = ReplicationConfig.fromEnv(override: const {
        'USER_NAME': 'your_username',
        'USER_PASSWORD': 'your_password',
        'PUBLIC_CONNECTION_URL': 'ws://localhost:4984/checklist_db',
      });
      expect(() => cfg.validate(), throwsA(isA<StateError>()));
    });

    test('validate throws for unsupported scheme', () {
      final cfg = ReplicationConfig.fromEnv(override: const {
        'USER_NAME': 'u',
        'USER_PASSWORD': 'p',
        'PUBLIC_CONNECTION_URL': 'http://localhost:4984/checklist_db',
      });
      expect(() => cfg.validate(), throwsA(isA<StateError>()));
    });

    test('validate throws for missing db name in URL', () {
      final cfg = ReplicationConfig.fromEnv(override: const {
        'USER_NAME': 'u',
        'USER_PASSWORD': 'p',
        'PUBLIC_CONNECTION_URL': 'ws://localhost:4984',
      });
      expect(() => cfg.validate(), throwsA(isA<StateError>()));
    });

    test('validate passes for correct config', () {
      final cfg = ReplicationConfig.fromEnv(override: const {
        'USER_NAME': 'u',
        'USER_PASSWORD': 'p',
        'PUBLIC_CONNECTION_URL': 'ws://localhost:4984/checklist_db',
        'SCOPE_NAME': '_default',
        'COLLECTION_NAME': 'checklist_items',
        'CHANNEL': 'checklist_items',
        'USER_COLLECTION_NAME': 'users',
        'USER_CHANNEL': 'users',
      });
      expect(() => cfg.validate(), returnsNormally);
    });
  });
}
