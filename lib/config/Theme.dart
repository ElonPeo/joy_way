import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
    textTheme: GoogleFonts.comfortaaTextTheme(),
  );
}
