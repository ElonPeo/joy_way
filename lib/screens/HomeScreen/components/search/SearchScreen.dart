import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/FirebaseServices/SearchService.dart';
import '../../../../widgets/ShowGeneralDialog.dart';

class SearchScreen extends StatefulWidget {
  final VoidCallback onFadeOutComplete;
  const SearchScreen({
    super.key,
    required this.onFadeOutComplete,
  });
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isTapSearch = false;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _searchResults = [];



  void _onSearchButtonPressed() {
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Container(
      height: specs.screenHeight,
      width: specs.screenWidth,
      color: Colors.white,
      child: Column(
        children: [
          Container(
              height: 90,
              width: specs.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: specs.bl240,
                    width: 1.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          widget.onFadeOutComplete();
                          FocusScope.of(context).unfocus();
                        },
                        icon:
                        Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: specs.screenWidth - 130,
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onChanged: (query) {
                            if (_debounce?.isActive ?? false)
                              _debounce!.cancel();
                            _debounce = Timer(Duration(milliseconds: 500),
                                    () async {
                                  if (query.length >= 4) {
                                    final results = await SearchService()
                                        .Find_Users(keyword: query);
                                    if (!mounted) return;
                                    setState(() {
                                      _searchResults = results;
                                    });
                                  } else {
                                    setState(() {
                                      _searchResults = [];
                                    });
                                  }
                                });
                          },
                          decoration: InputDecoration(
                            hintText: "Search something",
                            hintStyle: GoogleFonts.montserrat(
                              color: specs.bl80,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            filled: true,
                            fillColor:
                            const Color.fromRGBO(240, 240, 240, 1),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: _onSearchButtonPressed,
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ],
              )
          ),
          SizedBox(
            height: specs.screenHeight - 90,
            width: specs.screenWidth,
            child: ListView(
              padding: EdgeInsets.all(0),
                children: [
                if (_searchResults.isNotEmpty)
                  ..._searchResults
                      .map((user) => ListTile(
                            onTap: () {
                              ShowGeneralDialog.Profile_Dialog(
                                context: context,
                                otherUid: user['userId'] ?? '',
                                userName: user['userName'] ?? '',
                                fullName: user['fullName'] ?? '',
                                story: user['story'] ?? '',
                                sex: user['sex'] ?? '',
                                dateOfBirth: (user['dateOfBirth'] as Timestamp?)
                                    ?.toDate(),
                                placeOfBirth: user['placeOfBirth'] ?? '',
                                currentAddress: user['currentAddress'] ?? '',
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person),
                            ),
                            title: Text(user['fullName'] ?? 'No Name'),
                            subtitle: Text(user['userName'] ?? ''),
                            trailing: Text(user['email'] ?? ''),
                          ))
                      .toList(),
                if (_searchResults.isEmpty &&
                    _searchController.text.length >= 4)
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(child: Text("No user found")),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



