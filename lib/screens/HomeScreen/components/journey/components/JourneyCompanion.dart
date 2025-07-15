import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/screens/HomeScreen/components/journey/components/JourneyCompanionExtend.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../services/DataProcessing/LocationProcessing.dart';
import '../../../../../services/FirebaseServices/PostService.dart';
import '../../../../../widgets/ShowGeneralDialog.dart';

class JourneyCompanion extends StatefulWidget {
  final bool isOwner;
  final bool isJoin;
  final String startLocation;
  final String endLocation;
  final List<Map<String, dynamic>>? informationAboutCompanion;

  const JourneyCompanion({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.isOwner,
    required this.isJoin,
    required this.informationAboutCompanion,
  });

  @override
  State<JourneyCompanion> createState() => _JourneyCompanionState();
}

class _JourneyCompanionState extends State<JourneyCompanion> {
  List<Map<String, dynamic>>? enrichedCompanions;

  @override
  void initState() {
    super.initState();
    _loadEnrichedCompanions();
  }

  void _loadEnrichedCompanions() async {
    final result = await PostService().getCompanionInfosWithUserDetails(widget.informationAboutCompanion);
    setState(() {
      enrichedCompanions = result;
    });
  }



  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    if (enrichedCompanions == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Companion',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 33,
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    '${widget.informationAboutCompanion!.length}',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          // Có thể cải tiến
          Column(
            children: List.generate(widget.informationAboutCompanion?.length ?? 0, (index) {
              final currentUid = FirebaseAuth.instance.currentUser?.uid;
              final companionData = widget.informationAboutCompanion![index];
              final isCurrentUser = companionData['id'] == currentUid;
              final startCleaned = LocationProcessing.extractCleanedComponents(companionData['pickUpLocation']);
              final startProvince = startCleaned.isNotEmpty ? startCleaned[0] : 'unknown';
              final startDistrict = startCleaned.length > 1 ? startCleaned[1] : 'unknown';
              final companion = enrichedCompanions![index];
              final userData = companion['userData'];
              final fullName = userData?['fullName'] ?? 'Unknown';
              final userName = userData?['userName'] ?? '';


              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 63,
                          width: 63,
                          child: Stack(
                            children: [
                              Center(
                                child: ClipOval(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    color: specs.bl240,
                                    child: const Icon(Icons.person, size: 25),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 63,
                                  width: 63,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.0,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCurrentUser ? 'You' : fullName ?? 'Unknown',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${startProvince},${startDistrict} ',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Nút nhắn tin
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Mở hộp thoại nhắn tin
                          // ShowGeneralDialog.Message_Room_Dialog(...)
                        },
                        icon: const ImageIcon(
                          AssetImage('assets/icons/message/message.png'),
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
          GestureDetector(
            onTap: () {
              print(enrichedCompanions);
              ShowGeneralDialog.General_Dialog(
                  context: context,
                  beginOffset: const Offset(1, 0),
                  child: JourneyCompanionExtend(
                      endLocation: widget.endLocation,
                      startLocation: widget.startLocation,
                      isOwner: widget.isOwner,
                      isJoin: widget.isJoin,
                      enrichedCompanions: enrichedCompanions));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 40,
              width: 130,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(24)),
              child: Center(
                child: Text(
                  'View everyone',
                  style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
