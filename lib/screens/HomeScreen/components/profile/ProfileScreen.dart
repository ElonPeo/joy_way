import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/screens/HomeScreen/components/profile/ProfileEditForm.dart';
import 'package:joy_way/widgets/ShowGeneralDialog.dart';

import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/FirebaseServices/ProfileService.dart';

class ProfileScreen extends StatefulWidget {
  final bool isAuth;
  final String? uid;
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
    this.uid ,
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


  @override
  void initState() {
    super.initState();
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
    final user = FirebaseAuth.instance.currentUser;
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                                    beginOffset: Offset(0, 1),
                                    child: ProfileEditForm());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: specs.pantoneColor
                                ),
                                child: Text(
                                  "Edit profile",
                                  style: GoogleFonts.montserrat(
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
                                      onTap: () {
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: specs.pantoneColor
                                        ),
                                        child: Text(
                                          "Make friend",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    GestureDetector(
                                      onTap: () {
                                          ShowGeneralDialog.Message_Dialog(
                                              context: context,
                                              userId: widget.uid,
                                              userName: widget.userName,
                                              fullName: widget.fullName);
                                        },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: specs.pantoneColor
                                        ),
                                        child: Text(
                                          "Message",
                                          style: GoogleFonts.montserrat(
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.fullName ?? "Full Name",
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.userName ?? "User Name",
                          style: GoogleFonts.montserrat(
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
                                  SizedBox(width: 4),
                                  Text(
                                    'From ${widget.placeOfBirth}, lives in ${widget.currentAddress}',
                                    style: GoogleFonts.montserrat(color: specs.bl150),
                                  ),
                                ],
                              )
                            else if (widget.placeOfBirth != null && widget.placeOfBirth!.isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.home_filled, color: specs.bl150, size: 15),
                                  SizedBox(width: 4),
                                  Text(
                                    'From ${widget.placeOfBirth}',
                                    style: GoogleFonts.montserrat(color: specs.bl150),
                                  ),
                                ],
                              )
                            else if (widget.currentAddress != null && widget.currentAddress !.isNotEmpty)
                                Row(
                                  children: [
                                    Icon(Icons.pin_drop_rounded, color: specs.bl150, size: 15),
                                    SizedBox(width: 4),
                                    Text(
                                      'Lives in ${widget.currentAddress} ',
                                      style: GoogleFonts.montserrat(color: specs.bl150),
                                    ),
                                  ],
                                )
                              else Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(40),
                  child:Container(
                    height: 40,
                    width: specs.screenWidth,
                    decoration: BoxDecoration(
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
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Center(
                                  child: Text(
                                    "Posts",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                      fontWeight: FontWeight.bold,
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
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Center(
                                  child: Text(
                                    "About",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                      fontWeight: FontWeight.bold,
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
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Center(
                                  child: Text(
                                    "Movement history",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          top: 38,
                          left: (onPage == 0) ? 0 : (onPage == 1 ? 70 : (onPage == 2 ? 145 : 65)),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
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
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(left: 20, bottom: 20, right: 10, top: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.red,
                        ),
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                      ),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
          Container(
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
              child: Container(
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
                          child: Icon(
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
          )

        ],
      ),

    );
  }
}
