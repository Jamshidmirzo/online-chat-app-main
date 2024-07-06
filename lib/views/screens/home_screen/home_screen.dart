import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/view_model/auth_view_model.dart';
import 'package:chat_app/view_model/user_view_model.dart';
import 'package:chat_app/views/screens/home_screen/widgets/chat_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserViewModel _userViewModel = UserViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.amber),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName ??
                          'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.email ?? 'Mikkii Mouse',
                      style: const TextStyle(
                        color: Color(0xFFB1DDFE),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  AuthController().logoutUser();
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _userViewModel.getUsers(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading'));
          } else if (!snapshot.hasData || snapshot.hasError) {
            return Center(child: Text('error: snapshot ${snapshot.error}'));
          } else {
            final List<QueryDocumentSnapshot<Object?>> users =
                snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final CurrentUser user = CurrentUser.fromQuerySnapshot(
                  users[index],
                );
                return Column(
                  children: [
                    ChatListTile(user: user),
                    const SizedBox(
                      height: 10,
                      child: Divider(
                        thickness: 0.3,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
