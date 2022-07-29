import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/invoice_models.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

class AdminProvider with ChangeNotifier {
  Future<Map<String, dynamic>> getAllUserData() async {
    final userData = await FirebaseFirestore.instance.collection('users').get();

    final providersLength =
        userData.docs.where((e) => e['isProvider'] == true).toList().length;

    final driversLength =
        userData.docs.where((e) => e['isDriver'] == true).toList().length;

    final allUsers = userData.docs.length;

    notifyListeners();
    return {
      'users': allUsers.toString(),
      'providers': providersLength.toString(),
      'drivers': driversLength.toString(),
    };
  }

  Future<void> revokeUserRight(String uid, bool isDriver) async {
    if (isDriver) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isDriver': false,
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isProvider': false,
      });
    }

    notifyListeners();
  }

  Future<void> makeAdmin(String uid, bool isAdmin) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isAdmin': !isAdmin,
    });

    notifyListeners();
  }

  Future<void> deleteUserAccount(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    notifyListeners();
  }

  Future<void> blockUser(String uid) async {
    try {
      await http.post(
          Uri.parse(
              'https://us-central1-gas-app-26a73.cloudfunctions.net/disableUser'),
          body: {'uid': uid});
      Get.snackbar('User blocked', 'User has been blocked',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: kIconColor,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: kIconColor,
          borderWidth: 2,
          colorText: Colors.white,
          icon: const Icon(
            Icons.block,
            color: Colors.white,
          ));
    } catch (e) {
      Get.snackbar('Failed to Block User', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          borderColor: Colors.red,
          borderWidth: 2);
    }

    notifyListeners();
  }

  Future<Invoice> getAllTransactions(BuildContext context) async {
    final results = await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .get();

    List<RequestModel> requests =
        results.docs.map((doc) => RequestModel.fromJson(doc)).toList();

    final invoice = Invoice(
        info: InvoiceInfo(
          date: DateTime.now(),
          dueDate: DateTime.now(),
          description: 'All transacations to date',
          number: 'All',
        ),
        supplier: const Supplier(
            name: 'System admin',
            address: 'Confidential',
            paymentInfo: 'Mpesa'),
        customer: const Customer(name: 'From all Customers'),
        items: requests
            .map((k) => InvoiceItem(
                description: k.products!.first.name!,
                date: k.createdAt!.toDate(),
                quantity: 1,
                name: k.user!.fullName!,
                unitPrice: double.parse(k.products!.first.price!)))
            .toList());
    notifyListeners();
    return invoice;
  }
}
