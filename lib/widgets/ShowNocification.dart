import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';





class ShowNotification {
  static void showAnimatedSnackBar(BuildContext context, String message, int type) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackBar(
        errorMessage: message,
        overlayEntry: overlayEntry,
        type: type,
      ),
    );
    Overlay.of(context)?.insert(overlayEntry);
  }
}

class _AnimatedSnackBar extends StatefulWidget {
  final String errorMessage;
  final OverlayEntry overlayEntry;
  final int type;
  const _AnimatedSnackBar({
    required this.errorMessage,
    required this.overlayEntry,
    required this.type,
  });
  @override
  __AnimatedSnackBarState createState() => __AnimatedSnackBarState();
}

class __AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  List<Color> _colorListBackground = [
    Color.fromRGBO(217, 22, 86, 1),
    Color.fromRGBO(232, 123, 64, 1),
    Color.fromRGBO(74, 98, 138, 1),
    Color.fromRGBO(152, 205, 126, 1),
  ];
  List<Color> _colorListIcon= [
    Color.fromRGBO(167, 0, 20, 1),
    Color.fromRGBO(209, 70, 0, 1),
    Color.fromRGBO(10, 57, 129, 1),
    Color.fromRGBO(52, 121, 40, 1),
  ];
  List<String> _titleErr = [
    "Oh Snap!",
    "Warning!",
    "Hi There!",
    "Well done!",
  ];
  List<String> _iconPath = [
    "assets/backgrounds/NotificationBG/close.svg",
    "assets/backgrounds/NotificationBG/warning.svg",
    "assets/backgrounds/NotificationBG/question.svg",
    "assets/backgrounds/NotificationBG/tick.svg",
  ];





  double _rightPosition = -400;
  double _opacity = 1;

  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _rightPosition = 40;
      });
      Future.delayed(Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          _rightPosition = 10;
        });
      });
    });
    Future.delayed(Duration(milliseconds: 3000), () {
      Future.delayed(Duration(milliseconds: 300), () {
        if (!mounted) return;
        setState(() {
          _rightPosition = 40;
        });
        Future.delayed(Duration(milliseconds: 300), () {
          if (!mounted) return;
          setState(() {
            _opacity = 0.2;
          });
          Future.delayed(Duration(milliseconds: 300), () {
            if (!mounted) return;
            setState(() {
              _rightPosition = -400;
            });
          });
        });
      });
    });

    Future.delayed(Duration(milliseconds: 4000), () {
      if (!mounted) return;
      widget.overlayEntry.remove();
    });
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: MediaQuery.of(context).padding.top + 10,
      right: _rightPosition,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: _opacity,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 230,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: 230,
                        decoration: BoxDecoration(
                          color: _colorListBackground[widget.type],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: 50,
                              width: 55,
                              child:ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(0),
                                ),
                                child: SvgPicture.asset(
                                  "assets/backgrounds/NotificationBG/bubbles.svg",
                                  color: _colorListIcon[widget.type],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              width: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _titleErr[widget.type],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    widget.errorMessage,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: _colorListIcon[widget.type],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
                Container(
                    height: 70,
                    width: 230,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            height: 35,
                            width: 35,
                            child: Stack(
                              children: [
                                SvgPicture.asset(
                                  "assets/backgrounds/NotificationBG/fail.svg",
                                  color: _colorListIcon[widget.type],
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        child: SvgPicture.asset(
                                          _iconPath[widget.type],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
