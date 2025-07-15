import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/GeneralSpecifications.dart';


class JourneyStatus extends StatefulWidget {
  final String status;
  const JourneyStatus({super.key,required this.status});
  @override
  State<JourneyStatus> createState() => _JourneyStatusState();
}

class _JourneyStatusState extends State<JourneyStatus> {
  List<String> iconsAssets =  [
    "assets/icons/status/questioning.png",
    "assets/icons/status/check.png",
    "assets/icons/status/user.png",
    "assets/icons/status/selection.png",
    "assets/icons/status/location.png",
    "assets/icons/status/success.png",
  ];
  List<String> steps =  [
    "Looking for passengers",
    "Prepare to depart",
    "Picking up guests",
    "Picked all guests",
    "Heading to destination",
    "Arrived",
  ];

  int convertStatus(String status) {
    switch (status) {
      case "Looking for passengers":
        return 0;
      case "Prepare to depart":
        return 1;
      case "Picking up guests":
        return 2;
      case "Picked all guests":
        return 3;
      case "Heading to destination":
        return 4;
      case "Arrived":
        return 5;
      default:
        return 0;
    }
  }



  StatusLoadingState getStatusState(int index) {
    if (convertStatus(widget.status) > index) {
      return StatusLoadingState.success;
    } else if (convertStatus(widget.status) == index) {
      return StatusLoadingState.loading;
    } else {
      return StatusLoadingState.idle;
    }
  }



  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Container(
        height: 80,
        width: specs.screenWidth - 20,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: List.generate(6, (index) => Row(
            children: [
              StatusLoading(state: getStatusState(index)),
              Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      iconsAssets[index],
                      width: 30,
                      height: 30,
                      color: convertStatus(widget.status) <= index ? specs.bl100 : specs.pantoneColor,
                      fit: BoxFit.contain,
                    ),
                    Text(
                        steps[index],
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: convertStatus(widget.status) <= index ? specs.bl100 : specs.pantoneColor,
                      ),
                    ),
                  ],
                 ),
              ),
            ],
          ),
          ),
        )
    );
  }
}


enum StatusLoadingState {
  loading,
  success,
  idle,
}


class StatusLoading extends StatefulWidget {
  final StatusLoadingState state;
  StatusLoading({super.key, required this.state});

  @override
  State<StatusLoading> createState() => _StatusLoadingState();
}


class _StatusLoadingState extends State<StatusLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.4;
      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    if (widget.state == StatusLoadingState.loading) {
      _controller.addListener(() {
        if (mounted) setState(() {});
      });
      _controller.repeat();
    }

  }

  @override
  @override
  void didUpdateWidget(covariant StatusLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      if (widget.state == StatusLoadingState.loading) {
        _controller.reset();
        _controller.repeat();
        _controller.addListener(() {
          if (mounted) setState(() {});
        });
      } else {
        _controller.stop();
      }
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index) {
    double opacity;
    Color color;

    switch (widget.state) {
      case StatusLoadingState.loading:
        opacity = _animations[index].value;
        color = const Color.fromRGBO(62, 157, 110, 1);
        break;
      case StatusLoadingState.success:
        opacity = 1.0;
        color = const Color.fromRGBO(62, 157, 110, 1);
        break;
      case StatusLoadingState.idle:
      default:
        opacity = 1.0;
        color = const Color.fromRGBO(100, 100, 100, 1);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, _buildDot),
    );
  }
}





