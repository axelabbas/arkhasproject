import 'package:arkhasproject/Providers/itemsProviders.dart';
import 'package:arkhasproject/Views/Screens/home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Arkhasly");
    setWindowMaxSize(const Size(720, 1280));
  }

  runApp(ChangeNotifierProvider(
    create: (context) => scrapedItemsProvider(),
    child: MaterialApp(
      theme: ThemeData(fontFamily: "poppins"),
      home: homeScreen(),
      debugShowCheckedModeBanner: false,
    ),
  ));
}
