import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class TextQuestion extends ConsumerWidget {
  static const routeName = '/TXT';

  var cobjectList = new List<Cobject>();
  var cobjectIdList = new List<String>();
  int questionIndex;
  int cobjectIndex;
  int cobjectIdListLength;
  int cobjectQuestionsLength;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    cobjectIdList = args.cobjectIdList;
    questionIndex = args.questionIndex;
    cobjectIndex = args.cobjectIndex;
    cobjectIdListLength = args.cobjectIdLength;
    cobjectQuestionsLength = args.cobjectQuestionsLength;

    String questionDescription = cobjectList[0].description;
    String headerText = cobjectList[0].questions[questionIndex].header["text"];

    String questionText =
        cobjectList[0].questions[questionIndex].pieces['1']['text'];
    String pieceId = cobjectList[0].questions[questionIndex].pieceId;
    Stopwatch chronometer = Stopwatch();

    return Scaffold(
      body: TemplateSlider(
        currentId: cobjectIdList[cobjectIndex],
        cobjectIdList: cobjectIdList,
        cobjectIdListLength: cobjectIdListLength,
        cobjectQuestionsLength: cobjectQuestionsLength,
        isTextTemplate: true,
        cobjectIndex: cobjectIndex,
        questionIndex: questionIndex,
        title: questionDescription.toUpperCase(),
        // title: Text(
        //   questionDescription,
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: fonteDaLetra,
        //     fontFamily: 'Mulish',
        //   ),
        // ),
        sound: cobjectList[0].questions[questionIndex].header["sound"],
        linkImage: cobjectList[0].questions[0].header["image"].isNotEmpty
            ? 'https://elesson.com.br/app/library/image/' +
                cobjectList[0].questions[0].header["image"]
            : null,
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
              submitAnswer(context, cobjectList, 'TXT', ++questionIndex,
                  cobjectIndex, pieceId, true,
                  cobjectIdListLength: cobjectIdListLength,
                  cobjectQuestionsLength: cobjectQuestionsLength,
                  cobjectIdList: cobjectIdList),
            ],
          ),
        ),
      ),
    );
  }
}
