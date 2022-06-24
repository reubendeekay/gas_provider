import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

String calculateTime(LatLng locData, LatLng userLocation) {
  final distance = calculateDistance(locData.latitude, locData.longitude,
      userLocation.latitude, userLocation.longitude);

  final timeInHours = (distance / 45);

  if (timeInHours < 1) {
    return '${(timeInHours * 60.0).toStringAsFixed(0)} mins';
  } else if (timeInHours % 1 == 0) {
    return '${(timeInHours).toStringAsFixed(0)} hrs';
  } else {
    final minRem = timeInHours % 1;
    final hrs = timeInHours.floor();
    final mins = (minRem * 60).floor();

    return '$hrs hrs $mins mins';
  }
}

LatLng calculateLatLng(GeoPoint locData) {
  return LatLng(locData.latitude, locData.longitude);
}
