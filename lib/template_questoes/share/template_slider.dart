import 'package:flutter/material.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class TemplateSlider extends StatefulWidget {
  final Widget titulo;
  final Widget activityScreen;
  final Widget imagem;

  const TemplateSlider({Key key, this.titulo, this.activityScreen, this.imagem})
      : super(key: key);

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondTab = false;

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
      decoration: BoxDecoration(color: Colors.grey[200]),
      width: screenWidth,
      height: screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: widget.titulo != null ? widget.titulo : Container()),
          widget.imagem != null ? widget.imagem : Container(),
        ],
      ),
    );
  }

  Widget bottomScreen(double screenWidth, double screenHeight) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue[200]),
      width: screenWidth,
      height: screenHeight,
      child: widget.activityScreen,
    );
  }
}
