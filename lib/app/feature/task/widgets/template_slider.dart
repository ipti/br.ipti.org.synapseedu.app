import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/confirm_button.dart';
import 'package:elesson/settings/settings_screen.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:elesson/share/snackbar_widget.dart';
import 'package:flutter/services.dart';

import 'template_slider/top_screen.dart';

class TemplateSlider extends StatefulWidget {
  final TaskViewController taskViewController;

  TemplateSlider({Key? key, required this.taskViewController}) : super(key: key);

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondScreen = false;
  Color colorResponder = Color(0xFF0000FF);
  Color boxResponder = Colors.white;
  late List<String> formattedTitle;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  double maxScreenHeight = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double bottonPadding = 65;
    double buttonHeight = 48 > size.height * 0.0656 ? 48 : size.height * 0.0656;
    double buttonWidth = 150 > 0.3649 * size.width ? 150 : 0.3649 * size.width;
    maxScreenHeight = size.height - 24 - bottonPadding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: maxScreenHeight,
        child: Stack(
          children: [
            TopScreen(headerWidgets: widget.taskViewController.screenEntity.headerWidgets),
            SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy > 0) {
                    setState(() {
                      boxResponder = Colors.white;
                      colorResponder = Color(0xFF0000FF);
                      showSecondScreen = false;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  margin: showSecondScreen == true ? EdgeInsets.only(bottom: 0) : EdgeInsets.only(top: size.height),
                  decoration: BoxDecoration(color: Colors.white),
                  width: size.width,
                  height: size.height - 90,
                  child: widget.taskViewController.screenEntity.bodyWidget,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: bottonTemplateSlider(bottonPadding, buttonHeight, context, buttonWidth),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget bottonTemplateSlider(double bottonPadding, double buttonHeight, BuildContext context, double buttonWidth) {
    return Container(
      color: Colors.white,
      height: bottonPadding,
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
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
                  side: BorderSide(color: Color.fromRGBO(0, 0, 255, 0.2)),
                ),
                child: Icon(Icons.settings, size: 32, color: Color(0xFF0000FF)),
                onPressed: () => Navigator.of(context).pushNamed(SettingsScreen.routeName),
              ),
            ),
            SizedBox(width: 10),
            ConfirmButtonWidget(taskViewController: widget.taskViewController),
            SizedBox(width: 10),
            showSecondScreen == false
                ? ButtonTheme(
                    minWidth: buttonWidth,
                    height: buttonHeight,
                    child: MaterialButton(
                      padding: EdgeInsets.zero,
                      color: boxResponder,
                      textColor: Color(0xFF0000FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Color.fromRGBO(0, 0, 255, 0.2)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "RESPONDER",
                            // widget.isTextTemplate ? 'VER MAIS   ' : 'RESPONDER',
                            style: TextStyle(color: colorResponder, fontSize: fonteDaLetra, fontWeight: FontWeight.w900),
                          ),
                          Icon(Icons.keyboard_arrow_down, size: 40, color: colorResponder),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          boxResponder = Color(0xFF0000FF);
                          colorResponder = Colors.white;
                          showSecondScreen = !showSecondScreen;
                        });
                      },
                    ),
                  )
                : backButton(buttonHeight),
          ],
        ),
      ),
    );
  }

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
        onPressed: () {
          setState(() {
            boxResponder = Colors.white;
            colorResponder = Color(0xFF0000FF);
            showSecondScreen = !showSecondScreen;
          });
        },
      ),
    );
  }
}
