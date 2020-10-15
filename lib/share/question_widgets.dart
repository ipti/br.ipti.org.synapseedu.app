import 'package:audioplayers/audioplayers.dart';
import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/template_questoes/drag_and_drop.dart';
import 'package:elesson/template_questoes/multichoice.dart';
import 'package:elesson/template_questoes/question_and_answer.dart';
import 'package:elesson/template_questoes/text.dart';
import '../template_questoes/model.dart';
import 'package:flutter/material.dart';

// Contém alguns métodos e variáveis globais necessárias para as questões.

const String BASE_URL = 'https://elesson.com.br/app/library';

List<String> questionList = ['3988','3987','3977','3976'];

AudioPlayer player = new AudioPlayer();
void playSound(String sound) async {
  await player.play(BASE_URL + '/sound/' + sound);

  // FlutterRingtonePlayer.playNotification();
}

Widget soundButton(BuildContext context, Question question) {
  return question.header["sound"].isNotEmpty
      ? IconButton(
          icon: Icon(Icons.volume_up),
          highlightColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).primaryColor,
          onPressed: () {
            playSound(question.header["sound"]);
          },
        )
      : null;
}

Widget submitAnswer(BuildContext context, List<dynamic> cobject,
    String questionType, int questionIndex, int listQuestionType) {
  Widget questionBuilder;

  switch (questionType) {
    case 'PRE':
      questionBuilder = SingleLineTextQuestion();
      break;
    case 'DDROP':
      questionBuilder = DragAndDrop();
      break;
    case 'MTE':
      questionBuilder = TextQuestion();
      break;
    case 'TXT':
      questionBuilder = TextQuestion();
      break;
  }

  return MaterialButton(
    onPressed: () {
      print("Enviando: ${questionIndex + 1}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            settings: RouteSettings(
              arguments:
                  ScreenArguments(cobject, ++questionIndex, questionType,listQuestionType),
            ),
            builder: (context) => questionBuilder),
      );
    },
    minWidth: 200.0,
    height: 45.0,
    color: Theme.of(context).primaryColor,
    splashColor: Theme.of(context).accentColor,
    child: Text(
      "Enviar Resposta",
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Alike",
        fontSize: 16.0,
      ),
      maxLines: 1,
    ),
  );
}
