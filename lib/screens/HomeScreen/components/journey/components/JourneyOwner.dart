import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../widgets/ShowGeneralDialog.dart';

class JourneyOwner extends StatefulWidget {
  final bool isJourneyScreen;
  final bool isOwner;
  final bool isJoin;
  final String ownerId;
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String? sex;

  const JourneyOwner({
    super.key,
    required this.isJourneyScreen,
    required this.isOwner,
    required this.isJoin,
    required this.ownerId,
    required this.fullName,
    required this.userName,
    required this.phoneNumber,
    required this.sex,
  });

  @override
  State<JourneyOwner> createState() => _JourneyOwnerState();
}

class _JourneyOwnerState extends State<JourneyOwner> {
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Container(
      width: specs.screenWidth,
      padding: EdgeInsets.only(top: 30, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isJoin == false
                  ?
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 0.6),
                    borderRadius: BorderRadius.circular(30)),
                child:IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
              ) : SizedBox(),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 0.6),
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  children: [
                    Center(
                      child: ClipOval(
                        child: Container(
                          width: 80,
                          height: 80,
                          color: specs.bl240,
                          child: const Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 83,
                        width: 83,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 3.0,
                            style: BorderStyle.solid,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    if (widget.isOwner == false)
                      Positioned(
                        top: 52,
                        left: 65,
                        child: Container(
                            height: 33,
                            width: 33,
                            decoration: BoxDecoration(
                                color: specs.pantoneColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                              onPressed: () {
                                ShowGeneralDialog.Message_Room_Dialog(
                                    context: context,
                                    userId: widget.ownerId,
                                    userName: widget.userName,
                                    fullName: widget.fullName);
                              },
                              icon: const ImageIcon(
                                AssetImage(
                                    'assets/icons/message/message-plane.png'),
                                size: 30,
                                color: Colors.white,
                              ),
                            )),
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.isOwner ? '${widget.fullName} (You)' : widget.fullName,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                widget.phoneNumber,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
