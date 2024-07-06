import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomFunctions {
  static bool isAndroid() {
    if (kIsWeb) {
      return false;
    } else if (Platform.isAndroid) {
      return true;
    } else {
      return false;
    }
  }

  static String generateChatRoomId(
      {required String user1Email, required String user2Email}) {
    List<String> sortedEmails = [user1Email, user2Email]..sort();
    String concatenatedEmails = sortedEmails.join();
    String hashedId =
        sha256.convert(utf8.encode(concatenatedEmails)).toString();
    return hashedId;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please, enter your email";
    }
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return "Please, enter a valid email";
    }
    return null;
  }

  static int getRandomColorForUserProfile() {
    List<Color> colors = [
      const Color(0xFF4B96D7),
      const Color(0xFF54B238),
      const Color(0xFFDB8538),
      const Color(0xFFD2635C),
      const Color(0xFF9F6DDE),
      const Color(0xFFd7458c),
    ];
    return colors[Random().nextInt(6)].value;
  }
}
