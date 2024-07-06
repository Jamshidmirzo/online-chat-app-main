import 'package:chat_app/utils/custom_functions.dart';
import 'package:chat_app/view_model/auth_view_model.dart';
import 'package:chat_app/view_model/user_view_model.dart';
import 'package:chat_app/views/widgets/custom_circular_progress.dart';
import 'package:chat_app/views/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  final UserViewModel _userViewModel = UserViewModel();
  bool _isLoading = false;

  void _onRegisterTap() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await _authController
          .registerUser(
              email: _emailController.text, password: _passwordController.text)
          .then(
        (value) async {
          Navigator.of(context).pop();
          // await Firebase
          final String? userToken = await FirebaseMessaging.instance.getToken();
          _userViewModel.addUser(
            email: _emailController.text,
            uid: FirebaseAuth.instance.currentUser!.uid,
            userFCMToken: userToken ?? 'null-token',
            colorValue: CustomFunctions.getRandomColorForUserProfile(),
          );
          Navigator.of(context).pop();
        },
      ).catchError((error) {
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
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SvgPicture.asset(
                'assets/icons/telegram_ico.svg',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _emailController,
                hint: "Your email",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please, enter your email";
                  }
                  return null;
                },
                isObscure: false,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                hint: "Your new password",
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please, enter password";
                  }
                  return null;
                },
                isObscure: true,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _confirmPasswordController,
                hint: "Confirm your password",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please, confirm password";
                  } else if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    return "Passwords does not match";
                  }
                  return null;
                },
                isObscure: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: !_isLoading ? _onRegisterTap : null,
                  child: !_isLoading
                      ? const Text("Register")
                      : const CustomCircularProgress(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
