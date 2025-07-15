import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/FirebaseServices/MessageService.dart';
import '../../../../widgets/ShowGeneralDialog.dart';

class MessagesScreen extends StatefulWidget {
  final String? userName;
  final String? fullName;

  // final String? story;
  // final String? phoneNumber;
  // final String? placeOfBirth;
  // final String? currentAddress;
  // final DateTime? dateOfBirth;
  final String? sex;

  const MessagesScreen({
    super.key,
    required this.userName,
    required this.fullName,
    // required this.story,
    // required this.phoneNumber,
    // required this.placeOfBirth,
    // required this.currentAddress,
    // required this.dateOfBirth,
    required this.sex,
  });

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool isTapFindMessage = false;
  List<Map<String, dynamic>> messagedConversations = [];
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
    fetchMessagedUsers();
  }

  Future<void> fetchMessagedUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final conversations = await _messageService
            .getMessagedUsersWithLastMessage(currentUser.uid);
        setState(() {
          messagedConversations = conversations;
        });
        print("Fetched conversations: ${conversations.length}");
        for (var convo in conversations) {
          print("With ${convo['otherUserId']} - Last: ${convo['lastMessage']}");
        }
      } catch (e) {
        print("Error fetching conversations: $e");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Material(
      child: Container(
        height: specs.screenHeight,
        width: specs.screenWidth,
        color: Colors.white,
        child: Stack(
          children: [
            SizedBox(
              height: specs.screenHeight,
              width: specs.screenWidth,
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  AnimatedContainer(
                    height: isTapFindMessage
                        ? specs.screenHeight * 0.05
                        : specs.screenHeight * 0.12,
                    duration: const Duration(milliseconds: 250),
                  ),
                  Container(
                    width: specs.screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 45,
                    // color: Colors.blue,
                    // color: Colors.orange,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                            duration: const Duration(milliseconds: 250),
                            top: 0,
                            left: isTapFindMessage ? 0 : -50,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: isTapFindMessage ? 1 : 0,
                              child: SizedBox(
                                height: 45,
                                width: 45,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isTapFindMessage = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_rounded,
                                      size: 25,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: AnimatedContainer(
                                  height: 40,
                                  width: isTapFindMessage
                                      ? specs.screenWidth - 70
                                      : specs.screenWidth - 30,
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: TextField(
                                    onTap: () {
                                      setState(() {
                                        isTapFindMessage = true;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      hintStyle: GoogleFonts.montserrat(
                                        color: specs.bl80,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(8),
                                      prefixIcon:
                                          Icon(Icons.search, color: specs.bl80),
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
                              ),
                            ]),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: specs.screenWidth - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Message",
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Message waiting",
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  messagedConversations.isEmpty
                      ? const Center(child: Text("Chưa có tin nhắn nào"))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messagedConversations.length,
                          itemBuilder: (context, index) {
                            final convo = messagedConversations[index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(convo['fullName'][0]),
                              ),
                              title: Text(convo['fullName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(convo['userName'] ?? '',
                                      style: const TextStyle(fontSize: 12)),
                                  Text(convo['lastMessage'] ?? '',
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                              onTap: () {
                                ShowGeneralDialog.Message_Room_Dialog(
                                    context: context,
                                    userId: convo['otherUserId'],
                                    userName: widget.userName,
                                    fullName: widget.fullName);
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: isTapFindMessage ? -specs.screenHeight * 0.12 : 0,
              left: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: isTapFindMessage ? 0 : 1,
                child: Container(
                  width: specs.screenWidth,
                  height: specs.screenHeight * 0.12,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            widget.userName ?? "Full Name",
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
