class UserEntity {
  final String? id;
  final String name;
  final String email;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? passwordHash,
    String? salt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    final createdAt = map['createdAt'];
    final updatedAt = map['updatedAt'];
    return UserEntity(
      id: map['id'] as String?,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['passwordHash'] as String,
      salt: map['salt'] as String,
      createdAt: createdAt is DateTime
          ? createdAt
          : DateTime.parse(createdAt as String),
      updatedAt: updatedAt is DateTime
          ? updatedAt
          : DateTime.parse(updatedAt as String),
    );
  }
}
