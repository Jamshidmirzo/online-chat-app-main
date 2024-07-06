import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/notification/firebase_push_notification_service.dart';
import 'package:chat_app/utils/custom_functions.dart';
import 'package:chat_app/utils/extensions/sized_box_extension.dart';
import 'package:chat_app/view_model/chat_view_model.dart';
import 'package:chat_app/views/screens/chat_screen/widgets/manage_media.dart';
import 'package:chat_app/views/screens/chat_screen/widgets/show_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  final CurrentUser curUser;

  const ChatScreen({super.key, required this.curUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String _currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  final ChatViewModel _chatViewModel = ChatViewModel();
  late final String _chatRoomId;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _chatRoomId = CustomFunctions.generateChatRoomId(
      user1Email: widget.curUser.email,
      user2Email: _currentUserEmail,
    );
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatViewModel.sendMessage(
        text: _messageController.text,
        senderId: _currentUserEmail,
        timeStamp: FieldValue.serverTimestamp(),
        chatRoomId: _chatRoomId,
        imageUrl: '',
      );
      _messageController.clear();
      FirebasePushNotificationService.sendNotificationMessage(
        title: widget.curUser.email,
        body: _messageController.text,
        tokenFCM: widget.curUser.userFCMToken,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white
            // image: DecorationImage(
            //   image: AssetImage('assets/images/back.png'),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Column(
              children: [
                Text(widget.curUser.email),
                const Text('Last seen recently')
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _chatViewModel.getMessages(_chatRoomId),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message =
                            Message.fromQuerySnapshot(messages[index]);

                        return Row(
                          mainAxisAlignment:
                              _currentUserEmail == message.senderId
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            ShowMessage(
                              text: message.text,
                              timestamp: message.timestamp,
                              isSender: _currentUserEmail == message.senderId,
                              imageUrl: message.imageUrl,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 70,
                color: Colors.white,
                child: TextField(
                  cursorColor: const Color(0xFFA5ADB0),
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => ManageMedia(
                                chatRoomId: _chatRoomId,
                              ),
                            ),
                            child:
                                SvgPicture.asset('assets/icons/paper_clip.svg'),
                          ),
                          10.width(),
                          GestureDetector(
                            onTap: _sendMessage,
                            child: const Icon(
                              Icons.send_rounded,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
