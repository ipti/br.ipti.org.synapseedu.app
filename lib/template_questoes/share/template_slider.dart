import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:elesson/settings/settings_screen.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:elesson/share/snackbar_widget.dart';
import 'package:flutter/services.dart';

import '../model.dart';

// Classe que implementa o template geral de questões.

class TemplateSlider extends StatefulWidget {
  final String title;
  final Widget text;
  final String linkImage;
  final String sound;
  bool showConfirmButton;
  final bool isTextTemplate;
  final bool isPreTemplate;
  int questionIndex;
  int cobjectIndex;
  DateTime startTime;
  final Widget activityScreen;
  final int cobjectIdListLength;
  final int cobjectQuestionsLength;
  final List<Cobject> cobjectList;
  final List<String> cobjectIdList;
  final String currentId;

  TemplateSlider({
    Key key,
    this.startTime,
    this.title,
    this.text,
    this.sound,
    this.showConfirmButton,
    this.activityScreen,
    this.isTextTemplate = false,
    this.isPreTemplate = false,
    this.questionIndex,
    this.cobjectIndex,
    this.linkImage,
    this.cobjectIdListLength,
    this.cobjectQuestionsLength,
    this.cobjectList,
    this.cobjectIdList,
    this.currentId,
  }) : super(key: key);

  @override
  _TemplateSliderState createState() => _TemplateSliderState();
}

class _TemplateSliderState extends State<TemplateSlider> {
  bool showSecondScreen = false;
  Color colorResponder = Color(0xFF0000FF);
  Color boxResponder = Colors.white;
  List<String> formattedTitle;
  bool isTitleFormatted = false;

  AudioPlayer playerDescription;

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
        onPressed: () {
          // O template de texto não possui a tela inferior, diferente dos outros. O condicional verifica
          // o booleano e fornece o direcionamento adequado. O template de texto permite ao usuário voltar para
          // a tela anterior dentro do mesmo texto, enquanto os outros templates não possuem tal opção.
          if (widget.isTextTemplate) {
            Navigator.of(context).pop();
            indexTextQuestion--;
            print(indexTextQuestion);
          } else {
            setState(() {
              boxResponder = Colors.white;
              colorResponder = Color(0xFF0000FF);
              showSecondScreen = !showSecondScreen;
            });
          }
        },
      ),
    );
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  @override
  void initState() {
    // TODO: implement initState
    timeStartIscaptured = false;
    timeStart = null;
    timeEnd = null;
    isTitleFormatted = formatTitle();

    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    playerDescription = AudioPlayer();
    playerDescription.setUrl(BASE_URL + '/sound/' + cobjectList[0].descriptionSound);
    super.initState();
  }

  bool formatTitle() {
    if (!widget.title.contains(RegExp("<[a-zA-Z]>"))) return false;
    List<String> openingTagFormat = widget.title.split(RegExp("<[a-zA-Z]>"));
    // print(openingTagFormat);
    formattedTitle = openingTagFormat[1].split(RegExp(r"<\/[a-zA-Z]>"));
    formattedTitle.insert(0, openingTagFormat[0]);
    // print(formattedTitle);
    return true;
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
    // double buttonWidth =
    //     259 > screenWidth * 0.63017 ? 259 : screenWidth * 0.63017;
    double buttonWidth = 150 > 0.3649 * screenWidth ? 150 : 0.3649 * screenWidth;

    // print(
    //     'Template slider: ${widget.cobjectIdListLength} and ${widget.cobjectQuestionsLength}');

    print('STATUS DA CONEXÃO: $_connectionStatus');

    return Scaffold(
      backgroundColor: Colors.white,
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
                  Navigator.of(context).pushNamed(SettingsScreen.routeName),
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
                          color: boxResponder,
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
                                  color: colorResponder,
                                  fontSize: fonteDaLetra,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 40,
                                color: colorResponder,
                              ),
                            ],
                          ),
                          onPressed: () {
                            if (timeStartIscaptured == false) {
                              print("capturou time start");
                              timeStart = DateTime.now().millisecondsSinceEpoch;
                              print('timeStart na função topScreen: $timeStart');
                              timeStartIscaptured = true;
                            }
                            if (widget.isTextTemplate) {
                              print('Submit no template slider: ${widget.cobjectQuestionsLength} e ${widget.cobjectIdListLength}');
                              indexTextQuestion++;
                              submitLogic(
                                context,
                                ++widget.questionIndex,
                                widget.cobjectIndex,
                                'TXT',
                                cobjectIdListLength: widget.cobjectIdListLength,
                                cobjectQuestionsLength: widget.cobjectQuestionsLength,
                                cobjectList: cobjectList,
                                cobjectIdList: widget.cobjectIdList,
                              );
                            } else {
                              setState(() {
                                boxResponder = Color(0xFF0000FF);
                                colorResponder = Colors.white;
                                showSecondScreen = !showSecondScreen;
                              });
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

  // Nas questões de texto, a tela é responsável pelo texto e imagens. Nas outras questões, é o cabeçalho da
  // questão.

  Widget topScreen(double screenWidth, double screenHeight) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (!widget.isTextTemplate) {
          if (timeStartIscaptured == false) {
            timeStart = DateTime.now().millisecondsSinceEpoch;
            // print('timeStart na função topScreen: $timeStart');
            timeStartIscaptured = true;
          }
          if (details.delta.dy < 0) {
            //testes
            setState(() {
              boxResponder = Color(0xFF0000FF);
              colorResponder = Colors.white;
              showSecondScreen = true;
            });
          }
        } else {
          if (details.delta.dy < 0) {
            if (timeStartIscaptured == false) {
              // print("capturou time start 2");
              timeStart = DateTime.now().millisecondsSinceEpoch;
              timeStartIscaptured = true;
            }
            indexTextQuestion++;
            submitLogic(
              context,
              ++widget.questionIndex,
              widget.cobjectIndex,
              'TXT',
            );
          } else if (details.delta.dy > 0) {
            if (indexTextQuestion > 0) {
              indexTextQuestion--;
              Navigator.of(context).pop();
            }
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
              child: Center(
                child: RichText(
                  maxLines: 3,
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: isTitleFormatted ? formattedTitle[0] : widget.title,
                    // text: widget.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: fonteDaLetra,
                      fontFamily: 'Mulish',
                    ),
                    children: isTitleFormatted
                        ? [
                            TextSpan(
                              text: formattedTitle[1],
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            TextSpan(
                              text: formattedTitle[2],
                            ),
                          ]
                        : [],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        playerDescription.resume();
                      },
                  ),
                ),
              ),
              height: (screenHeight * 0.145) - 12,
              padding: EdgeInsets.symmetric(horizontal: 16),
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
                            border: Border.all(
                              width: 2,
                              color: Color.fromRGBO(110, 114, 145, 0.2),
                            ),
                            // image: DecorationImage(
                            //   image: NetworkImage(widget.linkImage),
                            //   fit: BoxFit.cover,
                            // ),
                          ),
                          child: Image.network(
                            widget.linkImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, exception, stackTrace) {
                              // print('erro');
                              callSnackBar(context);
                              return Container();
                            },
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                                ),
                              );
                            },
                          ),
                          // child: Container(
                          //   alignment: Alignment.center,
                          //   height: screenWidth,
                          //   child: Image.network(
                          //     widget.linkImage,

                          //     frameBuilder: (context, image, frame,
                          //         wasSynchronouslyLoaded) {
                          //       return Container(
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(18),
                          //           border: Border.all(
                          //               width: 2,
                          //               color:
                          //                   Color.fromRGBO(110, 114, 145, 0.2)),
                          //           image: DecorationImage(
                          //             image: image,
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //     // placeholder: (context, url) =>
                          //     //     CircularProgressIndicator(),
                          //     // errorWidget: (context, url, error) =>
                          //     //     Icon(Icons.error),
                          //   ),
                          // ),
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
                  onTap: () {
                    //kevenny aqui
                    playerTituloSegundaTela.resume();
                  },
                  child: Container(padding: EdgeInsets.only(right: 20, left: 20), child: widget.text),
                ),
              ),
              height: (screenHeight * 0.145),
              padding: EdgeInsets.only(left: 16, right: 16),
              // margin: EdgeInsets.only(bottom: 12),
            ),
          ],
        ),
      ),
    );
  }

  // Template responsável por organizar as opções de resposta da questão.

  Widget bottomScreen(double screenWidth, double screenHeight) {
    return GestureDetector(
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
        margin: showSecondScreen == true ? EdgeInsets.only(bottom: 0) : EdgeInsets.only(top: screenHeight),
        decoration: BoxDecoration(color: Colors.white),
        width: screenWidth,
        height: screenHeight,
        child: widget.activityScreen,
      ),
    );
  }
}
