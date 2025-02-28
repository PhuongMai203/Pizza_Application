class MacrosEntity {
  final int calories;
  final int proteins;
  final int fat;
  final int carbs;

  MacrosEntity({
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  // ✅ Chuyển MacrosEntity thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbs': carbs,
    };
  }

  // ✅ Chuyển Map từ Firestore thành MacrosEntity
  static MacrosEntity fromMap(Map<String, dynamic> map) {
    return MacrosEntity(
      calories: map['calories'] ?? 0,
      proteins: map['proteins'] ?? 0,
      fat: map['fat'] ?? 0,
      carbs: map['carbs'] ?? 0,
    );
  }
}
