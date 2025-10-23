import '../entities/log_entity.dart';
import '../services/couchbase_service.dart';

class LogRepository {
  final CouchbaseService couchbaseService;

  LogRepository({required this.couchbaseService});

  static const collectionName = 'app_logs';

  Future<void> addLog(LogEntity log) async {
    await couchbaseService.add(
      data: log.toMap(),
      collectionName: collectionName,
    );
  }

  Future<List<LogEntity>> fetchOldLogs(DateTime cutoff) async {
    final filter =
        'timestamp < ${cutoff.millisecondsSinceEpoch} AND compressed = false';
    final result = await couchbaseService.fetch(
      collectionName: collectionName,
      filter: filter,
    );
    return result.map(LogEntity.fromMap).toList();
  }

  Future<void> deleteLog(String id) async {
    await couchbaseService.delete(collectionName: collectionName, id: id);
  }
}
