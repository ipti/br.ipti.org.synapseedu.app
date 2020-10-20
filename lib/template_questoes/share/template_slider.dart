import 'package:flutter/material.dart';

class TemplateSlider extends StatefulWidget {
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
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondScreen = false;
  bool showConfirmButtom = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        topScreen(screenWidth, screenHeight*0.93),
        bottomScreen(screenWidth, screenHeight*0.93),
        bottomNavBar(context, screenHeight),
      ],
    );
  }

  Widget topScreen(double screenWidth, double screenHeight) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy < 0) {
          setState(() {
            showSecondScreen = true;
          });
        }
      },
      child: Container(
        //margin: EdgeInsets.only(bottom: screenHeight * 0.1),
        // decoration: BoxDecoration(color: Colors.grey[200]),
        decoration: BoxDecoration(color: Colors.white),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: widget.title != null ? widget.title : Container()),
            widget.text != null ? widget.text : Container(),
            widget.sound != null ? widget.sound : Container(),
            widget.image != null ? widget.image : Container(),
          ],
        ),
      ),
    );
  }

  Widget bottomScreen(double screenWidth, double screenHeight) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0) {
          setState(() {
            showSecondScreen = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: showSecondScreen == true
            ? EdgeInsets.only(bottom: 0)
            : EdgeInsets.only(top: screenHeight),
        decoration: BoxDecoration(color: Colors.grey[300]),
        width: screenWidth,
        height: screenHeight,
        child: widget.activityScreen,
      ),
    );
  }

  Widget bottomNavBar(BuildContext context, double screenHeight) {
    return Container(
      color: Colors.blue,
      margin: EdgeInsets.only(top: screenHeight * 0.93),
      height: screenHeight * 0.07,
      // color: Color.fromRGBO(255, 255, 255, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 12),
            child: OutlineButton(
              padding: EdgeInsets.all(0),
              borderSide: BorderSide(
                color: Color.fromRGBO(0, 0, 255, 1),
              ),
              color: Colors.white,
              textColor: Color(0xFF0000FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Icon(
                Icons.settings,
                size: 40,
                color: Color(0xFF0000FF),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
              },
            ),
          ),
          if (showConfirmButtom == true)
            OutlineButton(
              padding: EdgeInsets.all(0),
              borderSide: BorderSide(
                color: Color(0xFF00DC8C),
              ),
              color: Colors.white,
              textColor: Color(0xFF00DC8C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                'Confirmar',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
              },
            ),
          Container(
            margin: EdgeInsets.only(right: 12.0),
            child: OutlineButton(
              padding: EdgeInsets.all(0),
              borderSide: BorderSide(
                color: Color.fromRGBO(0, 0, 255, 1),
              ),
              color: Colors.white,
              textColor: Color(0xFF0000FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: showSecondScreen != true
                  ? Row(
                      children: [
                        Text(
                          'VER MAIS',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 40,
                        ),
                      ],
                    )
                  : Icon(
                      Icons.keyboard_arrow_up,
                      size: 40,
                      color: Color(0xFF0000FF),
                    ),
              onPressed: () {
                setState(() {
                  //showSecondScreen = !showSecondScreen; (ver mais)
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
