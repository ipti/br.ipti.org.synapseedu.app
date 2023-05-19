import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerLoadMultimedia extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerLoadMultimedia({Key? key, required this.height,required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: Duration(seconds: 3),
      interval: Duration(seconds: 5),
      color: Colors.white,
      colorOpacity: 0,
      enabled: true,
      direction: ShimmerDirection.fromLTRB(),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(18)),
        width: width,
        height: height,
      ),
    );
  }
}
