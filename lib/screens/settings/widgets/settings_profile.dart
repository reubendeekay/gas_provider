import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/screens/settings/business_management.dart';
import 'package:gas_provider/screens/settings/widgets/help_screen.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class SettingsProfile extends StatelessWidget {
  const SettingsProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).provider!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  user.logo!,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    user.address!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => BusinessManagement(
                        provider: user,
                      ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.green[200],
                  ),
                  child: Text(
                    'Business Management',
                    style: TextStyle(color: Colors.green[900], fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const HelpScreen());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.pink[200],
                  ),
                  child: Text(
                    'Support',
                    style: TextStyle(color: Colors.pink[900], fontSize: 12),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
