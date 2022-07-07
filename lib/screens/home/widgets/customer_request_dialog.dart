import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/distance_helper.dart';

import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/my_nav.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/providers/location_provider.dart';
import 'package:gas_provider/providers/request_provider.dart';
import 'package:gas_provider/widgets/product_widget.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class CustomerRequestDialog extends StatefulWidget {
  const CustomerRequestDialog({Key? key, required this.request})
      : super(key: key);
  final RequestModel request;

  @override
  State<CustomerRequestDialog> createState() => _CustomerRequestDialogState();
}

class _CustomerRequestDialogState extends State<CustomerRequestDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
          context: context,
          builder: (ctx) => Dialog(
                child: CustomerRequestWidget(request: widget.request),
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomerRequestWidget extends StatefulWidget {
  const CustomerRequestWidget({Key? key, required this.request})
      : super(key: key);
  final RequestModel request;

  @override
  State<CustomerRequestWidget> createState() => _CustomerRequestWidgetState();
}

class _CustomerRequestWidgetState extends State<CustomerRequestWidget> {
  bool isFinished = false;
  UserLocation? location;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      final locData = await Provider.of<LocationProvider>(context,
              listen: false)
          .getLocationDetails(calculateLatLng(widget.request.userLocation!));
      setState(() {
        location = locData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    final loc =
        Provider.of<LocationProvider>(context, listen: false).locationData;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      widget.request.user!.profilePic!),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.user!.fullName!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      widget.request.user!.phone!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            const Divider(),
            ...List.generate(widget.request.products!.length, (index) {
              final product = widget.request.products![index];
              return ProductWidget(
                product: product,
              );
            }),
            const SizedBox(
              height: 15,
            ),
            Text('Delivery Details',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 5),
            Text(location == null ? 'Address' : location!.address!),
            SizedBox(height: 3),
            Text(
              location == null ? 'Address' : location!.state!,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 48,
              child: SwipeableButtonView(
                buttonText: 'Slide to Accept',
                buttonWidget: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                ),
                activeColor: kPrimaryColor,
                isFinished: isFinished,
                onWaitingProcess: () {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {
                      isFinished = true;
                    });
                  });
                },
                onFinish: () async {
                  final request = RequestModel(
                    driverLocation: GeoPoint(loc!.latitude!, loc.longitude!),
                    products: widget.request.products,
                    id: widget.request.id,
                    user: widget.request.user,
                    driver: user,
                    userLocation: widget.request.userLocation,
                    paymentMethod: widget.request.paymentMethod,
                    total: widget.request.total,
                  );
                  //TODO: Handle customer request

                  await Provider.of<RequestProvider>(context, listen: false)
                      .sendProviderAcceptance(request);

                  Get.off(() => const MyNav());
                  setState(() {
                    isFinished = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
