import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RequestProvider with ChangeNotifier {
  Future<void> sendDriverAcceptance(RequestModel request, UserModel driver,
      LatLng driverInitialLocation) async {
//TO USER REQUEST POOL
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('users')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .update({
      'driver': driver.toJson(),
      'driverLocation': GeoPoint(
          driverInitialLocation.latitude, driverInitialLocation.longitude),
      'status': 'driver found',
    });
//TO SPECIFIC PROVIDER REQUEST POOL
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('providers')
        .collection(request.products!.first.ownerId!)
        .doc(request.id!)
        .update({
      'driver': driver.toJson(),
      'driverLocation': GeoPoint(
          driverInitialLocation.latitude, driverInitialLocation.longitude),
      'status': 'driver found',
    });
//TO COMMON POOL FOR NEARBY DRIVERS
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .doc(request.id!)
        .update({
      'driver': driver.toJson(),
      'driverLocation': GeoPoint(
          driverInitialLocation.latitude, driverInitialLocation.longitude),
      'status': 'driver found',
    });
    notifyListeners();
  }

  Future<void> sendProviderAcceptance(RequestModel request) async {
//TO USER REQUEST POOL
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('users')
        .collection(request.user!.userId!)
        .doc(request.id!)
        .update({
      'status': 'accepted',
    });
//TO SPECIFIC PROVIDER REQUEST POOL
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('providers')
        .collection(request.products!.first.ownerId!)
        .doc(request.id!)
        .update({
      'status': 'accepted',
    });
//TO COMMON POOL FOR NEARBY DRIVERS
    await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .doc(request.id!)
        .update({
      'status': 'accepted',
    });
    notifyListeners();
  }
}
