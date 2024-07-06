import 'package:chat_app/services/firebase/chat_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatViewModel {
  final ChatFirebaseService _chatFirebaseService = ChatFirebaseService();

  Stream<QuerySnapshot> getMessages(String chatRoomId) async* {
    yield* _chatFirebaseService.getMessages(chatRoomId);
  }

  void sendMessage({
    required String text,
    required String senderId,
    required String imageUrl,
    required FieldValue timeStamp,
    required String chatRoomId,
  }) {
    _chatFirebaseService.sendMessage(
      data: {
        'text': text,
        'sender-id': senderId,
        'time-stamp': timeStamp,
        'image-url': imageUrl,
      },
      chatRoomId: chatRoomId,
    );
  }
}
