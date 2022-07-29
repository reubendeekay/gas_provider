import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/helpers/distance_helper.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/providers/location_provider.dart';

import 'package:provider/provider.dart';

class ProviderInfo extends StatelessWidget {
  const ProviderInfo({Key? key, this.provider}) : super(key: key);

  final ProviderModel? provider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ProviderInfoCard(
          provider: provider!,
        ),
      ]),
    );
  }
}

class ProviderInfoCard extends StatelessWidget {
  const ProviderInfoCard({Key? key, required this.provider}) : super(key: key);
  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    final locData =
        Provider.of<LocationProvider>(context, listen: false).locationData;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Overview'.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(5))),
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Station'),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 30,
                    child: Image.network(provider.logo!),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                    Text('Status'),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Open Now',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  ])),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ratings'),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.message_outlined,
                        color: kIconColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        (provider.ratings! / provider.ratingCount!)
                            .toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(
                    '${provider.ratingCount} Reviews',
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 12),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Location'),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.my_location_sharp,
                        color: kIconColor,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${calculateDistance(provider.location!.latitude, provider.location!.longitude, locData!.latitude!, locData.longitude).toStringAsFixed(1)} KM',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  Text(
                    provider.address!,
                    style:
                        const TextStyle(color: Colors.blueGrey, fontSize: 12),
                  )
                ],
              ))
            ],
          )
        ]),
      ),
    ]);
  }
}
