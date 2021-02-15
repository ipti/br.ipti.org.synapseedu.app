import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';

import 'package:flutter/material.dart';

class ConfirmButtonWidget extends StatefulWidget {
  const ConfirmButtonWidget({
    Key key,
    @required this.buttonHeight,
    @required this.minButtonWidth,
    @required this.context,
    @required this.cobjectList,
    @required this.questionType,
    @required this.questionIndex,
    @required this.listQuestionIndex,
    @required this.pieceId,
    @required this.isCorrect,
    @required this.groupId,
    @required this.value,
  }) : super(key: key);

  final double buttonHeight;
  final double minButtonWidth;
  final BuildContext context;
  final List<Cobject> cobjectList;
  final String questionType;
  final int questionIndex;
  final int listQuestionIndex;
  final String pieceId;
  final bool isCorrect;
  final String groupId;
  final String value;

  @override
  _ConfirmButtonWidgetState createState() => _ConfirmButtonWidgetState();
}

class _ConfirmButtonWidgetState extends State<ConfirmButtonWidget> {
  bool confirmButtonColor = true;

  bool confirmButtonBorder = true;

  bool confirmButtonTextColor = true;

  String confirmButtonText = 'CONFIRMAR';

  double confirmButtonBackgroundOpacity = 0;

  bool isCorrect = true;

  AudioCache audioCache = AudioCache();

  bool isSecondClick = false;

  Timer nextQuestionTimer;

  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isIOS) {
      if (audioCache.fixedPlayer != null) {
        audioCache.fixedPlayer.startHeadlessService();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double minButtonWidth = MediaQuery.of(context).size.width < 411 ? 180 : 259;
    return MaterialButton(
      elevation: 0,
      height: widget.buttonHeight,
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
        if (isSecondClick == false) {
          setState(() {
            if (isCorrect) {
              confirmButtonColor = true;
              confirmButtonBorder = true;
              confirmButtonTextColor = true;
              confirmButtonText = 'VOCÊ ACERTOU!';
              audioCache.play('audio/positiva.wav');
              // confirmButtonColor = Color.fromARGB(51, 0, 220, 140);
              // confirmButtonBorder = Color.fromRGBO(0, 220, 140, 1);
              // confirmButtonTextColor = Color.fromRGBO(0, 220, 140, 1);

            } else {
              confirmButtonColor = false;
              confirmButtonBorder = false;
              confirmButtonTextColor = false;
              confirmButtonText = 'NÃO ERA ESSA :(';
              audioCache.play('audio/negativa.wav');
              // confirmButtonColor = Color.fromRGBO(255, 51, 0, 0.2);
              // confirmButtonBorder = Color.fromRGBO(255, 51, 0, 1);
              // confirmButtonTextColor = Color.fromRGBO(255, 51, 0, 1);
            }
            confirmButtonBackgroundOpacity = 0.2;
          });
          isCorrect = !isCorrect;
          nextQuestionTimer = Timer(Duration(seconds: 4), () {
            setState(() {
              confirmButtonText = 'PRÓXIMA QUESTÃO';
            });
          });
        } else {
          nextQuestionTimer.cancel();
          Answer().sendAnswer(
            widget.pieceId,
            isCorrect,
            timeEnd,
            intervalResolution: 1234566,
            groupId: widget.groupId != null ? widget.groupId : "",
            value: widget.value != null ? widget.value : "",
          );
          // // ! O erro está vindo daqui, quando tenta subtrair timeStart do timeEnd. Motivo: timeStart vem null

          submitLogic(context, widget.questionIndex, widget.listQuestionIndex,
              widget.questionType, widget.pieceId, isCorrect, timeEnd);
        }

        isSecondClick = true;
      },
    );
  }
}