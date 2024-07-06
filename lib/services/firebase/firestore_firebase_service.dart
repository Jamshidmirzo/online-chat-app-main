import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirestoreFirebaseService {
 static Future<String> getDownloadUrl(String name, File imageFile) async {
    try {
      final imagesImageStorage = FirebaseStorage.instance;
      final imageReference = imagesImageStorage
          .ref()
          .child("products")
          .child("images")
          .child("$name.jpg");
      final uploadTask = imageReference.putFile(imageFile);

      String imageUrl = '';
      await uploadTask.whenComplete(() async {
        imageUrl = await imageReference.getDownloadURL();
      });
      return imageUrl;
    } catch (e) {
      debugPrint("Error uploading image: $e");
      rethrow;
    }
  }
}
