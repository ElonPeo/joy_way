import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_way/widgets/ShowGeneralDialog.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class AddNewPostButton extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const AddNewPostButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<AddNewPostButton> createState() => _AddNewPostButtonState();
}

class _AddNewPostButtonState extends State<AddNewPostButton> with SingleTickerProviderStateMixin {
  late double top;
  late double left;
  late AnimationController _controller;
  late Animation<double> _animation;
  void _onDragEnd(DragEndDetails details) {
    final middle = widget.screenWidth / 2;
    final targetLeft = left < middle ? 15.0 : widget.screenWidth - 75;

    _animation = Tween<double>(begin: left, end: targetLeft).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ))
      ..addListener(() {
        setState(() {
          left = _animation.value;
        });
      });

    _controller.forward(from: 0);
  }
  @override
  void initState() {
    super.initState();
    top = widget.screenHeight - 150;
    left = widget.screenWidth - 15 - 55;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            left += details.delta.dx;
            top += details.delta.dy;
            left = left.clamp(0, widget.screenWidth - 60);
            top = top.clamp(0, widget.screenHeight - 60);
          });
        },
        onTap: (){
          ShowGeneralDialog.Post_Edit_Dialog(
              context: context
          );
        },
        onPanEnd: _onDragEnd,
        child: Container(
          height: 55,
          width: 55,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(230, 230, 230, 0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              LiquidGlassLayer(
                settings: const LiquidGlassSettings(
                  thickness: 10,
                  glassColor: Color.fromRGBO(126, 126, 126, 0.5),
                  lightIntensity: 1.5,
                  blend: 100,
                  lightAngle: 1,
                ),
                child: Center(
                  child: LiquidGlass.inLayer(
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: Radius.circular(50),
                    ),
                    child: Container(
                      width: 55,
                      height: 55,
                    ),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


