import 'package:arkhasproject/Providers/itemsProviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class categoryCard extends StatelessWidget {
  const categoryCard({
    super.key,
    required this.itemName,
  });

  final String itemName;

  @override
  Widget build(BuildContext context) {
    String selected = context.watch<scrapedItemsProvider>().selectedCategory;
    return Material(
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: (() {
          context.read<scrapedItemsProvider>().setCategory(itemName);
        }),
        child: Container(
          constraints: const BoxConstraints(minWidth: 50),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: selected == itemName ? Colors.blue : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              border: Border.all(color: Colors.grey)),
          child: Center(
            child: Text(
              itemName,
              style: TextStyle(
                  color: selected == itemName ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
