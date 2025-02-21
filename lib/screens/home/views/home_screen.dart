import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/home/views/details_screen.dart';
import 'package:pizza_app/screens/home/views/user_profile_screen.dart';
import '../../auth/blocs/cart_blocs/cart_bloc.dart';
import '../../auth/blocs/cart_blocs/cart_event_bloc.dart';
import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../auth/views/cart_screen.dart';
import 'package:intl/intl.dart'; // Import thư viện intl

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});
  static final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/8.png',
              scale: 14,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'PIZZA',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30
              ),
            )
          ],
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(  // Lắng nghe trạng thái giỏ hàng
            builder: (context, cartState) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: context.read<CartBloc>(),
                        child: const CartScreen(),
                      ),
                    ),
                  );

                },
                icon: Stack(
                  children: [
                    const Icon(CupertinoIcons.cart),
                    if (cartState.pizzas.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            cartState.pizzas.fold(0, (sum, pizza) => sum + pizza.quantity).toString(), // ✅ Tính tổng số lượng
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(SignOutRequired());
            },
            icon: const Icon(CupertinoIcons.arrow_right_to_line),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<SignInBloc>(), // ✅ Đảm bảo SignInBloc được cung cấp
                    child: const UserProfileScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(CupertinoIcons.person_alt_circle),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<GetPizzaBloc, GetPizzaState>(
          builder: (context, state) {
            if (state is GetPizzaSuccess) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 10,
                  childAspectRatio: 9 / 16,
                ),
                itemCount: state.pizzas.length,
                itemBuilder: (context, int i) {
                  return Material(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => DetailsScreen(state.pizzas[i]),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(state.pizzas[i].picture),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: state.pizzas[i].isVeg ? Colors.green : Colors.red,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    child: Text(
                                      state.pizzas[i].isVeg ? "CÓ RAU CỦ" : "KHÔNG RAU CỦ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                    child: Text(
                                      state.pizzas[i].spicy == 1
                                          ? "KHÔNG CAY"
                                          : state.pizzas[i].spicy == 2
                                          ? "CAY VỪA"
                                          : "CAY",
                                      style: TextStyle(
                                        color: state.pizzas[i].spicy == 1
                                            ? Colors.white
                                            : state.pizzas[i].spicy == 2
                                            ? Colors.orange
                                            : Colors.red,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              state.pizzas[i].name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              state.pizzas[i].description,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      formatCurrency.format(state.pizzas[i].price - (state.pizzas[i].price * state.pizzas[i].discount / 100)),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      formatCurrency.format(state.pizzas[i].price), // Hiển thị giá gốc
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.lineThrough
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<CartBloc>().add(RemoveFromCart(state.pizzas[i]));
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.minus_circle,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    "${state.pizzas[i].quantity}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      context.read<CartBloc>().add(AddToCart(state.pizzas[i]));
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.add_circled,
                                      size: 20,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is GetPizzaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text("Something went wrong!"));
            }
          },
        ),
      ),
    );
  }
}
