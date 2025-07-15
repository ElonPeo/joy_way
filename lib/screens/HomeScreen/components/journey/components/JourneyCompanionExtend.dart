import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../services/DataProcessing/LocationProcessing.dart';
import '../../../../../services/DataProcessing/TimeProcessing.dart';

class JourneyCompanionExtend extends StatefulWidget {
  final bool isOwner;
  final bool isJoin;
  final String startLocation;
  final String endLocation;
  final List<Map<String, dynamic>>? enrichedCompanions;

  const JourneyCompanionExtend({
    super.key,
    required this.isOwner,
    required this.isJoin,
    required this.startLocation,
    required this.endLocation,
    required this.enrichedCompanions,
  });

  @override
  State<JourneyCompanionExtend> createState() => _JourneyCompanionExtendState();
}

class _JourneyCompanionExtendState extends State<JourneyCompanionExtend> {
  bool isTapFindCompanion = false;
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Material(
      child: Container(
        height: specs.screenHeight,
        width: specs.screenWidth,
        color: Colors.white,
        child: Stack(
          children: [
            SizedBox(
              height: specs.screenHeight,
              width: specs.screenWidth,
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  AnimatedContainer(
                    height: isTapFindCompanion
                        ? specs.screenHeight * 0.05
                        : specs.screenHeight * 0.12,
                    duration: const Duration(milliseconds: 250),
                  ),
                  Container(
                    width: specs.screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 45,
                    // color: Colors.blue,
                    // color: Colors.orange,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                            duration: const Duration(milliseconds: 250),
                            top: 0,
                            left: isTapFindCompanion ? 0 : -50,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: isTapFindCompanion ? 1 : 0,
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isTapFindCompanion = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: AnimatedContainer(
                                  height: 40,
                                  width: isTapFindCompanion
                                      ? specs.screenWidth - 70
                                      : specs.screenWidth - 30,
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        isTapFindCompanion = true;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: GoogleFonts.outfit(
                                        color: specs.bl80,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(8),
                                      prefixIcon:
                                          Icon(Icons.search, color: specs.bl80),
                                      filled: true,
                                      fillColor: const Color.fromRGBO(
                                          240, 240, 240, 1),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    ),
                  ),


                  Column(
                    children: List.generate(widget.enrichedCompanions?.length ?? 0, (index) {
                      final companionData = widget.enrichedCompanions![index];
                      final user = companionData['userData'] ?? {};

                      final startCleaned = LocationProcessing.extractCleanedComponents(companionData['pickUpLocation']);
                      final endCleaned = companionData['dropOffLocation'] != null
                          ? LocationProcessing.extractCleanedComponents(companionData['dropOffLocation'])
                          : [];
                      final departureDate = TimeProcessing.formatDepartureTime2(companionData['departureTime']);
                      final startProvince = startCleaned.isNotEmpty ? startCleaned[0] : '';
                      final startDistrict = startCleaned.length > 1 ? startCleaned[1] : '';
                      final startCommunes = startCleaned.length > 2 ? startCleaned[2] : '';
                      final startDetail = startCleaned.length > 3 ? startCleaned[3] : '';
                      final endProvince = endCleaned.isNotEmpty ? endCleaned[0] : '';
                      final endDistrict = endCleaned.length > 1 ? endCleaned[1] : '';
                      final endCommunes = endCleaned.length > 2 ? endCleaned[2] : '';
                      final endDetail = endCleaned.length > 3 ? endCleaned[3] : '';
                      final expense = companionData['expense'] ?? 'Unknown';
                      final fullName = user['fullName'] ?? 'No Name';
                      final phoneNumber = user['phoneNumber'] ?? 'Unknown';
                      final hasEndAddress = (endDistrict != 'null' && endDistrict.isNotEmpty) &&
                          (endCommunes != 'null' && endCommunes.isNotEmpty);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: specs.bl240),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      height: 63,
                                      width: 63,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: ClipOval(
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey[300],
                                                child: const Icon(Icons.person, size: 25),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              height: 63,
                                              width: 63,
                                              decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white, width: 3),
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
                                          fullName,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          phoneNumber,
                                          style: GoogleFonts.outfit(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const ImageIcon(
                                    AssetImage('assets/icons/status/pick-up.png'),
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Địa điểm
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(startProvince,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: const Color.fromRGBO(255, 79, 15, 1),
                                        )),

                                    Text("$startDistrict, $startCommunes", style: GoogleFonts.outfit(fontSize: 12)),
                                    Divider(height: 10, color: specs.bl240),
                                    Text(startDetail, style: GoogleFonts.outfit(fontSize: 12)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(endProvince ?? '',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: const Color.fromRGBO(255, 166, 115, 1),
                                        )),
                                    hasEndAddress
                                        ? Text("$endDistrict, $endCommunes", style: GoogleFonts.outfit(fontSize: 12))
                                        : const SizedBox.shrink(),


                                    Divider(height: 10, color: specs.bl240),
                                    Text(endDetail ?? '', style: GoogleFonts.outfit(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Thời gian - Chi phí
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      departureDate['time'] ?? 'unknown',
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: const Color.fromRGBO(3, 166, 161, 1),
                                      ),
                                    ),
                                    Text(departureDate['date'] ?? 'unknown', style: GoogleFonts.outfit(fontSize: 12)),
                                  ],
                                ),
                                Text(
                                  '$expense VND',
                                  style: GoogleFonts.outfit(fontSize: 14, color: specs.pantoneColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  )


                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: isTapFindCompanion ? -specs.screenHeight * 0.12 : 0,
              left: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: isTapFindCompanion ? 0 : 1,
                child: Container(
                  width: specs.screenWidth,
                  height: specs.screenHeight * 0.12,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Companion",
                            style: GoogleFonts.outfit(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
