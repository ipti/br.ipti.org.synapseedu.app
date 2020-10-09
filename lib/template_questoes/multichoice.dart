import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';

import './share/template_slider.dart';
import 'package:flutter/material.dart';
import './question_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import './model.dart';

// const String BASE_URL = 'https://elesson.com.br/app/library';

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

// final cobjectProvider = StateNotifierProvider<Cobjects>((ref) {
//   return Cobjects();
// });

// final questionChangeNotifierProvider = ChangeNotifierProvider<Cobjects>((ref) {
//   return Cobjects();
// });

class MultipleChoiceQuestion extends ConsumerWidget {
  static const routeName = '/MTE';

  var cobject = new List<dynamic>();
  int questionIndex;

  List<bool> _buttonPressed = [false, false, false];
  int _selectedButton = 3;

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  void changeButtonColor(BuildContext context, index) {
    for (int i = 0; i < 3; i++) {
      if (_buttonPressed[i] == true && i != index) {
        _buttonPressed[i] = false;
        context.read(buttonStateProvider).state = false;
      }
    }
    if (_buttonPressed[index] == false) {
      _buttonPressed[index] = !_buttonPressed[index];
      context.read(buttonStateProvider).state = true;
    }
    _selectedButton = index;
  }

  Widget piece(
      int index, BuildContext context, ScopedReader watch, Question question) {
    final buttonState = watch(buttonStateProvider).state;
    double cardSize = MediaQuery.of(context).size.height / 4.3;
    bool audio = false;
    String grouping = (index + 1).toString();
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      color: Colors.white,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: cardSize, maxWidth: cardSize),
            child: MaterialButton(
              minWidth: 200,
              padding: const EdgeInsets.all(2),
              color: _buttonPressed[index] ? Colors.amber : Colors.green[300],
              child: question.questionImage != null
                  ? Image.network(
                      BASE_URL + '/image/' + question.pieces[grouping]["image"],
                    )
                  // ? Image.asset('assets/img/placeholder.jpg')
                  : Container(
                      child: Text(
                        question.pieces[grouping]["text"],
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      margin: const EdgeInsets.all(20),
                    ),
              // height: cardSize,
              // minWidth: cardSize,
              highlightColor: Theme.of(context).accentColor,
              splashColor: Theme.of(context).accentColor,
              onPressed: () {
                changeButtonColor(context, index);
                // if (question.pieces["correctAnswer"] == index + 1)
                //   print("Acertou");
                // setState(() {
                //   for (int i = 0; i < 3; i++) {
                //     if (_buttonPressed[i] == true && i != index)
                //       _buttonPressed[i] = false;
                //   }
                //   if (_buttonPressed[index] == false)
                //     _buttonPressed[index] = !_buttonPressed[index];
                //   _selectedButton = index;
                // });
              },
            ),
          ),
          if (audio == true)
            IconButton(
              icon: Icon(Icons.volume_up),
              highlightColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).primaryColor,
              onPressed: () {
                playSound(
                  question.pieces[grouping]["sound"],
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobject = args.cobject;
    questionIndex = args.questionIndex;


    // final cobjectProvidersState = watch(cobjectProvider.state);
    bool fetchBool = false;
    if (fetchBool == false) {}
    context.read(cobjectProvider).fetchCobjects(cobject);
    List<Question> question = context.read(cobjectProvider).items;
    String questionDescription = question[questionIndex].header["description"];

    // final questionChangeNotifier = watch(questionChangeNotifierProvider);
    // context.read(questionChangeNotifier).fetchCobjects();

    // print("Header: ${question[0].header}");
    // print("Pieces: ${question[0].pieces}");

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: () => {
          Navigator.of(context).pop(),
        },
      ),
      body: TemplateSlider(
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // alignment: Alignment.bottomLeft,
            children: [
              if (questionDescription.isNotEmpty)
                Text(
                  questionDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
              soundButton(context, question[questionIndex]),
            ],
          ),
        ),
        image: Image.network('https://elesson.com.br/app/library/image/' +
            question[0].header["image"]),
        // image: Image.asset('assets/img/logo.png'),
        activityScreen: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: ,
            children: [
              Text(
                question[0].header["text"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              piece(0, context, watch, question[questionIndex]),
              piece(1, context, watch, question[questionIndex]),
              piece(2, context, watch, question[questionIndex]),
              // if (_selectedButton < 3)
              MaterialButton(
                onPressed: () {
                  _selectedButton > 2
                      ? print('Escolha uma opção')
                      //     // : print(_selectedButton);
                      // : context.read(cobjectProvider).fetchCobjects(cobject);
                      : Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              settings: RouteSettings(
                                arguments: ScreenArguments(cobject, questionIndex++),
                              ),
                              builder: (context) => MultipleChoiceQuestion(
                                  // question: question[0].questionText,
                                  )),
                        );
                },
                minWidth: 200.0,
                height: 45.0,
                color: Colors.indigo,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
