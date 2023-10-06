import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

starsWidget(double stars, double size, Color color) {
  return RatingBarIndicator(
      itemSize: size,
      itemBuilder: (context, index) => Icon(
            Icons.star,
            color: color,
          ),
      rating: stars);
}
