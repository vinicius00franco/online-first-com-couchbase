import 'package:checklist/app/entities/shopping_item_entity.dart';

import '../services/couchbase_service.dart';
import '../utils/couchbase_constants.dart';

class ChecklistRepository {
  final CouchbaseService couchbaseService;

  ChecklistRepository({required this.couchbaseService});

  final collectionName = CouchbaseContants.collection;

  Future<List<ShoppingItemEntity>> fetchAll({required String userId}) async {
    final result = await couchbaseService.fetch(collectionName: collectionName);
    final data = result
        .where((item) => item['userId'] == userId)
        .map(ShoppingItemEntity.fromMap)
        .toList();
    return data;
  }

  Future<String?> addItem(ShoppingItemEntity item) async {
    final docId = await couchbaseService.add(
      data: item.toMap(),
      collectionName: collectionName,
    );
    return docId;
  }

  Future<void> updateItem({
    required String uuid,
    String? title,
    bool? isCompleted,
    double? price,
  }) async {
    await couchbaseService.edit(
      collectionName: collectionName,
      id: uuid,
      data: {
        if (title != null) 'title': title,
        if (isCompleted != null) 'isCompleted': isCompleted,
        if (price != null) 'price': price,
      },
    );
  }

  Future<void> deleteItem(String uuid) async {
    await couchbaseService.delete(collectionName: collectionName, id: uuid);
  }
}
