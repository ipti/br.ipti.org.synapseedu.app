import 'package:elesson/share/global_variables.dart';
import 'package:flutter/material.dart';

Widget initTitle({String? text, required double heightScreen, double? bottomMargin}) {
  return Container(
    height: heightScreen * 0.12,
    margin: EdgeInsets.only(bottom: bottomMargin == null ? 0 : bottomMargin),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 76, 0.1), spreadRadius: 0.5),
      ],
    ),
    child: Center(
      child: Text(
        text!,
        style: TextStyle(color: Color(0XFF00004C), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: heightScreen * 0.024),
      ),
    ),
  );
}
