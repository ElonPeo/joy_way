import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../services/DataProcessing/TimeProcessing.dart';
import '../../../../../services/FirebaseServices/NotifyService.dart';


class JoinJourneyRequest extends StatefulWidget {
  final String userName;
  final String postId;
  final String receiverId;
  final String senderId;
  final String message;
  final String expense;
  final String? dropOffLocation;
  final String pickUpLocation;
  final String departureTime;

  const JoinJourneyRequest({
    super.key,
    required this.userName,
    required this.senderId,
    required this.receiverId,
    required this.postId,
    required this.message,
    required this.expense,
    required this.dropOffLocation,
    required this.pickUpLocation,
    required this.departureTime,
  });

  @override
  State<JoinJourneyRequest> createState() => _JoinJourneyRequestState();
}

class _JoinJourneyRequestState extends State<JoinJourneyRequest> {

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    final departureDate = TimeProcessing.formatDepartureTime2(widget.departureTime);
    final String? dropOffLocation = widget.dropOffLocation;
    final String? departureTime = widget.departureTime;

    return Container(
      width: specs.screenWidth - 40,
      child: Row(
        children: [
          Column(

          ),
          Container(
            width: specs.screenWidth - 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: specs.pantoneColor,
                    ),
                    children: [
                      TextSpan(
                        text: widget.userName,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: 'wants to be picked up in '),
                      TextSpan(
                        text: widget.pickUpLocation,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (dropOffLocation != null && dropOffLocation.isNotEmpty) ...[
                        const TextSpan(text: 'and wants to drop off in '),
                        TextSpan(
                          text: dropOffLocation,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' '),
                      ],
                      if (departureTime != null && departureTime.isNotEmpty) ...[
                        const TextSpan(text: 'at '),
                        TextSpan(
                          text: departureDate['time'] ?? 'unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        DateTime? departureDate;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );
                        try {
                          if (widget.departureTime.isNotEmpty) {
                            departureDate = DateTime.parse(widget.departureTime);
                          }

                          await NotifyService().acceptJoinTripAndNotify(
                            postId: widget.postId,
                            receiverId: widget.receiverId,
                            senderId: widget.senderId,
                            expense: widget.expense,
                            dropOffLocation: widget.dropOffLocation ?? '',
                            pickUpLocation: widget.pickUpLocation,
                            departureTime: departureDate,
                          );

                          Navigator.of(context).pop();
                        } catch (e) {
                          Navigator.of(context).pop();

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Lỗi"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Đóng"),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.ac_unit),
                    ),
                    IconButton(
                      onPressed: () async {
                        DateTime? departureDate;
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );
                        try {
                          await NotifyService().refuseJoinTripAndNotify(
                            postId: widget.postId,
                            receiverId: widget.receiverId,
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          Navigator.of(context).pop();

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Lỗi"),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text("Đóng"),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.cancel),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

