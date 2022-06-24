import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Ratings extends StatelessWidget {
  const Ratings(
      {Key? key,
      required this.rating,
      this.gesturesDisabled = false,
      this.size = 18})
      : super(key: key);
  final double rating;
  final bool gesturesDisabled;
  final double size;
  @override
  Widget build(BuildContext context) {
    return RatingBar(
        onRatingUpdate: (rating) {},
        initialRating: rating,
        ignoreGestures: gesturesDisabled,
        itemSize: size,
        ratingWidget: RatingWidget(
          full: const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          half: const Icon(
            Icons.star_half,
            color: Colors.amber,
          ),
          empty: const Icon(
            Icons.star_border,
            color: Colors.amber,
          ),
        ));
  }
}
