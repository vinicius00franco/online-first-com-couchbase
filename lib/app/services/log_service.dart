import 'dart:async';
import '../entities/log_entity.dart';
import '../repositories/log_repository.dart';
import 'couchbase_service.dart';

class LogService {
  final LogRepository _repository =
      LogRepository(couchbaseService: CouchbaseService());
  final StringBuffer _buffer = StringBuffer();
  Timer? _timer;

  void init() {
    _timer = Timer.periodic(Duration(hours: 1), (_) => _compress());
  }

  void log(String message, String level) {
    final log = LogEntity(
      message: message,
      level: level,
      timestamp: DateTime.now(),
    );

    _repository.addLog(log);
    _buffer.writeln('[${log.timestamp}] [$level] $message');

    if (_buffer.length > 5000) {
      final content = _buffer.toString();
      _buffer.clear();
      _buffer.write(content.substring(content.length - 2500));
    }
  }

  String getLogs() => _buffer.toString();

  Future<void> _compress() async {
    final cutoff = DateTime.now().subtract(Duration(days: 1));
    final oldLogs = await _repository.fetchOldLogs(cutoff);

    if (oldLogs.isEmpty) return;

    final compressed = LogEntity(
      message: 'Compressed ${oldLogs.length} logs',
      level: 'system',
      timestamp: DateTime.now(),
      compressed: true,
    );

    await _repository.addLog(compressed);

    for (final log in oldLogs) {
      if (log.id != null) await _repository.deleteLog(log.id!);
    }
  }

  void dispose() => _timer?.cancel();
}
