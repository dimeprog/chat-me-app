import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/auth.dart';
import '../api/firebase_api.dart';
import '../group/log.dart';

class ChatPage extends StatefulWidget {
  final String username;
  final String userId;
  const ChatPage({super.key, required this.username, required this.userId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String groupChatId = '';
  String peerId = '';
  String curId = '';

  void generateChatId() {
    if (Auth.auth.currentUser!.uid.hashCode <= widget.userId.hashCode) {
      groupChatId = '${Auth.auth.currentUser!.uid}-${widget.userId}';
    } else {
      groupChatId = '${widget.userId}-${Auth.auth.currentUser!.uid}';
    }
  }

  @override
  void initState() {
    generateChatId();
    super.initState();
  }

  void sendMessage(String message) async {
    await FirebaseApi.addMessage(message, widget.userId, groupChatId);
    controller.clear();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseApi.getMessages(groupChatId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final data = snapshot.data!.docs
                        .map((e) => e.data() as Map<String, dynamic>)
                        .toList();
                    log.d(data.length);

                    return ListView.builder(
                      itemBuilder: (context, i) {
                        final chat = data[i];
                        log.d(chat);

                        final date = DateTime.parse(chat['createdAt']);
                        log.d('This the created $date');

                        final isMe =
                            chat['senderUserId'] == Auth.auth.currentUser!.uid;
                        return Row(
                          mainAxisAlignment:
                              chat['senderUserId'] == Auth.auth.currentUser!.uid
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(8.0),
                                constraints: BoxConstraints.loose(
                                    Size.fromWidth(
                                        MediaQuery.of(context).size.width / 2)),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.blue : Colors.grey,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chat['text'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '${date.hour}:${date.minute} ${DateFormat('a').format(date)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                          ],
                        );
                      },
                      itemCount: data.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                    );
                  }),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a message'),
                  )),
                  IconButton(
                      onPressed: () {
                        if (controller.text.isEmpty) return;
                        sendMessage(controller.text);
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
