import 'package:uuid/uuid.dart';

/// Helper class for generating UUIDs
class UuidHelper {
  final Uuid _uuid = const Uuid();

  /// Generates a new UUID v4 string
  String generate() {
    return _uuid.v4();
  }
}