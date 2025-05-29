import 'package:flutter/material.dart';

class ScaleContainer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Widget child;
  final Duration duration;
  final Color firstColor;
  final Color secondColor;

  const ScaleContainer({
    super.key,
    this.width = 100,
    this.height = 100,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    this.firstColor = const Color.fromRGBO(252, 239, 203, 1),
    this.secondColor = const Color.fromRGBO(254, 93, 38, 1),
  });


  @override
  State<ScaleContainer> createState() => _ScaleContainerState();
}

class _ScaleContainerState extends State<ScaleContainer> {
  bool animation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        child: AnimatedOpacity(
          duration: widget.duration,
          opacity: animation ? 1.0 : 0.0,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeOutCirc,
            width: animation ? widget.width : widget.width * 0.2,
            height: animation ? widget.height : widget.height * 0.2,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: animation ? widget.secondColor : widget.firstColor,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}


