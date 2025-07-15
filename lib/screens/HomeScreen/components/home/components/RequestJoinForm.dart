import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:joy_way/services/DataProcessing/TimeProcessing.dart';
import 'package:joy_way/services/FirebaseServices/NotifyService.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../widgets/ShowGeneralDialog.dart';

class RequestJoinForm extends StatefulWidget {
  final String postId;
  final String ownerId;

  const RequestJoinForm({
    super.key,
    required this.postId,
    required this.ownerId,
  });

  @override
  State<RequestJoinForm> createState() => _RequestJoinFormState();
}

class _RequestJoinFormState extends State<RequestJoinForm> {
  final _message = TextEditingController();
  final _expense = TextEditingController();
  String? _dropOffLocation;
  String? _pickUpLocation;
  DateTime? _date;
  DateTime? _time;

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Material(
      color: Colors.transparent,
      child: Column(
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
          Container(
            height: specs.screenHeight * 0.85,
            width: specs.screenWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
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
                          "Request",
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );
                            try {
                              await NotifyService().createJoinTripNotification(
                                ownerId: widget.ownerId,
                                postId: widget.postId,
                                message: _message.text,
                                expense: _expense.text,
                                dropOffLocation: _dropOffLocation,
                                pickUpLocation: _pickUpLocation ?? 'N/A',
                                departureTime: TimeProcessing().combineDateAndTime(_date!, _time!),
                              );
                              Navigator.of(context).pop(); // Tắt loading
                              Navigator.of(context).pop();
                            } catch (e) {
                              Navigator.of(context).pop(); // Tắt loading

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Lỗi"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Đóng"),
                                    )
                                  ],
                                ),
                              );
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
                SizedBox(
                  width: specs.screenWidth,
                  height: specs.screenHeight * 0.85 - 50,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Container(
                        height: specs.screenHeight * 0.15,
                        width: specs.screenWidth,
                        color: specs.bl200,
                      ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Content',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                width: specs.screenWidth * 0.7 - 20,
                                child: TextField(
                                  controller: _message,
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
                                    hintText: _message.text.isEmpty
                                        ? 'Write something'
                                        : _message.text,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expense',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: specs.screenWidth * 0.7 - 20,
                                child: TextField(
                                  controller: _expense,
                                  maxLength: 8,
                                  style: TextStyle(
                                    color: specs.pantoneColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    hintText: _expense.text.isEmpty
                                        ? 'Default is free'
                                        : _expense.text,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pick up',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String? result = await ShowGeneralDialog
                                      .Vietnam_Provinces_Picker(
                                          context: context) ?? 'N/A';
                                  setState(() {
                                    _pickUpLocation = result;
                                  });
                                },
                                child: Container(
                                  width: specs.screenWidth * 0.7 - 20,
                                  child: Text(
                                    _pickUpLocation ?? 'Preferred pick up ',
                                    style: GoogleFonts.montserrat(
                                      color: _pickUpLocation != null &&
                                              _pickUpLocation!.isNotEmpty
                                          ? specs.pantoneColor
                                          : specs.bl200,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Drop off',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String? result = await ShowGeneralDialog
                                      .Vietnam_Provinces_Picker(
                                          context: context);
                                  setState(() {
                                    _dropOffLocation = result;
                                  });
                                },
                                child: Container(
                                  width: specs.screenWidth * 0.7 - 20,
                                  child: Text(
                                    _dropOffLocation ?? 'Desired destination',
                                    style: GoogleFonts.montserrat(
                                      color: _dropOffLocation != null &&
                                              _dropOffLocation!.isNotEmpty
                                          ? specs.pantoneColor
                                          : specs.bl200,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Departure Time',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ShowGeneralDialog.showDatePickerDialog(
                                        context: context,
                                        title: "Add date",
                                        dateTime: DateTime.now(),
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(() {
                                            _date = newDate;
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 49,
                                      width: specs.screenWidth * 0.7 - 20,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: specs.bl240,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _date == null
                                                ? 'Add date'
                                                : DateFormat('dd/MM/yyyy')
                                                    .format(_date!),
                                            style: GoogleFonts.montserrat(
                                                color: _date == null
                                                    ? specs.bl200
                                                    : specs.pantoneColor,
                                                fontSize: 13),
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
                                  GestureDetector(
                                    onTap: () {
                                      ShowGeneralDialog.showDatePickerDialog(
                                        context: context,
                                        title: "Select departure time",
                                        dateTime: DateTime.now(),
                                        isDate: false,
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(() {
                                            _time = newDate;
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: specs.screenWidth * 0.7 - 20,
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _time == null
                                                ? 'Add time'
                                                : DateFormat('HH:mm')
                                                    .format(_time!),
                                            style: GoogleFonts.montserrat(
                                              color: _time == null
                                                  ? specs.bl200
                                                  : specs.pantoneColor,
                                              fontSize: 13,
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
                              )
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
