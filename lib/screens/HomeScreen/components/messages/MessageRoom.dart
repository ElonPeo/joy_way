import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/GeneralSpecifications.dart';
import '../../../../services/FirebaseServices/MessageService.dart';

class MessageRoom extends StatefulWidget {
  final String? userId;
  final String? userName;
  final String? fullName;

  const MessageRoom({
    super.key,
    required this.userId,
    required this.userName,
    required this.fullName,
  });

  @override
  State<MessageRoom> createState() => _MessageRoomState();
}

class _MessageRoomState extends State<MessageRoom> {
  final TextEditingController _messageController = TextEditingController();
  String? conversationId;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _setupConversation();
  }

  Future<void> _setupConversation() async {
    final existing = await MessageService().findConversation(currentUserId, widget.userId!);
    if (existing != null) {
      setState(() {
        conversationId = existing.id;
      });
    } else {
      final created = await MessageService().createConversation(currentUserId, widget.userId!);
      setState(() {
        conversationId = created.id;
      });
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isNotEmpty && widget.userId != null) {
      await MessageService().sendMessage(currentUserId, widget.userId!, text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final specs = GeneralSpecifications(context);
    return Material(
      color: Colors.white,
      child: Stack(
        children: [
          conversationId == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
            padding: EdgeInsets.only(bottom: 100, top: specs.screenHeight * 0.12),
            child: StreamBuilder<QuerySnapshot>(
              stream: MessageService().getMessages(conversationId!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          msg['text'],
                          style: TextStyle(color: isMe ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // App bar
          Container(
            height: specs.screenHeight * 0.12,
            width: specs.screenWidth,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: specs.bl240, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                ),
                Container(
                  height: 65,
                  width: specs.screenWidth - 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person),
                    ),
                    title: Text(widget.fullName ?? 'No Name'),
                    subtitle: Text(widget.userName ?? ''),
                  ),
                ),
              ],
            ),
          ),

          // Input message
          Positioned(
            bottom: 0,
            left: 15,
            right: 15,
            child: Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 240, 240, 1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Icon(Icons.camera_alt, color: specs.bl80),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: "Message...",
                        hintStyle: GoogleFonts.outfit(
                          color: specs.bl80,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
