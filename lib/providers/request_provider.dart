import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/notifications_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestProvider with ChangeNotifier {
  final notification = NotificationsProvider();

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

    await FirebaseFirestore.instance
        .collection('providers')
        .doc(request.products!.first.ownerId!)
        .collection('products')
        .doc(request.products!.first.id!)
        .update({
      'quantity': FieldValue.increment(-request.products!.first.quantity!),
    });

    await notification.sendAcceptanceRequest(request);
    notifyListeners();
  }
}
