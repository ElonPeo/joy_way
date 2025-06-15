import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:joy_way/screens/HomeScreen/components/search/SearchScreen.dart';
import '../../../../config/GeneralSpecifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPressSearchSomething = false;
  double searchOpacity = 0;
  bool showSearchSomeThing = false;


  void showSearch() async {
    setState(() {
      showSearchSomeThing = true;
    });
    await Future.delayed(Duration(milliseconds: 50));
    setState(() {
      searchOpacity = 1;
    });
  }


  void hideSearch() async {
    setState(() {
      searchOpacity = 0;
    });

    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      showSearchSomeThing = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Container(
      height: specs.screenHeight,
      width: specs.screenWidth,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: 90),
            children: [],
          ),
          SizedBox(
            height: 90,
            width: specs.screenWidth,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
                Container(
                    height: 90,
                    width: specs.screenWidth,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: specs.bl240,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 130,
                              child: Image.asset(
                                'assets/backgrounds/authenBG/fullLogo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: showSearch,
                                    icon: Icon(Icons.search)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.heart_broken))
                              ],
                            )
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
          if (showSearchSomeThing)
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: searchOpacity,
              child: SearchScreen(
                onFadeOutComplete: hideSearch,
              ),
            ),
        ],
      ),
    );
  }
}
