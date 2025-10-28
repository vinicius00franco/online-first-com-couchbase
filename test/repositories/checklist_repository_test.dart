import 'package:checklist/app/entities/shopping_item_entity.dart';
import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:checklist/app/services/couchbase_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCouchbaseService extends Mock implements CouchbaseService {}

void main() {
  late ChecklistRepository repository;
  late MockCouchbaseService mockCouchbaseService;

  setUp(() {
    mockCouchbaseService = MockCouchbaseService();
    repository = ChecklistRepository(couchbaseService: mockCouchbaseService);
  });

  group('ChecklistRepository', () {
    const userId = 'user123';
    const collectionName = 'checklist_items';

    group('fetchAll', () {
      test('should fetch items filtered by userId', () async {
        // Arrange
        final mockData = [
          {
            'id': '1',
            'uuid': 'uuid1',
            'userId': userId,
            'title': 'Item 1',
            'isCompleted': false,
            'price': 10.0,
          },
          {
            'id': '2',
            'uuid': 'uuid2',
            'userId': 'otherUser',
            'title': 'Item 2',
            'isCompleted': true,
            'price': 20.0,
          },
        ];
        when(() => mockCouchbaseService.fetch(collectionName: collectionName))
            .thenAnswer((_) async => mockData);

        // Act
        final result = await repository.fetchAll(userId: userId);

        // Assert
        expect(result.length, 1);
        expect(result[0].uuid, 'uuid1');
        expect(result[0].userId, userId);
        verify(() => mockCouchbaseService.fetch(collectionName: collectionName))
            .called(1);
      });
    });

    group('addItem', () {
      test('should add item with uuid as document id', () async {
        // Arrange
        final item = ShoppingItemEntity(
          uuid: 'test-uuid',
          userId: userId,
          title: 'Test Item',
          isCompleted: false,
          price: 15.0,
          createdAt: DateTime.now(),
        );
        when(() => mockCouchbaseService.add(
              data: item.toMap(),
              collectionName: collectionName,
            )).thenAnswer((_) async => 'doc-id');

        // Act
        final result = await repository.addItem(item);

        // Assert
        expect(result, 'doc-id');
      });
    });

    group('updateItem', () {
      test('should update item by uuid', () async {
        // Arrange
        const uuid = 'test-uuid';
        when(() => mockCouchbaseService.edit(
              collectionName: collectionName,
              id: uuid,
              data: {'title': 'Updated Title'},
            )).thenAnswer((_) async => true);

        // Act
        await repository.updateItem(
          uuid: uuid,
          title: 'Updated Title',
        );

        // Assert
        verify(() => mockCouchbaseService.edit(
              collectionName: collectionName,
              id: uuid,
              data: {'title': 'Updated Title'},
            )).called(1);
      });
    });

    group('deleteItem', () {
      test('should delete item by uuid', () async {
        // Arrange
        const uuid = 'test-uuid';
        when(() => mockCouchbaseService.delete(
              collectionName: collectionName,
              id: uuid,
            )).thenAnswer((_) async => true);

        // Act
        await repository.deleteItem(uuid);

        // Assert
        verify(() => mockCouchbaseService.delete(
              collectionName: collectionName,
              id: uuid,
            )).called(1);
      });
    });
  });
}
