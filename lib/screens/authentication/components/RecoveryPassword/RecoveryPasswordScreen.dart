import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/widgets/AnimationContainer/FadeContainer.dart';
import '../../../../services/FirebaseServices/Authentication.dart';
import '/config/GeneralSpecifications.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  final int type;
  final bool scaleForLoading;
  final String messages;
  final Function(bool) onPasswordRecoveryRequest;
  final Function(bool) onUnsuccessful;
  final Function(bool) onScaleChangedLoading;
  final Function(String) onMessages;
  final Function(int) onTypeChanged;


  const RecoveryPasswordScreen({
    super.key,
    required this.type,
    required this.scaleForLoading,
    required this.messages,
    required this.onUnsuccessful,
    required this.onMessages,
    required this.onPasswordRecoveryRequest,
    required this.onScaleChangedLoading,
    required this.onTypeChanged,
  });

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  final _emailController = TextEditingController();
  //Service
  final Authentication auth = Authentication();

  String _message = "";

  Future<bool> _Recovery() async {
    String email = _emailController.text.trim();
    if(auth.checkBeforeSendingResetPassword(email)){
      String? errorMessage = await auth.resetPassword(email);
      if (errorMessage == null) {
        setState(() {
          _message = 'Password recovery request sent successfully!';
        });
        return true;
      } else {
        setState(() {
          _message = errorMessage;
        });
        return false;
      }
    } else{
      setState(() {
        _message = auth.validateInputResetPassWord(email);
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
  bool _obscurePass1 = true;
  bool _obscurePass2 = true;

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
              : specs.screenHeight * 0.6,
          left: -10,
          duration: Duration(milliseconds: 100),
          child: Container(
            height: specs.screenHeight * 0.35,
            width: specs.screenWidth,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                FadeContainer(
                  animation: animation[0],
                  fatherHeight: 50,
                  fatherWidth: specs.screenWidth,
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Recovery Password",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  // color: Colors.yellowAccent,
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
                                      hintStyle: GoogleFonts.outfit(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
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
                        height: 20,
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
                                    widget.onScaleChangedLoading(true);
                                    bool success = await _Recovery();
                                    if (success) {
                                      await Future.delayed(const Duration(milliseconds: 2000));
                                      widget.onPasswordRecoveryRequest(true);
                                      widget.onUnsuccessful(true);
                                      widget.onMessages(_message);
                                    } else {
                                      widget.onMessages(_message);
                                      await Future.delayed(const Duration(milliseconds: 2000));
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
                                        "Send",
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
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
                FadeContainer(
                  fatherWidth: specs.screenWidth - 40,
                  fatherHeight: 20,
                  animation: animation[9],
                  duration: Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You are already a member? ",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
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
                              widget.onTypeChanged(0);
                            });
                          });
                        },
                        child: Text(
                          "Login now",
                          style: GoogleFonts.outfit(
                            color: specs.pantoneColor,
                            fontSize: 13,
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
