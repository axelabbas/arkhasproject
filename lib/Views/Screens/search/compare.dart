// ignore_for_file: unused_catch_clause

import 'dart:async';

// import 'package:arkhasproject/Ui/screens/widgets/loadingWidgets.dart';
import 'package:arkhasproject/Models/itemClass.dart';
import 'package:arkhasproject/Providers/itemsProviders.dart';
import 'package:arkhasproject/Views/Widgets/search/bottomSheetWidget.dart';
import 'package:arkhasproject/Views/Widgets/search/categoryCardWidget.dart';
import 'package:arkhasproject/Views/Widgets/search/searchItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class compareScreen extends StatefulWidget {
  final String searchQuery;
  const compareScreen({
    super.key,
    required this.searchQuery,
  });
  @override
  State<compareScreen> createState() => compareScreenState();
}

class compareScreenState extends State<compareScreen> {
  // 0 for descanding tanazoly
  // 1 for ascending tasa3ody
  final ScrollController _controller = ScrollController();
  late final Future myFuture;

  void scrollUp() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
    // _controller.jumpTo(_controller.position.minScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<scrapedItemsProvider>(context, listen: false)
        .getAllResults(widget.searchQuery, 0);
  }

  @override
  Widget build(BuildContext context) {
    List<String> platforms = context.read<scrapedItemsProvider>().platforms;

    bool isLoading = context.watch<scrapedItemsProvider>().isLoading;
    List<scrapedItem> currentItems =
        context.watch<scrapedItemsProvider>().currentItems; //get current items
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !isLoading,
        child: FloatingActionButton(
          onPressed: scrollUp,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
      appBar: AppBar(
        title: const Text("Compare"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (!isLoading) {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    context: context,
                    builder: (context) => bottomSheet(context));
              } else {
                Null;
              }
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Material(
                  borderRadius: BorderRadius.circular(25),
                  clipBehavior: Clip.hardEdge,
                  child: TextFormField(
                    onFieldSubmitted: (value) async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => compareScreen(
                                searchQuery: value,
                              )));
                    },
                    onChanged: ((value) => null), //display suggestions
                    initialValue: widget.searchQuery,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(.2),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(.2), width: 0.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0.0)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(00.0)),
                          borderSide: BorderSide(
                              color: Colors.grey.withOpacity(.2), width: 0.0),
                        ),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.withOpacity(.8),
                        )),
                  )),
            ),
          ),
          Expanded(
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Currently fetching from ${context.watch<scrapedItemsProvider>().currentlyLoading}"),
                    ],
                  )
                : Stack(
                    children: [
                      Positioned(
                        top: 45,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: ListView.builder(
                              controller: _controller,
                              itemCount: currentItems.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: searchItemWidget(
                                      item: currentItems[index], index: index),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 3,
                                offset: const Offset(0, 5),
                              ),
                            ],
                            color: const Color.fromRGBO(247, 247, 247, 1),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25))),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: platforms.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child:
                                      categoryCard(itemName: platforms[index]),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
