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
  final int quantity; // Thêm quantity
  final bool isSelected; // Bỏ late final

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
    this.quantity = 1, // Mặc định số lượng là 1
    this.isSelected = false, // Mặc định không được chọn
  });

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
      quantity: quantity ?? this.quantity, // Copy quantity
      isSelected: isSelected ?? this.isSelected, // Copy isSelected
    );
  }

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
      quantity: entity.quantity, // Lấy quantity từ entity
      isSelected: entity.isSelected, // Lấy isSelected từ entity
    );
  }
}
