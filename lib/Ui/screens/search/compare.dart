// ignore_for_file: unused_catch_clause

import 'dart:async';

import 'package:arkhasproject/Ui/screens/widgets/loadingWidgets.dart';
import 'package:arkhasproject/api/alibaba.dart';
import 'package:arkhasproject/api/aliexpress.dart';
import 'package:arkhasproject/api/itemClass.dart';
import 'package:arkhasproject/api/miswag.dart';
import 'package:flutter/material.dart';
import 'package:arkhasproject/api/ebay.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arkhasproject/api/tamata.dart';
import '../widgets/starsWidget.dart';

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
  int group = 1;
  bool finishedLoading = false;
  final ScrollController _controller = ScrollController();
  late final Future myFuture;
  Map colorsMap = {
    "text": const Color(0xFFffffff),
    "background": const Color(0xFF140e15),
    "primary": const Color(0xFFa518d8),
    "secondary": const Color(0xFF5e2f6f),
    "accent": const Color(0xFFad0de7)
  };
  List itemsList = [];
  List currentItems = [];
  String selected = "All";

  List platforms = ["All", "AliBaba", "Tamata", "AliExpress", "Ebay", "Miswag"];
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
    myFuture = getAllResults(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: finishedLoading,
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
              if (finishedLoading) {
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
                    onChanged: ((value) => setState(() {
                          //recommendeds

                          // var output = searchInList(itemsList, value);
                          // if (output == 'EMPTYLIST') {
                          //   return;
                          // }
                          // currentItems = output.toList();
                        })),
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
            child: FutureBuilder(
                future: myFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    // schedule set state until the building has been finished
                    SchedulerBinding.instance
                        .addPostFrameCallback((_) => setState(() {
                              finishedLoading = true;
                            }));
                    return Stack(
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
                                    child:
                                        searchItem(currentItems[index], index),
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
                                    child: categoryCard(platforms[index]),
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const loadingWidget();
                  }
                }),
          ),
        ],
      ),
    );
  }

  getAllResults(query) async {
    List<dynamic> allItems = [];
    var tamataItems = [];
    var aliexpressItems = [];
    var ebayItems = [];
    var alibabaItems = [];
    var miswagItems = [];
    // var amazonItems = await searchAmazon(query, 1);
    try {
      aliexpressItems = await searchAliExpress(query, 1);
    } on TimeoutException catch (e) {
      print("timeoutException aliex");
    }
    try {
      miswagItems = await searchMiswag(query, 1);
    } on TimeoutException catch (e) {
      print("timeoutException aliex");
    }
    try {
      tamataItems = await searchTamata(query, 1);
    } on TimeoutException catch (e) {
      print("timeoutException tamata");
    }
    try {
      alibabaItems = await searchAlibaba(query, 1);
    } on TimeoutException catch (e) {
      // ignore: avoid_print
      print("timeoutException alibaba");
    }

    try {
      ebayItems = await searchEbay(query, 1);
    } on TimeoutException catch (e) {
      print("timeoutException ebay");
    }

    allItems = [
      ...alibabaItems,
      ...aliexpressItems,
      ...ebayItems,
      ...tamataItems,
      ...miswagItems,
    ];
    // allItems = ebayItems;
    allItems.shuffle();
    itemsList = allItems;
    currentItems = allItems;
    print(allItems.length);

    return "done";
  }

  searchItem(item item, int index) {
    Uri link = Uri.parse(item.link);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        if (await canLaunchUrl(link)) {
          await launchUrl(link, mode: LaunchMode.externalApplication);
        } else {
          print("coudlnt launch $link");
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.2),
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(right: 20),
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(
                      item.img,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset("assets/images/errorImg.jpg");
                      },
                    ))),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      "${item.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      starsWidget(item.rateBase, 20, Colors.black),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${item.rateBase}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    "${item.type}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "${item.strPrice}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
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
                  setState(() {
                    currentItems = sortByRate(currentItems);
                  });
                }),
                child: const Text("Sort by rate")),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: (() {
                  setState(() {
                    currentItems = sortByPrice(currentItems);
                  });
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
                            setState(() {
                              updated(state, value);
                            });
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
                            setState(() {
                              updated(state, value);
                            });
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

  Future<void> updated(StateSetter updateState, value) async {
    updateState(() {
      group = value;
    });
  }

  sortByRate(List currentItems) {
    if (group == 1) {
      currentItems.sort((a, b) => a.rateBase.compareTo(b.rateBase));
    } else {
      currentItems.sort((b, a) => a.rateBase.compareTo(b.rateBase));
    }
    return currentItems;
  }

  sortByPrice(List currentItems) {
    if (group == 1) {
      currentItems.sort((a, b) => a.price.compareTo(b.price));
    } else {
      currentItems.sort((b, a) => a.price.compareTo(b.price));
    }

    return currentItems;
  }

  searchInList(List listofItems, String str) {
    if (listofItems.isEmpty) {
      return "EMPTYLIST";
    }

    List foundMatches =
        listofItems.where((element) => element.title.contains(str)).toList();

    return foundMatches;
  }

  Widget categoryCard(itemName) {
    return Material(
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: (() {
          setState(() {
            changeItems(itemName);
            selected = itemName;
          });
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

  changeItems(selectedType) {
    if (!(selectedType == 'All')) {
      currentItems =
          itemsList.where((element) => element.type == selectedType).toList();
    } else {
      currentItems = itemsList;
    }
  }
}
