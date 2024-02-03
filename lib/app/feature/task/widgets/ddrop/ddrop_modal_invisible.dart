import 'dart:math';

import 'package:flutter/material.dart';

class DdropModalInvisible extends StatelessWidget {
  const DdropModalInvisible({Key? key}) : super(key: key);

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

    return Container(
      width: heightWidth,
      height: heightWidth,
    );
  }
}
