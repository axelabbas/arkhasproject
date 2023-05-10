import 'package:arkhasproject/Ui/screens/home/homeScreen.dart';
import 'package:arkhasproject/Ui/screens/search/compare.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("OmeSpam");
    setWindowMaxSize(Size(720, 1100));
  }

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: "poppins"),
    home: homeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
