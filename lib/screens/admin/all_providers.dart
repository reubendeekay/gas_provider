import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/screens/admin/widgets/all_providers_tile.dart';
import 'package:gas_provider/screens/admin/widgets/all_users_tile.dart';

class AllProviders extends StatelessWidget {
  const AllProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('providers').snapshots(),
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
                    (index) => AllProvidersTile(
                          provider: ProviderModel.fromJson(docs[index]),
                        ))),
          );
        });
  }
}
