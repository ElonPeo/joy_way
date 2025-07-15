import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:joy_way/screens/HomeScreen/components/home/components/RequestJoinForm.dart';
import 'package:joy_way/screens/HomeScreen/components/journey/components/JourneyInformation.dart';
import 'package:joy_way/screens/HomeScreen/components/journey/components/JourneyOwner.dart';
import 'package:joy_way/screens/HomeScreen/components/journey/components/JourneyStatus.dart';
import 'package:joy_way/widgets/ShowGeneralDialog.dart';

import '../../../../config/GeneralSpecifications.dart';
import 'components/JourneyCompanion.dart';

class JourneyScreen extends StatefulWidget {
  final bool isJourneyScreen;
  final bool isOwner;
  final bool isJoin;
  final String postId;
  final String ownerId;
  final String timestamp;
  final String userName;
  final String fullName;
  final String phoneNumber;
  final String? sex;
  final String vehicleType;
  final int numberOfSeats;
  final String departureTime;
  final String? expense;
  final String status;
  final String startLocation;
  final String endLocation;
  final List<Map<String, dynamic>>? informationAboutCompanion;

  const JourneyScreen({
    super.key,
    required this.isJourneyScreen,
    required this.isOwner,
    required this.isJoin,
    required this.postId,
    required this.ownerId,
    required this.timestamp,
    required this.userName,
    required this.fullName,
    required this.phoneNumber,
    required this.sex,
    required this.vehicleType,
    required this.numberOfSeats,
    required this.departureTime,
    required this.expense,
    required this.status,
    required this.startLocation,
    required this.endLocation,
    required this.informationAboutCompanion,
  });


  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Material(
      child: Stack(
        children: [
          Container(
            height: specs.screenHeight,
            width: specs.screenWidth,
            child: Image.asset(
              'assets/backgrounds/img.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: specs.screenHeight,
            width: specs.screenWidth,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                height: specs.screenHeight * 0.7,
                width: specs.screenWidth,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListView(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(230, 230, 230, 1),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: JourneyStatus(status: widget.status),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    JourneyInformation(
                      postID: widget.postId,
                      vehicleType: widget.vehicleType,
                      numberOfSeats: 3,
                      departureTime: widget.departureTime,
                      expense: widget.expense,
                      startLocation: widget.startLocation,
                      endLocation: widget.endLocation,
                    ),
                    JourneyCompanion(
                        isOwner: widget.isOwner,
                        isJoin: widget.isJoin,
                      informationAboutCompanion: widget.informationAboutCompanion,
                        startLocation: widget.startLocation,
                        endLocation: widget.endLocation,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ShowGeneralDialog.General_Dialog(
                          context: context,
                          beginOffset: Offset(0, 1),
                          child: RequestJoinForm(
                            postId: widget.postId,
                            ownerId: widget.ownerId,
                          ),
                        );
                      },
                      child: Text('Yêu cầu tham gia'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Đã được đón'),
                    ),
                    Container(
                      height: specs.screenHeight * 0.3,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              JourneyOwner(
                  isJourneyScreen: widget.isJourneyScreen,
                  isJoin: widget.isJoin,
                  isOwner: widget.isOwner,
                  ownerId: widget.ownerId,
                  fullName: widget.fullName,
                  userName: widget.userName,
                  phoneNumber: widget.phoneNumber,
                  sex: widget.sex)
            ],
          ),
        ],
      ),
    );
  }
}
