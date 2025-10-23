class ShoppingItemEntity {
  String? id;
  String title;
  DateTime createdAt;
  bool isCompleted;
  double price;

  ShoppingItemEntity({
    required this.title,
    this.id,
    required this.createdAt,
    this.isCompleted = false,
    this.price = 0.0,
  });

  ShoppingItemEntity copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    bool? isCompleted,
    double? price,
  }) {
    return ShoppingItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'price': price,
    };
  }

  factory ShoppingItemEntity.fromMap(Map<String, dynamic> data) {
    return ShoppingItemEntity(
      title: data['title'] ?? '',
      createdAt: data['createdAt'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
      isCompleted: data['isCompleted'],
      price: (data['price'] ?? 0.0).toDouble(),
      id: data['id'],
    );
  }
}
