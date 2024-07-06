import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotificationService {
  static final _pushNotification = FirebaseMessaging.instance;

  /// INIT FUNCTION
  static Future<void> init() async {
    await _pushNotification.requestPermission();

    FirebaseMessaging.onMessageOpenedApp.listen((message) {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
  }

  /// FUNCTION TO SEND NOTIFICATION
  static void sendNotificationMessage({
    required String title,
    required String body,
    required String tokenFCM,
  }) async {
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    final notificationData = {
      'message': {
        'token': tokenFCM,
        'notification': {
          'title': title,
          'body': body,
        }
      },
    };

    const projectId = "chat-app-1fee3";
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("qwertytrewqwertrewerty");
      debugPrint("SUCCESSFULLY SENT");
    }
  }

// static void _storeToken(String? token) {
//   final UserViewModel userViewModel = UserViewModel();
//   if (token != null) {
//     userViewModel.updateUserFCMToken(
//       id: FirebaseAuth.instance.currentUser!.email ?? 'unknown',
//       userFCMToken: token,
//     );
//   }
// }
}
