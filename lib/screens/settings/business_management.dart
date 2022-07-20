import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/button_loader.dart';
import 'package:gas_provider/models/product_model.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/providers/location_provider.dart';
import 'package:gas_provider/widgets/add_on_map.dart';
import 'package:gas_provider/widgets/add_product.dart';
import 'package:gas_provider/widgets/loading_screen.dart';
import 'package:gas_provider/widgets/my_text_field.dart';
import 'package:gas_provider/widgets/option_list_tile.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class BusinessManagement extends StatefulWidget {
  const BusinessManagement({Key? key, required this.provider})
      : super(key: key);
  final ProviderModel provider;
  @override
  State<BusinessManagement> createState() => _BusinessManagementState();
}

class _BusinessManagementState extends State<BusinessManagement> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<LocationProvider>(context, listen: false)
          .getCurrentLocation();
    });
  }

  bool isLoading = false;
  List<ProductModel> _products = [];
  LatLng? _location;
  List<File> images = [];
  File? logo;
  String? address, businessName, email, phone, description;
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
                onPressed: () async {
                  final provider = ProviderModel(
                    name: businessName ?? widget.provider.name,
                    address: address ?? widget.provider.address,
                    location: _location == null
                        ? widget.provider.location
                        : GeoPoint(
                            _location!.latitude,
                            _location!.longitude,
                          ),
                    products: widget.provider.products,
                    ratingCount: widget.provider.ratingCount,
                    ratings: widget.provider.ratings,
                    logo: logo == null ? widget.provider.logo : null,
                    images: images.isEmpty ? widget.provider.images : null,
                    id: widget.provider.id,
                    ownerId: widget.provider.ownerId,
                  );

                  setState(() {
                    isLoading = true;
                  });

                  try {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .updateProvider(
                      provider,
                      images,
                      logo,
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registering.Please wait...'),
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                    Get.offAll(const InitialLoadingScreen());
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                color: kIconColor,
                textColor: Colors.white,
                child: isLoading ? const MyLoader() : const Text('Update'),
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
