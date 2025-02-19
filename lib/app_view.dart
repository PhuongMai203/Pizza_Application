import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/cart_blocs/cart_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/forgot_pass/forgot_password_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizza_app/screens/auth/views/welcome_screen.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/home/views/home_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:user_repository/user_repository.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = FirebaseUserRepo(); // ✅ Tạo UserRepository
    final pizzaRepository = FirebasePizzaRepo(); // ✅ Tạo PizzaRepository

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationBloc(userRepository: userRepository),
        ),
        BlocProvider(
          create: (context) => CartBloc(), // ✅ Cung cấp CartBloc ở đây
        ),
      ],
      child: Builder( // ✅ Dùng Builder để có đúng BuildContext
        builder: (context) {
          return MaterialApp(
            title: 'Pizza Delivery',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.light(
                surface: Colors.blue.shade100,
                onSurface: Colors.black,
                primary: Colors.blue.shade800,
                onPrimary: Colors.white,
              ),
            ),
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => SignInBloc(userRepository),
                      ),
                      BlocProvider(
                        create: (context) => ForgotPasswordBloc(),
                      ),
                      BlocProvider(
                        create: (context) => GetPizzaBloc(pizzaRepository)..add(GetPizza()),
                      ),

                    ],
                    child: const HomeScreen(),
                  );
                } else {
                  return const WelcomeScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
