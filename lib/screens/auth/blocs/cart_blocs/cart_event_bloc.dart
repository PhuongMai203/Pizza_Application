import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final Pizza pizza;

  AddToCartEvent(this.pizza);

  @override
  List<Object> get props => [pizza];
}

class RemoveFromCartEvent extends CartEvent {
  final Pizza pizza;

  RemoveFromCartEvent(this.pizza);

  @override
  List<Object> get props => [pizza];
}

class IncreaseQuantityEvent extends CartEvent {
  final int index;

  IncreaseQuantityEvent({required this.index});
}

class DecreaseQuantityEvent extends CartEvent {
  final int index;

  DecreaseQuantityEvent({required this.index});
}