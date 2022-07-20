import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';

class OrdersStats extends StatelessWidget {
  const OrdersStats({
    Key? key,
    this.title,
    this.value,
    this.progress,
    this.color,
  }) : super(key: key);
  final String? title;
  final String? value;
  final double? progress;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    print(progress);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Colors.grey[300]!)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title ?? 'Completed',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(value ?? '128'),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Progress',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 5,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color != null
                  ? color!.withOpacity(0.3)
                  : kIconColor.withOpacity(0.3),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
                widthFactor: progress ?? 0.6,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: color ?? kIconColor),
                )),
          )
        ]),
      ),
    );
  }
}
