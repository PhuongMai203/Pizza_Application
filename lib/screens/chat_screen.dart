import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = types.User(id: "1");
  final _bot = types.User(id: "2");
  final ChatService _chatService = ChatService();

  void _sendMessage(types.TextMessage message) async {
    setState(() => _messages.insert(0, message));

    // Gọi API GPT-4 để lấy phản hồi
    final response = await _chatService.sendMessage(message.text);

    final botMessage = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: response,
    );

    setState(() => _messages.insert(0, botMessage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat với PizzaBot")),
      body: Chat(
        messages: _messages,
        onSendPressed: (message) {
          final textMessage = types.TextMessage(
            author: _user,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: const Uuid().v4(),
            text: message.text,
          );
          _sendMessage(textMessage);
        },
        user: _user,
        theme: DefaultChatTheme(
          backgroundColor: Colors.white, // Nền chat
          primaryColor: Colors.blue.shade400, // Màu viền tin nhắn
          secondaryColor: Colors.grey.shade200,// Màu tin nhắn của bot
          receivedMessageBodyTextStyle: TextStyle(color: Colors.black),
          sentMessageBodyTextStyle: TextStyle(color: Colors.white),
          inputTextColor: Colors.black, // Màu chữ trong ô nhập
          inputBorderRadius: BorderRadius.circular(20), // Bo góc khung nhập
          inputContainerDecoration: BoxDecoration(
            color: Colors.white, // Màu nền của khung nhập
            borderRadius: BorderRadius.circular(20), // Bo góc viền
            border: Border.all(color: Colors.blue.shade700, width: 1.5), // Viền màu xanh dương nhạt
          ),

        ),

      ),
    );
  }
}
