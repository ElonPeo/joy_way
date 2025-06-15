import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_way/widgets/AnimationContainer/MoveAndFadeInContainer.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../../config/GeneralSpecifications.dart';
import '../AnimatedIcons/LoadingRiveIcon.dart';

class LoadingAndStatus extends StatefulWidget {
  final bool animation;
  final ValueNotifier<bool?> statusNotifier;
  final ValueNotifier<String?> message;
  final Function(bool) IsCompleteLoadingAndStatus;
  final Function(bool) onAnimation;
  const LoadingAndStatus({
    super.key,
    required this.animation,
    required this.statusNotifier,
    required this.message,
    required this.IsCompleteLoadingAndStatus,
    required this.onAnimation,
  });

  @override
  State<LoadingAndStatus> createState() => _LoadingAndStatusState();
}

class _LoadingAndStatusState extends State<LoadingAndStatus> {
  bool showStatusTitle = false;
  bool showStatusSubTitle = false;
  bool showLoadingTitle = false;
  bool showLoadingSubTitle = false;
  bool activeFail = false;
  bool activeSuccessful = false;
  bool activeLoading = false;

  @override
  void initState() {
    super.initState();
    widget.statusNotifier.addListener(() {
      final status = widget.statusNotifier.value;
      if (status == true) {
        setState(() {
          activeLoading = false;
          activeSuccessful = true;
          showLoadingSubTitle = false;
          showLoadingTitle = false;
        });
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) setState(() => showStatusSubTitle = true);
        });
        Future.delayed(Duration(milliseconds: 400), () {
          if (mounted) setState(() => showStatusTitle = true);
        });
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            widget.IsCompleteLoadingAndStatus(true);
            Navigator.of(context).maybePop();
          }
        });
      }

      if (status == null) {
        setState(() {
          activeLoading = false;
          activeFail = true;
          showLoadingSubTitle = false;
          showLoadingTitle = false;
        });
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) setState(() => showStatusSubTitle = true);
        });
        Future.delayed(Duration(milliseconds: 400), () {
          if (mounted) setState(() => showStatusTitle = true);
        });
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            widget.IsCompleteLoadingAndStatus(true);
            Navigator.of(context).maybePop();
          }
        });
      }
    });
    activeLoading = true;
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        showLoadingTitle = true;
      });
    });
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        showLoadingSubTitle = true;
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return GestureDetector(
      onTap: (){
        setState(() {
          widget.onAnimation(false);
        });
      },
      child: Container(
            height: specs.screenHeight,
            width: specs.screenWidth,
            color: Colors.transparent,
            child: Center(
              child: AnimatedScale(
                  duration: Duration(milliseconds: 300),
                  scale: widget.animation ? 1 : 1.5,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: widget.animation ? 1 : 0,
                    child: Container(
                      height: 180,
                      width: 180,
                      child: Stack(
                        children: [
                          LiquidGlassLayer(
                            settings: const LiquidGlassSettings(
                              thickness: 15,
                              glassColor: Color.fromRGBO(255, 255, 255, 0.1), // A subtle white tint
                              lightIntensity: 1.5,
                              blend: 50,
                              lightAngle: 1,
                            ),
                            child: Center(
                              child: LiquidGlass.inLayer(
                                shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(24)),
                                child: Container(
                                  width: 180,
                                  height:180,
                                  color: Color.fromRGBO(100, 100, 100, 0.1),
                                ),
                              ),
                            ),
                          ),
                            Stack(
                              children: [
                                Positioned(
                                  top: 40,
                                  left: 65,
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        child: LoadingRiveIcon(
                                          fatherHeight: 60,
                                          fatherWidth: 60,
                                          activeFail: activeFail,
                                          activeSuccessful: activeSuccessful,
                                          activeLoading: activeLoading,
                                        )
                                    ),
                                ),
                                MoveAndFadeInContainer(
                                  fatherHeight: 180,
                                  fatherWidth: 180,
                                  heightOfChild: 25,
                                  widthOfChild: 160,
                                  customizeTravelDistance: true,
                                  start: 100,
                                  end: 115,
                                  type: 2,
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                  animation: showStatusSubTitle,
                                  child: Container(
                                    height: 60,
                                    width: 160,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ValueListenableBuilder<String?>(
                                          valueListenable: widget.message,
                                          builder: (context, value, _) => Text(
                                            value ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                MoveAndFadeInContainer(
                                  fatherHeight: 180,
                                  fatherWidth: 180,
                                  heightOfChild: 25,
                                  widthOfChild: 160,
                                  customizeTravelDistance: true,
                                  start: 85,
                                  end: 95,
                                  type: 2,
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                  animation: showStatusTitle,
                                  child: Container(
                                    height: 25,
                                    width: 160,
                                    child: Center(
                                      child: ValueListenableBuilder<bool?>(
                                        valueListenable: widget.statusNotifier,
                                        builder: (context, status, _) => Text(
                                          status == true ? "Successful" : "Warning",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                MoveAndFadeInContainer(
                                  fatherHeight: 180,
                                  fatherWidth: 180,
                                  heightOfChild: 25,
                                  widthOfChild: 160,
                                  customizeTravelDistance: true,
                                  start: 130,
                                  end: 115,
                                  type: 0,
                                  duration: Duration(
                                    milliseconds: 500,
                                  ),
                                  animation: showLoadingSubTitle,
                                  child: Container(
                                    height: 60,
                                    width: 160,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.center,
                                          "We are processing your request.",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                  MoveAndFadeInContainer(
                                      fatherHeight: 180,
                                      fatherWidth: 180,
                                      heightOfChild: 25,
                                      widthOfChild: 160,
                                      customizeTravelDistance: true,
                                      start: 100,
                                      end: 90,
                                      type: 0,
                                      duration: Duration(
                                        milliseconds: 500,
                                      ),
                                      animation: showLoadingTitle,
                                      child: Container(
                                        height: 25,
                                        width: 160,
                                        child: Center(
                                          child: Text(
                                            "Loading",
                                            style: TextStyle(
                                                color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),

                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ),
          ),
    );
  }
}


// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:joy_way/widgets/AnimationContainer/MoveAndFadeInContainer.dart';
//
// import '../../config/GeneralSpecifications.dart';
// import '../AnimatedIcons/LoadingRiveIcon.dart';
//
// class LoadingAndStatus extends StatefulWidget {
//   final bool animation;
//   final ValueNotifier<bool?> statusNotifier;
//   final ValueNotifier<String?> message;
//   final Function(bool) IsCompleteLoadingAndStatus;
//   final Function(bool) onAnimation;
//   const LoadingAndStatus({
//     super.key,
//     required this.animation,
//     required this.statusNotifier,
//     required this.message,
//     required this.IsCompleteLoadingAndStatus,
//     required this.onAnimation,
//   });
//
//   @override
//   State<LoadingAndStatus> createState() => _LoadingAndStatusState();
// }
//
// class _LoadingAndStatusState extends State<LoadingAndStatus> {
//   bool showStatusTitle = false;
//   bool showStatusSubTitle = false;
//   bool showLoadingTitle = false;
//   bool showLoadingSubTitle = false;
//   bool zoomOut = false;
//   bool activeFail = false;
//   bool activeSuccessful = false;
//   bool activeLoading = false;
//
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     widget.statusNotifier.addListener(() {
//       final status = widget.statusNotifier.value;
//       if (status == true) {
//         setState(() {
//           activeLoading = false;
//           activeSuccessful = true;
//           showLoadingSubTitle = false;
//           showLoadingTitle = false;
//         });
//         Future.delayed(Duration(milliseconds: 300), () {
//           if (mounted) setState(() => showStatusSubTitle = true);
//         });
//         Future.delayed(Duration(milliseconds: 400), () {
//           if (mounted) setState(() => showStatusTitle = true);
//         });
//         Future.delayed(Duration(milliseconds: 1500), () {
//           if (mounted) {
//             widget.IsCompleteLoadingAndStatus(true);
//             Navigator.of(context).maybePop();
//           }
//         });
//       }
//
//       if (status == null) {
//         setState(() {
//           activeLoading = false;
//           activeFail = true;
//           showLoadingSubTitle = false;
//           showLoadingTitle = false;
//         });
//         Future.delayed(Duration(milliseconds: 300), () {
//           if (mounted) setState(() => showStatusSubTitle = true);
//         });
//         Future.delayed(Duration(milliseconds: 400), () {
//           if (mounted) setState(() => showStatusTitle = true);
//         });
//         Future.delayed(Duration(milliseconds: 1500), () {
//           if (mounted) {
//             widget.IsCompleteLoadingAndStatus(true);
//             Navigator.of(context).maybePop();
//           }
//         });
//       }
//     });
//
//     activeLoading = true;
//     Future.delayed(Duration(milliseconds: 300), () {
//       setState(() {
//         zoomOut = true;
//       });
//     });
//     Future.delayed(Duration(milliseconds: 700), () {
//       setState(() {
//         showLoadingTitle = true;
//       });
//     });
//     Future.delayed(Duration(milliseconds: 800), () {
//       setState(() {
//         showLoadingSubTitle = true;
//       });
//     });
//   }
//   @override
//   void dispose() {
//     super.dispose();
//   }
//   late DateTime selectedDate;
//   @override
//   Widget build(BuildContext context) {
//     final specs = GeneralSpecifications(context);
//     return Material(
//       color: Colors.black,
//       child: GestureDetector(
//         onTap: (){
//           setState(() {
//             widget.onAnimation(false);
//           });
//         },
//         child: Container(
//           height: specs.screenHeight,
//           width: specs.screenWidth,
//           color: Colors.transparent,
//           child: Center(
//             child: AnimatedScale(
//                 duration: Duration(milliseconds: 300),
//                 scale: zoomOut ? 1 : 1.5,
//                 child: AnimatedOpacity(
//                   duration: Duration(milliseconds: 300),
//                   opacity: zoomOut ? 1 : 0,
//                   child: Container(
//                     height: 180,
//                     width: 180,
//                     decoration: BoxDecoration(
//                       color: Color.fromRGBO(220, 220, 220, 0.5),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Stack(
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(30),
//                           child: BackdropFilter(
//                             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//                             child: Container(
//                               height: 180,
//                               width: 180,
//                             ),
//                           ),
//                         ),
//                           Stack(
//                             children: [
//                               Positioned(
//                                 top: 40,
//                                 left: 65,
//                                   child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       child: LoadingRiveIcon(
//                                         fatherHeight: 60,
//                                         fatherWidth: 60,
//                                         activeFail: activeFail,
//                                         activeSuccessful: activeSuccessful,
//                                         activeLoading: activeLoading,
//                                       )
//                                   ),
//                               ),
//                               MoveAndFadeInContainer(
//                                 fatherHeight: 180,
//                                 fatherWidth: 180,
//                                 heightOfChild: 25,
//                                 widthOfChild: 160,
//                                 customizeTravelDistance: true,
//                                 start: 100,
//                                 end: 115,
//                                 type: 2,
//                                 duration: Duration(
//                                   milliseconds: 500,
//                                 ),
//                                 animation: showStatusSubTitle,
//                                 child: Container(
//                                   height: 60,
//                                   width: 160,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       ValueListenableBuilder<String?>(
//                                         valueListenable: widget.message,
//                                         builder: (context, value, _) => Text(
//                                           value ?? "",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               MoveAndFadeInContainer(
//                                 fatherHeight: 180,
//                                 fatherWidth: 180,
//                                 heightOfChild: 25,
//                                 widthOfChild: 160,
//                                 customizeTravelDistance: true,
//                                 start: 85,
//                                 end: 95,
//                                 type: 2,
//                                 duration: Duration(
//                                   milliseconds: 500,
//                                 ),
//                                 animation: showStatusTitle,
//                                 child: Container(
//                                   height: 25,
//                                   width: 160,
//                                   child: Center(
//                                     child: ValueListenableBuilder<bool?>(
//                                       valueListenable: widget.statusNotifier,
//                                       builder: (context, status, _) => Text(
//                                         status == true ? "Successful" : "Warning",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     )
//                                   ),
//                                 ),
//                               ),
//                               MoveAndFadeInContainer(
//                                 fatherHeight: 180,
//                                 fatherWidth: 180,
//                                 heightOfChild: 25,
//                                 widthOfChild: 160,
//                                 customizeTravelDistance: true,
//                                 start: 130,
//                                 end: 115,
//                                 type: 0,
//                                 duration: Duration(
//                                   milliseconds: 500,
//                                 ),
//                                 animation: showLoadingSubTitle,
//                                 child: Container(
//                                   height: 60,
//                                   width: 160,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         textAlign: TextAlign.center,
//                                         "We are processing your request.",
//                                         style: TextStyle(
//                                           color: Colors.black,
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                                 MoveAndFadeInContainer(
//                                     fatherHeight: 180,
//                                     fatherWidth: 180,
//                                     heightOfChild: 25,
//                                     widthOfChild: 160,
//                                     customizeTravelDistance: true,
//                                     start: 100,
//                                     end: 90,
//                                     type: 0,
//                                     duration: Duration(
//                                       milliseconds: 500,
//                                     ),
//                                     animation: showLoadingTitle,
//                                     child: Container(
//                                       height: 25,
//                                       width: 160,
//                                       child: Center(
//                                         child: Text(
//                                           "Loading",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 ),
//
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ),
//         ),
//       ),
//     );
//   }
// }
