import 'package:chat_app/utils/custom_functions.dart';
import 'package:chat_app/views/screens/home_screen/home_screen.dart';
import 'package:chat_app/views/screens/login_screen/login_screen.dart';
import 'package:chat_app/views/screens/onboarding/onboarding_screen.dart';
import 'package:chat_app/views/screens/register_screen/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String chat = '/chat';

  static PageRoute _buildPageRoute(Widget widget, bool isAndroid) {
    return isAndroid
        ? MaterialPageRoute(builder: (BuildContext context) => widget)
        : CupertinoPageRoute(builder: (BuildContext context) => widget);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    bool isAndroid = CustomFunctions.isAndroid();
    switch (settings.name) {
      case AppRouter.login:
        return _buildPageRoute(const LoginScreen(), isAndroid);
      case AppRouter.register:
        return _buildPageRoute(const RegisterScreen(), isAndroid);
      case AppRouter.home:
        return _buildPageRoute(const HomeScreen(), isAndroid);
      case AppRouter.onboarding:
        return _buildPageRoute(const OnboardingScreen(), isAndroid);
      // case AppRouter.chat:

        // return _buildPageRoute(ChatScreen(email: 'email'), isAndroid);
      default:
        return _buildPageRoute(const OnboardingScreen(), isAndroid);
    }
  }
}
