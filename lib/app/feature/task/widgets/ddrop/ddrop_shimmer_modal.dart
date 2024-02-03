import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DdropShimmerModal extends StatelessWidget {
  const DdropShimmerModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isHorizontal = size.width > size.height;
    double heightWidth = 200;
    double horizontalWidth = size.width / 2;
    if (isHorizontal) {
      heightWidth = horizontalWidth / 2.5;
    } else {
      heightWidth = size.width / 3;
    }
    heightWidth = min(size.height/3.5 , heightWidth);

    return Shimmer(
      duration: Duration(seconds: 3),
      interval: Duration(seconds: 5),
      color: Colors.white,
      colorOpacity: 0,
      enabled: true,
      direction: ShimmerDirection.fromLTRB(),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(18)),
        width: heightWidth,
        height: heightWidth,
      ),
    );
  }
}
