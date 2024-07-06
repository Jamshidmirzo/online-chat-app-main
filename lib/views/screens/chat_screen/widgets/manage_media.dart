import 'dart:io';
import 'package:chat_app/services/firebase/firestore_firebase_service.dart';
import 'package:chat_app/view_model/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManageMedia extends StatefulWidget {
  final String chatRoomId;
  const ManageMedia({super.key,required this.chatRoomId});

  @override
  State<ManageMedia> createState() => _ManageMediaState();
}

class _ManageMediaState extends State<ManageMedia> {
  File? imageFile;
  bool _isLoading = false;

  void _openGallery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void _openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void _sendImage() async {
    _isLoading = true;
    setState(() {});
    try {
      final imageUrl = await FirestoreFirebaseService.getDownloadUrl(
          UniqueKey().toString(), imageFile!);
      ChatViewModel().sendMessage(
        text: '',
        senderId: FirebaseAuth.instance.currentUser!.email!,
        imageUrl: imageUrl,
        timeStamp: FieldValue.serverTimestamp(),
        chatRoomId: widget.chatRoomId,
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error adding product: $e");
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Send media"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _openCamera,
                  label: const Text("Camera"),
                  icon: const Icon(Icons.camera),
                ),
                TextButton.icon(
                  onPressed: _openGallery,
                  label: const Text("Gallery"),
                  icon: const Icon(Icons.image),
                ),
              ],
            ),
            if (imageFile != null)
              SizedBox(
                height: 200,
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              )
          ],
        ),
      ),
      actions: !_isLoading
          ? [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _sendImage,
                child: const Text('Send'),
              ),
            ]
          : [const CircularProgressIndicator()],
    );
  }
}
