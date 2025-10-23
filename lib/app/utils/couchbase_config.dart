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
}