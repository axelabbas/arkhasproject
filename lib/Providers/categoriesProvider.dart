import 'package:flutter/material.dart';

class catgeoriesProvider extends ChangeNotifier{
  String selected = "All";
  void changeSelected(String newSelected){
    selected = newSelected;
    notifyListeners();
  }
  
}