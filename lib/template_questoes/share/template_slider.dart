import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

class TemplateSlider extends StatefulWidget {
  final Widget title;
  final Widget text;
  final String linkImage;
  final String sound;
  bool showConfirmButton;
  final bool isTextTemplate;
  int questionIndex;
  int listQuestionIndex;
  final Widget activityScreen;

  TemplateSlider(
      {Key key,
      this.title,
      this.text,
      this.sound,
      this.showConfirmButton,
      this.activityScreen,
      this.isTextTemplate = false,
      this.questionIndex,
      this.listQuestionIndex,
      this.linkImage})
      : super(key: key);

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondScreen = false;

  // bool showConfirmButton = false;

  Widget backButton(double buttonHeight) {
    return ButtonTheme(
      minWidth: buttonHeight,
      height: buttonHeight,
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        color: Colors.white,
        textColor: Color(0xFF0000FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Color.fromRGBO(0, 0, 255, 0.2),
          ),
        ),
        child: Icon(
          Icons.keyboard_arrow_up,
          color: Color(0xFF0000FF),
          size: 40,
        ),
        onPressed: () => {
          // ? Navigator.of(context).popAndPushNamed(TextQuestion.routeName,
          //     arguments: ScreenArguments(cobjectList,
          //         --widget.questionIndex, 'TXT', widget.listQuestionIndex))
          if (widget.isTextTemplate)
            {
              Navigator.of(context).pop(),
              indexTextQuestion--,
              print(indexTextQuestion),
            }
          else
            {
              setState(() {
                showSecondScreen = !showSecondScreen;
              }),
            }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
    // double buttonWidth =
    //     259 > screenWidth * 0.63017 ? 259 : screenWidth * 0.63017;
    double buttonWidth = 150 > 0.3649 * screenWidth ? 150 : 0.3649 * screenWidth;

    print('${widget.questionIndex} and ${widget.listQuestionIndex}');

    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.all(12),
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
                  borderRadius: BorderRadius.circular(18.0),
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
            Row(
              children: [
                if (widget.isTextTemplate && widget.questionIndex > 0) backButton(buttonHeight),
                if (widget.isTextTemplate)
                  SizedBox(
                    width: 6,
                  ),
                showSecondScreen != true
                    ? ButtonTheme(
                        minWidth: buttonWidth,
                        height: buttonHeight,
                        child: MaterialButton(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          textColor: Color(0xFF0000FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Color.fromRGBO(0, 0, 255, 0.2),
                            ),
                          ),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                widget.isTextTemplate ? 'VER MAIS   ' : 'RESPONDER',
                                style: TextStyle(
                                  fontSize: fonteDaLetra,
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
                            if (widget.isTextTemplate)
                              {indexTextQuestion++, submitLogic(context, ++widget.questionIndex, widget.listQuestionIndex, 'TXT')}
                            else
                              {
                                setState(() {
                                  showSecondScreen = !showSecondScreen;
                                }),
                              }
                          },
                        ),
                      )
                    : backButton(buttonHeight)
              ],
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
          if (!widget.isTextTemplate) bottomScreen(screenWidth, screenHeight),
          // navBarTest(context),
        ],
      ),
    );
  }

  Widget topScreen(double screenWidth, double screenHeight) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (!widget.isTextTemplate) {
          if (details.delta.dy < 0) {
            setState(() {
              showSecondScreen = true;
            });
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(child: widget.title),
              height: (screenHeight * 0.145) - 12,
              padding: EdgeInsets.only(left: 16, right: 16),
              margin: EdgeInsets.only(top: 12),
            ),
            widget.linkImage != null
                ? Expanded(
                    child: Container(
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          height: screenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2)),
                            image: DecorationImage(
                              image: NetworkImage(widget.linkImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(left: 16, right: 16),
                      height: screenHeight * 0.70,
                    ),
                  )
                : Container(),
            Container(
              child: Center(
                child: GestureDetector(
                  child: widget.text,
                  onTap: () {
                    playSound(widget.sound);
                  },
                ),
              ),
              height: (screenHeight * 0.145) - 12,
              padding: EdgeInsets.only(left: 16, right: 16),
              margin: EdgeInsets.only(bottom: 12),
            ),
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
        margin: showSecondScreen == true ? EdgeInsets.only(bottom: 0) : EdgeInsets.only(top: screenHeight),
        decoration: BoxDecoration(color: Colors.white),
        width: screenWidth,
        height: screenHeight,
        child: widget.activityScreen,
      ),
    );
  }
}
