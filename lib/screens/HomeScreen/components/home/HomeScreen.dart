import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_way/screens/HomeScreen/components/home/components/Post.dart';
import 'package:joy_way/screens/HomeScreen/components/search/SearchScreen.dart';
import 'package:joy_way/services/DataProcessing/TimeProcessing.dart';
import 'package:joy_way/widgets/ShowGeneralDialog.dart';
import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/FirebaseServices/PostService.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  final String? fullName;
  final String? story;
  final String? phoneNumber;
  final String? placeOfBirth;
  final String? currentAddress;
  final DateTime? dateOfBirth;
  final String? sex;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.fullName,
    required this.story,
    this.phoneNumber,
    required this.placeOfBirth,
    required this.currentAddress,
    required this.dateOfBirth,
    required this.sex,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPressSearchSomething = false;
  double searchOpacity = 0;
  bool showSearchSomeThing = false;



  void showSearch() async {
    setState(() {
      showSearchSomeThing = true;
    });
    await Future.delayed(Duration(milliseconds: 50));
    setState(() {
      searchOpacity = 1;
    });
  }

  void hideSearch() async {
    setState(() {
      searchOpacity = 0;
    });

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      showSearchSomeThing = false;
    });
  }






  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  void loadPosts() async {
    final data = await PostService().getAllPostsWithUserInfo();
    setState(() {
      _posts = data;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return SizedBox(
      height: specs.screenHeight,
      width: specs.screenWidth,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: 100),
            children: _isLoading
                ? [Center(child: CircularProgressIndicator())]
                : _posts.map((post) => Post(
              postId: post['postId'],
              ownerId: post['ownerId'],
              timestamp: TimeProcessing.formatTimestamp(post['timestamp']),
              userName: '${post['userData']['userName'] ?? 'username'}',
              fullName: post['userData']['fullName'] ?? 'Full Name',
              phoneNumber: post['userData']['phoneNumber'] ?? 'Phone Number',
              sex: post['userData']['sex'],
              content: post['content'],
              vehicleType: post['vehicleType'],
              numberOfSeats: post['numberOfSeats'],
              departureTime: TimeProcessing.formatDepartureTime(post['departureTime']),
              expense: post['expense'],
              status: post['status'],
              startLocation: post['startLocation'],
              endLocation: post['endLocation'],
              likeUserIds: List<String>.from(post['likeUserIds'] ?? []),
              comments: List<Map<String, dynamic>>.from(post['comments'] ?? []),
              informationAboutCompanion: List<Map<String, dynamic>>.from(post['companionIds'] ?? []),
            )).toList(),
          ),

          SizedBox(
            height: 90,
            width: specs.screenWidth,
            child: Stack(
              children: [
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 90,
                      width: specs.screenWidth,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  width: specs.screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: specs.bl240,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 130,
                            child: Image.asset(
                              'assets/backgrounds/authenBG/fullLogo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: showSearch,
                                icon: Icon(Icons.search),
                              ),
                              IconButton(
                                onPressed: () {
                                  ShowGeneralDialog.Message_Dialog(
                                      context: context, userName: widget.userName, fullName: widget.fullName, sex: widget.sex,
                                  );
                                },
                                icon: Image.asset(
                                  'assets/icons/chat.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showSearchSomeThing)
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: searchOpacity,
              child: SearchScreen(
                onFadeOutComplete: hideSearch,
              ),
            ),
        ],
      ),
    );
  }
}
