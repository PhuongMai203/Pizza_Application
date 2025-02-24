import 'package:pizza_repository/pizza_repository.dart';

class OrderStorage {
  static List<OrderData> orderHistory = [];
}

class OrderData {
  final String itemName;
  final String itemImage;
  final int quantity;
  final double totalPrice;
  final String orderTime;
  final List<Pizza> pizzas;

  OrderData({
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.totalPrice,
    required this.orderTime,
    this.pizzas = const [],
  });
}
