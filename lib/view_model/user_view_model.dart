import 'package:chat_app/services/firebase/users_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserViewModel {
  final UsersFirebaseService _usersFirebaseService = UsersFirebaseService();

  Stream<QuerySnapshot> getUsers() async* {
    yield* _usersFirebaseService.getUsers();
  }

  void addUser({
    required String userFCMToken,
    required String email,
    required String uid,
    required int colorValue,
  }) {
    _usersFirebaseService.addUser(
      userFCMToken: userFCMToken,
      email: email,
      uid: uid,
      colorValue: colorValue,
    );
  }
}
