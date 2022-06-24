import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/providers/gas_providers.dart';
import 'package:gas_provider/widgets/add_on_map.dart';
import 'package:gas_provider/widgets/add_product.dart';
import 'package:gas_provider/widgets/my_text_field.dart';
import 'package:gas_provider/widgets/option_list_tile.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class RegisterProvider extends StatefulWidget {
  const RegisterProvider({Key? key}) : super(key: key);

  @override
  State<RegisterProvider> createState() => _RegisterProviderState();
}

class _RegisterProviderState extends State<RegisterProvider> {
  List<ProductModel> _products = [];
  LatLng? _location;
  List<File> images = [];
  File? logo;
  String? name, address, businessName, email, phone, password, description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Provider'),
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  children: [
                    const Text(
                      'Account Details',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    MyTextField(
                        labelText: 'Owner name',
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextField(
                        labelText: 'Email address',
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextField(
                        labelText: 'Phone number',
                        onChanged: (val) {
                          setState(() {
                            phone = val;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextField(
                        labelText: 'Password',
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Business Details',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    MyTextField(
                      labelText: 'Name of business',
                      onChanged: (val) {
                        setState(() {
                          businessName = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    MyTextField(
                      labelText: 'Address',
                      onChanged: (val) {
                        setState(() {
                          address = val;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OptionListTile(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      isComplete: _location != null,
                      onChanged: () {
                        Get.to(() => AddOnMap(
                              onSelectLocation: (val) {
                                setState(() {
                                  _location = val;
                                });
                              },
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    OptionListTile(
                      icon: Icons.sell_outlined,
                      isComplete: _products.isNotEmpty,
                      title: 'Products',
                      onChanged: () {
                        Get.to(() => AddProducts(
                              onCompleted: (val) {
                                setState(() {
                                  _products = val;
                                });
                              },
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Photos',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    OptionListTile(
                      icon: Icons.camera_outlined,
                      title: 'Logo',
                      isComplete: logo != null,
                      onChanged: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                                // allowedExtensions: ['png', 'jpeg', 'webp'],
                                type: FileType.image);

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          setState(() {
                            logo = file;
                          });
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                              type: FileType.image,
                            );

                            if (result != null) {
                              List<File> files = result.paths
                                  .map((path) => File(path!))
                                  .toList();
                              setState(() {
                                images = files;
                              });
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Center(
                              child: Icon(Iconsax.camera),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7.5,
                        ),
                        Expanded(
                            child: SizedBox(
                                height: 80,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(
                                      images.length,
                                      (index) => Container(
                                            height: 80,
                                            width: 120,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 7.5),
                                            child: Image.file(
                                              images[index],
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              height: 45,
              child: RaisedButton(
                onPressed: name == null &&
                        address == null &&
                        businessName == null &&
                        email == null &&
                        phone == null &&
                        password == null &&
                        _location == null &&
                        _products.isEmpty &&
                        logo == null &&
                        images.isEmpty
                    ? () {
                        if (name == null) {
                          Get.snackbar('Error', 'Please enter your name',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (address == null) {
                          Get.snackbar('Error', 'Please enter your address',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (businessName == null) {
                          Get.snackbar(
                              'Error', 'Please enter your business name',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (email == null) {
                          Get.snackbar('Error', 'Please enter your email',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (phone == null) {
                          Get.snackbar(
                              'Error', 'Please enter your phone number',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (password == null) {
                          Get.snackbar('Error', 'Please enter your password',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (_location == null) {
                          Get.snackbar('Error', 'Please select your location',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (_products.isEmpty) {
                          Get.snackbar('Error', 'Please add your products',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (logo == null) {
                          Get.snackbar('Error', 'Please add your logo',
                              snackPosition: SnackPosition.BOTTOM);
                        } else if (images.isEmpty) {
                          Get.snackbar('Error', 'Please add your images',
                              snackPosition: SnackPosition.BOTTOM);
                        } else {
                          Get.snackbar('Success', 'Please wait...',
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      }
                    : () async {
                        final provider = ProviderModel(
                          name: name,
                          address: address,
                          location: GeoPoint(
                            _location!.latitude,
                            _location!.longitude,
                          ),
                          products: _products,
                          ratingCount: 0,
                          ratings: 0,
                          ownerId: FirebaseAuth.instance.currentUser!.uid,
                        );

                        final user = UserModel(
                          email: email,
                          phone: phone,
                          password: password,
                          isProvider: true,
                          fullName: name,
                          locations: [],
                          isDriver: false,
                        );
                        try {
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .registerProvider(provider, images, logo!, user);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Registering.Please wait...'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      },
                color: kIconColor,
                textColor: Colors.white,
                child: const Text('Register'),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
