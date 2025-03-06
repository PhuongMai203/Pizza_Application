import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pizza_app/blocs/authentication_bloc/authentication_bloc.dart';

import 'package:pizza_app/screens/auth/blocs/bloc/sign_up_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/cart_blocs/cart_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/forgot_pass/forgot_password_bloc.dart';
import 'package:pizza_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:pizza_app/screens/auth/views/chatbot.dart';
import 'package:pizza_app/screens/auth/views/welcome_screen.dart';
import 'package:pizza_app/screens/home/blocs/get_pizza_bloc/get_pizza_bloc.dart';
import 'package:pizza_app/screens/home/views/home_screen.dart';
import 'package:pizza_repository/pizza_repository.dart';
import 'package:user_repository/user_repository.dart';


class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = FirebaseUserRepo();
    final pizzaRepository = FirebasePizzaRepo();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(userRepository: userRepository)),
        BlocProvider(create: (context) => SignInBloc(userRepository)),
        BlocProvider(create: (context) => SignUpBloc(userRepository)),
        BlocProvider(create: (context) => ForgotPasswordBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => GetPizzaBloc(pizzaRepository)..add(GetPizza())),
      ],
      child: Builder(
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
            home: Scaffold(
              body: Stack(
                children: [
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      if (state.status == AuthenticationStatus.authenticated) {
                        return const HomeScreen();
                      } else {
                        return BlocProvider(
                          create: (context) => SignInBloc(userRepository),
                          child: const WelcomeScreen(),
                        );
                      }
                    },
                  ),

                  // Floating Chatbot Button
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Builder(
                      builder: (innerContext) => FloatingActionButton(
                        backgroundColor: Colors.blue.shade800,
                        onPressed: () {
                          Navigator.of(innerContext).push(
                            MaterialPageRoute(builder: (context) => ChatScreen()),
                          );
                        },
                        child: Icon(Icons.chat, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
