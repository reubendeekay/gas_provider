import 'package:flutter/material.dart';
import 'package:gas_provider/screens/home/widgets/bar_chart.dart';
import 'package:gas_provider/screens/home/widgets/overview_widget.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: const [
          OverviewWidget(),
          SizedBox(
            height: 15,
          ),
          Expanded(child: BarChart())
        ]),
      ),
    );
  }
}
