import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_event_bloc.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CartBloc() : super(CartState.initial()) {
    // ✅ Khi mở app, tải giỏ hàng từ Firebase
    on<LoadCart>((event, emit) async {
      String userId = _auth.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        List<Pizza> loadedCart = await _loadCartFromFirestore(userId);
        emit(state.copyWith(pizzas: loadedCart));
      }
    });

    // ✅ Xử lý sự kiện thêm pizza vào giỏ hàng
    on<AddToCart>((event, emit) async {
      List<Pizza> updatedList = _addPizzaToList(state.pizzas, event.pizza);
      emit(state.copyWith(pizzas: updatedList));
      await _saveCartToFirestore(updatedList); // Lưu vào Firebase
    });

    // ✅ Xử lý sự kiện giảm số lượng hoặc xóa pizza khỏi giỏ hàng
    on<RemoveFromCart>((event, emit) async {
      List<Pizza> updatedList = _removePizzaFromList(state.pizzas, event.pizza);
      emit(state.copyWith(pizzas: updatedList));
      await _saveCartToFirestore(updatedList); // Cập nhật Firebase
    });

    // ✅ Xử lý chọn/bỏ chọn pizza
    on<ToggleSelectPizza>((event, emit) {
      final updatedPizzas = state.pizzas.map((p) {
        if (p.pizzaId == event.pizza.pizzaId) {
          return p.copyWith(isSelected: event.isSelected);
        }
        return p;
      }).toList();
      emit(state.copyWith(pizzas: updatedPizzas));
    });

    // ✅ Xử lý tăng số lượng pizza
    on<IncreasePizzaQuantity>((event, emit) async {
      final updatedPizzas = state.pizzas.map((p) {
        if (p.pizzaId == event.pizza.pizzaId) {
          return p.copyWith(quantity: p.quantity + 1);
        }
        return p;
      }).toList();

      emit(state.copyWith(pizzas: updatedPizzas));
      await _saveCartToFirestore(updatedPizzas); // Lưu vào Firebase
    });
  }

  // ✅ Hàm tải giỏ hàng từ Firebase
  Future<List<Pizza>> _loadCartFromFirestore(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).collection('cart').get();
    return snapshot.docs.map((doc) => Pizza.fromMap(doc.data())).toList();
  }

  // ✅ Hàm lưu giỏ hàng vào Firebase
  Future<void> _saveCartToFirestore(List<Pizza> cart) async {
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) return;

    final userCartRef = _firestore.collection('users').doc(userId).collection('cart');
    await userCartRef.get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete(); // Xóa giỏ hàng cũ
      }
    });

    for (var pizza in cart) {
      await userCartRef.doc(pizza.pizzaId).set(pizza.toMap());
    }
  }

  // ✅ Hàm xử lý thêm pizza vào danh sách
  List<Pizza> _addPizzaToList(List<Pizza> pizzas, Pizza newPizza) {
    final existingPizza = pizzas.firstWhereOrNull((p) => p.pizzaId == newPizza.pizzaId);
    if (existingPizza != null) {
      return pizzas.map((p) {
        return p.pizzaId == newPizza.pizzaId ? p.copyWith(quantity: p.quantity + 1) : p;
      }).toList();
    } else {
      return List<Pizza>.from(pizzas)..add(newPizza);
    }
  }

  // ✅ Hàm xử lý giảm số lượng pizza hoặc xóa pizza khỏi giỏ hàng
  List<Pizza> _removePizzaFromList(List<Pizza> pizzas, Pizza removePizza) {
    return pizzas
        .map((p) => p.pizzaId == removePizza.pizzaId
        ? (p.quantity > 1 ? p.copyWith(quantity: p.quantity - 1) : null)
        : p)
        .where((p) => p != null)
        .cast<Pizza>()
        .toList();
  }
}
