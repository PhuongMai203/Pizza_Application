import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

import 'bank_account_link_screen.dart'; // Đảm bảo import file chứa màn hình liên kết tài khoản ngân hàng

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  bool _isLoading = false;
  MyUser? myUser; // Biến lưu user

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (docSnapshot.exists && docSnapshot.data() != null) {
      final data = docSnapshot.data()!;
      setState(() {
        myUser = MyUser(
          userId: data['userId'] ?? '',
          email: data['email'] ?? '',
          name: data['name'] ?? '',
          hasActiveCart: data['hasActiveCart'] ?? false,
          avatarUrl: data['avatarUrl'] ?? '',
        );

        // Cập nhật các controller để hiển thị dữ liệu lên UI
        _nameController.text = data['name'] ?? '';
        _addressController.text = data['address'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _bankAccountController.text = data['bankAccount'] ?? '';
      });
    } else {
      print("User document does not exist!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'bankAccount': _bankAccountController.text, // Kiểm tra lại dòng này
      });

      Navigator.pop(context, _nameController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thông tin đã được cập nhật!")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Cài đặt tài khoản",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade100,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Tên", _nameController),
            _buildTextField("Địa chỉ giao hàng", _addressController),
            _buildTextField("Số điện thoại", _phoneController),
            _buildBankAccountField(), // Sử dụng phương thức _buildBankAccountField() ở đây

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Nền xanh lá
                foregroundColor: Colors.white, // Chữ màu trắng
              ),
              child: const Text("Lưu thay đổi"),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.blue.shade50,
        ),
      ),
    );
  }

  /// **Hàm mở màn hình liên kết tài khoản ngân hàng**
  Widget _buildBankAccountField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BankAccountLinkScreen()),
          );

          if (result != null && result is String) {
            setState(() {
              _bankAccountController.text = result;
            });
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: _bankAccountController,
            decoration: InputDecoration(
              labelText: "Liên kết tài khoản ngân hàng",
              labelStyle: TextStyle(color: Colors.grey.shade700),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade400, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue.shade200, width: 1.5),
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade50,
              suffixIcon: const Icon(Icons.add, color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
