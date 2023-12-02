import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLoadingScreen extends StatelessWidget {
  final String imagePath;
  final String text;
  final double imageSize;
  const AnimatedLoadingScreen(
      {super.key,
      required this.imagePath,
      required this.text,
      required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              imagePath,
              repeat: true,
              width: imageSize,
            ),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ]),
    );
  }
}
