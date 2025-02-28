import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../blocs/oder/order_detail_screen.dart';
import 'bank_account_link_screen.dart';

const String kGoogleApiKey = "AIzaSyDaoX8UCu2amH1Hm-VxbiCZEhlB4Jex-w8";

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
  final TextEditingController _bankAccountController = TextEditingController(); // Thêm controller cho tài khoản ngân hàng

  String selectedPaymentMethod = "Tiền mặt";
  final double shippingFee = 20000;
  final double discountThreshold = 4;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        nameController.text = userDoc['name'] ?? "";
        phoneController.text = userDoc['phone'] ?? "";
        addressController.text = userDoc['address'] ?? "";
        _bankAccountController.text =
            userDoc['bankAccount'] ?? ""; // Thêm dòng này
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalItems =
    widget.selectedPizzas.fold(0, (sum, pizza) => sum + pizza.quantity);
    bool isFreeShipping = totalItems >= discountThreshold;
    double finalShippingFee = isFreeShipping ? 0 : shippingFee;
    double finalTotalPrice = widget.totalPrice + finalShippingFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Thanh toán"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Thông tin người nhận",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField("Tên người nhận", nameController),
            _buildTextField("Số điện thoại", phoneController,
                keyboardType: TextInputType.phone),
            _buildAddressField(),
            _buildBankAccountField(), // Đã thêm ở đây
            _buildTextField("Ghi chú (tuỳ chọn)", noteController),

            const SizedBox(height: 10),
            const Text("Các món đã chọn",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...widget.selectedPizzas.map((pizza) => ListTile(
              leading: Image.network(pizza.picture,
                  width: 50, height: 50, fit: BoxFit.cover),
              title: Text(pizza.name),
              subtitle: Text("Số lượng: ${pizza.quantity}"),
              trailing: Text(formatCurrency.format(
                  (pizza.price - (pizza.price * pizza.discount / 100)) *
                      pizza.quantity)),
            )),

            const Divider(height: 30),
            const Text("Phương thức thanh toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildPaymentOption("Tiền mặt"),
            _buildPaymentOption("Ví điện tử (Momo)"),
            _buildPaymentOption("Thẻ ngân hàng"),

            const Divider(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Phí vận chuyển:", style: TextStyle(fontSize: 16)),
                Text(
                    isFreeShipping
                        ? "Miễn phí"
                        : formatCurrency.format(finalShippingFee),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isFreeShipping ? Colors.green : Colors.black)),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng thanh toán:",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(formatCurrency.format(finalTotalPrice),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Xác nhận đặt hàng",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccountField() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BankAccountLinkScreen()),
        );
      },
      child: AbsorbPointer(
        child: TextField(
          controller: _bankAccountController,
          decoration: InputDecoration(
            labelText: "Liên kết tài khoản ngân hàng",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.blue.shade600, width: 2.0),
            ),
            suffixIcon: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
          ),
        ),
      ),
    );
  }


  Widget _buildAddressField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TypeAheadField<Prediction>(
        controller: addressController,
        builder: (context, controller, focusNode) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: "Địa chỉ nhận hàng",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.blue.shade600, width: 2.0),
              ),
              suffixIcon: const Icon(Icons.location_on, color: Colors.blue),
            ),
          );
        },
        suggestionsCallback: (pattern) async {
          if (pattern.isEmpty) return [];

          final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
          final response = await places.autocomplete(pattern,
              language: "vi",
              components: [Component(Component.country, "vn")]);

          if (response.isOkay) {
            return response.predictions;
          } else {
            return [];
          }
        },
        itemBuilder: (context, Prediction suggestion) {
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: Text(suggestion.description ?? ""),
          );
        },
        onSelected: (Prediction suggestion) {
          addressController.text = suggestion.description!;
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.blue.shade600, width: 2.0),
          ),
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
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin nhận hàng!")),
      );
      return;
    }

    if (widget.selectedPizzas.isNotEmpty) {
      Pizza firstPizza = widget.selectedPizzas.first; // Chọn pizza đầu tiên

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailScreen(
            itemName: firstPizza.name,
            itemImage: firstPizza.picture,
            quantity: firstPizza.quantity,
            totalPrice:
            (firstPizza.price - (firstPizza.price * firstPizza.discount / 100)) *
                firstPizza.quantity,
            selectedPizzas: widget.selectedPizzas,
          ),
        ),
      );
    }
  }
}
