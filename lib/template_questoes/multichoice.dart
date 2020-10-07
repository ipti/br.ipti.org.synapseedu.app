import 'package:elesson/activity_selection/activity_selection_view.dart';

import './share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import './question_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import './model.dart';

const String BASE_URL = 'https://elesson.com.br/app/library';

final cobject = Provider<Cobjects>((ref) {
  return Cobjects();
});

// final cobject = StateNotifierProvider<Cobjects>((ref) {
//   return Cobjects();
// });

// final questionChangeNotifierProvider = ChangeNotifierProvider<Cobjects>((ref) {
//   return Cobjects();
// });

class MultipleChoiceQuestion extends ConsumerWidget {
  static const routeName = '/MTE';

  var CObject = new List<dynamic>();

  List<bool> _buttonPressed = [false, false, false];
  int _selectedButton = 3;

  AudioPlayer player = new AudioPlayer();

  void playSound(String sound) async {
    await player.play(BASE_URL + '/sound/' + sound);

    // FlutterRingtonePlayer.playNotification();
  }

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  void changeButtonColor(BuildContext context, index) {
    for (int i = 0; i < 3; i++) {
      if (_buttonPressed[i] == true && i != index) {
        _buttonPressed[i] = false;
        context.read(buttonStateProvider).state = false;
        print('hello');
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
      margin: EdgeInsets.all(10),
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
              padding: EdgeInsets.all(2),
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
                      margin: EdgeInsets.all(20),
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

  void questionData(Question question) {
    // print('''${question.questionText}\n
    // a.${question.piecesItem[0]}
    // b.${question.piecesItem[1]}
    // c.${question.piecesItem[2]}''');
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    CObject = args.CObject;
    //print(CObject);

    // final cobjectsState = watch(cobject);
    // final cobjectsState = watch(cobject.state);
    context.read(cobject).fetchCobjects(CObject);
    List<Question> question = context.read(cobject).items;
    // print("\n Tamanho: ${question.length}");

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
              Text(
                question[0].header["text"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              IconButton(
                icon: Icon(Icons.volume_up),
                highlightColor: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).primaryColor,
                onPressed: () {
                  playSound(question[0].header["sound"]);
                },
              ),
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
                'Como visto acima, faça pipipipopopó',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              piece(0, context, watch, question[0]),
              piece(1, context, watch, question[0]),
              piece(2, context, watch, question[0]),
              MaterialButton(
                onPressed: () {
                  // _selectedButton > 2
                  //     ? print('Escolha uma opção')
                  //     // : print(_selectedButton);
                  //     : context.read(cobject).fetchCobjects();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        settings: RouteSettings(
                            // arguments: question[0],
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

class SecondRoute extends StatelessWidget {
  // final String question;

  // SecondRoute({Key key, @required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Question question = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: Column(
          children: [
            // Text(question.questionText),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
