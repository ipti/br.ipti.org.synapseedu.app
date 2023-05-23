import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DdropShimmerModal extends StatelessWidget {
  const DdropShimmerModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Shimmer(
      duration: Duration(seconds: 3),
      interval: Duration(seconds: 5),
      color: Colors.white,
      colorOpacity: 0,
      enabled: true,
      direction: ShimmerDirection.fromLTRB(),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(18)),
        width: size.width / 2.6,
        height: size.width / 2.6,
      ),
    );
  }
}
