import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsModel {
  final String? id;
  final String? message;
  final String? imageUrl;
  final String? type;
  final String? senderId;
  final Timestamp? createdAt;

  NotificationsModel(
      {this.id,
      this.message,
      this.imageUrl,
      this.type,
      this.senderId,
      this.createdAt});

  factory NotificationsModel.fromJson(dynamic json) {
    return NotificationsModel(
      id: json['id'],
      message: json['message'],
      imageUrl: json['imageUrl'],
      type: json['type'],
      createdAt: json['createdAt'],
    );
  }
}
