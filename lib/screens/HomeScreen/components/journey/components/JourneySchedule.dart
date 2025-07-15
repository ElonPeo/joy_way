import 'package:flutter/material.dart';

import '../../../../../config/GeneralSpecifications.dart';




class JourneySchedule extends StatefulWidget {
  final String location;
  const JourneySchedule({super.key,required this.location});
  @override
  State<JourneySchedule> createState() => _JourneyScheduleState();
}

class _JourneyScheduleState extends State<JourneySchedule> {
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Column(
      children: [

      ],
    );
  }
}

