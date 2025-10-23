class LogEntity {
  String? id;
  String message;
  String level;
  DateTime timestamp;
  bool compressed;

  LogEntity({
    this.id,
    required this.message,
    required this.level,
    required this.timestamp,
    this.compressed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'level': level,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'compressed': compressed,
    };
  }

  factory LogEntity.fromMap(Map<String, dynamic> data) {
    return LogEntity(
      id: data['id'],
      message: data['message'] ?? '',
      level: data['level'] ?? 'info',
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      compressed: data['compressed'] ?? false,
    );
  }
}
