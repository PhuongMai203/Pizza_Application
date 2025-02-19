// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:pizza_repository/pizza_repository.dart';
//
// part 'cart_event.dart';
// part 'cart_state.dart';
//
// class CartBloc extends Bloc<CartEvent, CartState> {
//   CartBloc() : super(CartState.initial()) {
//     on<AddToCartEvent>((event, emit) {
//       final updatedList = List<Pizza>.from(state.pizzas)..add(event.pizza);
//       emit(state.copyWith(pizzas: updatedList));
//     });
//
//     on<RemoveFromCartEvent>((event, emit) {
//       final updatedList = List<Pizza>.from(state.pizzas)..remove(event.pizza);
//       emit(state.copyWith(pizzas: updatedList));
//     });
//   }
// }
