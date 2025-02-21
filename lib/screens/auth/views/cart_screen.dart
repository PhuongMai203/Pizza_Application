import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pizza_repository/pizza_repository.dart';
import '../blocs/cart_blocs/cart_bloc.dart';
import '../blocs/cart_blocs/cart_event_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isSelectAll = false;
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ Hàng"),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.pizzas.isEmpty) {
            return const Center(
              child: Text("Giỏ hàng trống!"),
            );
          }

          // Kiểm tra nếu tất cả pizza đều được chọn
          bool allSelected = state.pizzas.isNotEmpty &&
              state.pizzas.every((pizza) => pizza.isSelected);

          // Tính tổng tiền chỉ cho pizza được chọn
          double totalPrice = state.pizzas.fold(0, (sum, pizza) {
            if (pizza.isSelected) {
              return sum +
                  (pizza.price - (pizza.price * pizza.discount / 100)) *
                      pizza.quantity;
            }
            return sum;
          });

          return Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue.shade50,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.pizzas.length,
                    itemBuilder: (context, index) {
                      final pizza = state.pizzas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: pizza.isSelected,
                                onChanged: (value) {
                                  context.read<CartBloc>().add(
                                      ToggleSelectPizza(
                                          pizza: pizza, isSelected: value!));
                                },
                              ),
                              Image.network(
                                pizza.picture,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                          title: Text(pizza.name),
                          subtitle: Text(
                            "Giá: ${formatCurrency.format(pizza.price - (pizza.price * pizza.discount / 100))}", // ✅ Sử dụng ở đây
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                      RemoveFromCart(pizza));
                                },
                                icon: const Icon(
                                  CupertinoIcons.minus_circle,
                                  size: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  "${state.pizzas[index].quantity}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    IncreasePizzaQuantity(pizza), // Sử dụng sự kiện mới
                                  );
                                },
                                icon: const Icon(
                                  CupertinoIcons.add_circled,
                                  size: 20,
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              _buildCheckoutSection(totalPrice, allSelected, state.pizzas),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckoutSection(double totalPrice, bool allSelected,
      List<Pizza> pizzas) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: allSelected,
                onChanged: (value) {
                  for (var pizza in pizzas) {
                    context.read<CartBloc>().add(
                        ToggleSelectPizza(pizza: pizza, isSelected: value!));
                  }
                },
              ),
              const Text("Chọn tất cả"),
              const Spacer(),
              Text(
                "Tổng tiền: ${formatCurrency.format(totalPrice)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: totalPrice > 0 ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                "Thanh toán",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}