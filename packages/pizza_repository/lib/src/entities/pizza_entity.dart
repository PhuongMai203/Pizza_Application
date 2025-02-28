import 'package:pizza_repository/src/entities/macros_entity.dart';
import '../models/models.dart';

class PizzaEntity {
  final String pizzaId;
  final String picture;
  final bool isVeg;
  final int spicy;
  final String name;
  final String description;
  final int price;
  final int discount;
  final MacrosEntity macros;
  final int quantity;
  final bool isSelected;

  PizzaEntity({
    required this.pizzaId,
    required this.picture,
    required this.isVeg,
    required this.spicy,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.macros,
    required this.quantity,
    required this.isSelected,
  });

  // ✅ Chuyển PizzaEntity thành Map để lưu vào Firestore
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

  // ✅ Chuyển Map từ Firestore thành PizzaEntity
  static PizzaEntity fromMap(Map<String, dynamic> map) {
    return PizzaEntity(
      pizzaId: map['pizzaId'] ?? '',
      picture: map['picture'] ?? '',
      isVeg: map['isVeg'] ?? false,
      spicy: map['spicy'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
      discount: map['discount'] ?? 0,
      macros: MacrosEntity.fromMap(map['macros'] ?? {}),
      quantity: map['quantity'] is int ? map['quantity'] : 1,
      isSelected: map['isSelected'] is bool ? map['isSelected'] : false,
    );
  }
}
