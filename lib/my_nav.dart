import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/screens/home/home_page.dart';
import 'package:gas_provider/screens/orders/orders_screen.dart';
import 'package:gas_provider/screens/products/products_screen.dart';
import 'package:gas_provider/screens/settings/settings_screen.dart';
import 'package:iconsax/iconsax.dart';

class MyNav extends StatefulWidget {
  const MyNav({Key? key}) : super(key: key);

  @override
  State<MyNav> createState() => _MyNavState();
}

class _MyNavState extends State<MyNav> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: const [
            Homepage(),
            ProductsScreen(),
            OrdersScreen(),
            SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavyBarItem(
              activeColor: kIconColor,
              inactiveColor: kIconColor,
              title: const Text(
                'Dashboard',
                style: TextStyle(fontSize: 12),
              ),
              icon: const Icon(Iconsax.home)),
          BottomNavyBarItem(
              activeColor: kIconColor,
              inactiveColor: kIconColor,
              title: const Text(
                'Products',
                style: TextStyle(fontSize: 12),
              ),
              icon: const Icon(Iconsax.box)),
          BottomNavyBarItem(
              activeColor: kIconColor,
              inactiveColor: kIconColor,
              title: const Text(
                'Orders',
                style: TextStyle(fontSize: 12),
              ),
              icon: const Icon(Iconsax.shopping_bag)),
          BottomNavyBarItem(
              activeColor: kIconColor,
              inactiveColor: kIconColor,
              title: const Text(
                'Profile',
                style: TextStyle(fontSize: 12),
              ),
              icon: const Icon(Iconsax.user)),
        ],
      ),
    );
  }
}
