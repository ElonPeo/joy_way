import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/widgets/AnimationContainer/FadeContainer.dart';
import 'package:joy_way/widgets/AnimationContainer/MoveAndFadeInContainer.dart';
import 'package:joy_way/widgets/AnimationContainer/ScaleContainer.dart';
import '../../../../services/FirebaseServices/Authentication.dart';
import '/config/GeneralSpecifications.dart';

class LoginScreen extends StatefulWidget {
  final int type;
  final bool scaleForLoading;
  final String messages;
  final Function(bool) onGotoHomePage;
  final Function(bool) onUnsuccessful;
  final Function(bool) onScaleChangedLoading;
  final Function(String) onMessages;
  final Function(int) onTypeChanged;


  const LoginScreen({
    super.key,
    required this.type,
    required this.scaleForLoading,
    required this.messages,
    required this.onUnsuccessful,
    required this.onMessages,
    required this.onGotoHomePage,
    required this.onScaleChangedLoading,
    required this.onTypeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Services
  final Authentication auth = Authentication();
  String _message = "";

  Future<bool> _LoginIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (auth.Check_Before_Sending_SignIn(email, password)) {
      String? errorMessage = await auth.Sign_In(email, password);
      if (errorMessage == null) {
        setState(() {
          _message = 'Congratulations you have successfully logged in!';
        });
        return true;
      } else {
        setState(() {
          _message = errorMessage;
        });
        return false;
      }
    } else {
      setState(() {
        _message = auth.Validate_Input_SignIn(email, password);
      });
      return false;
    }
  }



  List<String> assetsIcons = [
    "assets/icons/google.png",
    "assets/icons/facebook.png",
    "assets/icons/apple.png",
  ];
  List<bool> animation = List<bool>.filled(10, false);
  bool _obscurePass = true;
  void setListFalse  (List<bool> list) {
    for(int i = 0 ; i < list.length; i++ )
      {
        list[i] = false;
      }
  }


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500), () {
      for (int i = 0; i < animation.length; i++){
        setState(() {
          animation[i] = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Stack(
      children: [
        AnimatedPositioned(
          top: widget.scaleForLoading
              ? specs.screenHeight
              : specs.screenHeight * 0.35,
          left: -10,
          duration: Duration(milliseconds: 100),
          child: Container(
            height: specs.screenHeight * 0.6,
            width: specs.screenWidth,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 260,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: specs.screenWidth,
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              curve: Curves.easeOutExpo,
                              duration: Duration(milliseconds: 500),
                              left: animation[1] ? 0 : 100,
                              top: 0,
                              child: AnimatedOpacity(
                                opacity: animation[1] ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  width: specs.screenWidth - 40,
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
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      hintText: "Enter your email",
                                      hintStyle: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),

                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: specs.pantoneColor,
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                        ),
                                      ),

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 60,
                        width: specs.screenWidth,
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              curve: Curves.easeOutExpo,
                              duration: Duration(milliseconds: 500),
                              left: animation[2] ? 0 : 100,
                              top: 0,
                              child: AnimatedOpacity(
                                opacity: animation[2] ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  width: specs.screenWidth - 40,
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
                                    controller: _passwordController,
                                    obscureText: _obscurePass,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      hintText: "Password",
                                      hintStyle: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),

                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: specs.pantoneColor,
                                          width: 2.0,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),

                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePass ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePass = !_obscurePass;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 20,
                        width: specs.screenWidth,
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutExpo,
                              right: animation[3] ? 0 : 60,
                              top: 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: animation[3] ? 1.0 : 0.0,
                                curve: Curves.easeOutExpo,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      animation = List<bool>.filled(10, false);
                                    });
                                    Future.delayed(Duration(milliseconds: 500), () {
                                      setState(() {
                                        widget.onTypeChanged(2);
                                      });
                                    });
                                  },
                                  child: Text(
                                    "Recovery Password",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        height: 55,
                        width: specs.screenWidth - 40,
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              left: 0,
                              top: animation[4] ? 0 : 100,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOutExpo,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: animation[4] ? 1.0 : 0.0,
                                curve: Curves.easeOutExpo,
                                child: GestureDetector(
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    widget.onScaleChangedLoading(true);
                                    bool success = await _LoginIn();
                                    if (success) {
                                      await Future.delayed(const Duration(milliseconds: 3000));
                                      widget.onMessages(_message);
                                      widget.onGotoHomePage(true);
                                    } else {
                                      await Future.delayed(const Duration(milliseconds: 3000));
                                      widget.onMessages(_message);
                                      widget.onUnsuccessful(true);
                                    }
                                  },
                                  child: Container(
                                    height: 55,
                                    width: specs.screenWidth - 40,
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
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                MoveAndFadeInContainer(
                  fatherHeight: 20,
                  fatherWidth: specs.screenWidth - 40,
                  heightOfChild: 15,
                  widthOfChild: specs.screenWidth - 40,
                  type: 3,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeOutExpo,
                  animation: animation[5],
                  child: Container(
                    height: 15,
                    width: specs.screenWidth - 40,
                    child: Row(
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
                          style: GoogleFonts.montserrat(
                            color: specs.bl80,
                            fontSize: 13,
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
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => ScaleContainer(
                      fatherHeight: 70,
                      fatherWidth: 90,
                      animation: animation[index + 6],
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                        width: 80,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
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
                ),
                FadeContainer(
                  fatherWidth: specs.screenWidth - 40,
                  fatherHeight: 20,
                  animation: animation[9],
                  duration: Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member? ",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            animation = List<bool>.filled(10, false);
                          });
                          Future.delayed(Duration(milliseconds: 500), () {
                            setState(() {
                              widget.onTypeChanged(1);
                            });
                          });
                        },
                        child: Text(
                          "Register now",
                          style: GoogleFonts.montserrat(
                            color: specs.pantoneColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
