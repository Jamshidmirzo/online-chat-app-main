import 'package:chat_app/utils/app_router.dart';
import 'package:chat_app/utils/custom_functions.dart';
import 'package:chat_app/view_model/auth_view_model.dart';
import 'package:chat_app/views/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onLoginTapped() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await _authController
          .loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .then((_) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.home,
          (route) => true,
        );
      }).catchError((dynamic error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: Text(error.toString()),
          ),
        );
      });
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  !_isLoading
                      ? GestureDetector(
                          onTap: _onLoginTapped,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(
                          color: Color(0xFF007AFF),
                          strokeAlign: -3,
                          strokeWidth: 3,
                        ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Please confirm your country code\nand enter your phone number',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            hint: "Your email",
                            validator: CustomFunctions.emailValidator,
                            isObscure: false,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _passwordController,
                            hint: "Your password",
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Please, enter your password";
                              }
                              return null;
                            },
                            isObscure: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRouter.register),
                          child: const Text("Not a member? Register here"),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_emailController.text.isNotEmpty) {
                              await _auth
                                  .sendPasswordResetEmail(
                                      email: _emailController.text)
                                  .then(
                                (value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Password reset email sent'),
                                    ),
                                  );
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Enter your email to email field'),
                                ),
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Forgot password'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
