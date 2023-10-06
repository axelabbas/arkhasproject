import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

starsWidget(double stars, double size, Color color) {
  print(stars);
  return RatingBarIndicator(
      itemSize: size,
      itemBuilder: (context, index) => Icon(
            Icons.star,
            color: color,
          ),
      rating: stars);
  return RatingBar(
    initialRating: stars,
    ignoreGestures: true,
    allowHalfRating: true,
    onRatingUpdate: (value) {},
    ratingWidget: RatingWidget(
        full: Icon(
          Icons.star,
        ),
        half: Icon(
          Icons.star_half,
        ),
        empty: Icon(
          Icons.star_border,
        )),
  );
}
// starsWidget(double stars, double size, Color color) {
//     List<Widget> starsList = [];
//     for (double i = 0; i < 5; i++) {
//       if (stars - i >= 1) {
//         starsList.add(Icon(
//           Icons.star,
//           size: size,
//           color: color,
//         ));
//       } else if (stars - i <= 0) {
//         starsList.add(Icon(
//           Icons.star_border,
//           size: size,
//           color: color,
//         ));
//       } else {
//         starsList.add(Icon(
//           Icons.star_half,
//           size: size,
//           color: color,
//         ));
//       }
//     }
//     return Row(
//       children: starsList,
//     );
//   }