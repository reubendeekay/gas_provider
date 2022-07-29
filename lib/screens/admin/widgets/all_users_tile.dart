import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/screens/admin/widgets/trail_actions_sheet.dart';
import 'package:iconsax/iconsax.dart';

class AllUsersTile extends StatelessWidget {
  const AllUsersTile({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        actionSheet(context, user);
      },
      child: Container(
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
            backgroundImage: CachedNetworkImageProvider(user.profilePic!),
          ),
          title: Row(
            children: [
              Text(user.fullName!),
              if (user.isAdmin!) const SizedBox(width: 2.5),
              if (user.isAdmin!)
                const Icon(
                  Iconsax.verify,
                  color: Colors.green,
                  size: 14,
                ),
            ],
          ),
          subtitle: Text(user.email!),
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
              await FlutterPhoneDirectCaller.callNumber(user.phone!);
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
      ),
    );
  }
}
