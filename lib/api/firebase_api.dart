import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class FirebaseApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _mainCollection =
      _firestore.collection('messages');
  static final CollectionReference _chatCollection =
      _firestore.collection('chats');
  static final CollectionReference _userCollection =
      _firestore.collection('users');

  static Stream<QuerySnapshot> getChats() {
    return _chatCollection
        .where('userId', isNotEqualTo: Auth.auth.currentUser!.uid)
        .snapshots();
  }

  static Future createChats(
      String username, String password, String userId) async {
    return await _chatCollection.add({
      'username': username,
      'pssword': password,
      'userId': userId,
      'createdAt': DateTime.now(),
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  static Stream<QuerySnapshot> getMessages(String groupChatId) {
    return _mainCollection
        .doc(groupChatId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  static Future<void> addMessage(
      String text, String recieveruserId, String groupChatId) async {
    _mainCollection.doc(groupChatId).collection('messages').add({
      'text': text,
      'senderUserId': Auth.auth.currentUser!.uid,
      'recieverUserId': recieveruserId,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}
