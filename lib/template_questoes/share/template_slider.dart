// import 'package:elesson/template_questoes/share/button_widgets.dart';
import 'package:flutter/material.dart';

class TemplateSlider extends StatefulWidget {
  final Widget title;
  final Widget text;
  final Widget image;
  final Widget sound;
  bool showConfirmButton;
  final Widget activityScreen;

  TemplateSlider(
      {Key key,
      this.title,
      this.text,
      this.sound,
      this.showConfirmButton,
      this.activityScreen,
      this.image})
      : super(key: key);

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondScreen = false;
  // bool showConfirmButton = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight =
        48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
    double buttonWidth =
        259 > screenWidth * 0.63017 ? 259 : screenWidth * 0.63017;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonTheme(
              minWidth: buttonHeight,
              height: buttonHeight,
              child: MaterialButton(
                padding: EdgeInsets.all(8),
                color: Colors.white,
                textColor: Color(0xFF0000FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Color.fromRGBO(0, 0, 255, 0.2),
                  ),
                ),
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: Color(0xFF0000FF),
                ),
                onPressed: () => {
                  // A ser decidido o que fará
                },
              ),
            ),
            if (widget.showConfirmButton == true && showSecondScreen == true)
              ButtonTheme(
                minWidth: 259,
                height: buttonHeight,
                child: MaterialButton(
                  padding: EdgeInsets.all(8),
                  color: Colors.white,
                  textColor: Color(0xFF00DC8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: Color(0xFF00DC8C),
                    ),
                  ),
                  child: Text(
                    'CONFIRMAR',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  },
                ),
              ),
            showSecondScreen != true
                ? ButtonTheme(
                    minWidth:
                        150 > 0.3649 * screenWidth ? 150 : 0.3649 * screenWidth,
                    height: buttonHeight,
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.white,
                      textColor: Color(0xFF0000FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Color.fromRGBO(0, 0, 255, 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'VER MAIS',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 40,
                          ),
                        ],
                      ),
                      onPressed: () => {
                        setState(() {
                          showSecondScreen = !showSecondScreen;
                        }),
                        print('mudou'),
                      },
                    ),
                  )
                : ButtonTheme(
                    minWidth: buttonHeight,
                    height: buttonHeight,
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.white,
                      textColor: Color(0xFF0000FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Color.fromRGBO(0, 0, 255, 1),
                        ),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Color(0xFF0000FF),
                        size: 40,
                      ),
                      onPressed: () => {
                        // Navigator.of(context).pop(),
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // PARA ATIVAR A NAVBAR
      // bottomNavigationBar: bottomNavigationBar(context),
      body: Stack(
        children: [
          topScreen(screenWidth, screenHeight - buttonHeight - 24),
          bottomScreen(screenWidth, screenHeight),
          // navBarTest(context),
        ],
      ),
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
        decoration: BoxDecoration(color: Colors.white),
        width: screenWidth,
        height: screenHeight,
        child: widget.activityScreen,
      ),
    );
  }
}
