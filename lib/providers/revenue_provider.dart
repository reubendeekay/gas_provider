import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/models/invoice_models.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:provider/provider.dart';

List<String> transactionsStrings = [
  'All time',
  'Today',
  'This week',
  'This month'
];

class RevenueProvider with ChangeNotifier {
  int selectedTransactionIndex = 0;

  Future<Map<String, dynamic>> getAllTransactionsWithInvoice() async {
    final results = await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .get();

    List<RequestModel> requestData =
        results.docs.map((doc) => RequestModel.fromJson(doc)).toList();

    List<RequestModel> requests = [];

    if (selectedTransactionIndex == 0) {
      requests = requestData;
    } else if (selectedTransactionIndex == 1) {
      //Get todays requests
      requests = requestData
          .where((element) =>
              DateTime.now().difference(element.createdAt!.toDate()).inDays < 1)
          .toList();
    } else if (selectedTransactionIndex == 2) {
      //Get this week requests
      requests = requestData
          .where((element) =>
              DateTime.now().difference(element.createdAt!.toDate()).inDays < 7)
          .toList();
    } else if (selectedTransactionIndex == 3) {
      //Get this month requests
      requests = requestData
          .where((element) =>
              DateTime.now().difference(element.createdAt!.toDate()).inDays <
              30)
          .toList();
    }

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

    return {'invoice': invoice, 'requests': requests};
  }

  void setSelectedTransactionIndex(int index) {
    selectedTransactionIndex = index;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getUserPerformance() async {
    final results = await FirebaseFirestore.instance
        .collection('requests')
        .doc('common')
        .collection('drivers')
        .get();

    List<RequestModel> requestData =
        results.docs.map((doc) => RequestModel.fromJson(doc)).toList();
//Get todays requests
    List<RequestModel> todaysRequests = requestData
        .where((element) =>
            DateTime.now().difference(element.createdAt!.toDate()).inDays < 1)
        .toList();
    double todaysRevenue = todaysRequests.fold(0, (sum, element) {
      return sum + double.parse(element.total.toString());
    });
//Get yesterdays requests
    List<RequestModel> yestRequests = requestData
        .where((element) =>
            DateTime.now().difference(element.createdAt!.toDate()).inDays < 2)
        .toList();
    double yestRevenue = yestRequests.fold(0, (sum, element) {
      return sum + double.parse(element.total.toString());
    });

    final totalProvidersRevenue = requestData
        .map((k) => k.products!.first.price!)
        .reduce((a, b) => a + b);
    final totalDriversRevenue = requestData
        .map((k) => k.deliveryFee)
        .reduce((value, element) => value + element);
    //Get 2 requests with most total value
    requestData.sort((a, b) => b.total!.compareTo(a.total!));
    final top2Requests = requestData.take(2).toList();
    return {
      'totalProvidersRevenue': double.parse(totalProvidersRevenue.toString()),
      'totalDriversRevenue': totalDriversRevenue,
      'todaysRevenue': todaysRevenue,
      'assetPerfomance': todaysRevenue / yestRevenue * 100,
      'top2Requests': top2Requests,
    };
  }

  Future<List<ProviderModel>> searchProvider(String searchTerm) async {
    final results =
        await FirebaseFirestore.instance.collection('providers').get();
    final providers =
        results.docs.map((doc) => ProviderModel.fromJson(doc)).toList();

    final searchedResults = providers
        .where((element) =>
            element.name!.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    return searchedResults;
  }

  Future<Invoice> getSpecificTransactions(ProviderModel provider) async {
    final results = await FirebaseFirestore.instance
        .collection('requests')
        .doc('providers')
        .collection(provider.id!)
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
