import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/my_nav.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/providers/gas_providers.dart';
import 'package:gas_provider/providers/location_provider.dart';
import 'package:gas_provider/screens/home/home_page.dart';

import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({Key? key}) : super(key: key);

  @override
  State<InitialLoadingScreen> createState() => InitialLoadingScreenState();
}

class InitialLoadingScreenState extends State<InitialLoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<AuthProvider>(context, listen: false).getCurrentUser();
      await Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation();

      Get.offAll(() => const MyNav());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 250,
          width: 250,
          child: Lottie.asset('assets/loading.json'),
        ),
      ),
    );
  }
}
