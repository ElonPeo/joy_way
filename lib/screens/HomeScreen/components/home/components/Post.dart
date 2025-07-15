import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/services/DataProcessing/LocationProcessing.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../widgets/ShowGeneralDialog.dart';
import '../../journey/JourneyScreen.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String timestamp;
  final String userName;
  final String fullName;
  final String phoneNumber;
  final String? sex;
  final String? content;
  final String vehicleType;
  final int numberOfSeats;
  final String departureTime;
  final String? expense;
  final String status;
  final String startLocation;
  final String endLocation;
  final List<Map<String, dynamic>>? informationAboutCompanion;
  final List<String>? likeUserIds;
  final List<Map<String, dynamic>>? comments;

  const Post({
    super.key,
    required this.postId,
    required this.ownerId,
    required this.timestamp,
    required this.userName,
    required this.fullName,
    required this.phoneNumber,
    required this.sex,
    required this.content,
    required this.vehicleType,
    required this.numberOfSeats,
    required this.departureTime,
    required this.expense,
    required this.status,
    required this.startLocation,
    required this.endLocation,
    required this.informationAboutCompanion,
    this.likeUserIds = const [],
    this.comments = const [],
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {


  @override
  Widget build(BuildContext context) {
    final startCleaned = LocationProcessing.extractCleanedComponents(
        widget.startLocation);
    final endCleaned = LocationProcessing.extractCleanedComponents(
        widget.endLocation);
    final startProvince = startCleaned.isNotEmpty ? startCleaned[0] : 'unknown';
    final endProvince = endCleaned.isNotEmpty ? endCleaned[0] : 'unknown';
    final endDistrict = startCleaned.isNotEmpty ? startCleaned[1] : 'unknown';
    final specs = GeneralSpecifications(context);
    return GestureDetector(
      onTap: () {
        ShowGeneralDialog.General_Dialog(
            context: context,
            beginOffset: Offset(1, 0),
            child: JourneyScreen(
              isJourneyScreen: false,
              isOwner: false,
              isJoin: false,
              postId: widget.postId,
              ownerId: widget.ownerId,
              timestamp: widget.timestamp,
              userName: widget.userName,
              fullName: widget.fullName,
              phoneNumber: widget.phoneNumber,
              sex: widget.sex,
              vehicleType: widget.vehicleType,
              numberOfSeats: widget.numberOfSeats,
              departureTime: widget.departureTime,
              expense: widget.expense,
              status: widget.status,
              startLocation: widget.startLocation,
              endLocation: widget.endLocation,
              informationAboutCompanion: widget.informationAboutCompanion,
            ),
        );
      },
      child: Container(
        width: specs.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 252, 251, 1),
          border: Border(
            bottom: BorderSide(
              color: specs.bl240,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Container(
                width: 40,
                height: 40,
                color: specs.bl240,
                child: const Icon(
                  Icons.person,
                  size: 20,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: specs.screenWidth - 70,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.fullName ?? 'Unknown',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.timestamp,
                        style: GoogleFonts.montserrat(
                            fontSize: 12, color: specs.bl200),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: specs.pantoneColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: specs.screenWidth - 70,
                    child: Text(
                        widget.content ?? '',
                        textAlign: TextAlign.start,
                        style: GoogleFonts.outfit(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: specs.screenWidth - 70,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        Text(
                          "Starts in ",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          startProvince,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 79, 15, 1),
                          ),
                        ),
                        Text(
                          ' at ',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.departureTime,
                          style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(3, 166, 161, 1)
                          ),
                        ),
                        Text(
                          ' and ends in ',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          endProvince + ', ' + endDistrict,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(255, 166, 115, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 100,
                      width: specs.screenWidth - 70,
                      decoration: BoxDecoration(
                        color: specs.bl240,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                height: 13,
                                width: 13,
                                child: Image.asset(
                                  'assets/icons/comment.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '123',
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: specs.bl240,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.fromRGBO(230, 230, 230, 1),
                            width: 0.7,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                height: 13,
                                width: 13,
                                child: Image.asset(
                                  // 'assets/icons/heartFill.png',
                                  'assets/icons/heartOutline.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '123',
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
