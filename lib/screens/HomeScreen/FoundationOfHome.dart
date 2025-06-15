import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joy_way/screens/HomeScreen/BottomNavigationBar.dart';
import 'package:joy_way/screens/HomeScreen/components/profile/ProfileScreen.dart';
import 'package:joy_way/services/FirebaseServices/Authentication.dart';

import '../../config/GeneralSpecifications.dart';
import '../../services/FirebaseServices/ProfileService.dart';
import 'components/home/HomeScreen.dart';
import 'components/messages/MessagesScreen.dart';
import 'components/search/SearchScreen.dart';

class FoundationOfHome extends StatefulWidget {
  const FoundationOfHome({super.key});

  @override
  State<FoundationOfHome> createState() => _FoundationOfHomeState();
}

class _FoundationOfHomeState extends State<FoundationOfHome> {
  int page = 0;

  String? _userName;
  String? _fullName;

  String? _story;
  String? _phoneNumber;
  String? _placeOfBirth;
  String? _currentAddress;
  DateTime? _dateOfBirth;
  String? _sex;

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<dynamic>? info =
          await ProfileService().Get_User_Information(user.uid);
      if (info != null) {
        print("User info: $info");
        setState(() {
          _userName = info[0];
          _fullName = info[1];
          _sex = info[2];
          _story = info[3];
          _phoneNumber = info[4];
          _dateOfBirth = info[5];
          _placeOfBirth = info[6];
          _currentAddress = info[7];
        });
      } else {
        print("No user data found");
      }
    } else {
      print("No user logged in");
    }
  }

  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    final user = FirebaseAuth.instance.currentUser;
    final Authentication auth = Authentication();
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          (page == 0)
              ? HomeScreen()
              : (page == 1)
                  ? Container()
                  : (page == 2)
                      ? MessagesScreen(
                          userName: _userName,
                          fullName: _fullName,
                          story: _story,
                          phoneNumber: _phoneNumber,
                          placeOfBirth: _placeOfBirth,
                          currentAddress: _currentAddress,
                          dateOfBirth: _dateOfBirth,
                          sex: _sex,
                      )
                      : ProfileScreen(
                          isAuth: true,
                          userName: _userName,
                          fullName: _fullName,
                          story: _story,
                          phoneNumber: _phoneNumber,
                          placeOfBirth: _placeOfBirth,
                          currentAddress: _currentAddress,
                          dateOfBirth: _dateOfBirth,
                          sex: _sex,
                        ),
          Positioned(
            top: specs.screenHeight - 80,
            child: CustomBottomNavigationBar(
              page: page,
              OnPage: (value) {
                setState(() {
                  page = value;
                });
              },
            ),
          ),
          // (page == 0)
          //     ? Container()
          //     : (page == 1)
          //     ? Container()
          //     : (page == 2)
          //     ? Container()
          //     : Container(),
        ],
      ),
    );
  }
}
