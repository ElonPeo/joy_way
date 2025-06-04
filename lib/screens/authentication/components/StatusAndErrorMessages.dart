import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/widgets/AnimatedIcons/LoadingRiveIcon.dart';
import 'package:joy_way/widgets/AnimationContainer/MoveAndFadeInContainer.dart';
import '../../../../config/GeneralSpecifications.dart';
import '../../../widgets/AnimationContainer/FadeContainer.dart';

class StatusAndErrorMessages extends StatefulWidget {
  final bool scaleLoading;
  final int type;
  final bool goToHomePage;
  final bool isUnsuccessful;
  final bool passwordRecoveryRequestsSuccessful;
  final String messages;
  final Function(bool) onPasswordRecoveryRequest;
  final Function(bool) onScaleLoading;
  final Function(bool) onUnsuccessful;
  final Function(String) onMessages;

  const StatusAndErrorMessages({
    super.key,
    required this.type,
    required this.scaleLoading,
    required this.goToHomePage,
    required this.messages,
    required this.isUnsuccessful,
    required this.passwordRecoveryRequestsSuccessful,
    required this.onPasswordRecoveryRequest,
    required this.onScaleLoading,
    required this.onUnsuccessful,
    required this.onMessages,
  });

  @override
  State<StatusAndErrorMessages> createState() => _StatusAndErrorMessagesState();
}

class _StatusAndErrorMessagesState extends State<StatusAndErrorMessages>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim1;
  late Animation<double> _scaleAnim2;
  late Animation<double> _scaleAnim3;

  bool fadeInAnimation1 = false;
  bool fadeInAnimation2 = false;
  bool fadeInCircle = false;

  // animation for loading
  bool hintLogo = false;
  bool showLoading = false;
  bool showTitleAndSubText = false;
  bool showTitleText = false;
  bool showSubTitleText = false;

  // animation for successful
  bool showSuccessful = false;
  bool showSuccessfulText = false;
  bool showSubSuccessfulText = false;
  bool hideTwoCircle = false;
  bool scaleTheFirstCircle = false;

  // animation for warning
  bool showWarning = false;
  bool showErrolTitle = false;
  bool showErrolSubTitle = false;
  bool showReturnButton = false;


  @override
  void didUpdateWidget(covariant StatusAndErrorMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scaleLoading != oldWidget.scaleLoading) {
      if (widget.scaleLoading) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() {
              showTitleAndSubText = true;
            });
          }
        });
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              hintLogo = true;
            });
          }
        });
        Future.delayed(Duration(milliseconds: 550), () {
          if (mounted) {
            setState(() {
              showTitleText = true;
            });
          }
        });
        Future.delayed(Duration(milliseconds: 550), () {
          if (mounted) {
            setState(() {
              showLoading = true;
            });
          }
        });
        Future.delayed(Duration(milliseconds: 700), () {
          if (mounted) {
            setState(() {
              showSubTitleText = true;
            });
          }
        });
      }
    }
    if (widget.goToHomePage != oldWidget.goToHomePage) {
      if (widget.goToHomePage) {
        showSubTitleText = false;
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            showTitleText = false;
          });
        });
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            showSuccessful = true;
          });
        });
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            fadeInAnimation1 = false;
          });
        });
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            fadeInAnimation1 = false;
          });
        });
        Future.delayed(Duration(milliseconds: 2100), () {
          setState(() {
            hideTwoCircle = true;
          });
        });
        Future.delayed(Duration(milliseconds: 2200), () {
          setState(() {
            scaleTheFirstCircle = true;
          });
        });
        Future.delayed(Duration(milliseconds: 3500), () {
          setState(() {
            Navigator.pushReplacementNamed(context, '/home');
          });
        });
      }
    }
    if (widget.passwordRecoveryRequestsSuccessful != oldWidget.passwordRecoveryRequestsSuccessful) {
      if (widget.passwordRecoveryRequestsSuccessful) {
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            showSuccessful = true;
          });
        });
      }
    }
    if (widget.isUnsuccessful != oldWidget.isUnsuccessful) {
      if (widget.isUnsuccessful) {
        showSubTitleText = false;
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            showTitleText = false;
          });
        });
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            showWarning = true;
          });
        });
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            showReturnButton= true;
          });
        });
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            showErrolTitle= true;
          });
        });
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            showErrolSubTitle= true;
          });
        });
      }
    }
  }

  double LocationOfStatusAndErrol(
      double screenHeight, bool scaleLoading, int type) {
    if (scaleLoading) {
      return screenHeight * 0.2;
    } else {
      switch (type) {
        case 0:
          return 0;
        case 1:
          return screenHeight * 0.1;
        case 2:
          return screenHeight * 0.15;
        default:
          return 0;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        fadeInCircle = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        fadeInAnimation1 = true;
      });
    });
    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        fadeInAnimation2 = true;
      });
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    )..repeat(reverse: true);

    _scaleAnim1 = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnim2 = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.ease),
    );
    _scaleAnim3 = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 500),
          top: LocationOfStatusAndErrol(
              specs.screenHeight, widget.scaleLoading, widget.type),
          left: (specs.screenWidth - 300) / 2,
          child: Container(
              height: 300,
              width: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                      duration: Duration(milliseconds: 1000),
                      opacity: fadeInCircle ? 1 : 0,
                      child: AnimatedScale(
                        curve: Curves.easeInOutBack,
                        duration: Duration(milliseconds: 1000),
                        scale: fadeInCircle ? 1 : 1.6,
                        child: Container(
                          height: 230,
                          width: 230,
                          child: Stack(
                            children: [
                              Center(
                                child: FadeContainer(
                                  fatherHeight: 200,
                                  fatherWidth: 200,
                                  animation: !hideTwoCircle,
                                  duration: Duration(milliseconds: 300),
                                  child: AnimatedBuilder(
                                    animation: _scaleAnim1,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _scaleAnim1.value,
                                        child: child,
                                      );
                                    },
                                    child: Container(
                                      height: 220,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(164, 237, 205, 0.5),
                                            Color.fromRGBO(255, 255, 255, 0.05),
                                            // Color.fromRGBO(64, 165, 120, 0.05),
                                            // Color.fromRGBO(159, 179, 223, 0.2),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: FadeContainer(
                                  fatherHeight: 160,
                                  fatherWidth: 160,
                                  animation: !hideTwoCircle,
                                  duration: Duration(milliseconds: 300),
                                  child: AnimatedBuilder(
                                    animation: _scaleAnim2,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _scaleAnim2.value,
                                        child: child,
                                      );
                                    },
                                    child: Container(
                                      height: 170,
                                      width: 170,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(85, 216, 157, 0.5),
                                            Color.fromRGBO(255, 255, 255, 0.2),
                                            // Color.fromRGBO(159, 179, 223, 0.5),
                                            // Color.fromRGBO(159, 179, 223, 0.1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: AnimatedScale(
                                  scale: scaleTheFirstCircle ? 10 : 1,
                                  curve: Curves.easeOutCirc,
                                  duration: Duration(milliseconds: 1500),
                                  child: AnimatedBuilder(
                                    animation: _scaleAnim3,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _scaleAnim3.value,
                                        child: child,
                                      );
                                    },
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(56, 149, 195, 1),
                                            Color.fromRGBO(250, 250, 250, 0.8),
                                            Color.fromRGBO(92, 39, 161, 1),
                                            // Color.fromRGBO(121, 101, 193, 1),
                                            // Color.fromRGBO(159, 179, 223, 0.8),
                                            // Color.fromRGBO(0, 252, 255, 0.8),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  MoveAndFadeInContainer(
                      fatherHeight: 200,
                      fatherWidth: 100,
                      heightOfChild: 200,
                      widthOfChild: 100,
                      type: 0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutExpo,
                      animation: fadeInAnimation1,
                      child: Container(
                        height: 200,
                        width: 100,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(5, 7),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 1),
                              Color.fromRGBO(255, 255, 255, 0.6),
                              Color.fromRGBO(255, 255, 255, 0.6),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: Colors.white.withOpacity(1)),
                        ),
                        child: hintLogo
                            ? Center(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: Container(
                                          height: 200,
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: FadeContainer(
                                        fatherHeight: 50,
                                        fatherWidth: 50,
                                        animation: showLoading,
                                        duration: Duration(milliseconds: 500),
                                        child: LoadingRiveIcon(
                                          fatherHeight: 50,
                                          fatherWidth: 50,
                                          activeFail: showWarning,
                                          activeLoading: showTitleText,
                                          activeSuccessful: showSuccessful,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ),
                    ),
                  MoveAndFadeInContainer(
                      fatherHeight: 150,
                      fatherWidth: 200,
                      heightOfChild: 100,
                      widthOfChild: 200,
                      duration: Duration(milliseconds: 300),
                      type: 0,
                      animation: !hintLogo,
                      child: MoveAndFadeInContainer(
                        fatherHeight: 100,
                        fatherWidth: 200,
                        heightOfChild: 40,
                        widthOfChild: 150,
                        curve: Curves.easeOutCirc,
                        duration: Duration(milliseconds: 500),
                        animation: fadeInAnimation2,
                        type: 1,
                        child: Container(
                          height: 40,
                          width: 150,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(1)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/backgrounds/authenBG/logo.png',
                                    ),
                                    Container(
                                      height: 5,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      height: 5,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              )),
        ),
        Positioned(
            top: specs.screenHeight * 0.55,
            left: 0,
            child: FadeContainer(
                fatherHeight: specs.screenHeight * 0.4,
                fatherWidth: specs.screenWidth,
                animation: hintLogo,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MoveAndFadeInContainer(
                            fatherHeight: specs.screenHeight * 0.1,
                            fatherWidth: specs.screenWidth,
                            heightOfChild: 35,
                            widthOfChild: specs.screenWidth,
                            type: 2,
                            customizeTravelDistance: true,
                            start: 45,
                            end: (specs.screenHeight * 0.1 - 35) / 2,
                            animation: showTitleText,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                                height: 35,
                                width: specs.screenWidth,
                                child: Center(
                                  child: Text(
                                    "Loading",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                    ),
                                  ),
                                ))),
                        MoveAndFadeInContainer(
                            fatherHeight: specs.screenHeight * 0.3,
                            fatherWidth: specs.screenWidth,
                            heightOfChild: 100,
                            widthOfChild: specs.screenWidth - 40,
                            animation: showSubTitleText,
                            curve: Curves.easeOutCirc,
                            customizeTravelDistance: true,
                            start: 50,
                            end: 0,
                            type: 2,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                                height: specs.screenHeight * 0.3,
                                width: specs.screenWidth - 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "We are processing your request, please wait.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: specs.bl80,
                                      ),
                                    ),
                                  ],
                                ))),
                      ],
                    ),
                    Column(
                      mainAxisAlignment:MainAxisAlignment.start,
                      children: [
                        MoveAndFadeInContainer(
                            fatherHeight: specs.screenHeight * 0.07,
                            fatherWidth: specs.screenWidth,
                            heightOfChild: 30,
                            widthOfChild: specs.screenWidth,
                            type: 0,
                            customizeTravelDistance: true,
                            start: 0,
                            end: (specs.screenHeight * 0.1 - 40)/2,
                            animation: showErrolTitle,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                                height: 35,
                                width: specs.screenWidth,
                                child: Center(
                                  child: Text(
                                    widget.passwordRecoveryRequestsSuccessful ? "Successful" :"Warning",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 26,
                                    ),
                                  ),
                                ))),
                        MoveAndFadeInContainer(
                            fatherHeight: specs.screenHeight * 0.33,
                            fatherWidth: specs.screenWidth,
                            heightOfChild: 100,
                            widthOfChild: specs.screenWidth - 40,
                            animation: showErrolSubTitle,
                            curve: Curves.easeOutCirc,
                            customizeTravelDistance: true,
                            start: 0,
                            end: specs.screenHeight * 0.03,
                            type: 0,
                            duration: Duration(milliseconds: 500),
                            child: Container(
                                height: specs.screenHeight * 0.3,
                                width: specs.screenWidth - 40,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.messages,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: specs.bl80,
                                      ),
                                    ),
                                  ],
                                )
                            )),
                      ],
                    )
                  ],
                ))),
        Positioned(
          top: specs.screenHeight * 0.8,
          left: 0,
            child: GestureDetector(
              onTap: (){
                setState(() {
                  widget.onScaleLoading(false);
                  widget.onUnsuccessful(false);
                  widget.onPasswordRecoveryRequest(false);
                  widget.onMessages("");
                  // animation for loading
                  hintLogo = false;
                  showLoading = false;
                  showTitleAndSubText = false;
                  showTitleText = false;
                  showSubTitleText = false;

                  // animation for successful
                  showSuccessful = false;
                  showSuccessfulText = false;
                  showSubSuccessfulText = false;
                  hideTwoCircle = false;
                  scaleTheFirstCircle = false;

                  // animation for warning
                  showWarning = false;
                  showErrolTitle = false;
                  showErrolSubTitle = false;
                  showReturnButton = false;

                });

              },
              child: MoveAndFadeInContainer(
                fatherHeight: 150,
                fatherWidth: specs.screenWidth,
                heightOfChild: 100,
                widthOfChild: specs.screenWidth - 40,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutCirc,
                customizeTravelDistance: true,
                start: 40,
                end: 20,
                type: 1,
                animation: showReturnButton,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Return",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_double_arrow_up_rounded,
                          color: Colors.white,
                          size: 32.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ),
      ],
    );
  }
}
