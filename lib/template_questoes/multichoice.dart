import './share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import './question_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import './model.dart';

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
  List<bool> _buttonPressed = [false, false, false];
  int _selectedButton = 3;

  void play() {
    //Tocar áudio. Como ele necessita de um áudio exemplo, estou utilizando
    //o ringtone player para testar.

    // AudioPlayer player = new AudioPlayer();
    // await player.play("caminho");

    //Caso não tenha um áudio de exemplo
    FlutterRingtonePlayer.playNotification();
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
    // print(question.pieceImages);
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
              color: _buttonPressed[index] ? Colors.amber : Colors.green[300],
              child: question.questionImage == null
                  ? Image.network(
                      'http://dev.elesson.com.br:8080/library/image/' +
                          question.questionImage)
                  // : Image.asset('assets/img/placeholder.jpg'),
                  : Text(question.firstItem),
              height: cardSize,
              minWidth: cardSize,
              highlightColor: Theme.of(context).accentColor,
              splashColor: Theme.of(context).accentColor,
              onPressed: () {
                changeButtonColor(context, index);
                print(question.questionImage);
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
          IconButton(
            icon: Icon(Icons.volume_up),
            highlightColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).primaryColor,
            onPressed: () {
              play();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final cobjectsState = watch(cobject);
    // final cobjectsState = watch(cobject.state);
    context.read(cobject).fetchCobjects();
    List<Question> question = context.read(cobject).items;

    // final questionChangeNotifier = watch(questionChangeNotifierProvider);

    // context.read(questionChangeNotifier).fetchCobjects();

    // if (questionChangeNotifier.items == null) print("nullou");

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          question[0].questionText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        image: Image.network('http://dev.elesson.com.br:8080/library/image/' +
            question[0].questionImage),
        activityScreen: Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () {
                  // _selectedButton > 2
                  //     ? print('Escolha uma opção')
                  //     // : print(_selectedButton);
                  //     : context.read(cobject).fetchCobjects();
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