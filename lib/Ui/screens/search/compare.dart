import 'package:arkhasproject/api/alibaba.dart';
import 'package:arkhasproject/api/aliexpress.dart';
import 'package:arkhasproject/util/usefulfunctions.dart';
import 'package:flutter/material.dart';
import 'package:arkhasproject/api/amazon.dart';
import 'package:arkhasproject/api/ebay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arkhasproject/api/tamata.dart';

class compareScreen extends StatefulWidget {
  final String searchQuery;
  compareScreen({
    required this.searchQuery,
  });
  @override
  State<compareScreen> createState() => compareScreenState();
}

class compareScreenState extends State<compareScreen> {
  int group = 1;
  final ScrollController _controller = ScrollController();
  late final Future myFuture;
  Map colorsMap = {
    "text": Color(0xFFffffff),
    "background": Color(0xFF140e15),
    "primary": Color(0xFFa518d8),
    "secondary": Color(0xFF5e2f6f),
    "accent": Color(0xFFad0de7)
  };
  List itemsList = [];
  List currentItems = [];
  String selected = "All";

  Map platforms = {
    "All": "all",
    // "Amazon": amazonItem,
    "Ebay": ebayItem,
    "AliExpress": aliexpressItem,
    "AliBaba": alibabaItem,
    "Tamata": tamataItem
  };
  void scrollUp() {
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
    // _controller.jumpTo(_controller.position.minScrollExtent);
  }

  @override
  void initState() {
    myFuture = getAllResults(widget.searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: scrollUp,
        child: Icon(Icons.arrow_upward),
      ),
      appBar: AppBar(
        title: Text("Compare"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  context: context,
                  builder: (context) => bottomSheet(context));
            },
            icon: Icon(Icons.filter_list),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
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
                          borderRadius: BorderRadius.all(Radius.circular(0.0)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(00.0)),
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
                    return Stack(
                      children: [
                        Positioned(
                          top: 45,
                          child: Container(
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
                                    child: testItem(currentItems[index]),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.2),
                                  blurRadius: 3,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              color: Color.fromRGBO(247, 247, 247, 1),
                              borderRadius: BorderRadius.only(
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
                                    child: categoryCard(
                                        platforms.keys.elementAt(index)),
                                  );
                                }),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${snapshot.connectionState}"),
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                }
                //body after loading

                ),
          ),
        ],
      ),
    );
  }

  getAllResults(query) async {
    List<dynamic> allItems = [];
    // var amazonItems = await searchAmazon(query, 1);
    var aliexpressItems = await searchAliExpress(query, 1);
    var tamataItems = await searchTamata(query, 1);
    var alibabaItems = await searchAlibaba(query, 1);
    var ebayItems = await searchEbay(query, 1);
    allItems = [
      ...alibabaItems,
      ...aliexpressItems,
      ...ebayItems,
      ...tamataItems
    ];
    // allItems = ebayItems;
    allItems.shuffle();
    itemsList = allItems;
    currentItems = allItems;
    return "done";
  }

  testItem(item) {
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
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(right: 20),
                width: 120,
                height: 150,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(
                      item.img,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      starsWidget(item.rateBase, 20, Colors.black),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${item.rateBase}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Text(
                    "${item.type}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "${item.strPrice}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
        padding: EdgeInsets.all(16),
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
                child: Text("Sort by rate")),
            ElevatedButton(
                onPressed: (() {
                  setState(() {
                    currentItems = sortByPrice(currentItems);
                  });
                }),
                child: Text("Sort by price")),
            SizedBox(
              height: 20,
            ),
            RadioListTile(
              title: const Text('Sort Ascending'),
              groupValue: group,
              value: 1,
              onChanged: (value) {
                setState(() {
                  updated(state, value);
                });
              },
            ),
            RadioListTile(
              title: const Text('Sort Descending'),
              groupValue: group,
              value: 0,
              onChanged: (value) {
                setState(() {
                  updated(state, value);
                });
              },
            ),
            ElevatedButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                child: Text("Done")),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    });
  }

  Future<Null> updated(StateSetter updateState, value) async {
    updateState(() {
      group = value;
    });
  }

  sortByRate(List currentItems) {
    if (group == 1)
      currentItems.sort((a, b) => a.rateBase.compareTo(b.rateBase));
    else {
      currentItems.sort((b, a) => a.rateBase.compareTo(b.rateBase));
    }
    return currentItems;
  }

  sortByPrice(List currentItems) {
    if (group == 1)
      currentItems.sort((a, b) => a.price.compareTo(b.price));
    else
      currentItems.sort((b, a) => a.price.compareTo(b.price));

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
            changeItems(platforms[itemName]);
            selected = itemName;
          });
        }),
        child: Container(
          constraints: BoxConstraints(minWidth: 50),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: selected == itemName ? Colors.blue : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(color: Colors.black)),
          child: Center(
            child: Text(itemName),
          ),
        ),
      ),
    );
  }

  changeItems(selectedType) {
    if (!(selectedType == 'all')) {
      currentItems = itemsList
          .where((element) => element.runtimeType == selectedType)
          .toList();
    } else {
      currentItems = itemsList;
    }
  }

  starsWidget(double stars, double size, Color color) {
    List<Widget> starsList = [];
    for (double i = 0; i < 5; i++) {
      if (stars - i >= 1) {
        starsList.add(Icon(
          Icons.star,
          size: size,
          color: color,
        ));
      } else if (stars - i <= 0) {
        starsList.add(Icon(
          Icons.star_border,
          size: size,
          color: color,
        ));
      } else {
        starsList.add(Icon(
          Icons.star_half,
          size: size,
          color: color,
        ));
      }
    }
    return Row(
      children: starsList,
    );
  }
}
