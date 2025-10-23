import '../services/log_service.dart';

class Logger {
  static final Logger _instance = Logger._();
  static Logger get instance => _instance;
  Logger._();

  final LogService _service = LogService();

  void init() => _service.init();
  void info(String message) => _service.log(message, 'info');
  void error(String message) => _service.log(message, 'error');
  String getLogs() => _service.getLogs();
  void dispose() => _service.dispose();
}
