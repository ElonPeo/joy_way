import 'package:flutter/material.dart';
import 'package:joy_way/screens/HomeScreen/components/profile/ProfileScreen.dart';
import '../screens/HomeScreen/components/messages/MessageRoom.dart';
import 'DatePicker/ShowDialogDatePicker.dart';
import 'LoadingAndStatus/LoadingAndStatus.dart';


class ShowGeneralDialog {
  static void General_Dialog({
    required BuildContext context,
    required Offset beginOffset,
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    Curve curve = Curves.easeInOut,
    String barrierLabel = 'Dismiss',
  }) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      context: context,
      transitionDuration: duration,
      transitionBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: beginOffset, end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => child,
    );
  }

  static void showDatePickerDialog({
    required BuildContext context,
    required DateTime? dateTime,
    required title,
    Function(DateTime)? onDateTimeChanged,
    Duration duration = const Duration(milliseconds: 500),
    bool barrierDismissible = true,
    Color barrierColor = Colors.transparent,
    Curve curve = Curves.easeInOut,
    String barrierLabel = 'Dismiss',
  }) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      context: context,
      transitionDuration: duration,
      transitionBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => ShowDialogDatePicker(
        dateTime: dateTime,
        onDateTimeChanged: onDateTimeChanged,
        title: title,
      ),
    );
  }

  static void Profile_Dialog({
    required BuildContext context,
    required String? userId,
    required String? userName,
    required String? fullName,
    required String? story,
    required String? sex,
    required DateTime? dateOfBirth,
    required String? placeOfBirth,
    required String? currentAddress,
    Duration duration = const Duration(milliseconds: 500),
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    Curve curve = Curves.easeInOut,
    String barrierLabel = 'Dismiss',
  }) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      context: context,
      transitionDuration: duration,
      transitionBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => ProfileScreen(
          uid: userId,
          isAuth: false,
          userName: userName,
          fullName: fullName,
          story: story,
          sex: sex,
          dateOfBirth: dateOfBirth,
          placeOfBirth: placeOfBirth,
          currentAddress: currentAddress),
    );
  }

  static void Message_Dialog({
    required BuildContext context,
    required String? userId,
    required String? userName,
    required String? fullName,
    Duration duration = const Duration(milliseconds: 500),
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    Curve curve = Curves.easeInOut,
    String barrierLabel = 'Dismiss',
  }) {
    showGeneralDialog(
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      context: context,
      transitionDuration: duration,
      transitionBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => MessageRoom(
          userId: userId,
          userName: userName,
          fullName: fullName,
          ),
    );
  }
}