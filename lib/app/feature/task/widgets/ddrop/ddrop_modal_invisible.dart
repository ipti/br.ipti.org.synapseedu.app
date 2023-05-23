import 'package:flutter/material.dart';

class DdropModalInvisible extends StatelessWidget {
  const DdropModalInvisible({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2.6,
      height: size.width / 2.6,
    );
  }
}
