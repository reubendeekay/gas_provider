import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/providers/admin_provider.dart';
import 'package:gas_provider/screens/admin/widgets/total_users_card.dart';
import 'package:provider/provider.dart';

class AdminOverview extends StatelessWidget {
  const AdminOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<Map<String, dynamic>>(
              future: Provider.of<AdminProvider>(context, listen: false)
                  .getAllUserData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(children: const [
                    TotalUsersCard(),
                    TotalUsersCard(
                      color: kIconColor,
                      percentage: '40%',
                    ),
                    TotalUsersCard(
                      color: Colors.grey,
                      percentage: '10%',
                    ),
                  ]);
                }

                final userData = snapshot.data!;

                return Column(children: [
                  TotalUsersCard(
                    title: 'Total Users',
                    totalUsers: userData['users'],
                  ),
                  TotalUsersCard(
                    title: 'Total Drivers',
                    totalUsers: userData['drivers'],
                    color: kIconColor,
                  ),
                  TotalUsersCard(
                    title: 'Total Providers',
                    totalUsers: userData['providers'],
                    color: Colors.grey,
                  ),
                ]);
              }),
          const Text('User Retention',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: size.height * 0.4,
            child: DChartBar(
              data: const [
                {
                  'id': 'Bar',
                  'data': [
                    {'domain': 'Mon', 'measure': 3},
                    {'domain': 'Tue', 'measure': 4},
                    {'domain': 'Wed', 'measure': 6},
                    {'domain': 'Thur', 'measure': 3},
                    {'domain': 'Fri', 'measure': 6},
                    {'domain': 'Sat', 'measure': 5},
                    {'domain': 'Sun', 'measure': 4},
                  ],
                },
              ],
              domainLabelPaddingToAxisLine: 15,
              minimumPaddingBetweenLabel: 15,
              axisLineTick: 2,
              axisLinePointTick: 2,
              axisLinePointWidth: 10,
              axisLineColor: Colors.grey[300],
              measureLabelPaddingToAxisLine: 16,
              animationDuration: const Duration(seconds: 1),
              barColor: (barData, index, id) => kIconColor,
              showBarValue: true,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
