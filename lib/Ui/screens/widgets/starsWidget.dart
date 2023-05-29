import 'package:flutter/material.dart';

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