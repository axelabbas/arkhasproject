import 'package:arkhasproject/Ui/screens/home/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Arkhasly");
    setWindowMaxSize(const Size(720, 1280));
  }

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: "poppins"),
    home: const homeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
