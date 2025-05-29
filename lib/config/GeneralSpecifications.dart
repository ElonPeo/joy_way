import 'package:flutter/material.dart';

class GeneralSpecifications {
  final double screenHeight;
  final double screenWidth;
  final Color pantoneColor;
  final Color pantoneShadow;
  final Color bl80;
  GeneralSpecifications(BuildContext context)
      : screenHeight = MediaQuery.of(context).size.height,
        screenWidth = MediaQuery.of(context).size.width,
        pantoneColor = const Color(0xFF3E9D6E),
        bl80 = Color.fromRGBO(80, 80, 80, 1),
        pantoneShadow = Color.fromRGBO(52, 147, 100, 0.15);
}
