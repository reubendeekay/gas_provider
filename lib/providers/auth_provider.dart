import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/location_provider.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  ProviderModel? _provider;
  ProviderModel? get provider => _provider;

  Future<void> login(String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get()
        .then((value) {
      _user = UserModel.fromJson(value);
    });
    await getCurrentUser();

    notifyListeners();
  }

  Future<void> signup(UserModel userModel) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.email!, password: userModel.password!);

    userModel.userId = userCredential.user!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(userModel.toJson());

    await getCurrentUser();
    notifyListeners();
  }

  Future<void> getCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      return UserModel.fromJson(value);
    });

    final providerData = await FirebaseFirestore.instance
        .collection('providers')
        .doc(uid)
        .get()
        .then((value) {
      return ProviderModel.fromJson(value);
    });

    _user = userData;
    _provider = providerData;
    notifyListeners();
  }

  Future<UserLocation> getLocationDetails(LatLng loc) async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: loc.latitude,
        longitude: loc.longitude,
        googleMapApiKey: "AIzaSyDIL1xyrMndlk2dSSSSikdobR8qDjz0jjQ");

    return UserLocation(
      city: data.city,
      country: data.country,
      street: data.street_number,
      postalCode: data.postalCode,
      address: data.address,
      state: data.state,
      location: LatLng(loc.latitude, loc.longitude),
    );
  }

  void setTransitId(String? id) {
    if (id == null) {
      _user!.transitId = null;
    } else {
      _user!.transitId = id;
    }
    notifyListeners();
  }

  //REGISTER A NEW PROVIDER
  Future<void> registerProvider(ProviderModel provider, List<File> images,
      File logo, UserModel userModel) async {
    // final id = FirebaseFirestore.instance.collection('providers').doc().id;

    List<String> imageUrls = [];
    await signup(userModel);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    for (File image in images) {
      final upload = await FirebaseStorage.instance
          .ref('providers/images/${DateTime.now().toIso8601String()}')
          .putFile(image);

      final downloadUrl = await upload.ref.getDownloadURL();

      imageUrls.add(downloadUrl);
    }

    final logoUpload =
        await FirebaseStorage.instance.ref('providers/$uid').putFile(logo);

    final logoUrl = await logoUpload.ref.getDownloadURL();

    provider.id = uid;
    provider.images = imageUrls;
    provider.logo = logoUrl;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'profilePic': logoUrl,
    });

    await FirebaseFirestore.instance
        .collection('providers')
        .doc(provider.ownerId!)
        .set(provider.toJson());

    for (ProductModel product in provider.products!) {
      final productId = FirebaseFirestore.instance
          .collection('providers')
          .doc(uid)
          .collection('products')
          .doc()
          .id;

      product.id = productId;

      await FirebaseFirestore.instance
          .collection('providers')
          .doc(uid)
          .collection('products')
          .doc(productId)
          .set(product.toJson());
    }

    await FirebaseFirestore.instance
        .collection('providers')
        .doc(uid)
        .collection('account')
        .doc('finances')
        .set({
      'balance': 0,
      'totalRevenue': 0,
    });

    notifyListeners();
  }
}
