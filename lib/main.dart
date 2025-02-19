import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/app.dart';
import 'package:pizza_app/simple_bloc_observer.dart';
import 'package:user_repository/user_repository.dart';
import 'firebase_options.dart'; // Đảm bảo đã tạo file này bằng `flutterfire configure`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Đảm bảo chạy được trên Web
    );
    Bloc.observer = SimpleBlocObserver();
    runApp(MyApp(FirebaseUserRepo()));
  } catch (e) {
    debugPrint("🔥 Firebase init error: $e");
  }
}
