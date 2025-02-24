import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_repository/pizza_repository.dart';
import '../../views/order_detail_screen_state.dart';

class OrderDetailScreen extends StatefulWidget {
  final String itemName;
  final String itemImage;
  final int quantity;
  final double totalPrice;
  final List<Pizza> selectedPizzas; // ✅ Thêm danh sách pizza

  const OrderDetailScreen({
    super.key,
    required this.itemName,
    required this.itemImage,
    required this.quantity,
    required this.totalPrice,
    required this.selectedPizzas, // ✅ Bắt buộc truyền danh sách pizza
  });

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

