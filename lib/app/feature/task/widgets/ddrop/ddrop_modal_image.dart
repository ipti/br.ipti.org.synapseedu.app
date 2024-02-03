import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';


class DdropModalImage extends StatelessWidget {
  final Uint8List bytesImage;

  const DdropModalImage({Key? key, required this.bytesImage}) : super(key: key);

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(189, 0, 255, 0.2), width: 2),
        image: DecorationImage(
          image: MemoryImage(bytesImage),
          fit: BoxFit.cover, scale: 2
        ),
      ),
    );
  }
}
