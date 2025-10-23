import 'dart:io';
import 'package:cbl/cbl.dart';
import 'package:path_provider/path_provider.dart';

class CouchbaseConfig {
  static Future<void> configureLogging() async {
    // Configurar logging do Couchbase Lite
    final appDir = await getApplicationDocumentsDirectory();
    final logDir = '${appDir.path}/cbl-logs';

    Database.log.file.config = LogFileConfiguration(
      directory: logDir,
      maxSize: 1024 * 1024, // 1MB por arquivo
      maxRotateCount: 5, // Manter até 5 arquivos de log
      usePlainText: true, // Logs em texto plano para facilitar leitura
    );
  }

  static Future<String> getLogDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/cbl-logs';
  }

  static Future<List<FileSystemEntity>> getLogFiles() async {
    final logDir = await getLogDirectory();
    final directory = Directory(logDir);

    if (!await directory.exists()) {
      return [];
    }

    return directory
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.log'))
        .toList();
  }

  static Future<String> readLogFile(String fileName) async {
    final logDir = await getLogDirectory();
    final file = File('$logDir/$fileName');

    if (!await file.exists()) {
      return 'Arquivo de log não encontrado: $fileName';
    }

    return await file.readAsString();
  }
}
