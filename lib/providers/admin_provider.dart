import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

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

  Future<void> deleteUserAccount(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    notifyListeners();
  }

  Future<void> blockUser(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isBlocked': true,
    });
    notifyListeners();
  }
}
