import '../entities/macros_entity.dart';

class Macros {
  int calories;
  int proteins;
  int fat;
  int carbs;

  Macros({
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  // ✅ Chuyển đổi Macros thành MacrosEntity
  MacrosEntity toEntity() {
    return MacrosEntity(
      calories: calories,
      proteins: proteins,
      fat: fat,
      carbs: carbs,
    );
  }

  // ✅ Chuyển đổi MacrosEntity thành Macros
  static Macros fromEntity(MacrosEntity entity) {
    return Macros(
      calories: entity.calories,
      proteins: entity.proteins,
      fat: entity.fat,
      carbs: entity.carbs,
    );
  }

  // ✅ Chuyển Macros thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbs': carbs,
    };
  }

  // ✅ Chuyển Map từ Firestore thành Macros
  static Macros fromMap(Map<String, dynamic> map) {
    return Macros(
      calories: map['calories'] ?? 0,
      proteins: map['proteins'] ?? 0,
      fat: map['fat'] ?? 0,
      carbs: map['carbs'] ?? 0,
    );
  }
}
