import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? senderId;
  final String? receiverId;
  final Timestamp? sentAt;
  final String? message;
  final String? mediaUrl;
  final List<File>? mediaFiles;
  final String? mediaType;
  final bool? isRead;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.sentAt,
    this.message,
    this.mediaUrl,
    this.mediaFiles,
    this.mediaType,
    this.isRead,
  });

  factory MessageModel.fromJson(dynamic json) {
    return MessageModel(
      senderId: json['sender'],
      receiverId: json['to'],
      sentAt: json['sentAt'],
      message: json['message'],
      mediaUrl: json['media'],
      mediaType: json['mediaType'],
      isRead: json['isRead'],
    );
  }
}
