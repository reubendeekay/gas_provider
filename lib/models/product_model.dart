class ProductModel {
  String? id;
  final String? name;
  final String? category;
  final String? ownerId;
  final String? price;
  final String? description;
  double quantity;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.ownerId,
    this.price,
    this.description,
    this.quantity = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'ownerId': ownerId,
      'price': price,
      'description': description
    };
  }

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      ownerId: json['ownerId'] as String,
      price: json['price'] as String,
      description: json['description'] as String,
    );
  }
}
