import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ProfileService.dart';

class PostService {
  /// 🎯 Tạo bài đăng mới
  ///
  /// 🟩 [content]: Nội dung bài viết (tùy chọn)
  /// 🟩 [vehicleType]: Loại phương tiện
  /// 🟩 [numberOfSeats]: Số ghế
  /// 🟩 [departureTime]: Thời gian khởi hành
  /// 🟩 [expense]: Chi phí (tùy chọn)
  /// 🟩 [status]: Trạng thái bài viết
  /// 🟩 [startLocation], [endLocation]: Địa điểm đi và đến
  /// 🟩 [companionIds]: Danh sách ID người đi cùng (tối đa 45)
  ///
  /// 🟦 Trả về Future<void>, ném lỗi nếu chưa đăng nhập hoặc vượt quá số người
  Future<void> createPost({
    required String? content,
    required String vehicleType,
    required int numberOfSeats,
    required DateTime departureTime,
    required String? expense,
    required String status,
    required String startLocation,
    required String endLocation,
    required List<String> informationAboutCompanion,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Người dùng chưa đăng nhập");
    final postRef = FirebaseFirestore.instance.collection("posts").doc();
    final postId = postRef.id;
    final timestamp = DateTime.now().toIso8601String();

    final postData = {
      'postId': postId,
      'ownerId': user.uid,
      'timestamp': timestamp,
      'content': content ?? '',
      'vehicleType': vehicleType,
      'numberOfSeats': numberOfSeats,
      'departureTime': departureTime.toIso8601String(),
      'expense': expense ?? '',
      'status': status,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'informationAboutCompanion': informationAboutCompanion,
      'likeUserIds': <String>[],
      'comments': <Map<String, dynamic>>[],
      'imageUrls': [],
    };
    await postRef.set(postData);
  }

  /// 🎯 Cập nhật bài đăng theo [postId]
  /// 🟩 Các tham số là tùy chọn, cập nhật nếu khác null
  Future<void> updatePost({
    required String postId,
    String? content,
    String? vehicleType,
    int? numberOfSeats,
    DateTime? departureTime,
    String? expense,
    String? status,
    String? startLocation,
    String? endLocation,
    List<Map<String, dynamic>>? companionInfoList,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Người dùng chưa đăng nhập");

    final postRef = FirebaseFirestore.instance.collection("posts").doc(postId);
    final updateData = <String, dynamic>{'timestamp': DateTime.now().toIso8601String()};

    if (content != null) updateData['content'] = content;
    if (vehicleType != null) updateData['vehicleType'] = vehicleType;
    if (numberOfSeats != null) updateData['numberOfSeats'] = numberOfSeats;
    if (departureTime != null) updateData['departureTime'] = departureTime.toIso8601String();
    if (expense != null) updateData['expense'] = expense;
    if (status != null) updateData['status'] = status;
    if (startLocation != null) updateData['startLocation'] = startLocation;
    if (endLocation != null) updateData['endLocation'] = endLocation;
    if (companionInfoList != null) {
      if (companionInfoList.length > 45) throw Exception("Tối đa 45 người đi cùng");
      updateData['informationAboutCompanion'] = companionInfoList;
    }

    await postRef.update(updateData);
  }

  /// 🎯 Lấy tất cả bài đăng và kèm thông tin người đăng
  Future<List<Map<String, dynamic>>> getAllPostsWithUserInfo() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .get();
    final posts = snapshot.docs.map((doc) => doc.data()).toList();

    final enrichedPosts = await Future.wait(posts.map((post) async {
      final ownerId = post['ownerId'];
      final userData = await ProfileService().Get_Other_User_Information_by_uid(ownerId);
      return {
        ...post,
        'userData': userData,
      };
    }));

    return enrichedPosts;
  }

  /// 🎯 Lấy bài viết theo [ownerId]
  Future<List<Map<String, dynamic>>> getPostsByOwnerId(String ownerId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("posts")
        .where("ownerId", isEqualTo: ownerId)
        .orderBy("timestamp", descending: true)
        .get();

    final posts = snapshot.docs.map((doc) => doc.data()).toList();
    final userData = await ProfileService().Get_Other_User_Information_by_uid(ownerId);

    return posts.map((post) => {...post, 'userData': userData}).toList();
  }

  // /// 🎯 Lấy bài viết mà người dùng hiện tại là chủ sở hữu hoặc người đi cùng
  Future<List<Map<String, dynamic>>> getPostsByUserParticipation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final userId = user.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    final filteredPosts = snapshot.docs.where((doc) {
      final data = doc.data();
      final ownerId = data['ownerId'];
      final companionList = List<Map<String, dynamic>>.from(data['informationAboutCompanion'] ?? []);
      final isCompanion = companionList.any((c) => c['id'] == userId);
      return ownerId == userId || isCompanion;
    }).toList();

    return await Future.wait(filteredPosts.map((doc) async {
      final post = doc.data();
      final userData = await ProfileService().Get_Other_User_Information_by_uid(post['ownerId']);
      return {...post, 'userData': userData};
    }));
  }

  /// 🎯 Lấy danh sách UID từ companionInfoList
  Future<List<String>> getCompanionsUserID(List<Map<String, dynamic>>? companionList) async {
    if (companionList == null || companionList.isEmpty) return [];

    return companionList
        .map((companion) => companion['id'] as String?)
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
  }



  /// 🎯 Lấy danh sách thông tin companion từ post và bổ sung thêm thông tin người dùng tương ứng
  /// 🟩 Nhận vào danh sách companion: List<Map<String, dynamic>>
  /// 🟦 Trả về List<Map> đã được enrich với thông tin user
  Future<List<Map<String, dynamic>>> getCompanionInfosWithUserDetails(List<Map<String, dynamic>>? companionList) async {
    if (companionList == null || companionList.isEmpty) return [];
    List<Map<String, dynamic>> enrichedList = [];
    for (final companion in companionList) {
      final String? userId = companion['id'];
      if (userId == null || userId.isEmpty) continue;
      final userData = await ProfileService().Get_Other_User_Information_by_uid(userId);
      enrichedList.add({
        ...companion,
        'userData': userData,
      });
    }
    return enrichedList;
  }


}