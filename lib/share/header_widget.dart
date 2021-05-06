import 'package:flutter/material.dart';

Widget header(double screenHeight, String headerText) {
  double headerHeight = (88 / 731) * screenHeight;
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: const Color.fromRGBO(0, 0, 76, 0.1),
          width: 1,
        ),
      ),
    ),
    height: headerHeight,
    child: Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        headerText,
        style: TextStyle(
          fontSize: screenHeight < 823 ? 22 : 26,
          fontWeight: FontWeight.w800,
          color: const Color.fromRGBO(
            0,
            0,
            76,
            1,
          ),
        ),
      ),
    ),
  );
}
