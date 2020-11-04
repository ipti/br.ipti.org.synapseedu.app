import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class TextQuestion extends ConsumerWidget {
  static const routeName = '/TXT';

  var cobjectList = new List<Cobject>();
  int questionIndex;
  int listQuestionIndex;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    // String questionHeaderDescription = cobjectList[0].questions[questionIndex].header["description"]; (IMPORTANTE)
    String questionDescription = cobjectList[0].description;
    String headerText = cobjectList[0].questions[questionIndex].header["text"];

    String questionText = cobjectList[0].questions[questionIndex].pieces['1']['text'];
    String pieceId = cobjectList[0].questions[questionIndex].pieceId;
    Stopwatch chronometer = Stopwatch();
    return Scaffold(
      body: TemplateSlider(
        isTextTemplate: true,
        listQuestionIndex: listQuestionIndex,
        questionIndex: questionIndex,
        title: Text(
          questionDescription,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        sound: cobjectList[0].questions[questionIndex].header["sound"],
        linkImage: 'https://elesson.com.br/app/library/image/' + cobjectList[0].questions[questionIndex].header["image"],
        text: Text(
          headerText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        activityScreen: Container(
          child: Wrap(
            children: [
              Text(
                questionText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fonteDaLetra,
                  fontFamily: 'Mulish',
                ),
              ),
              submitAnswer(context, cobjectList, 'TXT', ++questionIndex, listQuestionIndex, pieceId, true,""),
            ],
          ),
        ),
      ),
    );
  }
}
