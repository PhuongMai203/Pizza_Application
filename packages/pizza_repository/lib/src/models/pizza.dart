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
  final double rating;
  final int reviewsCount;


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
    required this.rating,
    required this.reviewsCount,

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
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,

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
      rating: rating,
      reviewsCount: reviewsCount,

    );
  }

  // ✅ Tạo một bản sao của Pizza với giá trị mới
  Pizza copyWith({int? quantity, bool? isSelected, double? rating, int? reviewsCount}) {
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
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
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
      'rating': rating,
      'reviewsCount': reviewsCount,
    };
  }

  // ✅ Chuyển từ Map Firestore thành Pizza object
  factory Pizza.fromMap(Map<String, dynamic> map) {
    return Pizza(
      pizzaId: map['pizzaId'] as String? ?? '',
      picture: map['picture'] as String? ?? '',
      isVeg: map['isVeg'] as bool? ?? false,
      spicy: map['spicy'] as int? ?? 0,
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      price: map['price'] as int? ?? 0,
      discount: map['discount'] as int? ?? 0,
      macros: Macros.fromMap(map['macros'] as Map<String, dynamic>? ?? {}),
      quantity: map['quantity'] as int? ?? 1,
      isSelected: map['isSelected'] as bool? ?? false,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0, // ✅ Đảm bảo rating là double
      reviewsCount: map['reviewsCount'] as int? ?? 0,

    );
  }
}
