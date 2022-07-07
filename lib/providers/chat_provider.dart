import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:gas_provider/models/message_model.dart';
import 'package:gas_provider/models/user_model.dart';

class ChatTileModel {
  final UserModel? user;
  String? latestMessage;
  Timestamp? time;
  final String? latestMessageSenderId;
  final String? chatRoomId;

  ChatTileModel({
    this.user,
    this.latestMessage,
    this.time,
    this.chatRoomId,
    this.latestMessageSenderId,
  });
}

class ChatProvider with ChangeNotifier {
  /////////////////SEND MESSAGE////////////////////////
  Future<void> sendMessage(
      String chatRoomId, MessageModel message, String driverId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String url = '';

/*
Chatroom Id is the unique id for colletion containing all the messages
It is the same as the request id since the chat is available only during the request(transit)
  */

    await Future.forEach(message.mediaFiles!, (File element) async {
      final fileData = await FirebaseStorage.instance
          .ref('chatFiles/$uid/${DateTime.now().toIso8601String()}')
          .putFile(element);
      url = await fileData.ref.getDownloadURL();
    });
    final room = FirebaseFirestore.instance.collection('chats').doc(chatRoomId);

    room.get().then((value) async => {
          if (value.exists)
            {
              await room.update({
                'latestMessage':
                    message.message!.isNotEmpty ? message.message : 'photo',
                'sentAt': Timestamp.now(),
                'sentBy': uid,
              }),
              await room.collection('messages').doc().set({
                'message': message.message!.isNotEmpty
                    ? message.message
                    : url.isNotEmpty
                        ? 'photo'
                        : 'text',
                'sender': uid,
                'to': driverId,
                'media': url,
                'mediaType': message.mediaType,
                'isRead': false,
                'sentAt': Timestamp.now()
              })
            }
          else
            {
              await room.set({
                'user': uid,
                'driver': driverId,
                'startedAt': Timestamp.now(),
                'latestMessage':
                    message.message!.isNotEmpty ? message.message : '',
                'sentAt': Timestamp.now(),
                'sentBy': uid,
              }),
              await room.collection('messages').doc().set({
                'message': message.message ?? '',
                'sender': uid,
                'to': driverId,
                'media': url,
                'mediaType': message.mediaType,
                'isRead': false,
                'sentAt': Timestamp.now()
              }),
            }
        });

    notifyListeners();
  }

  Future<List<ChatTileModel>> getChats() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    List<ChatTileModel> users = [];

    final allChats = await FirebaseFirestore.instance
        .collection('chats')
        .where('user', isEqualTo: uid)
        .get();

    await Future.forEach(allChats.docs, (QueryDocumentSnapshot element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(element['driver'])
          .get()
          .then((value) => {
                // print(value['username']),
                if (value.exists)
                  {
                    users.add(
                      ChatTileModel(
                          chatRoomId: element.id,
                          latestMessageSenderId: element['sentBy'],
                          user: UserModel.fromJson(value),
                          latestMessage: element['latestMessage'],
                          time: element['sentAt']),
                    ),
                  }
              });
    });

    users.sort((a, b) => b.time!.compareTo(a.time!));

    return users;

    notifyListeners();
  }

  Future<List<ChatTileModel>> searchUser(String searchTerm) async {
    List<UserModel> users = [];

    final results = await FirebaseFirestore.instance.collection('users').get();
    results.docs
        .where((element) =>
            element['fullName']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            element['phoneNumber']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            element['fullName']
                .toLowerCase()
                .contains(searchTerm.toLowerCase()))
        .forEach((e) {
      users.add(UserModel.fromJson(e));
    });
    print(users.length);

    notifyListeners();
    return users.map((e) => ChatTileModel(user: e, chatRoomId: '')).toList();
  }
}
