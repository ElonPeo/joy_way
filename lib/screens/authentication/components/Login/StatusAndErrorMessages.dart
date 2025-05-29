import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../config/GeneralSpecifications.dart';

class StatusAndErrorMessages extends StatefulWidget {
  final bool scaleContainer;
  final Function(bool) onScaleChanged;

  const StatusAndErrorMessages({
    super.key,
    required this.scaleContainer,
    required this.onScaleChanged,
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

  @override
  void didUpdateWidget(covariant StatusAndErrorMessages oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scaleContainer == true && oldWidget.scaleContainer == false) {
      Future.delayed(Duration(milliseconds: 2000), () {
        if (mounted) {
          widget.onScaleChanged(false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _scaleAnim1 = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scaleAnim2 = Tween<double>(begin: 0.9, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceInOut),
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
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 200,
      ),
      height: widget.scaleContainer ? (specs.screenHeight - 20) : specs.screenHeight * 0.4,
      width: specs.screenWidth,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color.fromRGBO(239, 249, 255, 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: AnimatedScale(
          scale: widget.scaleContainer ? 1.2 : 0.8,
          duration: Duration(milliseconds: 200),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(159, 179, 223, 0.05),
                        Color.fromRGBO(159, 179, 223, 0.2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),


              AnimatedBuilder(
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(159, 179, 223, 0.5),
                        Color.fromRGBO(159, 179, 223, 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),


              AnimatedBuilder(
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(121, 101, 193, 1),
                        Color.fromRGBO(159, 179, 223, 0.8),
                        Color.fromRGBO(0, 252, 255, 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: 200,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white.withOpacity(1)),
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white.withOpacity(1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            ],
          ),
        ),
      ),
    );
  }
}
