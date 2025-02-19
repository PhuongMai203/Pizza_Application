class MacrosEntity {
  int calories;
  int proteins;
  int fat;
  int carbs;

  MacrosEntity({
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  Map<String, Object?> toDocument() {
    return {
      'calories': calories,
      'proteins': proteins,
      'fat': fat,
      'carbs': carbs,
    };
  }

  static MacrosEntity fromDocument(Map<String, dynamic> doc) {
  return MacrosEntity(
    calories: doc['calories'] != null ? (doc['calories'] as num).toInt() : 0,
    proteins: doc['proteins'] != null ? (doc['proteins'] as num).toInt() : 0,
    carbs: doc['carbs'] != null ? (doc['carbs'] as num).toInt() : 0,
    fat: doc['fat'] != null ? (doc['fat'] as num).toInt() : 0,
  );
}

}