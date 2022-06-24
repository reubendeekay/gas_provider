import 'package:gas_provider/providers/location_provider.dart';

class UserModel {
  final String? fullName;
  String? userId;
  final String? email;
  final String? password;
  final String? phone;
  final bool? isProvider;
  final bool? isDriver;
  String? profilePic;
  String? transitId;
  final String? plateNumber;
  List<UserLocation>? locations;

  UserModel(
      {this.fullName,
      this.email,
      this.password,
      this.phone,
      this.isProvider,
      this.transitId,
      this.plateNumber,
      this.userId,
      this.locations,
      this.isDriver = false,
      this.profilePic});

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'isProvider': false,
      'isDriver': isDriver,
      'userId': userId,
      'profilePic': profilePic,
      'transitId': transitId,
      'plateNumber': plateNumber,
    };
  }

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      isProvider: json['isProvider'],
      userId: json['userId'],
      profilePic: json['profilePic'],
      transitId: json['transitId'],
      plateNumber: json['plateNumber'],
      isDriver: json['isDriver'],
    );
  }
}
