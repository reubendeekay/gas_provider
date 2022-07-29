import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gas_provider/models/user_model.dart';
import 'package:gas_provider/providers/admin_provider.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/screens/chat/chatroom.dart';
import 'package:get/route_manager.dart';

import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

void actionSheet(BuildContext context, UserModel user) {
  final myUser = Provider.of<AuthProvider>(context, listen: false).user;
  showModalBottomSheet(
      context: context,
      builder: (BuildContext buildContext) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 8),
                    child: const Text("ACTIONS",
                        style: TextStyle(
                            letterSpacing: 0.3, fontWeight: FontWeight.bold))),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Iconsax.message,
                    size: 20,
                  ),
                  title: const Text(
                    "Message",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                  onTap: () async {
                    Get.to(() => ChatRoom(user,
                        chatRoomId: '${myUser!.userId}_${user.userId}'));
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.call,
                    size: 20,
                  ),
                  onTap: () async {
                    await FlutterPhoneDirectCaller.callNumber(user.phone!);
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    "Call",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                if (user.isDriver!)
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.close,
                      size: 20,
                    ),
                    onTap: () async {
                      await Provider.of<AdminProvider>(context, listen: false)
                          .revokeUserRight(user.userId!, false);
                      Navigator.of(context).pop();
                    },
                    title: const Text(
                      "Revoke Driver",
                      style: (TextStyle(
                          letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.close,
                    size: 20,
                  ),
                  onTap: () async {
                    await Provider.of<AdminProvider>(context, listen: false)
                        .makeAdmin(user.userId!, user.isAdmin!);
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    user.isAdmin! ? "Remove as Admin" : "Make an Admin",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.block,
                    size: 20,
                  ),
                  onTap: () async {
                    await Provider.of<AdminProvider>(context, listen: false)
                        .blockUser(user.userId!);
                  },
                  title: const Text(
                    "Block User",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.report_outlined,
                    size: 20,
                  ),
                  onTap: () async {
                    await Provider.of<AdminProvider>(context, listen: false)
                        .deleteUserAccount(user.userId!);
                    Navigator.of(context).pop();
                  },
                  title: const Text(
                    "Delete User",
                    style: (TextStyle(
                        letterSpacing: 0.3, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
