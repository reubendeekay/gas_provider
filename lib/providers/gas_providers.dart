import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/request_model.dart';

class GasProviders extends ChangeNotifier {
  List<ProviderModel> _providers = [];

  List<ProviderModel> get providers => _providers;

  //EDIT PRODUCT
  Future<void> editProduct(ProductModel product) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('providers')
        .doc(uid)
        .collection('products')
        .doc(product.id)
        .update(product.toJson());

    notifyListeners();
  }

// Number of Customers and income
  Future<Map<String, dynamic>> getIncomeAndCustomers() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final orderResults = await FirebaseFirestore.instance
        .collection('/requests/providers/$uid')
        .get();

    final requests =
        orderResults.docs.map((doc) => RequestModel.fromJson(doc)).toList();

    final income = requests.fold(
        0, (sum, request) => double.parse(sum!.toString()) + request.total!);

//Get each unique customer per user id
    final customers = requests.map((request) => request.user!.userId!).toSet();

    notifyListeners();
    return {
      'income': income.toStringAsFixed(0),
      'customers': customers.length,
    };
  }

//Get completed orders
  Future<Map<String, dynamic>> getCompletedOrders() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final orderResults = await FirebaseFirestore.instance
        .collection('/requests/providers/$uid')
        .get();

    final requests =
        orderResults.docs.map((doc) => RequestModel.fromJson(doc)).toList();

    final completedOrders = requests
        .where((request) =>
            request.status == 'completed' || request.status == 'done')
        .toList();
    //Get length of each unique customer per user id
    final customers =
        completedOrders.map((request) => request.user!.userId!).toSet();

    //Number of occurences of each unique customer per user id
    final customerCount = customers.map((customer) {
      final count = completedOrders
          .where((request) => request.user!.userId == customer)
          .length;
      return {'customer': customer, 'count': count};
    }).toList();

    //Customers who have more than 1 occurence
    final customersWithMoreThanOneOccurence = customerCount
        .where((customer) => int.parse(customer['count'].toString()) > 1)
        .toList();

    notifyListeners();

    return {
      'completedOrders': completedOrders.length,
      'progress': completedOrders.length / requests.length,
      'customers': customers.length,
      'returnedCustomers': customersWithMoreThanOneOccurence.length,
    };
  }
}
