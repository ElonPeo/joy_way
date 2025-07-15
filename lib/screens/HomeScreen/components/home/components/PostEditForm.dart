
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:joy_way/services/DataProcessing/TimeProcessing.dart';

import '../../../../../config/GeneralSpecifications.dart';
import '../../../../../services/FirebaseServices/PostService.dart';
import '../../../../../widgets/ShowGeneralDialog.dart';

class PostEditForm extends StatefulWidget {
  final String? content;
  final String? vehicleType;
  final int? numberOfSeats;
  final DateTime? departureTime;
  final String? expense;
  final String? status;
  final String? startLocation;
  final String? endLocation;
  final List<String>? companionIds;

  const PostEditForm({
    super.key,
    this.content,
    this.expense,
    this.vehicleType,
    this.numberOfSeats,
    this.departureTime,
    this.status,
    this.startLocation,
    this.endLocation,
    this.companionIds,
  });

  @override
  State<PostEditForm> createState() => _PostEditFormState();
}

class _PostEditFormState extends State<PostEditForm>
    with TickerProviderStateMixin {
  final _content = TextEditingController();
  final _expense = TextEditingController();
  final _numberOfSeats = TextEditingController();

  String? _endLocation;
  String? _startLocation;
  DateTime? _date;
  DateTime? _time;



  String? _vehicleType;
  bool isTapVehicleType = false;
  late AnimationController _rotationController1;
  bool showVehicleType = false;

  void _toggleRotationVehicleType() {
    if (isTapVehicleType) {
      _rotationController1.reverse();
    } else {
      _rotationController1.forward();
    }
    setState(() {
      isTapVehicleType = !isTapVehicleType;

      if (isTapVehicleType) {
        Future.delayed(Duration(milliseconds: 400), () {
          if (isTapVehicleType) {
            setState(() {
              showVehicleType = true;
            });
          }
        });
      } else {
        showVehicleType = false;
      }
    });
  }

  String? _status;
  bool isTapStatus = false;
  late AnimationController _rotationController2;
  bool showStatusType = false;

  void _toggleRotationStatus() {
    if (isTapStatus) {
      _rotationController2.reverse();
    } else {
      _rotationController2.forward();
    }
    setState(() {
      isTapStatus = !isTapStatus;

      if (isTapStatus) {
        Future.delayed(Duration(milliseconds: 400), () {
          if (isTapStatus) {
            setState(() {
              showStatusType = true;
            });
          }
        });
      } else {
        showStatusType = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _rotationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    _rotationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _rotationController1.dispose();
    _rotationController2.dispose();
    _content.dispose();
    _expense.dispose();
    _numberOfSeats.dispose();

    super.dispose();
  }

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
                          "Post",
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
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );

                            try {
                              await PostService().createPost(
                                content: _content.text,
                                vehicleType: _vehicleType ?? "Other",
                                numberOfSeats: int.tryParse(_numberOfSeats.text) ?? 1,
                                departureTime: TimeProcessing().combineDateAndTime(_date!, _time!),
                                expense: _expense.text,
                                status: _status ?? "Looking for passengers",
                                startLocation: _startLocation ?? "null",
                                endLocation: _endLocation ?? "null",
                                informationAboutCompanion: [],
                              );

                              Navigator.of(context).pop(); // Tắt loading
                              Navigator.of(context).pop(); // Tắt pop up form
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
                                  controller: _content,
                                  maxLength: 200,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: specs.pantoneColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  textInputAction: TextInputAction.send,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 10),
                                    hintText: _content.text.isEmpty
                                        ? 'Write something'
                                        : _content.text,
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
                      AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: isTapVehicleType ? 200 : 50,
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
                                width: specs.screenWidth * 0.15,
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Vehicle',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: specs.screenWidth * 0.3,
                                height: isTapVehicleType ? 200 : 50,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleRotationVehicleType,
                                      child: Container(
                                        width: specs.screenWidth * 0.3,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              (_vehicleType == null ||
                                                      _vehicleType!.isEmpty)
                                                  ? 'Type'
                                                  : '$_vehicleType',
                                              style: GoogleFonts.montserrat(
                                                  color: (_vehicleType ==
                                                              null ||
                                                          _vehicleType!.isEmpty)
                                                      ? specs.bl200
                                                      : specs.pantoneColor,
                                                  fontSize: 13),
                                            ),
                                            AnimatedBuilder(
                                                animation: _rotationController1,
                                                builder: (context, child) {
                                                  final angle =
                                                      _rotationController1
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
                                    if (showVehicleType)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _vehicleType = "Car";
                                                _rotationController1.reverse();
                                                showVehicleType = false;
                                                isTapVehicleType = false;
                                              });
                                            },
                                            child: Container(
                                              width: specs.screenWidth * 0.3,
                                              height: 50,
                                              color: specs.bl240,
                                              child: Center(
                                                child: Text(
                                                  'Car',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _vehicleType = "Motorbike";
                                                _rotationController1.reverse();
                                                showVehicleType = false;
                                                isTapVehicleType = false;
                                              });
                                            },
                                            child: Container(
                                              width: specs.screenWidth * 0.3,
                                              height: 50,
                                              color: specs.bl240,
                                              child: Center(
                                                child: Text(
                                                  'Motorbike',
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _vehicleType = "Other";
                                                _rotationController1.reverse();
                                                showVehicleType = false;
                                                isTapVehicleType = false;
                                              });
                                            },
                                            child: Container(
                                              width: specs.screenWidth * 0.3,
                                              height: 50,
                                              color: specs.bl240,
                                              child: Center(
                                                child: Text(
                                                  'Other',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              Container(
                                width: specs.screenWidth * 0.15,
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Seat',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                              ),
                              Container(
                                width: specs.screenWidth * 0.2,
                                child: TextField(
                                  controller: _numberOfSeats,
                                  maxLength: 2,
                                  style: TextStyle(
                                    color: specs.pantoneColor,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    hintText: _numberOfSeats.text.isEmpty
                                        ? 'Empty seat'
                                        : _numberOfSeats.text,
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
                                                : DateFormat('HH:mm').format(
                                                    _time!),
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
                                      'Start',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String? result = await ShowGeneralDialog.Vietnam_Provinces_Picker(context: context);
                                  setState(() {
                                    _startLocation = result;
                                  });
                                },

                                child:Container(
                                  width: specs.screenWidth * 0.7 - 20,
                                  child: Text(
                                    _startLocation ?? 'Fill in starting point',
                                    style:GoogleFonts.montserrat(
                                      color: _startLocation != null && _startLocation!.isNotEmpty
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
                                      'End',
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String? result = await ShowGeneralDialog.Vietnam_Provinces_Picker(context: context);
                                  setState(() {
                                    _endLocation = result;
                                  });
                                },

                                child:Container(
                                  width: specs.screenWidth * 0.7 - 20,
                                  child: Text(
                                    _endLocation ?? 'Destination',
                                    style:GoogleFonts.montserrat(
                                      color: _endLocation != null && _endLocation!.isNotEmpty
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
                      AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: isTapStatus ? 200 : 50,
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
                                  'Status',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13),
                                ),
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: specs.screenWidth * 0.7 - 20,
                                height: isTapStatus ? 200 : 50,
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: _toggleRotationStatus,
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
                                              (_status == null ||
                                                      _status!.isEmpty)
                                                  ? 'Looking for passengers'
                                                  : '$_status',
                                              style: GoogleFonts.montserrat(
                                                  color: (_status == null ||
                                                          _status!.isEmpty)
                                                      ? specs.bl200
                                                      : specs.pantoneColor,
                                                  fontSize: 13),
                                            ),
                                            AnimatedBuilder(
                                                animation: _rotationController2,
                                                builder: (context, child) {
                                                  final angle =
                                                      _rotationController2
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
                                    if (showStatusType)
                                      Container(
                                        margin: EdgeInsets.only(top: 50),
                                        width: specs.screenWidth * 0.7 - 20,
                                        height: 200,
                                        child: ListView(
                                          padding: EdgeInsets.all(0),
                                          children: [
                                            _buildStatusItem(
                                                "Looking for passengers"),
                                            _buildStatusItem(
                                                "Prepare to depart"),
                                            _buildStatusItem(
                                                "Picking up guests"),
                                            _buildStatusItem(
                                                "Picked all guests"),
                                            _buildStatusItem(
                                                "Heading to destination"),
                                            _buildStatusItem("Arrived"),
                                            _buildStatusItem("Cancelled"),
                                          ],
                                        ),
                                      )
                                  ],
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
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label) {
    final specs = GeneralSpecifications(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _status = label;
          isTapStatus = false;
          showStatusType = false;
          _rotationController2.reverse();
        });
      },
      child: Container(
        height: 45,
        color: specs.bl240,
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.montserrat(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
