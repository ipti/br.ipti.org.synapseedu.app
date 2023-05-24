import 'package:flutter/material.dart';

class TextModalInvisible extends StatelessWidget {
  const TextModalInvisible({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = ((size.height - 24) * 0.145) - 12;
    return SizedBox(height: height);
  }
}
