import 'package:flutter/material.dart';
import '../blocs/oder/order_detail_screen.dart';
import '../blocs/oder/order_storage.dart'; // Import OrderStorage
import '../views/order_history_screen.dart'; // Import màn hình Lịch sử đơn hàng

@override
OrderDetailScreenState createState() => OrderDetailScreenState();

class OrderDetailScreenState extends State<OrderDetailScreen> {
  int _orderStatus = 0; // 0: Đang chuẩn bị, 1: Đang giao, 2: Đã nhận hàng

  @override
  void initState() {
    super.initState();
    _simulateOrderProgress();
  }
  void _simulateOrderProgress() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) setState(() => _orderStatus = 1);
    });

    Future.delayed(const Duration(seconds: 45), () {
      if (mounted) {
        setState(() => _orderStatus = 2);
        _saveOrder(); // Lưu đơn hàng
      }
    });
  }
  void _saveOrder() {
    // Kiểm tra xem đơn hàng đã được lưu chưa
    bool exists = OrderStorage.orderHistory.any((order) =>
    order.itemName == widget.itemName &&
        order.totalPrice == widget.totalPrice);

    if (!exists) {
      // Lưu đơn hàng vào lịch sử
      OrderStorage.orderHistory.add(OrderData(
        itemName: widget.itemName,
        itemImage: widget.itemImage,
        quantity: widget.quantity,
        totalPrice: widget.totalPrice,
        orderTime: DateTime.now().toString(),
        pizzas: widget.selectedPizzas,
      ));
    }
  }

  void _navigateToOrderHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> statusTexts = ["Quán đang chuẩn bị", "Đang giao", "Đã nhận hàng"];
    List<Color> statusColors = [Colors.orange, Colors.blue, Colors.green];

    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết đơn hàng")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_pizza, size: 100, color: statusColors[_orderStatus]),
            const SizedBox(height: 20),
            Text(statusTexts[_orderStatus], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            if (_orderStatus == 2) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToOrderHistory,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.green,
                ),
                child: const Text("Xem lịch sử đơn hàng", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ],

        ),
      ),
    );
  }
}