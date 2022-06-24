import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/providers/gas_providers.dart';
import 'package:provider/provider.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<GasProviders>(context, listen: false)
            .getIncomeAndCustomers(),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 12,
                      color: kIconColor.withOpacity(0.3),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Overview',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(width: 1, color: Colors.grey[300]!)),
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        elevation: 1,
                        child: Row(
                          children: const [
                            Text('All time'),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            child: Text(
                              'All time',
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              'Yesterday',
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              '7 days ago',
                            ),
                          ),
                          const PopupMenuItem(
                            child: Text(
                              '30 days ago',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),

                //CUSTOMERS
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(width: 1, color: Colors.grey[300]!)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Customers',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? '248'
                                  : snapshot.data!['customers'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 12,
                                        color: Colors.green[900],
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text('28%',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[900])),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    //INCOME
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: kIconColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Income',
                              style: TextStyle(
                                  color: Colors.green[900]!, fontSize: 13),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? '120'
                                  : snapshot.data!['income'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green.shade900),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.pink[100],
                                      borderRadius: BorderRadius.circular(3)),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 12,
                                        color: Colors.pink[900],
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text('10%',
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.pink[900])),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
