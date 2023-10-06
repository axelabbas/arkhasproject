import 'package:arkhasproject/Providers/itemsProviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget bottomSheet(BuildContext context) {
  return StatefulBuilder(builder: (context, state) {
    int group = context.watch<scrapedItemsProvider>().group;
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: (() {
                context.read<scrapedItemsProvider>().sortByRate();
              }),
              child: const Text("Sort by rate")),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: (() {
                context.read<scrapedItemsProvider>().sortByPrice();
              }),
              child: const Text("Sort by price")),
          Center(
            child: SizedBox(
              height: 100,
              width: 225,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Radio(
                        groupValue: group,
                        value: 1,
                        onChanged: (value) {
                          context.read<scrapedItemsProvider>().setGroup(value);
                        },
                      ),
                      title: const Text('Sort Ascending'),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Sort Descending'),
                      leading: Radio(
                        groupValue: group,
                        value: 0,
                        onChanged: (value) {
                          context.read<scrapedItemsProvider>().setGroup(value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              child: const Text("Done")),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  });
}
