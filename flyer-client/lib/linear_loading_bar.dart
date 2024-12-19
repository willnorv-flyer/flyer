import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget linearLoadingBar(double width, double height) {
  return Shimmer(
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFFE0E0E0),
        Color(0xFFF5F5F5),
        Color(0xFFE0E0E0),
      ],
    ),
    child: Column(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
