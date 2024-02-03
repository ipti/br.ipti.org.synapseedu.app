import 'package:flutter/material.dart';

class TopScreen extends StatelessWidget {
  final List<Widget> headerWidgets;
  const TopScreen({Key? key, required this.headerWidgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: size.width,
      height: size.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: headerWidgets,
        ),
      ),
    );
  }
}
