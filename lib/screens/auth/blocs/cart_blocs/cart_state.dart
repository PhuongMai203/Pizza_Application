part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<Pizza> pizzas;
  final List<CartItem> items;

  const CartState({this.pizzas = const [], this.items = const []});

  factory CartState.initial() {
    return CartState(pizzas: [], items: []);
  }

  CartState copyWith({List<Pizza>? pizzas, List<CartItem>? items}) {
    return CartState(
      pizzas: pizzas ?? this.pizzas,
      items: items ?? this.items,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object> get props => [pizzas, items];
}

class CartItem {
  final String name;
  final int price;  // Đổi thành int
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});

  // Phương thức tính tổng giá trị món hàng
  int get totalPrice => (price * quantity).round();  // Tính tổng và làm tròn kết quả
}
