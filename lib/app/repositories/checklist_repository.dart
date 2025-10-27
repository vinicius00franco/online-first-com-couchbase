import 'package:checklist/app/entities/shopping_item_entity.dart';

import '../services/couchbase_service.dart';
import '../utils/couchbase_constants.dart';

class ChecklistRepository {
  final CouchbaseService couchbaseService;

  ChecklistRepository({required this.couchbaseService});

  final collectionName = CouchbaseContants.collection;

  Future<List<ShoppingItemEntity>> fetchAll() async {
    final result = await couchbaseService.fetch(collectionName: collectionName);
    final data = result.map(ShoppingItemEntity.fromMap).toList();
    return data;
  }

  Future<void> addItem(ShoppingItemEntity item) async {
    await couchbaseService.add(
      data: item.toMap(),
      collectionName: collectionName,
    );
  }

  Future<void> updateItem({
    required String id,
    String? title,
    bool? isCompleted,
    double? price,
  }) async {
    await couchbaseService.edit(
      collectionName: collectionName,
      id: id,
      data: {
        if (title != null) 'title': title,
        if (isCompleted != null) 'isCompleted': isCompleted,
        if (price != null) 'price': price,
      },
    );
  }

  Future<void> deleteItem(String id) async {
    await couchbaseService.delete(collectionName: collectionName, id: id);
  }
}
