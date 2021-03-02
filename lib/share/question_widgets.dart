import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/root/start_and_send_test.dart';
import 'package:elesson/share/qr_code_reader.dart';
import 'package:elesson/template_questoes/PRE_IMG_IA.dart';
import 'package:elesson/template_questoes/ddrop/ddrop.dart';
import 'package:elesson/template_questoes/multiple_choice.dart';
import 'package:elesson/template_questoes/question_and_answer.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/text_question.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../template_questoes/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



import 'api.dart';
import 'block_conclusion.dart';

// Contém alguns métodos e variáveis globais necessárias para as questões.

const String BASE_URL = 'https://elesson.com.br/app/library';

List<String> questionList = ['3988', '3987', '3977', '3976'];
List<String> questionListTest = [];
// esse aqui será a lista que já está recebendo a lista de CObject
//todo substituir o question list anterior por essa variavel

AudioPlayer player = new AudioPlayer();

int indexTextQuestion = 0;

int timeStart;
bool timeStartIscaptured = false;
int timeEnd;

Color buttonBackground = Colors.white;
Color iconBackground = Color(0xFF0000FF);

double fonteDaLetra;
double headerFontSize;

// Variáveis do botão de confirmar

bool confirmButtonColor = true;
bool confirmButtonBorder = true;
bool confirmButtonTextColor = true;

String confirmButtonText = 'CONFIRMAR';
double confirmButtonBackgroundOpacity = 0;

void playSound(String sound) async {
  await player.play(BASE_URL + '/sound/' + sound);
}

var cobjectList = new List<Cobject>();
var cobject = new List<dynamic>();

// todo: essa é a lista que vai receber a lista de cobjects vindo da api
List<String> cobjectIdList = [];

getCobjectList(String blockId) async {
  ApiBlock.getBlock(blockId).then((response) {
    response.data[0]["cobject"].forEach((cobject) {
      // print(cobject["id"]);
      cobjectIdList.add(cobject["id"]);
    });
  });
  // print('Lista: $cobjectIdList');

  return cobjectIdList;
}

getCobject(int listQuestionIndex, BuildContext context,
    List<String> questionListTest) async {
  cobjectList.clear();
  //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
  ApiCobject.getQuestao(questionList[listQuestionIndex]).then((response) {
    cobject = response.data;
    var questionType = cobject[0]["cobjects"][0]["template_code"];
    context.read(cobjectProvider).fetchCobjects(cobject);
    cobjectList = context.read(cobjectProvider).items;
    switch (questionType) {
      case 'PRE':
        //todo voltar ao normal depois aqui
        // Navigator.of(context).pushNamedAndRemoveUntil(SingleLineTextQuestion.routeName, ModalRoute.withName(StartAndSendTest.routeName),
        //     arguments: ScreenArguments(cobjectList, 0, 'PRE', listQuestionIndex));
        Navigator.of(context).pushNamedAndRemoveUntil(PreImgIa.routeName, ModalRoute.withName(StartAndSendTest.routeName),
            arguments: ScreenArguments(cobjectList, 0, 'PRE', listQuestionIndex));
        break;
      case 'DDROP':
        Navigator.of(context).pushNamedAndRemoveUntil(DragAndDrop.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments:
                ScreenArguments(cobjectList, 0, 'DDROP', listQuestionIndex));
        break;
      case 'MTE':
        Navigator.of(context).pushNamedAndRemoveUntil(
            MultipleChoiceQuestion.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments:
                ScreenArguments(cobjectList, 0, 'MTE', listQuestionIndex));
        break;
      case 'TXT':
        Navigator.of(context).pushNamedAndRemoveUntil(TextQuestion.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments:
                ScreenArguments(cobjectList, 0, 'TXT', listQuestionIndex));
        break;
    }
  });
}

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

Widget soundButton(BuildContext context, Question question) {
  return question.header["sound"].isNotEmpty
      // ? IconButton(
      //     icon: Icon(Icons.volume_up),
      //     highlightColor: Theme.of(context).primaryColor,
      //     splashColor: Theme.of(context).primaryColor,
      //     onPressed: () {
      //       playSound(question.header["sound"]);
      //     },
      //   )
      ? OutlineButton(
          padding: EdgeInsets.all(6),
          borderSide: BorderSide(
            color: Color.fromRGBO(0, 0, 255, 1),
          ),
          color: buttonBackground,
          textColor: Color(0xFF0000FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Icon(
            Icons.volume_up,
            size: 40,
            color: Color(0xFF0000FF),
          ),
          onPressed: () => {
            playSound(question.header["sound"]),
          },
        )
      : null;
}

void submitLogic(BuildContext context, int questionIndex, int listQuestionIndex,
    String questionType,
    [String pieceId, bool isCorrect, int finalTime, int intervalResolution]) {
  timeStartIscaptured = false; // resetando
  if (questionIndex < cobjectList[0].questions.length &&
      questionType != 'TXT') {
    switch (questionType) {
      case 'PRE':
        Navigator.of(context).pushReplacementNamed(
            SingleLineTextQuestion.routeName,
            arguments: ScreenArguments(
                cobjectList, questionIndex, 'PRE', listQuestionIndex));
        break;
      case 'DDROP':
        Navigator.of(context).pushReplacementNamed(DragAndDrop.routeName, arguments: ScreenArguments(cobjectList, questionIndex, 'DDROP', listQuestionIndex));
        break;
      case 'MTE':
        Navigator.of(context).pushReplacementNamed(
            MultipleChoiceQuestion.routeName,
            arguments: ScreenArguments(
                cobjectList, questionIndex, 'MTE', listQuestionIndex));
        break;
    }
  } else if (questionType == 'TXT' &&
      indexTextQuestion < cobjectList[0].questions.length) {
    if (questionIndex == 0) {
      indexTextQuestion = 0;
      Navigator.of(context).pushReplacementNamed(TextQuestion.routeName, arguments: ScreenArguments(cobjectList, questionIndex, 'TXT', listQuestionIndex));
    } else {
      print(indexTextQuestion);
      Navigator.of(context).pushNamed(TextQuestion.routeName,
          arguments: ScreenArguments(
              cobjectList, indexTextQuestion, 'TXT', listQuestionIndex));
    }
  } else {
    if (questionType == 'TXT') {
      //todo enviar como correto
      Answer().sendAnswer(pieceId, true, 0,
          intervalResolution: 0, groupId: "", value: "");
      print("enviada rewsposta do txt");
    }
    if (++listQuestionIndex < questionList.length) {
      getCobject(listQuestionIndex, context, questionListTest);
    } else {
      if (questionType != 'TXT')
        Navigator.of(context).pop();
      else
        Navigator.of(context).popAndPushNamed(BlockConclusion.routeName);
    }
  }
}

Widget submitAnswer(
    BuildContext context,
    List<Cobject> cobjectList,
    String questionType,
    int questionIndex,
    int listQuestionIndex,
    String pieceId,
    bool isCorrect,
    {String groupId,
    String value}) {
  double screenHeight = MediaQuery.of(context).size.height;
  double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
  double minButtonWidth = MediaQuery.of(context).size.width < 411 ? 180 : 259;

  timeEnd = DateTime.now().millisecondsSinceEpoch;
  print("$timeEnd or $timeStart");

  return Align(
    child: ButtonTheme(
      minWidth: minButtonWidth,
      height: buttonHeight,
      child: MaterialButton(
        padding: EdgeInsets.all(8),
        color: Colors.white,
        textColor: Color(0xFF00DC8C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
            color: Color(0xFF00DC8C),
          ),
        ),
        child: Text(
          'CONFIRMAR',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: fonteDaLetra,
          ),
        ),
        onPressed: () {
          // modifiquei para funcionar.
          // Answer().sendAnswer(pieceId, isCorrect, timeEnd,
          //     intervalResolution: timeEnd-timeStart, groupId: groupId != null ? groupId : "", value: value != null ? value : "");
          Answer().sendAnswer(
            pieceId,
            isCorrect,
            timeEnd,
            intervalResolution: 1234566,
            groupId: groupId != null ? groupId : "",
            value: value != null ? value : "",
          );
          // ! O erro está vindo daqui, quando tenta subtrair timeStart do timeEnd. Motivo: timeStart vem null

          submitLogic(context, questionIndex, listQuestionIndex, questionType,
              pieceId, isCorrect, timeEnd);
        },
      ),
    ),
  );
}

Future<String> scan(BuildContext context) async {
  String returnedValue = await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new QrCodeReader()));
  //todo implementar aqui direcionamento pra aluma pagina se for preciso (OBS: Tem que ser antes do retorno pra não bugar)
  return returnedValue;
}

Future<void> sendMetaData(
    {String pieceId,
    String groupId,
    int finalTime,
    int intervalResolution,
    String value,
    bool isCorrect}) async {
  print("tentando enviar metadata");
  print(isCorrect);
  try {
    var response = await http.post(
        "http://app.elesson.com.br/api-synapse/synapse/performance/actor/save",
        body: {
          "mode": "proficiency", //ok
          "piece_id": pieceId, //ok
          "group_id": groupId, //ok
          "actor_id": "5", //ok (mockado)
          "final_time": finalTime
              .toString(), //ok // pode ser que precise colocar um .toString()
          "interval_resolution": intervalResolution
              .toString(), //ok // pode ser que precise colocar um .toString()
          "value": value != null ? value : "",
          "iscorrect": isCorrect.toString(),
          "isMetadata": "true"
        },
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        });
  } catch (e) {
    print("ERROR:");
    print(e.message);
  }

  //BASE DO FABIO
  // var data_default = {
  //   'mode': Meet.render_mode,
  //   'piece_id': currentPieceID,
  //   'goal_id': Meet.domCobject.cobject.goal_id,
  //   'actor_id': Meet.actor,
  //   'final_time': self.start_time_piece + self.interval_piece, //TimeStamp quando firmou a resolução da questão
  //   'interval_resolution': self.interval_piece, //delta T
  //   'iscorrect': pieceIsTrue,
  //   'isMetadata': false
  // };
  print("Enviado metadata");
}

// para drag and drop
double double1LoadingPercent = 0;
double double2LoadingPercent = 0;
double double3LoadingPercent = 0;

double double4LoadingPercent = 0;
double double5LoadingPercent = 0;
double double6LoadingPercent = 0;
double current = 0;
// ignore: non_constant_identifier_names, missing_return
Widget LoadingGestureDetector({Widget child, Function onLongPress, Function setState, int definedPosition, double widthScreen, bool enableMargin}) {
  switch (definedPosition) {
    case 1:
      current = double1LoadingPercent;
      break;
    case 2:
      current = double2LoadingPercent;
      break;
    case 3:
      current = double3LoadingPercent;
      break;
    case 4:
      current = double4LoadingPercent;
      break;
    case 5:
      current = double5LoadingPercent;
      break;
    case 6:
      current = double6LoadingPercent;
      break;
  }
  return GestureDetector(
    child: Container(
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Container(
            margin: EdgeInsets.only(left: enableMargin == true ? 32 : 0),
            child: CircularPercentIndicator(
              radius: 120.0,
              animation: true,
              animationDuration: 450,
              lineWidth: 15.0,
              percent: current,
              circularStrokeCap: CircularStrokeCap.round,
              backgroundColor: Colors.transparent,
              progressColor: Colors.green,
            ),
          ),
        ],
      ),
    ),
    onPanCancel: () {
      setState(() {
        switch (definedPosition) {
          case 1:
            setState(() {
              double1LoadingPercent = 0;
            });
            break;
          case 2:
            setState(() {
              double2LoadingPercent = 0;
            });
            break;
          case 3:
            setState(() {
              double3LoadingPercent = 0;
            });
            break;
          case 4:
            setState(() {
              double4LoadingPercent = 0;
            });
            break;
          case 5:
            setState(() {
              double5LoadingPercent = 0;
            });
            break;
          case 6:
            setState(() {
              double6LoadingPercent = 0;
            });
            break;
        }
      });
    },
    onPanDown: (details) {
      switch (definedPosition) {
        case 1:
          setState(() {
            double1LoadingPercent = 1;
          });
          break;
        case 2:
          setState(() {
            double2LoadingPercent = 1;
          });
          break;
        case 3:
          setState(() {
            double3LoadingPercent = 1;
          });
          break;
        case 4:
          setState(() {
            double4LoadingPercent = 1;
          });
          break;
        case 5:
          setState(() {
            double5LoadingPercent = 1;
          });
          break;
        case 6:
          setState(() {
            double6LoadingPercent = 1;
          });
          break;
      }
    },
    onLongPress: () {
      onLongPress();
      //fazendo icone desaparecer
      setState(() {
        switch (definedPosition) {
          case 1:
            setState(() {
              double1LoadingPercent = 0;
            });
            break;
          case 2:
            setState(() {
              double2LoadingPercent = 0;
            });
            break;
          case 3:
            setState(() {
              double3LoadingPercent = 0;
            });
            break;
          case 4:
            setState(() {
              double4LoadingPercent = 0;
            });
            break;
          case 5:
            setState(() {
              double5LoadingPercent = 0;
            });
            break;
          case 6:
            setState(() {
              double6LoadingPercent = 0;
            });
            break;
        }
      });
    },
  );
}
