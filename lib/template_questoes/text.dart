import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

class TextQuestion extends ConsumerWidget {
  static const routeName = '/TXT';

  var cobject = new List<dynamic>();
  int questionIndex;
  String questionType;
  bool fetch = false;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobject = args.cobject;
    questionIndex = args.questionIndex;
    questionType = args.questionType;
    if (fetch == false) {
      context.read(cobjectProvider).fetchCobjects(cobject);
      print("fetch");
      fetch = true;
    } else
      print("no fetch");

    List<Question> question = context.read(cobjectProvider).items;

    String questionDescription = question[questionIndex].header["description"];
    String headerText = question[questionIndex].header["text"];

    String questionText = question[questionIndex].pieces['1']['text'];

    // print("Header: ${question[0].header}");
    // print("Pieces: ${question[0].pieces}");

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          questionDescription,
          //questionDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        sound: soundButton(context, question[questionIndex]),
        image: Image.network('https://elesson.com.br/app/library/image/' +
            question[questionIndex].header["image"]),
        text: Text(headerText),
        activityScreen: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(questionText),
              // submitAnswer(context, cobject, questionType, questionIndex),
              MaterialButton(
                onPressed: () {
                  print("lido");
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
}
