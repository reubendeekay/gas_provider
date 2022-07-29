import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/screens/admin/provider_info.dart';
import 'package:gas_provider/widgets/loading_effect.dart';
import 'package:gas_provider/widgets/product_widget.dart';

class ProviderDetails extends StatelessWidget {
  const ProviderDetails(
      {Key? key, required this.userId, required this.provider})
      : super(key: key);
  final String userId;
  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(provider.name!),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProviderInfo(
              provider: provider,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, bottom: 15),
              child: Text(
                'Products',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('providers')
                        .doc(userId)
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return LoadingEffect.getSearchLoadingScreen(context);
                      }
                      List<DocumentSnapshot> docs = snapshot.data!.docs;
                      return ListView(
                        children: docs
                            .map((doc) => ProductWidget(
                                product: ProductModel.fromJson(doc)))
                            .toList(),
                      );
                    })),
          ],
        ));
  }
}
