import 'package:audioplayers/audioplayers.dart';
import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/template_questoes/drag_and_drop.dart';
import 'package:elesson/template_questoes/multichoice.dart';
import 'package:elesson/template_questoes/question_and_answer.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/text.dart';
import 'package:flutter_riverpod/all.dart';
import '../template_questoes/model.dart';
import 'package:flutter/material.dart';

import 'api.dart';

// Contém alguns métodos e variáveis globais necessárias para as questões.

const String BASE_URL = 'https://elesson.com.br/app/library';

List<String> questionList = ['3988', '3987', '3977', '3976'];

AudioPlayer player = new AudioPlayer();

double fonteDaLetra;

void playSound(String sound) async {
  await player.play(BASE_URL + '/sound/' + sound);

  // FlutterRingtonePlayer.playNotification();
}

var cobjectList = new List<Cobject>();
var cobject = new List<dynamic>();

getCobject(int listQuestionIndex, BuildContext context) async {
  cobjectList.clear();
  //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
  ApiCobject.getQuestao(questionList[listQuestionIndex]).then((response) {
    cobject = response.data;
    var questionType = cobject[0]["cobjects"][0]["template_code"];
    context.read(cobjectProvider).fetchCobjects(cobject);
    cobjectList = context.read(cobjectProvider).items;
    switch (questionType) {
      case 'PRE':
        Navigator.of(context).pushNamedAndRemoveUntil(
            SingleLineTextQuestion.routeName, ModalRoute.withName('/'),
            arguments:
                ScreenArguments(cobjectList, 0, 'PRE', listQuestionIndex));
        break;
      case 'DDROP':
        Navigator.of(context).pushNamedAndRemoveUntil(
            DragAndDrop.routeName, ModalRoute.withName('/'),
            arguments:
                ScreenArguments(cobjectList, 0, 'DDROP', listQuestionIndex));
        break;
      case 'MTE':
        Navigator.of(context).pushNamedAndRemoveUntil(
            MultipleChoiceQuestion.routeName, ModalRoute.withName('/'),
            arguments:
                ScreenArguments(cobjectList, 0, 'MTE', listQuestionIndex));
        break;
      case 'TXT':
        Navigator.of(context).pushNamedAndRemoveUntil(
            TextQuestion.routeName, ModalRoute.withName('/'),
            arguments:
                ScreenArguments(cobjectList, 0, 'TXT', listQuestionIndex));
        break;
    }
  });
}

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

Widget soundButton(BuildContext context, Question question) {
  return question.header["sound"].isNotEmpty
      // ? IconButton(
      //     icon: Icon(Icons.volume_up),
      //     highlightColor: Theme.of(context).primaryColor,
      //     splashColor: Theme.of(context).primaryColor,
      //     onPressed: () {
      //       playSound(question.header["sound"]);
      //     },
      //   )
      ? OutlineButton(
          padding: EdgeInsets.all(6),
          borderSide: BorderSide(
            color: Color.fromRGBO(0, 0, 255, 1),
          ),
          color: Colors.white,
          textColor: Color(0xFF0000FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Icon(
            Icons.volume_up,
            size: 40,
            color: Color(0xFF0000FF),
          ),
          onPressed: () => {playSound(question.header["sound"])},
        )
      : null;
}

Widget submitAnswer(BuildContext context, List<Cobject> cobjectList,
    String questionType, int questionIndex, int listQuestionIndex) {
  double screenHeight = MediaQuery.of(context).size.height;
  double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
  return Align(
    child: ButtonTheme(
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
        onPressed: () {
          if (questionIndex < cobjectList[0].questions.length) {
            switch (questionType) {
              case 'PRE':
                Navigator.of(context).pushReplacementNamed(
                    SingleLineTextQuestion.routeName,
                    arguments: ScreenArguments(
                        cobjectList, questionIndex, 'PRE', listQuestionIndex));
                break;
              case 'DDROP':
                Navigator.of(context).pushReplacementNamed(
                    DragAndDrop.routeName,
                    arguments: ScreenArguments(cobjectList, questionIndex,
                        'DDROP', listQuestionIndex));
                break;
              case 'MTE':
                Navigator.of(context).pushReplacementNamed(
                    MultipleChoiceQuestion.routeName,
                    arguments: ScreenArguments(
                        cobjectList, questionIndex, 'MTE', listQuestionIndex));
                break;
              case 'TXT':
                Navigator.of(context).pushReplacementNamed(
                    TextQuestion.routeName,
                    arguments: ScreenArguments(
                        cobjectList, questionIndex, 'TXT', listQuestionIndex));
                break;
            }
          } else {
            if (++listQuestionIndex < questionList.length) {
              getCobject(listQuestionIndex, context);
            } else {
              Navigator.of(context).pop();
            }
          }
        },
      ),
    ),
  );
}
