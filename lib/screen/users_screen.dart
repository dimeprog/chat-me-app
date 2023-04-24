import 'package:flutter/material.dart';

import 'package:socket_chat_app/screen/chat_page.dart';

import '../api/auth.dart';
import '../api/firebase_api.dart';
import '../main.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            onPressed: () {
              Auth.logout();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseApi.getChats(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = snapshot.data!.docs
                  .map((e) => e.data() as Map<String, dynamic>)
                  .toList();
              // print(data.length);
              // final orignalLsit = data
              //     .where((e) => e['userId'] != Auth.auth.currentUser!.uid)
              //     .toList();

              // print(Auth.auth.currentUser!.uid);
              return ListView.builder(
                itemBuilder: (context, i) {
                  final chat = data[i];
                  // print(chat);
                  // final date = DateTime.parse(chat['createAt']);
                  final id = chat['userId'];
                  return ListTile(
                    title: Text(chat['username']),
                    subtitle: Text(chat['userId'].toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            username: chat['username'],
                            userId: id,
                          ),
                        ),
                      );
                    },
                    // subtitle: Text(date.toString()),
                  );
                },
                itemCount: data.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
              );
            }),
      ),
    );
  }
}
