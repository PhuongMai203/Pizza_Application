import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? chatId; // Lưu ID user khi đăng nhập

  @override
  void initState() {
    super.initState();
    _loadUserChatId(); // Lấy ID khi màn hình khởi chạy
  }

  void _loadUserChatId() {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        chatId = user.uid; // Dùng UID làm chatId
      });
    } else {
      print("Người dùng chưa đăng nhập!");
    }
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty && chatId != null) {
      // Lưu tin nhắn vào Firestore
      await _firestore.collection("chats").doc(chatId).collection("messages").add({
        "sender": "user",
        "text": _messageController.text,
        "timestamp": FieldValue.serverTimestamp(),
      });

      try {
        // Gửi tin nhắn đến Firebase Function để nhận phản hồi từ OpenAI
        final response = await http.post(
          Uri.parse('https://your-cloud-function-url'), // Thay bằng URL Firebase Function thực tế
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "chatId": chatId,
            "message": _messageController.text,
          }),
        );

        if (response.statusCode == 200) {
          print("Phản hồi từ OpenAI đã được xử lý.");
        } else {
          print("Lỗi: ${response.statusCode}, ${response.body}");
        }
      } catch (e) {
        print("Lỗi kết nối API: $e");
      }

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Chat với PizzaBot")),
      body: chatId == null
          ? Center(child: Text("Vui lòng đăng nhập để trò chuyện."))
          : Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection("chats")
                  .doc(chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    bool isUser = data["sender"] == "user";
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(data["text"], style: TextStyle(color: isUser ? Colors.white : Colors.black)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade400),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue.shade400),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
