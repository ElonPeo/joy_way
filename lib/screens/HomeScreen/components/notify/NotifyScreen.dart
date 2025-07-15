import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joy_way/services/FirebaseServices/NotifyService.dart';
import 'components/JoinJourneyRequest.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  State<NotifyScreen> createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tất cả Thông báo của bạn'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: NotifyService().getAllUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Không có thông báo nào.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(0),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final type = notification['type'] as String? ?? 'unknown';
              final senderId = notification['senderId'] as String? ?? 'N/A';
              final receiverId = notification['receiverId'] as String? ?? 'N/A';
              final message = notification['message'] as String? ?? 'Không có tin nhắn';
              final timestamp = (notification['timestamp'] as Timestamp?)?.toDate();
              final notificationData = notification['data'] as Map<String, dynamic>?;

              final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
              final bool isSentByCurrentUser = currentUserUid != null && senderId == currentUserUid;

              String formattedTime = timestamp != null
                  ? '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.day}/${timestamp.month}'
                  : 'Không rõ thời gian';

              Widget content;
              Color cardColor = Colors.white;
              IconData icon = Icons.notifications;

              if (type == 'trip_request') {
                final dropOffLocation = notificationData?['dropOffLocation'] ?? 'N/A';
                final pickUpLocation = notificationData?['pickUpLocation'] ?? 'N/A';
                final expense = notificationData?['expense'] ?? 'N/A';
                final departureTime = notificationData?['departureTime'] ?? 'N/A';
                final postId = notificationData?['postId'] ?? '';

                content = JoinJourneyRequest(
                  userName: isSentByCurrentUser ? 'You' : '@username',
                  receiverId: receiverId,
                  senderId: senderId,
                  postId: postId,
                  message: message,
                  expense: expense,
                  dropOffLocation: dropOffLocation,
                  pickUpLocation: pickUpLocation,
                  departureTime: departureTime,
                );
                cardColor = Colors.orange.shade50;
              } else if (type == 'friend_request') {
                icon = Icons.person_add;
                content = ListTile(
                  leading: Icon(icon, color: Colors.blue),
                  title: Text(isSentByCurrentUser
                      ? 'Bạn đã gửi lời mời kết bạn đến $receiverId'
                      : 'Yêu cầu kết bạn từ $senderId'),
                  subtitle: Text('Tin nhắn: "$message"\n$formattedTime'),
                );
                cardColor = isSentByCurrentUser ? Colors.blue.shade50 : Colors.green.shade50;
              } else {
                icon = Icons.info_outline;
                content = ListTile(
                  leading: Icon(icon, color: Colors.grey),
                  title: Text('Thông báo: $type'),
                  subtitle: Text('Từ: $senderId, Đến: $receiverId\nTin nhắn: "$message"\n$formattedTime'),
                );
                cardColor = Colors.grey.shade100;
              }

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: content,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
