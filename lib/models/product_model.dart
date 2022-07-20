class ProductModel {
  String? id;
  final String? name;
  final String? category;
  String? ownerId;
  final String? price;
  final String? description;
  int? quantity;

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
      'description': description,
      'quantity': quantity,
    };
  }

  factory ProductModel.fromJson(dynamic json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      ownerId: json['ownerId'],
      price: json['price'],
      description: json['description'],
      quantity: json['quantity'],
    );
  }
}
