import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/services/DataProcessing/TimeProcessing.dart';
import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../services/DataProcessing/LocationProcessing.dart';


class JourneyInformation extends StatefulWidget {
  final String postID;
  final String vehicleType;
  final int numberOfSeats;
  final String departureTime;
  final String? expense;
  final String startLocation;
  final String endLocation;
  const JourneyInformation({
    super.key,
    required this.postID,
    required this.vehicleType,
    required this.numberOfSeats,
    required this.departureTime,
    required this.expense,
    required this.startLocation,
    required this.endLocation,
  });
  @override
  State<JourneyInformation> createState() => _JourneyInformationState();
}

class _JourneyInformationState extends State<JourneyInformation> {
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    final startCleaned = LocationProcessing.extractCleanedComponents(widget.startLocation);
    final endCleaned = LocationProcessing.extractCleanedComponents(widget.endLocation);
    final startProvince = startCleaned.isNotEmpty ? startCleaned[0] : 'unknown';
    final startDistrict = startCleaned.length > 1 ? startCleaned[1] : '';
    final endProvince = endCleaned.isNotEmpty ? endCleaned[0] : 'unknown';
    final endDistrict = endCleaned.length > 1 ? endCleaned[1] : '';
    final departureDate = TimeProcessing.formatDepartureTime2(widget.departureTime);
    return Container(
      width: specs.screenWidth - 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 20, right: 10),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(90, 130, 126, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Journey',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                    onPressed: (){

                    },
                    icon: Icon(
                      Icons.copy_outlined,
                      color: Colors.white,
                      size: 20,
                    )
                )
              ],
            ),

          ),
          Container(
            padding: EdgeInsets.only( right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  margin: EdgeInsets.only(right: 20),
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(236, 237, 176, 1),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Seats',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '2/4',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        height: 1,
                        width: 40,
                        color: specs.bl200,
                      ),
                      Text(
                        'Vehicle',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Car',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: specs.screenWidth - 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                startProvince,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color.fromRGBO(255, 79, 15, 1),
                                ),
                              ),
                              Text(
                                startDistrict,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                endProvince,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color.fromRGBO(255, 166, 115, 1),
                                ),
                              ),
                              Text(
                                endDistrict,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: specs.screenWidth - 120,
                        height: 1,
                        color: specs.bl240,
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                departureDate['time'] ?? 'unknown',
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: Color.fromRGBO(3, 166, 161, 1)
                                ),
                              ),
                              Text(
                                departureDate['date'] ?? 'unknown',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: specs.screenWidth - 120,
                        height: 1,
                        color: specs.bl240,
                        margin: EdgeInsets.symmetric(vertical: 5),
                      ),
                      Container(
                        height: 50,
                        child: Text(
                            '100.000 VND'
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

