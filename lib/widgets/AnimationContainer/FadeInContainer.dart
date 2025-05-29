import 'package:flutter/material.dart';

class   FadeInContainer extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Duration duration;
  final Duration delay;

  const FadeInContainer({
    super.key,
    this.width = 200,
    this.height = 100,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  State<FadeInContainer> createState() => _FadeInContainerState();
}

class _FadeInContainerState extends State<FadeInContainer> {
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
      child: Center(
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: widget.duration,
              opacity: animation ? 1.0 : 0.0,
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
