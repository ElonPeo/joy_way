import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/screens/authentication/components/Login/CustomTextFieldInput.dart';
import '/config/GeneralSpecifications.dart';
import 'StatusAndErrorMessages.dart';

class Loginscreen extends StatefulWidget {
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  List<String> assetsIcons = [
    "assets/icons/google.png",
    "assets/icons/facebook.png",
    "assets/icons/apple.png",
  ];
  bool scaleContainer = false;

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: specs.screenHeight,
        width: specs.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(143, 135, 241, 0.2),
              Color.fromRGBO(156, 204, 204, 0.2),
              Color.fromRGBO(242, 198, 245, 0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              StatusAndErrorMessages(
                scaleContainer: scaleContainer,
                onScaleChanged: (newValue) {
                  setState(() {
                    scaleContainer = newValue;
                  });
                },
              ),
            ],
          ),
          Stack(
            children: [
              AnimatedPositioned(
                top: scaleContainer ? specs.screenHeight :  specs.screenHeight * 0.4,
                left: -10,
                duration: Duration(milliseconds: 500),
                child: Container(
                  height: specs.screenHeight * 0.57,
                  width: specs.screenWidth,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Text(
                        "Sign up",
                        style: GoogleFonts.comfortaa(
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                        ),
                      ),
                      Container(
                        height: 230,
                        child: CustomTextFieldInput(
                          scaleContainer: scaleContainer,
                          onScaleChanged: (newValue) {
                            setState(() {
                              scaleContainer = newValue;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80,
                            height: 1,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [
                                Colors.white,
                                Colors.grey,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )),
                          ),
                          Text(
                            "Or continue with",
                            style: GoogleFonts.comfortaa(
                              color: specs.bl80,
                              fontSize: 11,
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 1,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.white,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          3,
                          (index) => Container(
                            width: 80,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                assetsIcons[index],
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member? ",
                            style: GoogleFonts.comfortaa(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Register now",
                            style: GoogleFonts.comfortaa(
                              color: specs.pantoneColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]
        ),
      ),
    );
  }
}
