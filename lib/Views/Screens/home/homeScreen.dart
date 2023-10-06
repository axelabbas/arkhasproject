
import 'package:arkhasproject/Views/Screens/search/compare.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String search = '';
    return Scaffold(
      body: ListView(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: TextFormField(
              onFieldSubmitted: (value) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => compareScreen(
                      searchQuery: value,
                    )));
              },
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
