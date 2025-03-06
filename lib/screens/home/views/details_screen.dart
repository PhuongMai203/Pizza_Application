import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pizza_app/components/macro.dart';
import 'package:pizza_app/screens/auth/blocs/cart_blocs/cart_event_bloc.dart';
import 'package:pizza_repository/pizza_repository.dart';

import '../../auth/blocs/cart_blocs/cart_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final Pizza pizza;
  const DetailsScreen(this.pizza, {super.key});

  static final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Chi tiết sản phẩm", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width-(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow:const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(3, 3),
                        blurRadius: 5
                    ),
                  ],

                  image: DecorationImage(
                    image: NetworkImage(
                        pizza.picture
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow:const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(3, 3),
                        blurRadius: 5
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex:2,
                            child: Text(
                              pizza.name ,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatCurrency.format(pizza.price - (pizza.price * pizza.discount / 100)),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    formatCurrency.format(pizza.price),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                          MyMacroWidget(
                            title: "Calories",
                            value: pizza.macros.calories,
                            icon: FontAwesomeIcons.fire,
                          ),
                          const SizedBox(width: 10,),
                          MyMacroWidget(
                            title: "Protein",
                            value: pizza.macros.proteins,
                            icon: FontAwesomeIcons.dumbbell,
                          ),
                          const SizedBox(width: 10,),
                          MyMacroWidget(
                            title: "fat",
                            value: pizza.macros.fat,
                            icon: FontAwesomeIcons.oilWell,
                          ),
                          const SizedBox(width: 10,),
                          MyMacroWidget(
                            title: "carbs",
                            value: pizza.macros.carbs,
                            icon: FontAwesomeIcons.breadSlice,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mô tả sản phẩm
                            Text(
                              pizza.description,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            // Đánh giá
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text('${pizza.rating} (${pizza.reviewsCount} reviews)'),
                                SizedBox(width: 10), // Khoảng cách
                                Spacer(),
                                Icon(Icons.shopping_cart),
                                Text('Đã bán'),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<CartBloc>().add(RemoveFromCart(pizza));
                              },
                              icon: const Icon(
                                CupertinoIcons.minus_circle,
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                "${pizza.quantity}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CartBloc>().add(AddToCart(pizza));
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
