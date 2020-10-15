import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/api.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/question_and_answer.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import 'drag_and_drop.dart';
import 'multichoice.dart';

class TextQuestion extends ConsumerWidget {
  static const routeName = '/TXT';

  var cobjectList = new List<Cobject>();
  int questionIndex;
  String questionType;
  bool fetch = false;
  int listQuestionIndex;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    // String questionDescription =
    //     cobjectList[0].questions[questionIndex].header["description"];
    String questionDescription = cobjectList[0].description;
    String headerText = cobjectList[0].questions[questionIndex].header["text"];

    String questionText =
        cobjectList[0].questions[questionIndex].pieces['1']['text'];

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          questionDescription,
          //questionDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        sound: soundButton(context, cobjectList[0].questions[questionIndex]),
        image: Image.network('https://elesson.com.br/app/library/image/' +
            cobjectList[0].questions[questionIndex].header["image"]),
        text: Text(headerText),
        activityScreen: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(questionText),
              // submitAnswer(context, cobject, questionType, questionIndex),
              MaterialButton(
                onPressed: () {
                  print('questionIndex: $questionIndex, outro: ${cobjectList[0].questions.length-1}');
                  questionIndex < cobjectList[0].questions.length -1?print('sim')
                  //Navigator.of(context).pushReplacementNamed(TextQuestion.routeName,arguments: ScreenArguments(cobjectList,++questionIndex,'TXT',listQuestionIndex))
                      : print('não');
                    _getCobject(questionList[++listQuestionIndex], context);
                },
                minWidth: 200.0,
                height: 45.0,
                color: Colors.indigo,
                splashColor: Theme.of(context).accentColor,
                child: Text(
                  "Lido!",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Alike",
                    fontSize: 16.0,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  var cobject = new List<dynamic>();
  //var questionType;
  _getCobject(String questionId,BuildContext context) async {
    //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
    print('QuestionId: $questionId');
    ApiCobject.getQuestao(questionId).then((response) {
        cobject = response.data;
        questionType = cobject[0]["cobjects"][0]["template_code"];
        print('Questiontype: $questionType');
      context.read(cobjectProvider).fetchCobjects(cobject);
      List<Cobject> cobjectList = context.read(cobjectProvider).items;
      switch (questionType) {
        case 'PRE':
        //NAVIGATOR(CObject processado, index da primeira questão, tipo);
          Navigator.of(context).pushNamed(SingleLineTextQuestion.routeName,
              arguments: ScreenArguments(cobjectList, 0, 'PRE',0));
          break;
        case 'DDROP':
          Navigator.of(context).pushNamed(DragAndDrop.routeName,
              arguments: ScreenArguments(cobjectList, 0, 'DDROP',0));
          break;
        case 'MTE':
          Navigator.of(context).pushNamed(MultipleChoiceQuestion.routeName,
              arguments: ScreenArguments(cobjectList, 0, 'MTE',0));
          break;
        case 'TXT':
          Navigator.of(context).pushNamed(TextQuestion.routeName,
              arguments: ScreenArguments(cobjectList, 0, 'TXT',0));
          break;
      }
    });
  }

  final cobjectProvider = Provider<Cobjects>((ref) {
    return Cobjects();
  });

}
