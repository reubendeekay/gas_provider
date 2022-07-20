import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:iconsax/iconsax.dart';

class AllProvidersTile extends StatelessWidget {
  const AllProvidersTile({Key? key, required this.provider}) : super(key: key);
  final ProviderModel provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: CachedNetworkImageProvider(provider.logo!),
        ),
        title: Text(provider.name!),
        subtitle: Text(provider.address!),
        trailing:
            // Row(
            //   children: [
            // Container(
            //     padding: const EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //         color: kIconColor.withOpacity(0.2), shape: BoxShape.circle),
            //     child: const Icon(
            //       Icons.phone,
            //       color: kPrimaryColor,
            //     )),
            // const SizedBox(
            //   width: 10,
            // ),
            InkWell(
          onTap: () async {
            await FlutterPhoneDirectCaller.callNumber(
                provider.ratings.toString());
          },
          child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: kIconColor.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(
                Iconsax.call,
                color: kIconColor,
              )),
        ),
        //   ],
        // ),
      ),
    );
  }
}
