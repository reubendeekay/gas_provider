import 'package:flutter/material.dart';

import 'package:gas_provider/constants.dart';
import 'package:gas_provider/widgets/add_product.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class AddProductTile extends StatelessWidget {
  const AddProductTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => AddProducts());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(color: kIconColor.withOpacity(0.4)),
        child: Row(children: [
          Icon(Iconsax.activity, color: Colors.green[900]),
          const SizedBox(
            width: 20,
          ),
          Text(
            'Have a new product?',
            style: TextStyle(fontSize: 13, color: Colors.green[900]),
          ),
          const Spacer(),
          Text('ADD A PRODUCT',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.green[900])),
        ]),
      ),
    );
  }
}
