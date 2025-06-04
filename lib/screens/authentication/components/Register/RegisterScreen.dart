import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/widgets/AnimationContainer/FadeContainer.dart';
import '../../../../services/FirebaseServices/Authentication.dart';
import '/config/GeneralSpecifications.dart';

class RegisterScreen extends StatefulWidget {
  final int type;
  final bool scaleForLoading;
  final String messages;
  final Function(bool) onGotoHomePage;
  final Function(bool) onUnsuccessful;
  final Function(bool) onScaleChangedLoading;
  final Function(String) onMessages;
  final Function(int) onTypeChanged;


  const RegisterScreen({
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
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //Service
  final Authentication auth = Authentication();
  String _message = "";
  Future<bool> _Register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (auth.checkBeforeSendingSignUp(email, password, confirmPassword)) {
      String? errorMessage = await auth.signUp(email, password);

      if (errorMessage == null) {
        setState(() {
          _message = 'Congratulations on your successful registration!';
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
        _message = auth.validateInputSignUp(email, password, confirmPassword);
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
              : specs.screenHeight * 0.4,
          left: -10,
          duration: Duration(milliseconds: 100),
          child: Container(
            // color: Colors.red,
            height: specs.screenHeight * 0.57,
            width: specs.screenWidth,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                FadeContainer(
                  animation: animation[0],
                  fatherHeight: 40,
                  fatherWidth: specs.screenWidth,
                  duration: Duration(milliseconds: 500),
                  child: Text(
                    "Register",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  height: 300,
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
                                    obscureText: _obscurePass1,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      hintText: "Password",
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

                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePass1 ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePass1 = !_obscurePass1;
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
                                    controller: _confirmPasswordController,
                                    obscureText: _obscurePass2,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                                      hintText: "Confirm Password",
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

                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePass2 ? Icons.visibility_off : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePass2 = !_obscurePass2;
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
                                    bool success = await _Register();
                                    if (success) {
                                      await Future.delayed(const Duration(milliseconds: 2000));
                                      widget.onGotoHomePage(true);
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
                                        "Confirm",
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
