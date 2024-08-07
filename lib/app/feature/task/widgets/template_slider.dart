import 'dart:async';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/confirm_button.dart';
import 'package:elesson/app/util/enums/task_types.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

import 'template_slider/top_screen.dart';

class TemplateSlider extends StatefulWidget {
  final TaskViewController taskViewController;
  final bool offline;

  TemplateSlider({Key? key, required this.taskViewController, required this.offline}) : super(key: key);

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondScreen = false;
  Color colorResponder = Color(0xFF0000FF);
  Color boxResponder = Colors.white;
  late List<String> formattedTitle;

  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  @override
  void initState() {
    initConnectivity();
    // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    // _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    // ConnectivityResult result = ConnectivityResult.none;
    // try {
    //   result = await _connectivity.checkConnectivity();
    // } on PlatformException catch (e) {
    //   print(e.toString());
    // }
    // if (!mounted) {
    //   return Future.value(null);
    // }
    //
    // return _updateConnectionStatus(result);
  }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   switch (result) {
  //     case ConnectivityResult.wifi:
  //     case ConnectivityResult.mobile:
  //     case ConnectivityResult.none:
  //       setState(() => _connectionStatus = result.toString());
  //       break;
  //     default:
  //       setState(() => _connectionStatus = 'Failed to get connectivity.');
  //       break;
  //   }
  // }

  double maxScreenHeight = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double bottonPadding = 60;
    double buttonHeight = 48 > size.height * 0.0656 ? 48 : size.height * 0.0656;
    // double buttonWidth = 150 > 0.3649 * size.width ? 150 : 0.3649 * size.width;
    double buttonWidth = 150 > 0.3649 * size.width ? 0.3649 * size.width : 0.3649 * size.width;
    maxScreenHeight = size.height - 24 - bottonPadding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: maxScreenHeight,
        child: size.width > size.height
            ? Row(
                children: [
                  Expanded(child: TopScreen(headerWidgets: widget.taskViewController.screenEntity.headerWidgets)),
                  VerticalDivider(width: 20, thickness: 1, indent: 20, endIndent: 0, color: Colors.grey),
                  Expanded(child: widget.taskViewController.screenEntity.bodyWidget),
                ],
              )
            : Stack(
                children: [
                  TopScreen(headerWidgets: widget.taskViewController.screenEntity.headerWidgets),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    decoration: BoxDecoration(color: Colors.white),
                    margin: showSecondScreen == true ? EdgeInsets.only(bottom: 0) : EdgeInsets.only(top: size.height),
                    child: SingleChildScrollView(
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
                        child: Container(
                          width: size.width,
                          height: size.height - 90,
                          child: widget.taskViewController.screenEntity.bodyWidget,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
      floatingActionButton: bottonTemplateSlider(bottonPadding, buttonHeight, context, buttonWidth, size.width > size.height, widget.offline),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget bottonTemplateSlider(double bottonPadding, double buttonHeight, BuildContext context, double buttonWidth, bool showButtonResponse, bool offline) {
    return Container(
      color: Colors.white,
      height: bottonPadding,
      child: Padding(
        padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.taskViewController.componentSelected.body_id != null || widget.taskViewController.task.template_id == TemplateTypes.TEXT.templateId ||!widget.taskViewController.ddropOptions.value.any((element) => element.component_id == 0)) ConfirmButtonWidget(taskViewController: widget.taskViewController, soundpool: widget.taskViewController.soundpool, offline: offline),
            SizedBox(width: 10),
            showButtonResponse
                ? Container()
                : showSecondScreen == false
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
                    : backButton(buttonWidth, buttonHeight),
          ],
        ),
      ),
    );
  }

  Widget backButton(double buttonWidth, double buttonHeight) {
    return ButtonTheme(
      minWidth: buttonWidth,
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
        child: Row(
          children: [
            SizedBox(width: 10),
            Text(
              "VER A PERGUNTA",
              style: TextStyle(color: Color(0xFF0000FF), fontSize: fonteDaLetra, fontWeight: FontWeight.w900),
            ),
            Icon(
              Icons.keyboard_arrow_up,
              color: Color(0xFF0000FF),
              size: 40,
            ),
          ],
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
