// cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
//
// class CartBloc extends Cubit<int> {
//   CartBloc() : super(0);  // Mặc định số lượng sản phẩm trong giỏ hàng là 0.
//
//   void addToCart() {
//     emit(state + 1);  // Tăng số lượng sản phẩm trong giỏ hàng.
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';
part 'cart_state.dart';

class CartBloc extends Cubit<CartState> {
  CartBloc() : super(CartState.initial());

  void addToCart(Pizza pizza) {
    final updatedList = List<Pizza>.from(state.pizzas)..add(pizza);
    emit(state.copyWith(pizzas: updatedList));
  }

  void removeFromCart(Pizza pizza) {
    final updatedList = List<Pizza>.from(state.pizzas)..remove(pizza);
    emit(state.copyWith(pizzas: updatedList));
  }
}