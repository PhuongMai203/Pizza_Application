import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart_blocs/cart_bloc.dart';



class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.pizzas.length,
            itemBuilder: (context, index) {
              final pizza = state.pizzas[index]; // Lấy pizza từ giỏ hàng
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    pizza.picture,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(pizza.name),
                  subtitle: Text("Số lượng: ${pizza.quantity}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<CartBloc>().removeFromCart(pizza);

                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
