import 'package:flutter/material.dart';


class ShowGeneralDialog {
  static void General_Dialog({
    required BuildContext context,
    required beginOffset,
    required Widget contents,
  }) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      context: context,
      transitionDuration: Duration(milliseconds: 500),
      transitionBuilder: (_, animation, __, child) {
        Tween<Offset> tween = Tween(begin: beginOffset, end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => contents,
    );
  }

}