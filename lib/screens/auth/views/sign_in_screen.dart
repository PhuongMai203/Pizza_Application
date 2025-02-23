import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/my_text_fiedl.dart';
import '../blocs/forgot_pass/forgot_password_bloc.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.blue.shade100], // 🎨 Chỉnh màu theo ý bạn
              ),
            ),
          ),

          // Nội dung chính
          SafeArea(
            child: Center(
              child: BlocListener<SignInBloc, SignInState>(
                listener: (context, state) {
                  if (state is SignInSuccess) {
                    setState(() {
                      signInRequired = false;
                    });
                  } else if (state is SignInProcess) {
                    setState(() {
                      signInRequired = true;
                    });
                  } else if (state is SignInFailure) {
                    setState(() {
                      signInRequired = false;
                      _errorMsg = 'Invalid email or password';
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 8),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: MyTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(CupertinoIcons.mail_solid),
                              errorMsg: _errorMsg,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Material(
                              color: Colors.transparent,
                              child: Column(
                                children: [
                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: MyTextField(
                                      controller: passwordController,
                                      hintText: 'Password',
                                      obscureText: obscurePassword,
                                      keyboardType: TextInputType.visiblePassword,
                                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                                      errorMsg: _errorMsg,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return 'Please fill in this field';
                                        }
                                        return null;
                                      },
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscurePassword = !obscurePassword;
                                            iconPassword = obscurePassword
                                                ? CupertinoIcons.eye_fill
                                                : CupertinoIcons.eye_slash_fill;
                                          });
                                        },
                                        icon: Icon(iconPassword),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          // Nút "Quên mật khẩu?"
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ForgotPasswordBloc(),
                                    child: const ForgotPasswordScreen(),
                                  ),
                                ),
                              );
                            },
                            child: const Text("Quên mật khẩu?", style: TextStyle(color: Colors.blue)),
                          ),

                          const SizedBox(height: 5),
                          !signInRequired
                              ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<SignInBloc>().add(SignInRequired(
                                      emailController.text,
                                      passwordController.text)
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60)
                                  )
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ),
                          )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
