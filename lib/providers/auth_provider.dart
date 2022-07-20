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
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  ProviderModel? _provider;
  ProviderModel? get provider => _provider;

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'pushToken': token});
    }).catchError((err) {});
    await getCurrentUser();

    notifyListeners();
  }

  Future<void> signup(UserModel userModel, bool isInitial) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: userModel.email!, password: userModel.password!);

    userModel.userId = userCredential.user!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(userModel.toJson());
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'pushToken': token});
    }).catchError((err) {});
    if (!isInitial) {
      await getCurrentUser();
    }
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

    if (userData.isProvider!) {
      final providerData = await FirebaseFirestore.instance
          .collection('providers')
          .doc(uid)
          .get()
          .then((value) {
        return ProviderModel.fromJson(value);
      });
      _provider = providerData;
    }

    _user = userData;
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
    await signup(userModel, true);

    final uid = FirebaseAuth.instance.currentUser!.uid;
    provider.ownerId = uid;

    for (ProductModel p in provider.products!) {
      p.ownerId = uid;
    }

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

    await getCurrentUser();

    notifyListeners();
  }

  //REGISTER A NEW PROVIDER
  Future<void> updateProvider(
    ProviderModel provider,
    List<File> images,
    File? logo,
  ) async {
    // final id = FirebaseFirestore.instance.collection('providers').doc().id;

    List<String> imageUrls = [];

    if (images.isNotEmpty) {
      for (File image in images) {
        final upload = await FirebaseStorage.instance
            .ref('providers/images/${DateTime.now().toIso8601String()}')
            .putFile(image);

        final downloadUrl = await upload.ref.getDownloadURL();

        imageUrls.add(downloadUrl);
      }
    }

    String? logoUrl;
    if (logo != null) {
      final logoUpload = await FirebaseStorage.instance
          .ref('providers/${provider.id}')
          .putFile(logo);

      logoUrl = await logoUpload.ref.getDownloadURL();
    }

    if (images.isNotEmpty) {
      provider.images = imageUrls;
    }
    if (logo != null) {
      provider.logo = logoUrl;
    }

    await FirebaseFirestore.instance
        .collection('providers')
        .doc(provider.ownerId!)
        .update(provider.toJson());

    await getCurrentUser();

    notifyListeners();
  }

  Future<void> updateProfile(UserModel userData) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userId)
        .update(userData.toJson());
    notifyListeners();
  }

  Future<void> updateProfilePic(File profile) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final upload = await FirebaseStorage.instance
        .ref('profile_pics/$uid')
        .putFile(profile);
    final url = await upload.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'profilePic': url});
    setProfilePic(url);
    notifyListeners();
  }

  void setProfilePic(String url) {
    _user!.profilePic = url;
    notifyListeners();
  }
}
