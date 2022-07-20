import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/distance_helper.dart';
import 'package:gas_provider/models/request_model.dart';
import 'package:gas_provider/providers/location_provider.dart';
import 'package:gas_provider/screens/orders/widgets/delivery_driver_widget.dart';
import 'package:gas_provider/widgets/product_widget.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key, required this.request}) : super(key: key);
  final RequestModel request;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  UserLocation? _userLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<LocationProvider>(context, listen: false)
          .getLocationDetails(calculateLatLng(widget.request.userLocation!))
          .then((value) {
        setState(() {
          _userLocation = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductWidget(product: widget.request.products!.first),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: kIconColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.location_on,
                      color: kIconColor,
                      size: 24,
                    ),
                  ),
                  title: Text(_userLocation != null
                      ? _userLocation!.address!
                      : 'Nairobi'),
                  subtitle: Text(_userLocation != null
                      ? _userLocation!.state!
                      : 'Central Business District'),
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              'Customer Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          DeliveryDriverWidget(
            request: widget.request,
            isCustomer: true,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              'Driver Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (widget.request.status != 'pending' ||
              widget.request.status == 'accepted')
            DeliveryDriverWidget(request: widget.request),
          const Divider(),
          const Spacer(),
          if (widget.request.status.toLowerCase() == 'pending')
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: RaisedButton(
                color: kIconColor,
                textColor: Colors.white,
                onPressed: () {},
                child: const Text('Confirm Order'),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
