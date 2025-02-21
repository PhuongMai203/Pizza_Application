import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:collection/collection.dart';

import 'cart_event_bloc.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState.initial()) {
    // Xử lý sự kiện thêm pizza vào giỏ hàng
    on<AddToCart>((event, emit) {
      final existingPizza = state.pizzas.firstWhereOrNull(
            (p) => p.pizzaId == event.pizza.pizzaId,
      );

      List<Pizza> updatedList;
      if (existingPizza != null) { // ✅ Kiểm tra null thay vì dùng empty()
        updatedList = state.pizzas.map((p) {
          if (p.pizzaId == event.pizza.pizzaId) {
            return p.copyWith(quantity: p.quantity + 1);
          }
          return p;
        }).toList();
      } else {
        updatedList = List<Pizza>.from(state.pizzas)..add(event.pizza);
      }

      emit(state.copyWith(pizzas: updatedList));
    });

    // Xử lý sự kiện giảm số lượng hoặc xóa pizza khỏi giỏ hàng
    on<RemoveFromCart>((event, emit) {
      final updatedList = state.pizzas.map((p) {
        if (p.pizzaId == event.pizza.pizzaId) {
          if (p.quantity > 1) {
            return p.copyWith(quantity: p.quantity - 1);
          } else {
            return null; // Nếu số lượng về 0, loại bỏ pizza khỏi danh sách
          }
        }
        return p;
      }).where((p) => p != null).cast<Pizza>().toList();

      emit(state.copyWith(pizzas: updatedList));
    });

    // Xử lý chọn/bỏ chọn pizza
    on<ToggleSelectPizza>((event, emit) {
      final updatedPizzas = state.pizzas.map((p) {
        if (p.pizzaId == event.pizza.pizzaId) {
          return p.copyWith(isSelected: event.isSelected);
        }
        return p;
      }).toList();
      emit(state.copyWith(pizzas: updatedPizzas));
    });

    // Xử lý tăng số lượng pizza
    on<IncreasePizzaQuantity>((event, emit) {
      final updatedPizzas = state.pizzas.map((p) {
        if (p.pizzaId == event.pizza.pizzaId) {
          return p.copyWith(quantity: p.quantity + 1);
        }
        return p;
      }).toList();

      emit(state.copyWith(pizzas: updatedPizzas));
    });
  }
}
