import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MyShimmer extends StatelessWidget {
  const MyShimmer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.8),
        highlightColor: Colors.grey.withOpacity(0.2),
        enabled: true,
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 3000),
        child: child);
  }
}
