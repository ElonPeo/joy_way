import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/GeneralSpecifications.dart';




class CustomTextFieldInput extends StatefulWidget{
  final bool scaleContainer;
  final Function(bool) onScaleChanged;

  const CustomTextFieldInput({
    super.key,
    required this.scaleContainer,
    required this.onScaleChanged,
  });

  @override
  State<CustomTextFieldInput> createState() => _CustomTextFieldInputState();
}

class _CustomTextFieldInputState extends State<CustomTextFieldInput> {
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
       backgroundColor: Colors.transparent,
       body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  hintText: "Enter your email",
                  hintStyle: GoogleFonts.comfortaa(
                    color: specs.bl80,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  hintText: "Password",
                  hintStyle: GoogleFonts.comfortaa(
                    color: specs.bl80,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Recovery Password",
                  style: GoogleFonts.comfortaa(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                widget.onScaleChanged(true);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: specs.screenWidth,
                decoration: BoxDecoration(
                  color: specs.pantoneColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: specs.pantoneShadow,
                      blurRadius: 15,
                      offset: Offset(0, 30),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.comfortaa(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

    );
  }
}

