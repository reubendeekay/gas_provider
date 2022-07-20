import 'package:cached_network_image/cached_network_image.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/message_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/chat_provider.dart';

import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  final UserModel user;
  final String chatRoomId;

  const ChatRoom(this.user, {Key? key, required this.chatRoomId})
      : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Widget _buildReceiveMessage(MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    color: kIconColor.withOpacity(0.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            message.message!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: message.message!.length < 15 ? 15 : 3,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat('HH:mm ').format(message.sentAt!.toDate()),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSendMessage(MessageModel message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            message.message!,
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: message.message!.length < 15 ? 15 : 3,
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat('HH:mm ').format(message.sentAt!.toDate()),
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              color: kIconColor.withOpacity(0.3),
              child: Row(
                children: [
                  InkWell(
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.user.profilePic!),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user.fullName!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.user.phone!,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('sentAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                List<DocumentSnapshot> docs = snapshot.data!.docs;

                return ListView(
                  reverse: true,
                  children: List.generate(docs.length, (index) {
                    final message = MessageModel.fromJson(docs[index]);
                    return message.senderId == uid
                        ? Column(
                            children: [
                              _buildSendMessage(message),
                              const SizedBox(height: 16),
                            ],
                          )
                        : Column(
                            children: [
                              _buildReceiveMessage(message),
                              const SizedBox(height: 16),
                            ],
                          );
                  }),
                );
              },
            )),
            Container(
              margin: const EdgeInsets.fromLTRB(14, 5, 14, 14),
              child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Type Something ...',
                    hintStyle: const TextStyle(fontSize: 14),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: InputBorder.none,
                    filled: true,
                    fillColor: kIconColor.withOpacity(0.3),
                    suffixIcon: InkWell(
                      onTap: () {
                        if (messageController.text.isEmpty) {
                          return;
                        }
                        final MessageModel userMessage = MessageModel(
                          senderId: uid,
                          message: messageController.text,
                          mediaFiles: [],
                          mediaType: 'text',
                          isRead: false,
                          receiverId: widget.user.userId,
                          sentAt: Timestamp.now(),
                        );
                        Provider.of<ChatProvider>(context, listen: false)
                            .sendMessage(widget.chatRoomId, userMessage,
                                widget.user.userId!);
                        messageController.clear();
                      },
                      child: const Icon(
                        Iconsax.send_1,
                        color: kIconColor,
                        size: 20,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
