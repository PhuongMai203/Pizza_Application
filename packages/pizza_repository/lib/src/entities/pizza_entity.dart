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
  });

  Map<String, Object?> toDocument() {
    return {
      'pizzaId': pizzaId,
      'picture': picture,
      'isVeg': isVeg,
      'spicy': spicy,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'macros': macros.toDocument(),
      'quantity': quantity,
    };
  }

  static PizzaEntity fromDocument(Map<String, dynamic> doc) {
    return PizzaEntity(
      pizzaId: doc['pizzaId'] ?? '',
      picture: doc['picture'] ?? '',
      isVeg: doc['isVeg'] ?? false,
      spicy: doc['spicy'] ?? 0,
      name: doc['name'] ?? '',
      description: doc['description'] ?? '',
      price: doc['price'] ?? 0,
      discount: doc['discount'] ?? 0,
      macros: MacrosEntity.fromDocument(doc['macros'] ?? {}),
      quantity: doc.containsKey('quantity') && doc['quantity'] is int
          ? doc['quantity']
          : 1,
    );
  }
}
