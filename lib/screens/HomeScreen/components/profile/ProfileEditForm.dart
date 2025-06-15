import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:joy_way/widgets/LoadingAndStatus/LoadingAndStatus.dart';
import 'package:joy_way/widgets/ShowGeneralDialog.dart';
import 'package:joy_way/widgets/ShowNocification.dart';
import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/FirebaseServices/ProfileService.dart';


class ProfileEditForm extends StatefulWidget {
  @override
  State<ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<ProfileEditForm>
    with SingleTickerProviderStateMixin {
  final _userName = TextEditingController();
  final _fullName = TextEditingController();
  final _story = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _placeOfBirth = TextEditingController();
  final _currentAddress = TextEditingController();
  DateTime? _dateOfBirth;
  String? _sex;


  late AnimationController _rotationController;
  bool isTapGender = false;
  bool isCompleteLoadingAndStatus = false;
  bool showGenderType = false;
  int? genderType;
  bool animationLoading = false;
  ValueNotifier<bool?> statusNotifier = ValueNotifier(null);
  ValueNotifier<String?> message = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _loadUserInfo();
  }

  void _toggleRotation() {
    if (isTapGender) {
      _rotationController.reverse();
    } else {
      _rotationController.forward();
    }
    setState(() {
      isTapGender = !isTapGender;

      if (isTapGender) {
        Future.delayed(Duration(milliseconds: 400), () {
          if (isTapGender) {
            setState(() {
              showGenderType = true;
            });
          }
        });
      } else {
        showGenderType = false;
      }
    });
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      List<dynamic>? info =
          await ProfileService().Get_User_Information(user.uid);
      if (info != null) {
        print("User info: $info");
        setState(() {
          _userName.text = (info[0]?.toString().replaceFirst('@', '')) ?? '';
          _fullName.text = (info[1]?.toString()) ?? '';
          _sex = info[2];
          _story.text = (info[3]?.toString()) ?? '';
          _phoneNumber.text = (info[4]?.toString()) ?? '';
          _dateOfBirth = info[5];
          _placeOfBirth.text = (info[6]?.toString()) ?? '';
          _currentAddress.text = (info[7]?.toString()) ?? '';
        });
      } else {
        print("No user data found");
      }
    } else {
      print("No user logged in");
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _userName.dispose();
    _fullName.dispose();
    _story.dispose();
    _phoneNumber.dispose();
    _placeOfBirth.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    final user = FirebaseAuth.instance.currentUser;
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: specs.screenHeight * 0.15,
              width: specs.screenWidth,
              color: Colors.transparent,
            ),
          ),
          SizedBox(
            height: specs.screenHeight * 0.85,
            width: specs.screenWidth,
            child: Stack(
              children: [
                SizedBox(
                    height: specs.screenHeight * 0.85,
                    width: specs.screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: specs.screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            ),
                            color: Color.fromRGBO(62, 157, 110, 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                      'assets/icons/arrowBack.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Edit Profile",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {

                                    String userName = _userName.text;
                                    String fullName = _fullName.text;
                                    String story = _story.text;
                                    String phoneNumber = _phoneNumber.text;
                                    String placeOfBirth = _placeOfBirth.text;
                                    String currentAddress = _currentAddress.text;
                                    ProfileService service = ProfileService();
                                    String uid = FirebaseAuth.instance.currentUser!.uid;
                                    String email = FirebaseAuth.instance.currentUser!.email ?? '';
                                    String? e = await service.Check_Information_Before_Sending(userName, phoneNumber);
                                    if (e == null)
                                      {
                                        setState(() {
                                          animationLoading = true;
                                        });
                                        String? status = await service.Edit_Profile(
                                          uid: uid,
                                          email: email,
                                          userName: userName,
                                          fullName: fullName,
                                          sex: _sex,
                                          story: story,
                                          phoneNumber: phoneNumber,
                                          dateOfBirth: _dateOfBirth,
                                          placeOfBirth: placeOfBirth,
                                          currentAddress: currentAddress,
                                        );
                                        if (status == null) {
                                          await Future.delayed(const Duration(milliseconds: 2000));
                                          statusNotifier.value = true;
                                          message.value = "Update successfully";
                                        } else {
                                          print("loi");
                                          print(status);
                                          await Future.delayed(const Duration(milliseconds: 2000));
                                          statusNotifier.value = null;
                                          message.value = status;
                                        }
                                      }
                                    else {
                                      ShowNotification.showAnimatedSnackBar(context, e, 1);
                                    }
                                  },
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Image.asset(
                                      'assets/icons/save1.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: specs.screenHeight * 0.85 - 50,
                          width: specs.screenWidth,
                          color: Colors.white,
                          child: ListView(
                            padding: EdgeInsets.all(0),
                            children: [
                              Container(
                                height: specs.screenHeight * 0.15 + 60,
                                width: specs.screenWidth,
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: specs.screenHeight * 0.15,
                                      width: specs.screenWidth,
                                      color: specs.bl200,
                                    ),
                                    Positioned(
                                        left: 20,
                                        top: specs.screenHeight * 0.15 - 103 * 0.5,
                                        child: Container(
                                          height: 103,
                                          width: 103,
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: ClipOval(
                                                  child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    color: specs.bl240,
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 60,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 103,
                                                width: 103,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: 3.0,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Name',
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          width: specs.screenWidth * 0.7 - 20,
                                          child: TextField(
                                            controller: _fullName,
                                            maxLength: 25,
                                            style: TextStyle(
                                              color: specs.pantoneColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(vertical: 10),
                                              hintText: _fullName.text.isEmpty
                                                  ? 'Enter your name'
                                                  : _fullName.text,
                                              hintStyle: GoogleFonts.montserrat(
                                                color: specs.bl200,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                              border: InputBorder.none,
                                              counterText: '',
                                            ),
                                          )),
                                    ],
                                  )),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'User Name',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: specs.screenWidth * 0.7 - 20,
                                        child: Row(
                                          children: [
                                            Text(
                                              "@",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: specs.bl200,
                                              ),
                                            ),
                                            Container(
                                              width: specs.screenWidth * 0.6 - 20,
                                              child: TextField(
                                                controller: _userName,
                                                maxLength: 11,
                                                style: TextStyle(
                                                  color: specs.pantoneColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10),
                                                  hintText: _userName.text.isEmpty
                                                      ? 'Enter your user name'
                                                      : _userName.text,
                                                  hintStyle: GoogleFonts.montserrat(
                                                    color: specs.bl200,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                  ),
                                                  border: InputBorder.none,
                                                  counterText: '',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: isTapGender ? 200 : 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        padding: EdgeInsets.only(top: 15),
                                        child: Text(
                                          'Sex',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13
                                          ),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 300),
                                        width: specs.screenWidth * 0.7 - 20,
                                        height: isTapGender ? 200 : 50,
                                        child: Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: _toggleRotation,
                                              child: Container(
                                                width: specs.screenWidth * 0.7 - 20,
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      (_sex == null || _sex!.isEmpty)
                                                          ? 'Enter your gender'
                                                          : '$_sex',
                                                      style: GoogleFonts.montserrat(
                                                        color: (_sex == null ||
                                                                _sex!.isEmpty)
                                                            ? specs.bl200
                                                            : specs.pantoneColor,
                                                        fontSize: 13
                                                      ),
                                                    ),
                                                    AnimatedBuilder(
                                                        animation:
                                                            _rotationController,
                                                        builder: (context, child) {
                                                          final angle =
                                                              _rotationController
                                                                      .value *
                                                                  (3.1416 / 2);
                                                          return Transform.rotate(
                                                            angle: angle,
                                                            child: child,
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios_rounded,
                                                          size: 17,
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (showGenderType)
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _sex = "Male";
                                                      });
                                                    },
                                                    child: Container(
                                                      width: specs.screenWidth * 0.7 -
                                                          20,
                                                      height: 50,
                                                      color: specs.bl240,
                                                      child: Center(
                                                        child: Text(
                                                          'Male',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _sex = "Female";
                                                      });
                                                    },
                                                    child: Container(
                                                      width: specs.screenWidth * 0.7 -
                                                          20,
                                                      height: 50,
                                                      color: specs.bl240,
                                                      child: Center(
                                                        child: Text(
                                                          'Female',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _sex = "LGBT";
                                                      });
                                                    },
                                                    child: Container(
                                                      width: specs.screenWidth * 0.7 -
                                                          20,
                                                      height: 50,
                                                      color: specs.bl240,
                                                      child: Center(
                                                        child: Text(
                                                          'LGBT',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 100,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        padding: EdgeInsets.only(top: 12),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Your story',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 100,
                                        width: specs.screenWidth * 0.7 - 20,
                                        child: TextField(
                                          controller: _story,
                                          maxLength: 100,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: specs.pantoneColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          textInputAction: TextInputAction.send,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 10),
                                            hintText: _story.text.isEmpty
                                                ? 'Share your story'
                                                : _story.text,
                                            hintStyle: GoogleFonts.montserrat(
                                              color: specs.bl200,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'DOB',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ShowGeneralDialog.showDatePickerDialog(
                                            context: context,
                                            title: "Select date of birth",
                                            dateTime: DateTime.now(),
                                            onDateTimeChanged: (DateTime newDate) {
                                              setState(() {
                                                _dateOfBirth = newDate;
                                              });
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: specs.screenWidth * 0.7 - 20,
                                          color: Colors.transparent,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _dateOfBirth == null
                                                    ? 'Add date of birth'
                                                    : DateFormat('dd/MM/yyyy')
                                                        .format(_dateOfBirth!),
                                                style: GoogleFonts.montserrat(
                                                  color: _dateOfBirth == null
                                                      ? specs.bl200
                                                      : specs.pantoneColor,
                                                  fontSize: 13
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 17,
                                                color: Colors.black,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Email',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          width: specs.screenWidth * 0.7 - 20,
                                          child: Text(
                                            '${user?.email}',
                                            style: TextStyle(
                                              color: specs.pantoneColor,
                                            ),
                                          )),
                                    ],
                                  )),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Phone',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: specs.screenWidth * 0.7 - 20,
                                        child: TextField(
                                          controller: _phoneNumber,
                                          maxLength: 11,
                                          style: TextStyle(
                                            color: specs.pantoneColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(vertical: 10),
                                            hintText: _phoneNumber.text.isEmpty
                                                ? 'Setup phone number'
                                                : _phoneNumber.text,
                                            hintStyle: GoogleFonts.montserrat(
                                              color: specs.bl200,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Place of birth',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: specs.screenWidth * 0.7 - 20,
                                        child: TextField(
                                          controller: _placeOfBirth,
                                          style: TextStyle(
                                            color: specs.pantoneColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          maxLength: 50,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(vertical: 10),
                                            hintText: _placeOfBirth.text.isEmpty
                                                ? 'Add place date of birth'
                                                : _placeOfBirth.text,
                                            hintStyle: GoogleFonts.montserrat(
                                              color: specs.bl200,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  height: 50,
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: specs.bl240,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: specs.screenWidth * 0.2,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Current Address',
                                              style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: specs.screenWidth * 0.7 - 20,
                                        child: TextField(
                                          controller: _currentAddress,
                                          maxLength: 50,
                                          style: TextStyle(
                                            color: specs.pantoneColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(vertical: 10),
                                            hintText: _currentAddress.text.isEmpty
                                                ? 'Fill in where you currently live'
                                                : _currentAddress.text,
                                            hintStyle: GoogleFonts.montserrat(
                                              color: specs.bl200,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 13,
                                            ),
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                height: specs.screenHeight * 0.4,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: specs.bl240,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                if (animationLoading)
                Center(
                  child: LoadingAndStatus(
                    animation: animationLoading,
                    statusNotifier: statusNotifier,
                    message: message,
                    onAnimation: (value) {
                      setState(() {
                        animationLoading = value;
                      });
                    },
                    IsCompleteLoadingAndStatus: (completed) {
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
