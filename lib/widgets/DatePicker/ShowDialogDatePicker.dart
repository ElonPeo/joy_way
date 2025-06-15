import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/GeneralSpecifications.dart';

class ShowDialogDatePicker extends StatefulWidget {
  final DateTime? dateTime;
  final String title;
  final Function(DateTime)? onDateTimeChanged;

  const ShowDialogDatePicker({
    super.key,
    required this.dateTime,
    this.title = "Date Picker",
    required this.onDateTimeChanged,
  });

  @override
  State<ShowDialogDatePicker> createState() => _ShowDialogDatePickerState();
}

class _ShowDialogDatePickerState extends State<ShowDialogDatePicker> {
  late DateTime selectedDate;
  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        height: specs.screenHeight,
        width: specs.screenWidth,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: specs.screenHeight * 0.6 ,
                width: specs.screenWidth,
                color: Colors.transparent,
              ),
            ),

            Container(
              height: specs.screenHeight * 0.4 - 20,
              width: specs.screenWidth - 20,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        height: specs.screenHeight * 0.4 - 20,
                        width: specs.screenWidth - 20,
                      ),
                    ),
                  ),
                  Container(
                    height: specs.screenHeight * 0.4 - 20,
                    width: specs.screenWidth - 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          width: specs.screenWidth,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(62, 157, 110, 0.4),
                                blurRadius: 15.0,
                                spreadRadius: -1,
                                offset: Offset.zero,
                              ),
                            ],
                            color: Color.fromRGBO(44, 122, 84, 1),
                            borderRadius: BorderRadius.only(topLeft:  Radius.circular(30), topRight:Radius.circular(30),),
                          ),
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
                                widget.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (widget.onDateTimeChanged != null) {
                                    widget.onDateTimeChanged!(selectedDate);
                                  }
                                  Navigator.pop(context);
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
                        Container(
                          height: specs.screenHeight * 0.4 - 120,
                          width: specs.screenWidth,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 0.7),

                          ),
                          child:  CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: widget.dateTime,
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() {
                                selectedDate = newDate;
                              });
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          width: specs.screenWidth,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(210, 210, 210, 0.7),
                            borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
