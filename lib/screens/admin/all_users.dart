import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/screens/admin/widgets/all_users_tile.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return Container(
            padding: const EdgeInsets.all(15),
            child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(
                    docs.length,
                    (index) => AllUsersTile(
                          user: UserModel.fromJson(docs[index]),
                        ))),
          );
        });
  }
}
