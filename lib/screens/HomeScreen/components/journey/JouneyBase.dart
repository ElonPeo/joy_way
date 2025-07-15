import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joy_way/screens/HomeScreen/components/journey/JourneyScreen.dart';

import '../../../../services/FirebaseServices/PostService.dart';

class JourneyBase extends StatefulWidget {
  @override
  State<JourneyBase> createState() => _JourneyBaseState();
}

class _JourneyBaseState extends State<JourneyBase> {
  List<Map<String, dynamic>> _posts = [];
  Map<String, dynamic>? _firstPost;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadParticipatingPosts();
  }

  void loadParticipatingPosts() async {
    final posts = await PostService().getPostsByUserParticipation();
    if (!mounted) return;
    setState(() {
      _posts = posts;
      _firstPost = posts.isNotEmpty ? posts.first : null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_firstPost == null) {
      return const Center(
        child: Text('Không có chuyến nào bạn đã tham gia.'),
      );
    }
    return JourneyScreen(
      isJourneyScreen: true,
      isOwner: user?.uid == (_firstPost?['ownerId'] ?? 'unknown'),
      isJoin: true,
      postId: _firstPost?['postId'] ?? 'unknown',
      ownerId: _firstPost?['ownerId'] ?? 'unknown',
      timestamp: _firstPost?['timestamp'] ?? 'unknown',
      userName: _firstPost?['userData']['userName'] ?? 'unknown',
      fullName: _firstPost?['userData']['fullName'] ?? '@unknown',
      phoneNumber: _firstPost?['userData']['phoneNumber'] ?? 'unknown',
      sex: _firstPost?['userData']['sex'] ?? '@unknown',
      vehicleType: _firstPost?['vehicleType'] ?? 'unknown',
      numberOfSeats: _firstPost?['numberOfSeats'] ?? 1,
      departureTime: _firstPost?['departureTime'] ?? 'unknown',
      expense: _firstPost?['expense'],
      status: _firstPost?['status'] ?? 'Cancel',
      startLocation: _firstPost?['startLocation'] ?? 'unknown',
      endLocation: _firstPost?['endLocation'] ?? 'unknown',
      informationAboutCompanion: List<Map<String, dynamic>>.from(_firstPost?['informationAboutCompanion'] ?? []),
    );
  }
}

