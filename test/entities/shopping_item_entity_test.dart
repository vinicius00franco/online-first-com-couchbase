import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShoppingItemEntity', () {
    test('should create entity with required userId and uuid', () {
      final entity = ShoppingItemEntity(
        title: 'Test Item',
        userId: 'user123',
        uuid: 'uuid-123',
        createdAt: DateTime(2024),
        isCompleted: false,
        price: 10.0,
      );

      expect(entity.title, 'Test Item');
      expect(entity.userId, 'user123');
      expect(entity.uuid, 'uuid-123');
      expect(entity.isCompleted, false);
      expect(entity.price, 10.0);
    });

    // Removido: testes que esperam erro, pois Dart força parâmetros obrigatórios em compilação

    test('copyWith should update fields', () {
      final original = ShoppingItemEntity(
        title: 'Original',
        userId: 'user123',
        uuid: 'uuid-123',
        createdAt: DateTime(2024),
        isCompleted: false,
        price: 10.0,
      );

      final updated = original.copyWith(title: 'Updated', isCompleted: true);

      expect(updated.title, 'Updated');
      expect(updated.isCompleted, true);
      expect(updated.userId, 'user123'); // unchanged
      expect(updated.uuid, 'uuid-123'); // unchanged
    });

    test('toMap should include userId and uuid', () {
      final entity = ShoppingItemEntity(
        title: 'Test',
        userId: 'user123',
        uuid: 'uuid-123',
        createdAt: DateTime(2024),
        isCompleted: true,
        price: 15.0,
      );

      final map = entity.toMap();

      expect(map['title'], 'Test');
      expect(map['userId'], 'user123');
      expect(map['uuid'], 'uuid-123');
      expect(map['isCompleted'], true);
      expect(map['price'], 15.0);
    });

    test('fromMap should create entity with userId and uuid', () {
      final map = {
        'id': 'doc123',
        'title': 'Test',
        'userId': 'user123',
        'uuid': 'uuid-123',
        'isCompleted': true,
        'createdAt': DateTime(2024).millisecondsSinceEpoch,
        'price': 20.0,
      };

      final entity = ShoppingItemEntity.fromMap(map);

      expect(entity.id, 'doc123');
      expect(entity.title, 'Test');
      expect(entity.userId, 'user123');
      expect(entity.uuid, 'uuid-123');
      expect(entity.isCompleted, true);
      expect(entity.price, 20.0);
    });
  });
}
