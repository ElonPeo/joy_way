import 'package:flutter/material.dart';

class GeneralSpecifications {
  final double screenHeight;
  final double screenWidth;
  final Color pantoneColor;
  final Color pantoneColor2;
  final Color pantoneShadow;
  final Color bl80;
  final Color bl100;
  final Color bl240;
  final Color bl150;
  final Color bl200;
  GeneralSpecifications(BuildContext context)
      : screenHeight = MediaQuery.of(context).size.height,
        screenWidth = MediaQuery.of(context).size.width,
        pantoneColor = const Color.fromRGBO(62, 157, 110, 1),
        pantoneColor2 = const Color.fromRGBO(44, 122, 84, 1),
        bl80 = const Color.fromRGBO(80, 80, 80, 1),
        bl100 = const Color.fromRGBO(100, 100, 100, 1),
        bl150 = const Color.fromRGBO(150, 150, 150, 1),
        bl200 = const Color.fromRGBO(200, 200, 200, 1),
        bl240 = const Color.fromRGBO(240, 240, 240, 1),
        pantoneShadow = const Color.fromRGBO(52, 147, 100, 0.15);
}
