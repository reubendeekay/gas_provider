import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/screens/auth/login.dart';
import 'package:get/route_manager.dart';

class OtherSettings extends StatelessWidget {
  const OtherSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tile(),
          tile(title: 'Status'),
          tile(
            title: 'About',
          ),
          tile(
              title: 'Log out',
              color: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginScreen());
              }),
        ],
      ),
    );
  }

  Widget tile({String? title, Function? onTap, Color? color}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title ?? 'App Updates',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: color),
          )),
    );
  }
}
