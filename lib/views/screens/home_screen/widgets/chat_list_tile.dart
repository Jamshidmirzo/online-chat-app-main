import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/screens/chat_screen/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final CurrentUser user;

  const ChatListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ChatScreen(curUser: user),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(user.color).withOpacity(0.8),
                  radius: 28,
                  child: Text(
                    user.email.split('').sublist(0, 2).join().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(user.email),
                    const Text('Message'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
