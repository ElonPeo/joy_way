import 'package:flutter/material.dart';
import 'package:joy_way/screens/HomeScreen/components/messages/MessagesScreen.dart';
import 'package:joy_way/screens/HomeScreen/components/profile/ProfileScreen.dart';
import 'package:joy_way/widgets/SelectLocation/SelectLocation.dart';
import '../screens/HomeScreen/components/home/components/PostEditForm.dart';
import '../screens/HomeScreen/components/messages/MessageRoom.dart';
import 'DatePicker/ShowDialogDatePicker.dart';


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
    bool isDate = true,
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
        isDate: isDate,
      ),
    );
  }

  static void Profile_Dialog({
    required BuildContext context,
    required String? otherUid,
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
          otherUid: otherUid,
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

  static void Message_Room_Dialog({
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


  static void Message_Dialog({
    required BuildContext context,
    required String? userName,
    required String? fullName,
    required String? sex,
    // story: _story,
    // phoneNumber: _phoneNumber,
    // placeOfBirth: _placeOfBirth,
    // currentAddress: _currentAddress,
    // dateOfBirth: _dateOfBirth,
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
      pageBuilder: (context, _, __) => MessagesScreen(
        userName: userName,
        fullName: fullName,
        sex: sex,
      ),
    );
  }

  static void Post_Edit_Dialog({
    required BuildContext context,
    String? content,
    String? vehicleType,
    int? numberOfSeats,
    DateTime? departureTime,
    String? expense,
    String? status,
    String? startLocation,
    String? endLocation,
    List<String>? companionIds,
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
        final tween = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => Center(
        child: PostEditForm(
          content: content,
          vehicleType: vehicleType,
          numberOfSeats: numberOfSeats,
          departureTime: departureTime,
          expense: expense,
          status: status,
          startLocation: startLocation,
          endLocation: endLocation,
          companionIds: companionIds,
        ),
      ),
    );
  }


  static Future<String?> Vietnam_Provinces_Picker({
    required BuildContext context,
    Duration duration = const Duration(milliseconds: 500),
    bool barrierDismissible = true,
    Color barrierColor = Colors.black54,
    Curve curve = Curves.easeInOut,
    String barrierLabel = 'Dismiss',
  }) {
    return showGeneralDialog<String>(
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: barrierColor,
      context: context,
      transitionDuration: duration,
      transitionBuilder: (_, animation, __, child) {
        final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        );
      },
      pageBuilder: (context, _, __) => SelectLocation(),
    );
  }

}