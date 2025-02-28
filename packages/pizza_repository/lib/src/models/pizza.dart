import '../entities/entities.dart';
import 'models.dart';

class Pizza {
  final String pizzaId;
  final String picture;
  final bool isVeg;
  final int spicy;
  final String name;
  final String description;
  final int price;
  final int discount;
  final Macros macros;
  final int quantity;
  final bool isSelected;

  Pizza({
    required this.pizzaId,
    required this.picture,
    required this.isVeg,
    required this.spicy,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.macros,
    this.quantity = 1,
    this.isSelected = false,
  });
  // ✅ Chuyển từ PizzaEntity sang Pizza
  static Pizza fromEntity(PizzaEntity entity) {
    return Pizza(
      pizzaId: entity.pizzaId,
      picture: entity.picture,
      isVeg: entity.isVeg,
      spicy: entity.spicy,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discount: entity.discount,
      macros: Macros.fromEntity(entity.macros),
      quantity: entity.quantity,
      isSelected: entity.isSelected,
    );
  }
  // ✅ Chuyển Pizza thành PizzaEntity
  PizzaEntity toEntity() {
    return PizzaEntity(
      pizzaId: pizzaId,
      picture: picture,
      isVeg: isVeg,
      spicy: spicy,
      name: name,
      description: description,
      price: price,
      discount: discount,
      macros: macros.toEntity(),
      quantity: quantity,
      isSelected: isSelected,
    );
  }
  Pizza copyWith({int? quantity, bool? isSelected}) {
    return Pizza(
      pizzaId: pizzaId,
      picture: picture,
      isVeg: isVeg,
      spicy: spicy,
      name: name,
      description: description,
      price: price,
      discount: discount,
      macros: macros,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // ✅ Chuyển Pizza thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'pizzaId': pizzaId,
      'picture': picture,
      'isVeg': isVeg,
      'spicy': spicy,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'macros': macros.toMap(),
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  // ✅ Chuyển từ Map Firestore thành Pizza object
  factory Pizza.fromMap(Map<String, dynamic> map) {
    return Pizza(
      pizzaId: map['pizzaId'] ?? '',
      picture: map['picture'] ?? '',
      isVeg: map['isVeg'] ?? false,
      spicy: map['spicy'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      discount: map['discount'] ?? 0,
      macros: Macros.fromMap(map['macros'] ?? {}),
      quantity: map['quantity'] ?? 1,
      isSelected: map['isSelected'] ?? false,
    );
  }
}
