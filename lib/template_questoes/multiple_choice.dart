import 'package:elesson/activity_selection/activity_selection_view.dart';

import './share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import './question_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import './model.dart';

String mockJson = '''[ {
  "valid" : true,
  "error" : [ "Num Cobjects: 1" ],
  "cobjects" : [ {
    "cobject_id" : "3902",
    "description" : "",
    "cobject_type" : "Atividade",
    "template_name" : "Multipla Escolha",
    "template_code" : "MTE",
    "format_code" : "Vertical",
    "interative_code" : "Click",
    "theme" : null,
    "status" : "on",
    "goal" : "CONVERTER AS UNIDADES DE MEDIDAS: CAPACIDADE, VOLUME E SUPERFÍCIE",
    "goal_id" : "10107",
    "degree_name" : "Fundamental - 5º ANO/2",
    "stage" : "18",
    "year" : "5",
    "grade" : "2",
    "degree_parent" : "Fundamental Menor - 5º ANO",
    "discipline" : "Matemática",
    "content" : "Problemas",
    "content_parent_name" : null,
    "modality" : "Sonoro",
    "content_parent" : null,
    "id" : "1",
    "total_pieces" : "11",
    "screens" : [ {
      "id" : "8619",
      "cobject_id" : "3902",
      "oldID" : null,
      "position" : "0",
      "piecesets" : [ {
        "id" : "9007",
        "description" : "",
        "groups" : {
          "1" : {
            "elements" : [ {
              "id" : "61908",
              "piecesetElementID" : "17521",
              "type" : "text",
              "generalProperties" : [ {
                "name" : "language",
                "value" : "português"
              }, {
                "name" : "text",
                "value" : "Uma piscina olímpica tem 200 dm³ de volume. Quantos decâmetros cúbicos tem essa piscina?"
              } ],
              "piecesetElement_Properties" : {
                "grouping" : "1",
                "layertype" : null
              }
            }, {
              "id" : "61909",
              "piecesetElementID" : "17522",
              "type" : "multimidia",
              "generalProperties" : [ {
                "name" : "library_id",
                "value" : "36709"
              }, {
                "name" : "width",
                "value" : "1240"
              }, {
                "name" : "height",
                "value" : "1240"
              }, {
                "name" : "src",
                "value" : "30b987599888ca2f05669224378280ca.jpg"
              }, {
                "name" : "extension",
                "value" : "jpg"
              }, {
                "name" : "alias",
                "value" : "Pedro_Pensando_1"
              }, {
                "name" : "library_type",
                "value" : "image"
              } ],
              "piecesetElement_Properties" : {
                "grouping" : "1",
                "layertype" : null
              }
            } ]
          }
        },
        "pieces" : [ {
          "id" : "9112",
          "name" : null,
          "description" : null,
          "groups" : {
            "1" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "0,0002 dam³"
                } ],
                "id" : "61910",
                "pieceElementID" : "44878",
                "pieceElement_Properties" : {
                  "grouping" : "1",
                  "layertype" : "Acerto"
                },
                "type" : "text"
              } ]
            },
            "2" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "0,02 dam³"
                } ],
                "id" : "61911",
                "pieceElementID" : "44879",
                "pieceElement_Properties" : {
                  "grouping" : "2",
                  "layertype" : "Erro"
                },
                "type" : "text"
              } ]
            },
            "3" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "20 dam³"
                }, {
                  "name" : "width",
                  "value" : "283"
                }, {
                  "name" : "height",
                  "value" : "213"
                }, {
                  "name" : "content",
                  "value" : "OBJECT"
                }, {
                  "name" : "nstyle",
                  "value" : "Infantil"
                }, {
                  "name" : "extension",
                  "value" : "jpg"
                }, {
                  "name" : "src",
                  "value" : "803.jpg"
                }, {
                  "name" : "library_type",
                  "value" : "image"
                } ],
                "id" : "61912",
                "pieceElementID" : "44880",
                "pieceElement_Properties" : {
                  "grouping" : "3",
                  "layertype" : "Erro"
                },
                "type" : "text"
              } ]
            },
            "4" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "2 000 dam³"
                }, {
                  "name" : "width",
                  "value" : "303"
                }, {
                  "name" : "height",
                  "value" : "286"
                }, {
                  "name" : "color",
                  "value" : "COLOR"
                }, {
                  "name" : "content",
                  "value" : "OBJECT"
                }, {
                  "name" : "nstyle",
                  "value" : "Infantil"
                }, {
                  "name" : "extension",
                  "value" : "jpg"
                }, {
                  "name" : "src",
                  "value" : "409.jpg"
                }, {
                  "name" : "library_type",
                  "value" : "image"
                } ],
                "id" : "61913",
                "pieceElementID" : "44881",
                "pieceElement_Properties" : {
                  "grouping" : "4",
                  "layertype" : "Erro"
                },
                "type" : "text"
              } ]
            }
          },
          "types_elements" : [ ]
        } ],
        "template_code" : "PRE"
      } ]
    }],
    "elements" : [ ]
  } ]
} ]''';

final cobject = StateNotifierProvider<Cobjects>((ref) {
  return Cobjects();
});

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
                      // : print(_selectedButton);
                      : cobject;
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