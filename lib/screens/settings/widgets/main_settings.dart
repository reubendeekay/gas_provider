import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MainSettings extends StatelessWidget {
  const MainSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(children: [
          settingTile(),
          settingTile(
            icon: Iconsax.key,
            title: 'Password',
            subtitle: 'Change your password',
          ),
          settingTile(
            icon: Iconsax.notification,
            title: 'Notifications',
            subtitle: 'View all notifications',
          ),
          settingTile(
            icon: Iconsax.info_circle,
            title: 'Help',
            subtitle: 'Get help with the app',
          ),
        ]));
  }

  Widget settingTile({
    String? title,
    String? subtitle,
    IconData? icon,
    Function? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon ?? Iconsax.user),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Account Settings',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle ?? 'Manage your account',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }
}
