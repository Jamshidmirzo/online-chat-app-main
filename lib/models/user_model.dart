import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String id;
  final String uid;
  final String userFCMToken;
  final String email;
  final int color;

  const CurrentUser({
    required this.id,
    required this.uid,
    required this.userFCMToken,
    required this.email,
    required this.color,
  });

  factory CurrentUser.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return CurrentUser(
      id: query.id,
      uid: query['user-uid'],
      userFCMToken: query['user-fcm-token'],
      email: query['user-email'],
      color: query['color-value'] ?? 0,
    );
  }
}
