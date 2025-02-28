import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Pizza pizza;

  const AddToCart(this.pizza);

  @override
  List<Object> get props => [pizza];
}

class RemoveFromCart extends CartEvent {
  final Pizza pizza;

  const RemoveFromCart(this.pizza);

  @override
  List<Object> get props => [pizza];
}

class IncreaseQuantity extends CartEvent {
  final int index;

  const IncreaseQuantity({required this.index});

  @override
  List<Object> get props => [index];
}

class DecreaseQuantity extends CartEvent {
  final int index;

  const DecreaseQuantity({required this.index});

  @override
  List<Object> get props => [index];
}

class ToggleSelectPizza extends CartEvent {
  final Pizza pizza;
  final bool isSelected;

  const ToggleSelectPizza({required this.pizza, required this.isSelected});

  @override
  List<Object> get props => [pizza, isSelected];
}
class IncreasePizzaQuantity extends CartEvent {
  final Pizza pizza;

  IncreasePizzaQuantity(this.pizza);

  @override
  List<Object> get props => [pizza];
}
class LoadCart extends CartEvent {
  @override
  List<Object> get props => [];
}

