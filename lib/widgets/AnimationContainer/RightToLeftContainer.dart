import 'package:flutter/material.dart';

class RightToLeftContainer extends StatefulWidget {
  final double width;
  final double height;
  final double distance_traveled;
  final Widget child;
  final Duration duration;
  final Duration delay;

  const RightToLeftContainer({
    super.key,
    this.width = 200,
    this.height = 100,
    this.distance_traveled = 100,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  State<RightToLeftContainer> createState() => _RightToLeftContainerState();
}

class _RightToLeftContainerState extends State<RightToLeftContainer> {
  bool animation = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      setState(() {
        animation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: widget.duration,
            curve: Curves.easeInOut,
            top: 0,
            left: animation ? 0 : widget.distance_traveled,
            child: AnimatedOpacity(
              duration: widget.duration,
              opacity: animation ? 1.0 : 0.0,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
