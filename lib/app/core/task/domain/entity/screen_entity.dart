import 'package:flutter/material.dart';

class ScreenEntity{
  List<Widget> headerWidgets = [];
  Widget bodyWidget = Container();

  ScreenEntity({required this.bodyWidget,required this.headerWidgets});
}