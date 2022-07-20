import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/providers/gas_providers.dart';
import 'package:gas_provider/screens/orders/invoice_screen.dart';
import 'package:gas_provider/screens/orders/widgets/order_widget.dart';
import 'package:gas_provider/screens/orders/widgets/orders_stats.dart';
import 'package:gas_provider/widgets/loading_effect.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool isDownloading = false;
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          InkWell(
            onTap: () async {
              setState(() {
                isDownloading = true;
              });
              final invoice =
                  await Provider.of<GasProviders>(context, listen: false)
                      .getAllTransactions(context);
              final pdfFile = await PdfInvoiceApi.generate(invoice);
              setState(() {
                isDownloading = false;
              });

              PdfApi.openFile(pdfFile);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kIconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: isDownloading
                  ? SizedBox(
                      child: Transform.scale(
                        scale: 0.6,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : const Icon(
                      Iconsax.printer,
                      size: 18,
                      color: kIconColor,
                    ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>>(
              future: Provider.of<GasProviders>(context, listen: false)
                  .getCompletedOrders(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      snapshot.connectionState == ConnectionState.waiting &&
                              snapshot.data == null
                          ? const OrdersStats()
                          : OrdersStats(
                              progress: double.parse(
                                  snapshot.data!['progress'].toString()),
                              value:
                                  snapshot.data!['completedOrders'].toString(),
                            ),
                      const SizedBox(
                        width: 15,
                      ),
                      snapshot.connectionState == ConnectionState.waiting &&
                              snapshot.data == null
                          ? const OrdersStats(
                              color: kPrimaryColor,
                              progress: 0.8,
                              title: 'Retention',
                              value: '298',
                            )
                          : OrdersStats(
                              color: kPrimaryColor,
                              progress: double.parse(
                                  snapshot.data!['retention'].toString()),
                              title: 'Retention',
                              value: snapshot.data!['returnedCustomers']
                                  .toString(),
                            ),
                    ],
                  ),
                );
              }),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('requests/providers/$uid')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingEffect.getSearchLoadingScreen(context);
                  }

                  List<DocumentSnapshot> docs = snapshot.data!.docs;

                  return ListView(
                    padding: EdgeInsets.zero,
                    children: List.generate(
                        docs.length,
                        (index) => OrderWidget(
                              request: RequestModel.fromJson(docs[index]),
                              index: index + 1,
                            )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
