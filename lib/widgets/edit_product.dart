import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/my_shimmer.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/providers/gas_providers.dart';
import 'package:gas_provider/widgets/product_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? price, category, description;
  int? quantity;
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();

  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final product = ProductModel(
      name: name == null || name!.isEmpty ? widget.product.name : name,
      price: price == null || price!.isEmpty ? widget.product.price : price,
      category: category == null || category!.isEmpty
          ? widget.product.category
          : category,
      description: description == null || description!.isEmpty
          ? widget.product.description
          : description,
      id: widget.product.id,
      ownerId: widget.product.ownerId,
      quantity: quantity ?? widget.product.quantity,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product',
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      FlatButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: const Text('Delete'),
                        textColor: Colors.red,
                        onPressed: () async {
                          await Provider.of<GasProviders>(context,
                                  listen: false)
                              .deleteProduct(product.id!);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Iconsax.trash,
                color: Colors.red,
              )),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: const Text(
                'Preview',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: ProductWidget(
                product: product,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: const Text(
                'Fill in what to edit, ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey[200]),
                        child: TextFormField(
                            controller: nameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter the name of the product';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText: 'Name of product',
                                labelStyle: const TextStyle(fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                        color: kPrimaryColor, width: 1)),
                                border: InputBorder.none),
                            onChanged: (text) => {
                                  setState(() {
                                    name = text;
                                  })
                                }),
                      ),
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey[200]),
                        child: TextFormField(
                            controller: categoryController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter category of the product';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText: 'Category',
                                labelStyle: const TextStyle(fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                        color: kPrimaryColor, width: 1)),
                                border: InputBorder.none),
                            onChanged: (text) => {
                                  setState(() {
                                    category = text;
                                  })
                                }),
                      ),
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey[200]),
                        child: TextFormField(
                            controller: descriptionController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter the description of the product';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText: 'Product Description',
                                labelStyle: const TextStyle(fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                        color: kPrimaryColor, width: 1)),
                                border: InputBorder.none),
                            onChanged: (text) => {
                                  setState(() {
                                    description = text;
                                  })
                                }),
                      ),
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey[200]),
                        child: TextFormField(
                            controller: priceController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter the price of the product';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText: 'Price',
                                labelStyle: const TextStyle(fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                        color: kPrimaryColor, width: 1)),
                                border: InputBorder.none),
                            onEditingComplete: () {
                              // products.add(ProductModel(
                              //   name: name,
                              //   price: price,
                              // ));
                            },
                            onChanged: (text) => {
                                  setState(() {
                                    price = text;
                                  })
                                }),
                      ),
                      Container(
                        width: size.width,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Colors.grey[200]),
                        child: TextFormField(
                            controller: quantityController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter the quantity of the product';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                labelText:
                                    'Quantity (${widget.product.quantity} remaining)',
                                labelStyle: const TextStyle(fontSize: 14),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: const BorderSide(
                                        color: kPrimaryColor, width: 1)),
                                border: InputBorder.none),
                            onEditingComplete: () {
                              // products.add(ProductModel(
                              //   name: name,
                              //   price: price,
                              // ));
                            },
                            onChanged: (text) => {
                                  setState(() {
                                    quantity = int.parse(text);
                                  })
                                }),
                      ),
                    ])),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              height: 45,
              child: RaisedButton(
                onPressed: () async {
                  await Provider.of<GasProviders>(context, listen: false)
                      .editProduct(product);

                  setState(() {
                    price = null;
                    name = null;
                    category = null;
                    description = null;
                    priceController.clear();
                    nameController.clear();
                    categoryController.clear();
                    descriptionController.clear();
                  });
                  Navigator.pop(context);
                },
                color: kIconColor,
                child: const Text(
                  'Edit Product',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
