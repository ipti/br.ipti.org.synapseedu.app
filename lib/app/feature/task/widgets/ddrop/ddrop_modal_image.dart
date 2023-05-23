import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../image_multimedia.dart';

class DdropModalImage extends StatelessWidget {
  final Uint8List bytesImage;

  const DdropModalImage({Key? key, required this.bytesImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2.6,
      height: size.width / 2.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(189, 0, 255, 0.2), width: 2),
        image: DecorationImage(
          image: MemoryImage(bytesImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
