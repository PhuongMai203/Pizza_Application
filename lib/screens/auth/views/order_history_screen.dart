import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../blocs/oder/order_storage.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lịch sử đơn hàng"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: OrderStorage.orderHistory.isEmpty
          ? const Center(child: Text("Chưa có đơn hàng nào được hoàn thành!"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: OrderStorage.orderHistory.length,
        itemBuilder: (context, index) {
          final order = OrderStorage.orderHistory[index];
          //
          // // ✅ Tính tổng tiền của đơn hàng
          // double totalPrice = order.pizzas.fold(0, (sum, pizza) {
          //   return sum +
          //       (pizza.price - (pizza.price * pizza.discount / 100)) * pizza.quantity;
          // });

          return Card(
            child: ListTile(
              leading: Image.network(order.itemImage, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(order.itemName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Số lượng: ${order.quantity}"),
                  // Text(
                  //   "Tổng tiền: ${formatCurrency.format(totalPrice)}",
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  Text("Thời gian: ${order.orderTime}"),
                ],
              ),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}
