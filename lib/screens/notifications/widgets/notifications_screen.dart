import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/notification_model.dart';
import 'package:gas_provider/screens/notifications/widgets/notifications_tile.dart';
import 'package:gas_provider/widgets/loading_effect.dart';

class NotificationsScreen extends StatelessWidget {
  static const routeName = '/notifications';
  NotificationsScreen({Key? key}) : super(key: key);

  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userData')
              .doc('users')
              .collection(uid)
              .orderBy('createdAt')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingEffect.getSearchLoadingScreen(context);
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(
                child: Text('No Notifications'),
              );
            }
            return ListView(
                children: List.generate(
                    docs.length,
                    (index) => NotificationsTile(
                          notification:
                              NotificationsModel.fromJson(docs[index]),
                        )));
          }),
    );
  }
}
