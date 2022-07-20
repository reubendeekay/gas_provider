import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';

class TotalUsersCard extends StatelessWidget {
  const TotalUsersCard(
      {Key? key, this.percentage, this.color, this.totalUsers, this.title})
      : super(key: key);
  final String? totalUsers;
  final String? title;
  final String? percentage;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: color ?? kPrimaryColor,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ?? 'Total Users',
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 15),
              Text(
                totalUsers ?? '220',
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart, color: kIconColor),
                  Text(percentage ?? '+60%',
                      style: const TextStyle(fontSize: 12, color: kIconColor)),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  Icon(Icons.arrow_drop_up_sharp, color: kIconColor),
                  Text('100',
                      style: TextStyle(fontSize: 12, color: kIconColor)),
                  SizedBox(
                    width: 30,
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.red),
                  Text('30', style: TextStyle(fontSize: 12, color: kIconColor)),
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
