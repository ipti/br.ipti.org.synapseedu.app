import './share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

List<bool> _buttonPressed = [false, false, false];
int _selectedButton = 3;

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  Widget questionPiece(String item, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        child: Text(
          item,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
          maxLines: 1,
        ),
        // color: btncolor[k],
        color: _buttonPressed[index]
            ? Theme.of(context).accentColor
            : Colors.green[300],
        splashColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).accentColor,
        minWidth: 200.0,
        height: 45.0,
        // shape:
        //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: () => {
          setState(() {
            _buttonPressed[index] = !!_buttonPressed[index];
            print(_buttonPressed[index]);
          })
        },
      ),
    );
  }

  void play() {
    //Tocar áudio. Como ele necessita de um áudio exemplo, estou utilizando
    //o ringtone player para testar.

    // AudioPlayer player = new AudioPlayer();
    // await player.play("caminho");

    //Caso não tenha um áudio de exemplo
    FlutterRingtonePlayer.playNotification();
  }

  Widget piece(int index) {
    double cardSize = MediaQuery.of(context).size.height / 4.3;
    return Card(
      margin: EdgeInsets.all(10),
      borderOnForeground: mounted,
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
              child: Image.asset('assets/img/placeholder.jpg'),
              height: cardSize,
              minWidth: cardSize,
              highlightColor: Theme.of(context).accentColor,
              splashColor: Theme.of(context).accentColor,
              onPressed: () {
                setState(() {
                  for (int i = 0; i < 3; i++) {
                    if (_buttonPressed[i] == true && i != index)
                      _buttonPressed[i] = false;
                  }
                  if (_buttonPressed[index] == false)
                    _buttonPressed[index] = !_buttonPressed[index];
                  _selectedButton = index;
                });
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: TemplateSlider(
        title: Text(
          "Texto da questão",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        image: Image.network(
            'http://1.bp.blogspot.com/-Dk9tb3fDa68/UUN932BEVHI/AAAAAAAABNs/iqm8mdkMoA8/s1600/cubo_magico_montado.png'),
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
              piece(0),
              piece(1),
              piece(2),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () {
                  _selectedButton > 2
                      ? print('Escolha uma opção')
                      : print(_selectedButton);
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
