import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/providers/admin_provider.dart';
import 'package:gas_provider/providers/auth_provider.dart';
import 'package:gas_provider/screens/admin/admin_overview.dart';
import 'package:gas_provider/screens/admin/all_drivers.dart';
import 'package:gas_provider/screens/admin/all_providers.dart';
import 'package:gas_provider/screens/admin/all_users.dart';
import 'package:gas_provider/screens/admin/transactions/transactions_overview.dart';
import 'package:gas_provider/screens/auth/login.dart';
import 'package:gas_provider/screens/orders/invoice_screen.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user!;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.profilePic!),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'System Admin',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.to(() => const TransactionsOverview());
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kIconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.graph,
                  size: 18,
                  color: kIconColor,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginScreen());
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kIconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.logout,
                  color: kIconColor,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                text: 'Overview',
              ),
              Tab(
                text: 'Users',
              ),
              Tab(
                text: 'Providers',
              ),
              Tab(
                text: 'Drivers',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminOverview(),
            AllUsers(),
            AllProviders(),
            AllDrivers(),
          ],
        ),
      ),
    );
  }
}
