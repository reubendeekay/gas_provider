import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/screens/products/widgets/on_delivery_tile.dart';
import 'package:gas_provider/widgets/edit_product.dart';
import 'package:gas_provider/widgets/loading_effect.dart';
import 'package:gas_provider/widgets/product_widget.dart';
import 'package:get/route_manager.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          const AddProductTile(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('providers')
                      .doc(uid)
                      .collection('products')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingEffect.getSearchLoadingScreen(context);
                    }
                    List<DocumentSnapshot> docs = snapshot.data!.docs;
                    return ListView(
                      children: docs
                          .map((doc) => GestureDetector(
                                onTap: () {
                                  Get.to(() => EditProductScreen(
                                      product: ProductModel.fromJson(doc)));
                                },
                                child: ProductWidget(
                                    product: ProductModel.fromJson(doc)),
                              ))
                          .toList(),
                    );
                  }))
        ]),
      ),
    );
  }
}
