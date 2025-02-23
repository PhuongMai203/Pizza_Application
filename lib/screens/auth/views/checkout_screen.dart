import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizza_repository/pizza_repository.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Pizza> selectedPizzas;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.selectedPizzas,
    required this.totalPrice,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedPaymentMethod = "Tiền mặt"; // Mặc định là tiền mặt
  final double shippingFee = 20000; // Phí vận chuyển mặc định 20,000đ
  final double discountThreshold = 4; // Số món tối thiểu để được miễn phí vận chuyển

  @override
  Widget build(BuildContext context) {
    int totalItems = widget.selectedPizzas.fold(0, (sum, pizza) => sum + pizza.quantity);
    bool isFreeShipping = totalItems >= discountThreshold;

    double finalShippingFee = isFreeShipping ? 0 : shippingFee;
    double finalTotalPrice = widget.totalPrice + finalShippingFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Thanh toán"),
        backgroundColor: Colors.blue.shade50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin người nhận hàng
            const Text("Thông tin người nhận", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField("Tên người nhận", nameController),
            _buildTextField("Số điện thoại", phoneController, keyboardType: TextInputType.phone),
            _buildTextField("Địa chỉ nhận hàng", addressController),
            _buildTextField("Ghi chú (tuỳ chọn)", noteController),

            const SizedBox(height: 10),

            // Danh sách món ăn
            const Text("Các món đã chọn", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...widget.selectedPizzas.map((pizza) => ListTile(
              leading: Image.network(pizza.picture, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(pizza.name),
              subtitle: Text("Số lượng: ${pizza.quantity}"),
              trailing: Text(formatCurrency.format((pizza.price - (pizza.price * pizza.discount / 100)) * pizza.quantity)),
            )),

            const Divider(height: 30),

            // Chọn phương thức thanh toán
            const Text("Phương thức thanh toán", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            _buildPaymentOption("Tiền mặt"),
            _buildPaymentOption("Ví điện tử (Momo, ZaloPay)"),
            _buildPaymentOption("Thẻ ngân hàng"),

            const Divider(height: 10),

            // Hiển thị phí vận chuyển
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Phí vận chuyển:", style: TextStyle(fontSize: 16)),
                Text(isFreeShipping ? "Miễn phí" : formatCurrency.format(finalShippingFee),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isFreeShipping ? Colors.green : Colors.black)),
              ],
            ),

            const SizedBox(height: 10),

            // Tổng tiền
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng thanh toán:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(formatCurrency.format(finalTotalPrice), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),

            const SizedBox(height: 20),

            // Nút đặt hàng
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Xác nhận đặt hàng", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    return ListTile(
      title: Text(method),
      leading: Radio<String>(
        value: method,
        groupValue: selectedPaymentMethod,
        onChanged: (value) {
          setState(() {
            selectedPaymentMethod = value!;
          });
        },
      ),
    );
  }

  void _placeOrder() {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin nhận hàng!")));
      return;
    }

    // Hiển thị thông báo đặt hàng thành công
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đặt hàng thành công!")));

    // Quay lại màn hình chính sau khi đặt hàng
    Navigator.pop(context);
  }
}
