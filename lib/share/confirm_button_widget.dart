import 'dart:async';
import 'dart:io';

// import 'package:audioplayers/audio_cache.dart';
import 'package:connectivity/connectivity.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/ddrop/ddrop_function.dart';
import 'package:elesson/share/snackbar_widget.dart';
import 'package:elesson/template_questoes/model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmButtonWidget extends StatefulWidget {
  const ConfirmButtonWidget({
    Key key,
    // @required this.buttonHeight,
    // @required this.minButtonWidth,
    @required this.context,
    @required this.cobjectList,
    @required this.cobjectIdList,
    @required this.questionType,
    @required this.questionIndex,
    @required this.cobjectIndex,
    this.pieceId,
    @required this.isCorrect,
    this.groupId,
    this.value,
    this.cobjectIdListLength,
    this.cobjectQuestionsLength,
  }) : super(key: key);

  // final double buttonHeight;
  // final double minButtonWidth;
  final BuildContext context;
  final List<Cobject> cobjectList;
  final List<String> cobjectIdList;
  final String questionType;
  final int questionIndex;
  final int cobjectIndex;
  final String pieceId;
  final bool isCorrect;
  final String groupId;
  final String value;
  final int cobjectIdListLength;
  final int cobjectQuestionsLength;

  @override
  _ConfirmButtonWidgetState createState() => _ConfirmButtonWidgetState();
}

class _ConfirmButtonWidgetState extends State<ConfirmButtonWidget> {
  bool confirmButtonColor = true;

  bool confirmButtonBorder = true;

  bool confirmButtonTextColor = true;

  String confirmButtonText = 'CONFIRMAR';

  double confirmButtonBackgroundOpacity = 0;

  SharedPreferences prefs;

  // bool isCorrect = true;

  // AudioCache audioCache = AudioCache();

  bool isSecondClick = false;

  Timer nextQuestionTimer;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';

  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isIOS) {
      // if (audioCache.fixedPlayer != null) {
      //   audioCache.fixedPlayer.startHeadlessService();
      // }
    }
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
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
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    double buttonHeight =
        48 > deviceSize.height * 0.0656 ? 48 : deviceSize.height * 0.0656;
    double minButtonWidth = MediaQuery.of(context).size.width < 411 ? 180 : 259;

    return MaterialButton(
      elevation: 0,
      height: buttonHeight,
      minWidth: minButtonWidth,
      padding: EdgeInsets.all(8),
      color: confirmButtonColor
          ? Color.fromRGBO(0, 220, 140, confirmButtonBackgroundOpacity)
          : Color.fromRGBO(255, 51, 0, confirmButtonBackgroundOpacity),
      // textColor: Color.fromRGBO(0, 220, 140, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: confirmButtonBorder
              ? Color.fromRGBO(0, 220, 140, 1)
              : Color.fromRGBO(255, 51, 0, 1),
        ),
      ),
      child: Text(
        confirmButtonText,
        style: TextStyle(
          color: confirmButtonTextColor
              ? Color.fromRGBO(0, 220, 140, 1)
              : Color.fromRGBO(255, 51, 0, 1),
          fontWeight: FontWeight.w900,
          // fontSize: fonteDaLetra,
          fontSize: 16,
        ),
      ),

      onPressed: () {
        timeEnd = DateTime.now().millisecondsSinceEpoch;
        // prefs.setInt('last_question_${widget.cobjectList[0].discipline}',
        //     widget.questionIndex);
        // prefs.setInt('last_cobject_${widget.cobjectList[0].discipline}',
        //     widget.cobjectIndex);

        // if (!(widget.questionIndex < widget.cobjectQuestionsLength)) {
        //   if (widget.cobjectIndex + 1 < widget.cobjectIdListLength) {
        //     prefs.setInt(
        //         'last_question_${widget.cobjectList[0].discipline}', 0);
        //     prefs.setInt('last_cobject_${widget.cobjectList[0].discipline}',
        //         widget.cobjectIndex + 1);
        //   } else {
        //     prefs.setInt('last_cobject_${widget.cobjectList[0].discipline}', 0);
        //     prefs.setInt(
        //         'last_question_${widget.cobjectList[0].discipline}', 0);
        //     prefs.setBool(widget.cobjectList[0].discipline, true);
        //   }
        // }

        if (isSecondClick == false) {
          setState(() {
            if (widget.isCorrect) {
              confirmButtonColor = true;
              confirmButtonBorder = true;
              confirmButtonTextColor = true;
              confirmButtonText = 'VOCÊ ACERTOU!';
              // audioCache.play('audio/positiva.wav');
            } else {
              confirmButtonColor = false;
              confirmButtonBorder = false;
              confirmButtonTextColor = false;
              confirmButtonText = 'NÃO ERA ESSA :(';
              // audioCache.play('audio/negativa.wav');
            }
            confirmButtonBackgroundOpacity = 0.2;
          });
          // isCorrect = !isCorrect;
          nextQuestionTimer = Timer(Duration(seconds: 2), () {
            setState(() {
              confirmButtonText = 'PRÓXIMA QUESTÃO';
            });
          });
        } else {
          nextQuestionTimer.cancel();

          if (widget.questionType == "DDROP") {
            //resetando variaveis do DDROP
            valueFirstReceiver = 0;
            valueSecondReceiver = 0;
            valueThirdReceiver = 0;

            showFirstSender = true;
            showSecondSender = true;
            showThirdSender = true;

            urlFirstBox = '';
            urlSecondBox = '';
            urlThirdBox = '';
          }

          if (_connectionStatus != 'ConnectivityResult.none' &&
              _connectionStatus != 'ConnectivityResult.waiting') {
            // print('DEU ESSE: $_connectionStatus');
            // print('tempo de intervalo: ${timeEnd - timeStart}');

            if (isGuest == false)
              Answer().sendAnswerToApi(
                widget.pieceId,
                widget.isCorrect,
                timeEnd,
                intervalResolution: (timeEnd - timeStart),
                groupId: widget.groupId != null ? widget.groupId : "",
                value: widget.value != null ? widget.value : "",
              );

            // ! O erro está vindo daqui, quando tenta subtrair timeStart do timeEnd. Motivo: timeStart vem null
            try {
              submitLogic(context, widget.questionIndex, widget.cobjectIndex,
                  widget.questionType,
                  pieceId: widget.pieceId,
                  isCorrect: widget.isCorrect,
                  finalTime: 22,
                  // intervalResolution: 1234566,
                  cobjectList: widget.cobjectList,
                  cobjectIdList: widget.cobjectIdList,
                  cobjectIdListLength: widget.cobjectIdListLength,
                  cobjectQuestionsLength: widget.cobjectQuestionsLength);
            } catch (e) {
              // print('FOI AQUI');
            }
          } else
            callSnackBar(context);
        }

        isSecondClick = true;
      },
    );
  }
}
