import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../auth/views/forgot_password_screen.dart';
import '../../auth/views/sign_in_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back), // Icon quay lại
          onPressed: () {
            Navigator.pop(context); // Quay về trang trước
          },
        ),
        title: const Text("Tài khoản"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(CupertinoIcons.person, size: 50),
          ),
          const SizedBox(height: 10),
          const Text("Nguyễn Văn A", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text("nguyenvana@email.com", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Khoảng cách
            child: ListTile(
              tileColor: Colors.white, // Màu nền của ListTile
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc
              ),
              leading: const Icon(CupertinoIcons.cart, color: Colors.blue), // Màu icon
              title: const Text(
                "Lịch sử đơn hàng",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.grey), // Màu icon mũi tên
              onTap: () {
                // Chuyển sang trang lịch sử đơn hàng
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Khoảng cách
            child: ListTile(
              tileColor: Colors.white, // Màu nền của ListTile
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc
              ),
              leading: const Icon(CupertinoIcons.settings, color: Colors.blue), // Màu icon
              title: const Text(
                "Cài đặt tài khoản",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.grey), // Màu icon mũi tên
              onTap: () {
                // Chuyển sang trang lịch sử đơn hàng
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Khoảng cách
            child: ListTile(
              tileColor: Colors.white, // Màu nền của ListTile
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc
              ),
              leading: const Icon(CupertinoIcons.lock, color: Colors.blue), // Màu icon
              title: const Text(
                "Đổi mật khẩu",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.grey), // Màu icon mũi tên
              onTap: () {
                // Chuyển sang trang lịch sử đơn hàng
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Khoảng cách
            child: ListTile(
              tileColor: Colors.white, // Màu nền của ListTile
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Bo góc
              ),
              leading: const Icon(CupertinoIcons.square_arrow_right, color: Colors.blue), // Màu icon
              title: const Text(
                "Đăng xuất",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
              ),
              trailing: const Icon(CupertinoIcons.chevron_forward, color: Colors.grey), // Màu icon mũi tên
              onTap: () {
                context.read<SignInBloc>().add(SignOutRequired()); // Gửi sự kiện đăng xuất
                // Điều hướng về màn hình đăng nhập và xóa hết stack màn hình trước đó
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()), // Thay SignInScreen bằng màn hình đăng nhập của bạn
                      (Route<dynamic> route) => false, // Xóa tất cả các màn hình trước đó
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}