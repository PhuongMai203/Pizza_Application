import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/views/account_settings_screen.dart';
import '../../auth/views/forgot_password_screen.dart';
import '../../auth/views/order_history_screen.dart';
import '../../auth/views/welcome_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _image;
  String userName = "Đang tải...";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        userName = userDoc['name'] ?? "Không có tên";
        userEmail = userDoc['email'] ?? "";
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Tài khoản", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(CupertinoIcons.camera, size: 50, color: Colors.black54)
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(userEmail, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 20),
          _buildListTile(
            icon: CupertinoIcons.cart,
            title: "Lịch sử đơn hàng",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
              );
            },
          ),
          _buildListTile(
            icon: CupertinoIcons.settings,
            title: "Cài đặt tài khoản",
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
              ).then((updatedName) {
                if (updatedName != null && updatedName is String) {
                  setState(() {
                    userName = updatedName; // Cập nhật tên hiển thị ngay lập tức
                  });
                }
              });
            },
          ),

          _buildListTile(
            icon: CupertinoIcons.lock,
            title: "Đổi mật khẩu",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
              );
            },
          ),

          _buildListTile(
            icon: CupertinoIcons.power,
            title: "Đăng xuất",
            onTap: () async {
              await FirebaseAuth.instance.signOut(); // Đăng xuất khỏi Firebase
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()), // Chuyển đến màn hình chào mừng
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Màu nền xanh dương nhạt
          borderRadius: BorderRadius.circular(12.0), // Bo góc viền mềm mại
          border: Border.all(color: Colors.blue.shade200, width: 1.5), // Viền màu xanh dương nhạt
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          leading: Icon(icon, color: Colors.blue.shade600),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }
}
