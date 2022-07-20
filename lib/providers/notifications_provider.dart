import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:gas_provider/models/notification_model.dart';
import 'package:gas_provider/models/request_model.dart';

class NotificationsProvider {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final userNotificationsRef = FirebaseFirestore.instance
      .collection('userData')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notifications');

  Future<void> sendAcceptanceRequest(RequestModel request) async {
    final userNotification = NotificationsModel(
      id: request.id,
      message:
          'You have accepted ${request.id} order. Waiting for driver to arrive.',
      imageUrl:
          'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/accepted-design-template-48a9e766d62c1a3829317b368fafe817_screen.jpg?ts=1611813473',
      type: 'accepted',
      senderId: uid,
      createdAt: request.createdAt,
    );

    final customerNotification = NotificationsModel(
      id: request.id,
      message:
          'You have received a new order request from${request.user!.fullName}.Please accept or reject the request',
      imageUrl:
          'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/accepted-design-template-48a9e766d62c1a3829317b368fafe817_screen.jpg?ts=1611813473',
      type: 'accepted',
      senderId: uid,
      createdAt: request.createdAt,
    );

    await userNotificationsRef.doc().set(userNotification.toJson());

    await FirebaseFirestore.instance
        .collection('userData')
        .doc(request.user!.userId!)
        .collection('notifications')
        .doc()
        .set(customerNotification.toJson());
  }
}
