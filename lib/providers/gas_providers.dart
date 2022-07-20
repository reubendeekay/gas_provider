import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gas_provider/models/invoice_models.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GasProviders extends ChangeNotifier {
  List<ProviderModel> _providers = [];

  List<ProviderModel> get providers => _providers;

  int? overviewTime;

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

  Future<void> addProducts(List<ProductModel> products) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    for (ProductModel p in products) {
      final prodRef = FirebaseFirestore.instance
          .collection('providers')
          .doc(uid)
          .collection('products')
          .doc();
      p.id = prodRef.id;
      p.ownerId = uid;
      await prodRef.set(p.toJson());
    }

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

    if (overviewTime == null) {
      final income = requests.fold(
          0, (sum, request) => double.parse(sum!.toString()) + request.total!);

//Get each unique customer per user id
      final customers =
          requests.map((request) => request.user!.userId!).toSet();

      notifyListeners();
      return {
        'income': income.toStringAsFixed(0),
        'customers': customers.length,
      };
    } else {
      final newRequests = requests
          .where((r) => r.createdAt!
              .toDate()
              .isAfter(DateTime.now().subtract(Duration(days: overviewTime!))))
          .toList();

      final income = newRequests.fold(
          0, (sum, request) => double.parse(sum!.toString()) + request.total!);

//Get each unique customer per user id
      final customers =
          newRequests.map((request) => request.user!.userId!).toSet();

      notifyListeners();

      return {
        'income': income.toStringAsFixed(0),
        'customers': customers.length,
      };
    }
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
      'progress': completedOrders.isEmpty
          ? 0
          : completedOrders.length / requests.length,
      'customers': customers.length,
      'returnedCustomers': customersWithMoreThanOneOccurence.length,
      'retention':
          customersWithMoreThanOneOccurence.isEmpty || customers.isEmpty
              ? 0
              : customersWithMoreThanOneOccurence.length / customers.length,
    };
  }

  Future<void> deleteProduct(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('providers')
        .doc(uid)
        .collection('products')
        .doc(id)
        .delete();

    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getWeekIncome() async {
    List<String> daysOfTheWeek = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final orderResults = await FirebaseFirestore.instance
        .collection('/requests/providers/$uid')
        .get();

    final requests = orderResults.docs
        .where((element) => element['createdAt']
            .toDate()
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .map((doc) => RequestModel.fromJson(doc))
        .toList();

    List<Map<String, dynamic>> sales = [];

    //get total sales for each day for the current week
    for (int i = 0; i < daysOfTheWeek.length; i++) {
      double sum = 0.0;
      for (RequestModel r in requests) {
        if (DateFormat('EEE').format(r.createdAt!.toDate()) ==
            daysOfTheWeek[i]) {
          sum += r.total!;
        }
      }
      sales.add({
        'domain': daysOfTheWeek[i],
        'measure': sum,
      });
    }

    notifyListeners();

    return sales;
  }

  Future<Invoice> getAllTransactions(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final results = await FirebaseFirestore.instance
        .collection('requests')
        .doc('providers')
        .collection(uid)
        .get();

    final provider =
        Provider.of<AuthProvider>(context, listen: false).provider!;

    List<RequestModel> requests =
        results.docs.map((doc) => RequestModel.fromJson(doc)).toList();

    final invoice = Invoice(
        info: InvoiceInfo(
          date: DateTime.now(),
          dueDate: DateTime.now(),
          description: 'All transacations to date',
          number: uid.substring(0, 11),
        ),
        supplier: Supplier(
            name: provider.name!,
            address: provider.address!,
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
