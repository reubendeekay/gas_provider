import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/format_amount.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/providers/revenue_provider.dart';
import 'package:gas_provider/screens/orders/invoice_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ProviderTransactionDetails extends StatelessWidget {
  const ProviderTransactionDetails({Key? key, required this.provider})
      : super(key: key);
  final ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.5,
          backgroundColor: Colors.grey[50],
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(provider.logo!)),
          ),
          title: Text('${provider.name}\'s Transactions'),
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () async {
                final invoice =
                    await Provider.of<RevenueProvider>(context, listen: false)
                        .getSpecificTransactions(provider);
                final pdfFile = await PdfInvoiceApi.generate(invoice);

                PdfApi.openFile(pdfFile);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kIconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.graph,
                  size: 18,
                  color: kIconColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('requests')
              .doc('providers')
              .collection(provider.id!)
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final List<DocumentSnapshot> docs = snapshot.data!.docs;
            return ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) =>
                  listTile(RequestModel.fromJson(docs[index])),
              itemCount: docs.length,
              separatorBuilder: (ctx, index) => const Divider(),
            );
          }),
    );
  }

  ListTile listTile(RequestModel requestModel) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            CachedNetworkImageProvider(requestModel.user!.profilePic!),
      ),
      title: Text(
        requestModel.products!.first.name!,
      ),
      subtitle: Text(
        requestModel.user!.fullName!,
      ),
      trailing: Text(
        formatAmount(requestModel.total!.toStringAsFixed(2)),
        style: const TextStyle(),
      ),
    );
  }
}
