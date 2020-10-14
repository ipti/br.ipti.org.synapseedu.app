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

class SingleLineTextQuestion extends ConsumerWidget {
  static const routeName = '/PRE';
  // ignore: non_constant_identifier_names
  var cobjectList = new List<Cobject>();
  int questionIndex;

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
    //context.read(buttonStateProvider).state = true;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;

    //context.read(cobjectProvider).fetchCobjects(cobject);
    // List<Question> question = context.read(cobjectProvider).items;
    //List<Cobject> cobjectList = context.read(cobjectProvider).items;
    String questionDescription =
        cobjectList[0].questions[questionIndex].header["description"];
    String questionText =
        cobjectList[0].questions[questionIndex].header["text"];

    final buttonState = watch(buttonStateProvider).state;

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          questionDescription,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        sound: soundButton(context, cobjectList[0].questions[questionIndex]),
        image: Image.network('https://elesson.com.br/app/library/image/' +
            cobjectList[0].questions[0].header["image"]),
        activityScreen: Container(
          margin: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (image == true) Image.asset('assets/img/logo.png'),
                if (questionText.isNotEmpty)
                  Text(
                    questionText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                SizedBox(height: 15),
                Card(
                  child: TextFormField(
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    controller: _textController,
                    autofocus: false,
                    style: TextStyle(fontSize: 22.0),
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
                SizedBox(height: 15),
                if (_textController.text.isNotEmpty)
                  MaterialButton(
                    onPressed: () {
                      print(_textController.text);
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
                  ),
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
