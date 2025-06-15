import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:rive/rive.dart' hide Image;
import '../../config/GeneralSpecifications.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int page;
  final bool blurBottomBar;
  final Function(int) OnPage;

  const CustomBottomNavigationBar({
    super.key,
    required this.page,
    required this.OnPage,
    this.blurBottomBar = false,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> with TickerProviderStateMixin {
  bool showBottomBar = false;
  late AnimationController _homeSlideController;
  late AnimationController _searchSlideController;
  late AnimationController _messageSlideController;
  late AnimationController _profileSlideController;

  late Animation<Offset> _homeSlideAnimation;
  late Animation<Offset> _searchSlideAnimation;
  late Animation<Offset> _messageSlideAnimation;
  late Animation<Offset> _profileSlideAnimation;
  @override
  void didUpdateWidget(covariant CustomBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) {
      _startAnimation(widget.page);
      setState(() {
        positionedAndWidth = positioned(GeneralSpecifications(context).screenWidth, widget.page);
      });
    }
  }
  void _startAnimation(int page) {
    _homeSlideController.reset();
    _searchSlideController.reset();
    _messageSlideController.reset();
    _profileSlideController.reset();

    switch (page) {
      case 0:
        _homeSlideController.reverse();
        break;
      case 1:
        _searchSlideController.reverse();
        break;
      case 2:
        _messageSlideController.reverse();
        break;
      case 3:
        _profileSlideController.reverse();
        break;
    }
  }


  List<double> positioned(double screenWidth,int type){
    switch (type) {
      case 0:
        return [25,100];
      case 1:
        return [screenWidth * 0.27,110];
      case 2:
        return [screenWidth * 0.43,130];
      case 3:
        return [screenWidth - 135,110];
      default:
        return [25,100];
    }
  }
  List<double> positionedAndWidth = [5,100];
  @override
  void initState() {
    super.initState();
    _homeSlideController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _searchSlideController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _messageSlideController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _profileSlideController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _homeSlideAnimation = Tween<Offset>(begin: Offset(0.6, 0), end: Offset(2, 0)).animate(CurvedAnimation(parent: _homeSlideController, curve: Curves.easeOut));
    _searchSlideAnimation = Tween<Offset>(begin: Offset(0.8, 0), end: Offset(1.2, 0)).animate(CurvedAnimation(parent: _searchSlideController, curve: Curves.easeOut));
    _messageSlideAnimation = Tween<Offset>(begin: Offset(0.5, 0), end: Offset(0.1, 0)).animate(CurvedAnimation(parent: _messageSlideController, curve: Curves.easeOut));
    _profileSlideAnimation = Tween<Offset>(begin: Offset(0.9, 0), end: Offset(1.2, 0)).animate(CurvedAnimation(parent: _profileSlideController, curve: Curves.easeOut));

    setState(() {
      Future.delayed(Duration(milliseconds: 200), () {
        setState(() {
          showBottomBar = true;
        });
      });
    });
  }




  @override
  void dispose() {
    _homeSlideController.dispose();
    _searchSlideController.dispose();
    _messageSlideController.dispose();
    _profileSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Container(
      height: 100,
      width: specs.screenWidth,
        child: Stack(
          children: [
            // LiquidGlassLayer(
            //   settings: const LiquidGlassSettings(
            //     thickness: 15,
            //     glassColor: Color.fromRGBO(126, 126, 126, 0.5), // A subtle white tint
            //     lightIntensity: 1.5,
            //     blend: 100,
            //   ),
            //   child: Center(
            //     child: LiquidGlass.inLayer(
            //       shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(24)),
            //       child: Container(
            //         width: specs.screenWidth,
            //         height:120,
            //         color: Colors.transparent,
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(30),
            //           child: BackdropFilter(
            //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            //             child: Container(
            //               height: 120,
            //               width: specs.screenWidth,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

      TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: positionedAndWidth[0],
                end: positioned(GeneralSpecifications(context).screenWidth, widget.page)[0],
              ),
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOutBack,
              builder: (context, left, child) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: positionedAndWidth[1],
                    end: positioned(GeneralSpecifications(context).screenWidth, widget.page)[1],
                  ),
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOutBack,
                  builder: (context, width, child) {
                    return Positioned(
                      top: 5,
                      left: left,
                      child: LiquidGlassLayer(
                        settings: const LiquidGlassSettings(
                          thickness: 10,
                          glassColor: Color.fromRGBO(126, 126, 126,0.5),
                          lightIntensity: 1.5,
                          blend: 100,
                          lightAngle: 1,
                        ),
                        child: Center(
                          child: LiquidGlass.inLayer(
                            shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(24)),
                            child: Container(
                              width: width,
                              height:50,
                              color: Color.fromRGBO(200, 200, 200, 0.1),
                            ),
                          ),
                        ),
                      ),
                    //   child: Container(
                    //   height: 60,
                    //   width: specs.screenWidth - 40,
                    //
                    //   child: Stack(
                    //     children: [
                    //       ShaderMask(
                    //         shaderCallback: (Rect bounds) {
                    //           return const LinearGradient(
                    //             colors: [
                    //               Color.fromRGBO(255, 255, 255, 1),
                    //               Color.fromRGBO(62, 157, 110, 1),
                    //             ],
                    //             begin: Alignment.topLeft,
                    //             end: Alignment.bottomRight,
                    //           ).createShader(bounds);
                    //         },
                    //         blendMode: BlendMode.srcATop,
                    //         child: Container(
                    //           height: 50,
                    //           width: width,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(30.0),
                    //             border: Border.all(
                    //               color: Colors.white,
                    //               width: 1,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    );
                  },
                );
              },
            ),
            Container(
              height: 60,
              width: specs.screenWidth,
              padding:EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    margin: EdgeInsets.only(left: widget.page == 0 ? 20 : 15),
                    curve: Curves.elasticOut,
                    width: widget.page == 0 ? 87 : 50,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SlideTransition(
                          position: _homeSlideAnimation,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: widget.page == 0 ? 1.0 : 0.0,
                            child: Text(
                              'Home',
                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.OnPage(0);
                          },
                          child: Container(
                            height: 20,
                            width: 20,
                            child: Image.asset(
                              'assets/icons/home.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.elasticOut,
                    width: widget.page == 1 ? 87 : 50,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SlideTransition(
                          position: _searchSlideAnimation,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: widget.page == 1 ? 1.0 : 0.0,
                            child: Text(
                              'Search',
                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.OnPage(1);
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(Icons.search),
                          ),
                        )
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.elasticOut,
                    width: widget.page == 2 ? 100 : 50,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SlideTransition(
                          position: _messageSlideAnimation,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 100),
                            opacity: widget.page == 2 ? 1.0 : 0.0,
                            child: Text(
                              'Message',
                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.OnPage(2);

                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              'assets/icons/chat.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.elasticOut,
                    width: widget.page == 3 ? 100 : 50,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        SlideTransition(
                          position: _profileSlideAnimation,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: widget.page == 3 ? 1.0 : 0.0,
                            child: Text(
                              'Profile',
                              style: GoogleFonts.montserrat(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.OnPage(3);
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            child: Image.asset(
                              'assets/icons/profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}
