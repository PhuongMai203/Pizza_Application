import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firestore_service.dart';

class ChatService {
  static const String _baseUrl = "https://api.openai.com/v1/chat/completions";
  final FirestoreService _firestoreService = FirestoreService();

  Future<String> sendMessage(String message) async {
    try {
      // 🔥 Kiểm tra API Key trước khi gọi API
      final String? apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        print("🚨 LỖI: API Key không tồn tại hoặc rỗng!");
        return "Lỗi hệ thống: Chưa cấu hình API Key.";
      }

      // 🔥 Lấy danh sách pizza từ Firestore (có xử lý lỗi)
      List<Map<String, dynamic>> pizzas = [];
      try {
        pizzas = await _firestoreService.getPizzas();
      } catch (e) {
        print("❌ LỖI khi lấy menu từ Firestore: $e");
        return "Lỗi hệ thống: Không thể tải menu.";
      }

      // 🔥 Tạo chuỗi menu cho chatbot
      String menu = pizzas.map((pizza) {
        return "${pizza['name']} - ${pizza['price']} VND";
      }).join("\n");
      print("🔥 Menu được gửi cho chatbot:\n$menu");

      // 🔥 Gửi request đến OpenAI
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "Bạn là chatbot của PizzaApp. Đây là menu hiện tại:\n$menu"},
            {"role": "user", "content": message}
          ],
          "max_tokens": 100,
        }),
      );

      // 🔥 In log phản hồi từ OpenAI để kiểm tra
      print("📥 Phản hồi từ OpenAI (${response.statusCode}): ${response.body}");

      // 🔥 Xử lý phản hồi từ OpenAI
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"];
      } else {
        return "Lỗi OpenAI: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      print("❌ LỖI khi gọi API OpenAI: $e");
      return "Xin lỗi, có lỗi xảy ra!";
    }
  }
}
