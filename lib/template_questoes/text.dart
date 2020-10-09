import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

final cobject = Provider<Cobjects>((ref) {
  return Cobjects();
});

class TXTQuestion extends ConsumerWidget {
  static const routeName = '/TXT';

  var CObject = new List<dynamic>();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    CObject = args.CObject;

    context.read(cobject).fetchCobjects(CObject);
    List<Question> question = context.read(cobject).items;
    String questionDescription = question[0].header["description"];
    String headerText = question[0].header["text"];

    String questionText = question[0].pieces['1']['text'];

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          questionDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        sound: soundButton(context, question[0]),
        image: Image.network('https://elesson.com.br/app/library/image/' +
            question[0].header["image"]),
        activityScreen: Container(
          child: Text(questionText),
        ),
      ),
    );
  }
}
