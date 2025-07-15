import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FriendsService {

  Future<String?> sendFriendRequest({required String receiverId}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Người dùng chưa đăng nhập.");
      if (receiverId.isEmpty) return 'Friend UID không được để trống';

      final currentUid = user.uid;
      final currentUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(receiverId);

      final otherUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friends')
          .doc(currentUid);

      final notificationData = {
        'receiverId': receiverId,
        'senderId': currentUid,
        'type': 'friend-request',
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Chạy song song 3 thao tác ghi
      await Future.wait([
        currentUserFriendRef.set({
          'friendUid': receiverId,
          'isFriend': false,
          'isRequest': true,
          'isFollower': false,
          'requestAt': FieldValue.serverTimestamp(),
        }),
        otherUserFriendRef.set({
          'friendUid': currentUid,
          'isFriend': false,
          'isRequest': true,
          'isFollower': true,
          'requestAt': FieldValue.serverTimestamp(),
        }),
        FirebaseFirestore.instance.collection("notifications").add(notificationData),
      ]);

      debugPrint('✅ Yêu cầu kết bạn và thông báo đã được gửi');
      return null;
    } catch (e) {
      debugPrint('❌ Lỗi khi gửi yêu cầu kết bạn: $e');
      throw Exception("Lỗi khi gửi yêu cầu kết bạn: $e");
    }
  }


  // Chấp nhận ết bạn
  Future<String?> acceptFriendRequest({required String otherUserUid}) async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser!.uid;

      final currentUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(otherUserUid);

      final otherUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserUid)
          .collection('friends')
          .doc(currentUid);
      await currentUserFriendRef.update({
        'isFriend': true,
        'isRequest': false,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      await otherUserFriendRef.update({
        'isFriend': true,
        'isRequest': false,
        'acceptedAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      throw Exception("Error accepting friend request: $e");
    }
  }

  // Hủy kết bạn hoặc từ chối, từ 1 phía
  Future<String?> cancelFriendRequest({required String otherUserUid}) async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser!.uid;

      final currentUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(otherUserUid);

      final otherUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserUid)
          .collection('friends')
          .doc(currentUid);
      await currentUserFriendRef.delete();
      await otherUserFriendRef.delete();

      return null;
    } catch (e) {
      throw Exception("Error cancelling friend request: $e");
    }
  }



  // Theo dõi người dùng
  Future<String?> followUser({required String otherUserUid}) async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser!.uid;

      final currentUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(otherUserUid);

      await currentUserFriendRef.set({
        'friendUid': otherUserUid,
        'isFriend': false,
        'isRequest': false,
        'isFollower': true,
        'followAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return null;
    } catch (e) {
      throw Exception("Error while following user: $e");
    }
  }

  // Huy theo dõi người dùng
  Future<String?> unfollowUser({required String otherUserUid}) async {
    try {
      final currentUid = FirebaseAuth.instance.currentUser!.uid;
      final currentUserFriendRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUid)
          .collection('friends')
          .doc(otherUserUid);
      await currentUserFriendRef.update({
        'isFollower': false,
        'unfollowAt': FieldValue.serverTimestamp(),
      });

      return null;
    } catch (e) {
      throw Exception("Error while unfollowing user: $e");
    }
  }
















}


// users/
// {userId}/
//   (thông tin cá nhân)
//   friends/
//   {otherUserId}/
//     - friendUid: ...
//     - isFriend: true/false
//     - isRequest: true/false
//     - isFollower: true/false
//     - requestAt: Timestamp



