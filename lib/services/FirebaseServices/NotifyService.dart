import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class NotifyService {
  Stream<List<Map<String, dynamic>>> getAllUserNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    final receivedNotificationsStream = FirebaseFirestore.instance
        .collection("notifications")
        .where("receiverId", isEqualTo: user.uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList());

    final sentNotificationsStream = FirebaseFirestore.instance
        .collection("notifications")
        .where("senderId", isEqualTo: user.uid)
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList());

    return Rx.combineLatest2(
      receivedNotificationsStream,
      sentNotificationsStream,
          (List<Map<String, dynamic>> received, List<Map<String, dynamic>> sent) {
        final allNotifications = [...received, ...sent];

        allNotifications.sort((a, b) {
          final timeA = (a['timestamp'] as Timestamp?)?.toDate();
          final timeB = (b['timestamp'] as Timestamp?)?.toDate();
          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return 1;
          if (timeB == null) return -1;
          return timeB.compareTo(timeA);
        });

        return allNotifications;
      },
    );
  }


  Future<void> createJoinTripNotification({
    required String ownerId,
    required String postId,
    required String message,
    required String expense,
    required String? dropOffLocation,
    required String pickUpLocation,
    required DateTime? departureTime,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Người dùng chưa đăng nhập.");
      }
      final notificationData = {
        'receiverId': ownerId,
        'senderId': user.uid,
        'type': 'trip_request',
        'message': message,
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
        'data': {
          'postId': postId,
          'expense': expense,
          'dropOffLocation': dropOffLocation ?? '',
          'pickUpLocation': pickUpLocation,
          'departureTime': departureTime?.toIso8601String() ?? '',
        },
      };

      await FirebaseFirestore.instance
          .collection("notifications")
          .add(notificationData);

      debugPrint('Tạo thông báo yêu cầu chuyến đi thành công');
    } catch (e) {
      debugPrint('Lỗi khi tạo thông báo yêu cầu chuyến đi: $e');
    }
  }


  Future<void> acceptJoinTripAndNotify({
    required String postId,
    required String receiverId,
    required String senderId,
    required String? expense,
    required String? dropOffLocation,
    required String pickUpLocation,
    required DateTime? departureTime,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Người dùng chưa đăng nhập.");

      final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
      final postSnapshot = await postRef.get();
      final currentData = postSnapshot.data();
      if (currentData == null) throw Exception("Không tìm thấy bài đăng");

      List<dynamic> companionList = currentData['informationAboutCompanion'] ?? [];

      final newCompanion = {
        'id': senderId,
        'expense': expense ?? '',
        'dropOffLocation': dropOffLocation ?? '',
        'pickUpLocation': pickUpLocation,
        'departureTime': departureTime?.toIso8601String() ?? '',
      };
      companionList.add(newCompanion);
      await postRef.update({'informationAboutCompanion': companionList});
      // Tạo thông báo
      final notificationData = {
        'receiverId': receiverId,
        'senderId': user.uid,
        'type': 'trip_request_accepted',
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
        'data': {
          'postId': postId,
        },
      };
      await FirebaseFirestore.instance
          .collection("notifications")
          .add(notificationData);

      debugPrint('Đã chấp nhận yêu cầu và gửi thông báo thành công');
    } catch (e) {
      debugPrint('Lỗi khi xử lý yêu cầu và thông báo: $e');
      rethrow;
    }
  }


  Future<void> refuseJoinTripAndNotify({
    required String postId,
    required String receiverId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Người dùng chưa đăng nhập.");
      final notificationData = {
        'receiverId': receiverId,
        'senderId': user.uid,
        'type': 'trip_request_refused',
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
        'data': {
          'postId': postId,
        },
      };
      await FirebaseFirestore.instance
          .collection("notifications")
          .add(notificationData);
      debugPrint('❎ Đã từ chối yêu cầu và gửi thông báo thành công');
    } catch (e) {
      debugPrint('❌ Lỗi khi từ chối yêu cầu và gửi thông báo: $e');
      rethrow;
    }
  }




 









}