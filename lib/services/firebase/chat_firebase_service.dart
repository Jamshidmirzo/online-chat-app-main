import 'package:cloud_firestore/cloud_firestore.dart';

class ChatFirebaseService {
  final CollectionReference<Map<String, dynamic>> _firestore =
      FirebaseFirestore.instance.collection('chat-rooms');
  final String _collectionName = 'messages';

  Stream<QuerySnapshot> getMessages(String chatRoomId) async* {
    yield* _firestore
        .doc(chatRoomId)
        .collection(_collectionName)
        .orderBy('time-stamp', descending: true)
        .snapshots();
  }

  void sendMessage({
    required Map<String, dynamic> data,
    required String chatRoomId,
  }) {
    _firestore.doc(chatRoomId).collection(_collectionName).add(data);
  }
}
