import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/screens/HomeScreen/components/profile/ProfileEditForm.dart';
import 'package:joy_way/services/FirebaseServices/FriendsService.dart';
import 'package:joy_way/widgets/ShowGeneralDialog.dart';

import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/DataProcessing/TimeProcessing.dart';
import '../../../../services/FirebaseServices/PostService.dart';
import '../home/components/Post.dart';

class ProfileScreen extends StatefulWidget {
  final bool isAuth;
  final String? otherUid;
  final String? userName;
  final String? fullName;
  final String? story;
  final String? phoneNumber;
  final String? placeOfBirth;
  final String? currentAddress;
  final DateTime? dateOfBirth;
  final String? sex;

  const ProfileScreen({
    super.key,
    required this.isAuth,
    this.otherUid ,
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
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {



  int onPage = 0;
  late ScrollController _scrollController;
  double _dynamicHeight = 0.0;
  double _dynamicPositionAvatar = 0.0;
  late GeneralSpecifications specs;


  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  void loadPosts() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    final userId;
    if (widget.isAuth){
      userId = currentUser.uid;
    } else {
      userId = widget.otherUid;
    }
    final data = await PostService().getPostsByOwnerId(userId);
    setState(() {
      _posts = data;
      _isLoading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    loadPosts();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        specs = GeneralSpecifications(context);
        _dynamicHeight = specs.screenHeight * 0.2;
        _dynamicPositionAvatar = specs.screenHeight * 0.2 - 56.5;
        _scrollController = ScrollController()
          ..addListener(() {
            final offset = _scrollController.offset;
            double startHeight = specs.screenHeight * 0.2;
            double endHeight = specs.screenHeight * 0.15;
            double maxScroll = 200.0;
            double newHeight;
            if (offset <= 0) {
              newHeight = startHeight;
            } else if (offset >= maxScroll) {
              newHeight = endHeight;
            } else {
              double percent = offset / maxScroll;
              newHeight = startHeight - (startHeight - endHeight) * percent;
            }

            double startPos = specs.screenHeight * 0.2-51.5;
            double endPos = 20;
            double maxPos = 200.0;
            double newPos;
            if (offset <= 0) {
              newPos = startPos;
            } else if (offset >= maxScroll) {
              newPos = endPos;
            } else {
              double percent = offset / maxPos;
              newPos = startPos - (startPos - endPos) * percent;
            }

            setState(() {
              _dynamicHeight = newHeight;
              _dynamicPositionAvatar = newPos;
            });
          });
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                collapsedHeight: specs.screenHeight * 0.11,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                stretch: true,
                expandedHeight: specs.screenHeight * 0.4,
                flexibleSpace:FlexibleSpaceBar(
                  background: Container(
                    height: specs.screenHeight * 0.11 - 40,
                    width: specs.screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: specs.screenHeight*0.15 + 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.isAuth ?
                            GestureDetector(
                              onTap: () {
                                ShowGeneralDialog.General_Dialog(
                                    context: context,
                                    beginOffset: const Offset(0, 1),
                                    child: ProfileEditForm());
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: specs.pantoneColor
                                ),
                                child: Text(
                                  "Edit profile",
                                  style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                            )
                                :
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        print("is tap make friend");
                                        final friendsService = FriendsService();
                                        final  result = await friendsService.sendFriendRequest(
                                          receiverId: widget.otherUid ?? '',
                                        );
                                        if (result == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Đã gửi lời mời kết bạn')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Lỗi: $result')),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: specs.pantoneColor
                                        ),
                                        child: Text(
                                          "Make friend",
                                          style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15,),
                                    GestureDetector(
                                      onTap: () {
                                          ShowGeneralDialog.Message_Room_Dialog(
                                              context: context,
                                              userId: widget.otherUid,
                                              userName: widget.userName,
                                              fullName: widget.fullName);
                                        },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: specs.pantoneColor
                                        ),
                                        child: Text(
                                          "Message",
                                          style: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                )

                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              widget.fullName ?? "Full Name",
                              style: GoogleFonts.montserrat(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                final result = await FriendsService().followUser(otherUserUid: widget.otherUid ?? '');

                                if (result == null) {
                                  // Thành công: hiển thị snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('✅ Đã theo dõi người dùng'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  // Nếu có lỗi trả về từ service
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('❌ $result'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }

                                print("follow");
                              },

                              icon: Icon(
                                Icons.add
                              ),
                            ),
                          ],
                        ),

                        Text(
                          widget.userName ?? "@User Name",
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.placeOfBirth != null && widget.placeOfBirth!.isNotEmpty &&
                                widget.currentAddress != null && widget.currentAddress!.isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.home_filled, color: specs.bl150, size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    'From ${widget.placeOfBirth}, lives in ${widget.currentAddress}',
                                    style: GoogleFonts.outfit(color: specs.bl150),
                                  ),
                                ],
                              )
                            else if (widget.placeOfBirth != null && widget.placeOfBirth!.isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.home_filled, color: specs.bl150, size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    'From ${widget.placeOfBirth}',
                                    style: GoogleFonts.outfit(color: specs.bl150),
                                  ),
                                ],
                              )
                            else if (widget.currentAddress != null && widget.currentAddress !.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.pin_drop_rounded, color: specs.bl150, size: 15),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Lives in ${widget.currentAddress} ',
                                      style: GoogleFonts.outfit(color: specs.bl150),
                                    ),
                                  ],
                                )
                              else const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child:Container(
                    height: 40,
                    width: specs.screenWidth,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: [
                        ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  onPage = 0;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Center(
                                  child: Text(
                                    "Posts",
                                    style: GoogleFonts.outfit(
                                        fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  onPage = 1;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Center(
                                  child: Text(
                                    "About",
                                    style: GoogleFonts.outfit(
                                        fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  onPage = 2;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Center(
                                  child: Text(
                                    "Movement history",
                                    style: GoogleFonts.outfit(
                                        fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          top: 38,
                          left: (onPage == 0) ? 0 : (onPage == 1 ? 70 : (onPage == 2 ? 145 : 65)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 3,
                            width: (onPage == 0) ? 65 : (onPage == 1 ? 65 : (onPage == 2 ? 140 : 65)),
                            decoration: BoxDecoration(
                              color: specs.pantoneColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  _posts.map((post) => Post(
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
                    likeUserIds: List<String>.from(post['likeUserIds']),
                    comments: List<Map<String, dynamic>>.from(post['comments']),
                    informationAboutCompanion: List<Map<String, dynamic>>.from(post['companionIds'] ?? []),
                  )).toList(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: _dynamicHeight,
            width: specs.screenWidth,
             child: Image.asset(
               'assets/backgrounds/backgroundEX.jpg',
               fit: BoxFit.cover,
             ),
          ),
          Positioned(
            left: 10,
            top: _dynamicPositionAvatar,
            child: Transform.scale(
              scale: (_dynamicHeight - specs.screenHeight * 0.15) /
                  (specs.screenHeight * 0.2 - specs.screenHeight * 0.15) *
                  0.4 +
                  0.6, // scale từ 1.0 đến 0.6
              alignment: Alignment.center,
              child: SizedBox(
                height: 103,
                width: 103,
                child: Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: Container(
                          width: 100,
                          height: 100,
                          color: specs.bl240,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 103,
                      width: 103,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.circle,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          )


        ],
      ),

    );
  }
}
