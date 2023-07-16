import 'package:arkhasproject/Ui/screens/search/compare.dart';
import 'package:arkhasproject/api/miswag.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String search = '';
    return Scaffold(
      body: ListView(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
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
              initialValue: search,
              decoration: InputDecoration(
                  fillColor: Colors.grey.withOpacity(.2),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.2), width: 0.0),
                    borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(00.0)),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.2), width: 0.0),
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.withOpacity(.8),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
