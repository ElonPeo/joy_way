import 'package:cloud_firestore/cloud_firestore.dart';
class MessageService {


  Future<DocumentSnapshot?> findConversation(String uidA, String uidB) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .where('userIds', arrayContains: uidA)
        .get();

    for (var doc in snapshot.docs) {
      List users = doc['userIds'];
      if (users.contains(uidB)) {
        return doc;
      }
    }
    return null;
  }

  Future<DocumentReference> createConversation(String uidA, String uidB) async {
    return await FirebaseFirestore.instance.collection('conversations').add({
      'userIds': [uidA, uidB],
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }


  Future<void> sendMessage(String uidA, String uidB, String text) async {
    final existing = await findConversation(uidA, uidB);

    final conversationRef = existing != null
        ? FirebaseFirestore.instance.collection('conversations').doc(existing.id)
        : await createConversation(uidA, uidB);

    await conversationRef.collection('messages').add({
      'senderId': uidA,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await conversationRef.update({
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getMessages(String conversationId) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> getMessagedUsersWithLastMessage(String currentUserId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .where('userIds', arrayContains: currentUserId)
        .get();

    List<Map<String, dynamic>> result = [];

    for (var doc in snapshot.docs) {
      List<dynamic> userIds = doc['userIds'];
      List<String> otherUsers = userIds.where((uid) => uid != currentUserId).cast<String>().toList();

      if (otherUsers.isNotEmpty) {
        String otherUserId = otherUsers.first;

        // 🔍 Lấy thông tin đối tác
        final otherUserDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(otherUserId)
            .get();

        if (!otherUserDoc.exists) continue;

        final otherUserData = otherUserDoc.data()!;
        final fullName = otherUserData['fullName'] ?? '';
        final userName = (otherUserData['userName'] != null && otherUserData['userName'].isNotEmpty)
            ? otherUserData['userName']
            : '';

        // 💬 Lấy tin nhắn cuối cùng
        final messagesSnapshot = await FirebaseFirestore.instance
            .collection('conversations')
            .doc(doc.id)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        String lastMessage = '';
        if (messagesSnapshot.docs.isNotEmpty) {
          final lastMsgDoc = messagesSnapshot.docs.first;
          lastMessage = lastMsgDoc['text'] ?? '';
        }

        result.add({
          'conversationId': doc.id,
          'otherUserId': otherUserId,
          'fullName': fullName,
          'userName': userName,
          'lastMessage': lastMessage,
        });
      }
    }

    return result;
  }


}


// conversations (collection)
// └── conversationId (document)  // ví dụ: a_b hoặc tự sinh id
//   ├── userIds: [a, b]
//   ├── lastMessage: "xin chào"
//   ├── lastTimestamp: ...
//     └── messages (subcollection)
//       └── messageId (document)
//       ├── senderId: a
//       ├── text: "xin chào"
//       ├── timestamp: ...

