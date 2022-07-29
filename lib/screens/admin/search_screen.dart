import 'package:flutter/material.dart';
import 'package:gas_provider/constants.dart';
import 'package:gas_provider/models/provider_model.dart';
import 'package:gas_provider/providers/revenue_provider.dart';
import 'package:gas_provider/screens/admin/provider_details.dart';
import 'package:gas_provider/screens/admin/provider_transaction_details.dart';
import 'package:gas_provider/screens/admin/widgets/all_providers_tile.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: kToolbarHeight + 5,
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextFormField(
              onChanged: (val) {
                setState(() {
                  searchTerm = val;
                });
              },
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: kIconColor),
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                hintText: 'Search',
                hintStyle: const TextStyle(color: kIconColor),
                suffixIcon: const Icon(
                  Iconsax.search_normal,
                  size: 18,
                  color: kIconColor,
                ),
                fillColor: kIconColor.withOpacity(0.3),
                filled: true,
              ),
            ),
          ),
        ),
        if (searchTerm.isNotEmpty)
          Expanded(
              child: FutureBuilder<List<ProviderModel>>(
                  future: Provider.of<RevenueProvider>(context, listen: false)
                      .searchProvider(searchTerm),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('No results found'));
                    }
                    return Container(
                      padding: const EdgeInsets.all(15),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: List.generate(
                          snapshot.data!.length,
                          (index) => AllProvidersTile(
                              provider: snapshot.data![index],
                              isTransaction: true),
                        ),
                      ),
                    );
                  }))
      ],
    ));
  }
}
