import 'package:flutter/material.dart';

class TemplateSlider extends StatelessWidget {
  final Widget title;
  final Widget text;
  final Widget image;
  final Widget sound;
  final Widget activityScreen;

  const TemplateSlider(
      {Key key,
      this.title,
      this.text,
      this.sound,
      this.activityScreen,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PageView(
      scrollDirection: Axis.vertical,
      children: [
        topScreen(screenWidth, screenHeight),
        bottomScreen(screenWidth, screenHeight),
      ],
    );
  }

  Widget topScreen(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      // decoration: BoxDecoration(color: Colors.grey[200]),
      decoration: BoxDecoration(color: Colors.white),
      width: screenWidth,
      height: screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: title != null ? title : Container()),
          text != null ? text : Container(),
          sound != null ? sound : Container(),
          image != null ? image : Container(),
        ],
      ),
    );
  }

  Widget bottomScreen(double screenWidth, double screenHeight) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      width: screenWidth,
      height: screenHeight,
      child: activityScreen,
    );
  }
}
