import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas_provider/models/product_model.dart';

class ProviderModel {
  String? id;
  final String? name;
  final String? address;
  String? ownerId;
  List<dynamic>? images;
  String? logo;
  final int? ratings;
  final int? ratingCount;
  final GeoPoint? location;
  List<ProductModel>? products;

  ProviderModel(
      {this.name,
      this.address,
      this.images,
      this.ownerId,
      this.logo,
      this.ratings,
      this.ratingCount,
      this.location,
      this.products,
      this.id});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'imageUrl': images,
      'logo': logo,
      'ratings': ratings,
      'ratingCount': ratingCount,
      'location': location,
      'id': id,
      'ownerId': ownerId
    };
  }

  factory ProviderModel.fromJson(dynamic json) {
    return ProviderModel(
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      address: json['address'] as String,
      images: json['imageUrl'] as List<dynamic>,
      logo: json['logo'] as String,
      ratings: json['ratings'] as int,
      ratingCount: json['ratingCount'] as int,
      location: json['location'] as GeoPoint,
      id: json['id'] as String,
    );
  }
}
