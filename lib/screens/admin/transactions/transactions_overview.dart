import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/format_amount.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/providers/admin_provider.dart';
import 'package:gas_provider/providers/revenue_provider.dart';
import 'package:gas_provider/screens/admin/search_screen.dart';
import 'package:gas_provider/screens/orders/invoice_screen.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class TransactionsOverview extends StatefulWidget {
  const TransactionsOverview({Key? key}) : super(key: key);

  @override
  State<TransactionsOverview> createState() => _TransactionsOverviewState();
}

class _TransactionsOverviewState extends State<TransactionsOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Overview'),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              Get.to(() => const SearchScreen());
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kIconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.search_normal,
                size: 18,
                color: kIconColor,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder<Map<String, dynamic>>(
          future: Provider.of<RevenueProvider>(context, listen: false)
              .getUserPerformance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final providersT = snapshot.data!['totalProvidersRevenue'];
            final driversT = snapshot.data!['totalDriversRevenue'];
            final todaysRevenue = snapshot.data!['todaysRevenue'];
            final assetPerformance = snapshot.data!['assetPerfomance'];
            final top2Requests = snapshot.data!['top2Requests'];

            return ListView(
              children: [
                AssetPerformanceWidget(
                  amount: todaysRevenue.toStringAsFixed(2),
                  percentage: assetPerformance == null
                      ? '0.00'
                      : assetPerformance.toStringAsFixed(2),
                ),
                RevenueCardWidget(
                  amount: (driversT + providersT).toStringAsFixed(2),
                  top2: top2Requests,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'User Performance',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    UserPerformanceWidget(
                      title: 'Providers',
                      amount: providersT.toStringAsFixed(2),
                      percentage: providersT / (providersT + driversT),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    UserPerformanceWidget(
                      title: 'Drivers',
                      amount: driversT.toStringAsFixed(2),
                      percentage: driversT / (providersT),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                FutureBuilder<Map<String, dynamic>>(
                    future: Provider.of<RevenueProvider>(context, listen: false)
                        .getAllTransactionsWithInvoice(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final List<RequestModel> requests =
                          snapshot.data!['requests'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Transactions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  final pdfFile = await PdfInvoiceApi.generate(
                                      snapshot.data!['invoice']);

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
                              Container(
                                padding: const EdgeInsets.only(left: 15),
                                height: 40,
                                width: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1, color: Colors.grey[300]!)),
                                child: PopupMenuButton(
                                  padding: EdgeInsets.zero,
                                  elevation: 1,
                                  child: Row(
                                    children: [
                                      Text(transactionsStrings[
                                          Provider.of<RevenueProvider>(
                                        context,
                                      ).selectedTransactionIndex]),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (context) => List.generate(
                                      transactionsStrings.length,
                                      (index) => PopupMenuItem(
                                            value: index,
                                            child: Text(
                                                transactionsStrings[index]),
                                          )),
                                  onSelected: (int value) {
                                    Provider.of<RevenueProvider>(
                                      context,
                                    ).setSelectedTransactionIndex(value);
                                    setState(() {});
                                  },
                                ),
                              )
                            ],
                          ),
                          if (snapshot.connectionState == ConnectionState.done)
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) =>
                                    myListTile(requests[index])),
                                separatorBuilder: (ctx, i) => const Divider(),
                                itemCount: requests.length)
                        ],
                      );
                    }),
                const SizedBox(
                  height: 15,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserPerformanceWidget extends StatelessWidget {
  const UserPerformanceWidget({
    this.amount = '1930',
    this.percentage = 0.5,
    this.title,
    Key? key,
  }) : super(key: key);
  final String amount;
  final double percentage;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Providers',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              formatAmount(amount),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 5,
              child: Stack(
                children: [
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: kIconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${(percentage * 100).toStringAsFixed(2)}% of total',
              style: const TextStyle(color: kIconColor),
            ),
          ],
        ),
      ),
    );
  }
}

class RevenueCardWidget extends StatelessWidget {
  const RevenueCardWidget({
    required this.amount,
    required this.top2,
    Key? key,
  }) : super(key: key);
  final String amount;
  final List<RequestModel> top2;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  formatAmount(amount),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                const Text(
                  'Revenue generated',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[800]!,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(top2.length, (index) => listTile(top2[index])),
              Container(
                height: 45,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: RaisedButton(
                  onPressed: () async {
                    final invoice =
                        await Provider.of<AdminProvider>(context, listen: false)
                            .getAllTransactions(context);
                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                  },
                  color: kIconColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: const Text('Print all Transactions'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListTile listTile(RequestModel requestModel) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            CachedNetworkImageProvider(requestModel.user!.profilePic!),
      ),
      title: Text(
        requestModel.user!.fullName!,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        requestModel.user!.phone!.replaceRange(3, 7, '** **** *'),
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        formatAmount(requestModel.total!.toStringAsFixed(2)),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class AssetPerformanceWidget extends StatelessWidget {
  const AssetPerformanceWidget({
    required this.amount,
    required this.percentage,
    Key? key,
  }) : super(key: key);
  final String amount;
  final String percentage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Asset performance',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Today',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                  color: kIconColor, borderRadius: BorderRadius.circular(10)),
              child: Text(
                '$percentage%',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              '+ KES $amount',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

ListTile myListTile(RequestModel requestModel) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage:
          CachedNetworkImageProvider(requestModel.user!.profilePic!),
    ),
    title: Text(
      requestModel.user!.fullName!,
    ),
    subtitle: Text(
      requestModel.user!.phone!.replaceRange(3, 7, '** **** *'),
    ),
    trailing: Text(
      formatAmount(requestModel.total!.toStringAsFixed(2)),
      style: const TextStyle(),
    ),
  );
}
