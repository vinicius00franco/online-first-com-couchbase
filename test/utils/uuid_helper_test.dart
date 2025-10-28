import 'package:flutter_test/flutter_test.dart';
import 'package:checklist/app/utils/uuid_helper.dart';

void main() {
  group('UuidHelper', () {
    test('generate() should return a valid UUID v4 string', () {
      // Arrange
      final uuidHelper = UuidHelper();

      // Act
      final uuid = uuidHelper.generate();

      // Assert
      expect(uuid, isA<String>());
      expect(uuid.length,
          36); // UUID v4 format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
      expect(uuid[14], '4'); // Version 4
      expect(['8', '9', 'a', 'b'].contains(uuid[19]), isTrue); // Variant bits
    });

    test('generate() should return unique UUIDs on multiple calls', () {
      // Arrange
      final uuidHelper = UuidHelper();

      // Act
      final uuid1 = uuidHelper.generate();
      final uuid2 = uuidHelper.generate();

      // Assert
      expect(uuid1, isNot(equals(uuid2)));
    });
  });
}
