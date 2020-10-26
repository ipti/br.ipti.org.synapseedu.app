import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

class SingleLineTextQuestion extends ConsumerWidget {
  static const routeName = '/PRE';

  // ignore: non_constant_identifier_names
  var cobjectList = new List<Cobject>();
  int questionIndex;
  int listQuestionIndex;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  // ignore: override_on_non_overriding_member
  void dispose() {
    _textController.dispose();
  }

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  void submitButton(BuildContext context) {
    // print(context.read(buttonStateProvider).state);
    context.read(buttonStateProvider).state = true;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    String questionDescription = cobjectList[0].description;
    String questionText = cobjectList[0].questions[questionIndex].header["text"];

    final buttonState = watch(buttonStateProvider).state;

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height * 0.93;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          questionDescription,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fonteDaLetra),
        ),
        text: Text(
          questionText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fonteDaLetra),
        ),
        sound: soundButton(context, cobjectList[0].questions[questionIndex]),
        linkImage: 'https://elesson.com.br/app/library/image/' + cobjectList[0].questions[0].header["image"],
        activityScreen: Form(
          key: _formKey,
          child: SingleChildScrollView(
            reverse: true,
            child: Wrap(
              // crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // if (image == true) Image.asset('assets/img/logo.png'),
                //if (questionText.isNotEmpty)
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  margin: EdgeInsets.only(bottom: heightScreen * 0.22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 76, 0.1),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  height: heightScreen * 0.15,
                  width: widthScreen,
                  child: Center(
                    child: Text(
                      questionText,
                      style: TextStyle(fontSize: fonteDaLetra),
                    ),
                  ),
                ),
                //SizedBox(height: 15),
                Container(
                  height: heightScreen * 0.70,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(right: 16, left: 16, bottom: heightScreen / 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color.fromRGBO(189, 0, 255, 0.2),
                          width: 2,
                        ),
                      ),
                      height: heightScreen / 3,
                      child: TextFormField(
                        maxLines: 3,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        controller: _textController,
                        autofocus: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: fonteDaLetra),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Escreva a resposta aqui',
                          contentPadding: const EdgeInsets.all(8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.7),
                          ),
                        ),
                        // Utiliza o onChanged em conjunto com o provider para renderizar a UI assim que o form
                        // receber um texto, acionando o botão. O condicional faz com que a UI seja renderizada
                        // apenas uma vez enquanto o texto estiver sendo digitado.
                        onChanged: (val) {
                          if (_textController.text.length == 1) {
                            submitButton(context);
                          }
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Não se esqueça de digitar a resposta!';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: 15),
                // if (_textController.text.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.only(bottom: 4.0),
                //     child: submitAnswer(context, cobjectList, 'PRE', ++questionIndex, listQuestionIndex),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ScreenArguments {
//   final List<dynamic> cobject;
//   ScreenArguments(this.cobject);
// }