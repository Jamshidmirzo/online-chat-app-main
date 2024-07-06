import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUsers() async* {
    yield* _firestore.collection('users').snapshots();
  }

  void addUser({
    required String userFCMToken,
    required String email,
    required String uid,
    required int colorValue,
  }) {
    Map<String, dynamic> data = {
      'user-fcm-token': userFCMToken,
      'user-email': email,
      'user-uid': uid,
      'color-value': colorValue,
    };
    _firestore.collection('users').add(data);
  }
}
