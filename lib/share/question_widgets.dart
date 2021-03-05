import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/root/start_and_send_test.dart';
import 'package:elesson/share/qr_code_reader.dart';
import 'package:elesson/template_questoes/PRE_IMG_IA.dart';
import 'package:elesson/template_questoes/block_conclusion_arguments_model.dart';
import 'package:elesson/template_questoes/ddrop/ddrop.dart';
import 'package:elesson/template_questoes/ddrop/ddrop_function.dart';
import 'package:elesson/template_questoes/multiple_choice.dart';
import 'package:elesson/template_questoes/question_and_answer.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/text_question.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../template_questoes/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../share/elesson_icon_lib_icons.dart';

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

getCobjectList(String disciplineId) async {
  ApiBlock.getBlockByDiscipline(disciplineId).then((blockId) async {
    var responseBlock = await ApiBlock.getBlock(blockId);
    responseBlock.data[0]["cobject"].forEach((cobject) {
      // print(cobject["id"]);
      cobjectIdList.add(cobject["id"]);
    });

    return cobjectIdList;
  });
  // return cobjectIdList;
}

// Antigo para caso necessite testar
// getCobjectList(String blockId) async {

//   ApiBlock.getBlock(blockId).then((response) {
//     response.data[0]["cobject"].forEach((cobject) {
//       // print(cobject["id"]);
//       cobjectIdList.add(cobject["id"]);
//     });
//   });
//   print('Lista: $cobjectIdList');

//   return cobjectIdList;
// }

getCobject(int listQuestionIndex, BuildContext context,
    List<String> cobjectIdList) async {
  // print('cobjectIdList: $cobjectIdList and ${cobjectIdList.length}');
  int cobjectIdListLength = cobjectIdList.length;
  cobjectList.clear();
  //<======ENVIAR COMO PARAMETRO, O ID DA ESCOLA======>
  ApiCobject.getQuestao(cobjectIdList[listQuestionIndex]).then((response) {
    cobject = response.data;
    // O problema está sendo aqui. Corrigir para pegar todos os cobjects.
    var questionType = cobject[0]["cobjects"][0]["template_code"];
    context.read(cobjectProvider).fetchCobjects(cobject);
    cobjectList = context.read(cobjectProvider).items;
    // print('cobjectQuestionLength ${cobjectList[0].questions.length}');
    print('Lista de cobjects: $cobjectList');
    switch (questionType) {
      case 'PRE':
        // //todo voltar ao normal depois aqui
        // Navigator.of(context).pushNamedAndRemoveUntil(SingleLineTextQuestion.routeName, ModalRoute.withName(StartAndSendTest.routeName),
        //     arguments: ScreenArguments(cobjectList, 0, 'PRE', listQuestionIndex));
        // //todo aqui temos o novaigator levando para o PRE usando IA de imagem
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(PreImgIa.routeName, ModalRoute.withName(StartAndSendTest.routeName), arguments: ScreenArguments(cobjectList, 0, 'PRE', listQuestionIndex));
        Navigator.of(context).pushNamedAndRemoveUntil(
            SingleLineTextQuestion.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectList[0].questions.length,
                0,
                'PRE',
                listQuestionIndex));
        break;
      case 'DDROP':
        Navigator.of(context).pushNamedAndRemoveUntil(DragAndDrop.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectList[0].questions.length,
                0,
                'DDROP',
                listQuestionIndex));
        break;
      case 'MTE':
        Navigator.of(context).pushNamedAndRemoveUntil(
            MultipleChoiceQuestion.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectList[0].questions.length,
                0,
                'MTE',
                listQuestionIndex));
        break;
      case 'TXT':
        Navigator.of(context).pushNamedAndRemoveUntil(TextQuestion.routeName,
            ModalRoute.withName(StartAndSendTest.routeName),
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectList[0].questions.length,
                0,
                'TXT',
                listQuestionIndex));
        break;
    }
  });
}

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

Widget soundButton(BuildContext context, Question question) {
  return question.header["sound"].isNotEmpty
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
    {String pieceId,
    bool isCorrect,
    int finalTime,
    int intervalResolution,
    List<Cobject> cobjectList,
    List<String> cobjectIdList,
    int cobjectIdListLength,
    int cobjectQuestionsLength}) async {
  timeStartIscaptured = false; // resetando
  print('$questionIndex e $cobjectQuestionsLength');

  if (questionIndex < cobjectQuestionsLength && questionType != 'TXT') {
    switch (questionType) {
      case 'PRE':
        Navigator.of(context).pushReplacementNamed(
            SingleLineTextQuestion.routeName,
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectQuestionsLength,
                questionIndex,
                'PRE',
                listQuestionIndex));
        break;
      case 'DDROP':
        Navigator.of(context).pushReplacementNamed(DragAndDrop.routeName,
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectQuestionsLength,
                questionIndex,
                'DDROP',
                listQuestionIndex));
        break;
      case 'MTE':
        Navigator.of(context).pushReplacementNamed(
            MultipleChoiceQuestion.routeName,
            arguments: ScreenArguments(
                cobjectList,
                cobjectIdList,
                cobjectIdListLength,
                cobjectQuestionsLength,
                questionIndex,
                'MTE',
                listQuestionIndex));
        break;
    }
  } else if (questionType == 'TXT' &&
      indexTextQuestion < cobjectQuestionsLength) {
    if (questionIndex == 0) {
      indexTextQuestion = 0;
      Navigator.of(context).pushReplacementNamed(TextQuestion.routeName,
          arguments: ScreenArguments(
              cobjectList,
              cobjectIdList,
              cobjectIdListLength,
              cobjectQuestionsLength,
              questionIndex,
              'TXT',
              listQuestionIndex));
    } else {
      print('Índice da questão: $indexTextQuestion');
      Navigator.of(context).pushNamed(TextQuestion.routeName,
          arguments: ScreenArguments(
              cobjectList,
              cobjectIdList,
              cobjectIdListLength,
              cobjectQuestionsLength,
              indexTextQuestion,
              'TXT',
              listQuestionIndex));
    }
  } else {
    if (questionType == 'TXT') {
      //todo enviar como correto
      // Answer().sendAnswerToApi(pieceId, true, 0,
      //     intervalResolution: 0, groupId: "", value: "");
    }

    // Alterei o if(++listQuestionIndex para o atual, inclusive alterando o endereço do getCobject. Caso tenha problema de não alterar o cobject, é isso);
    if (listQuestionIndex + 1 < cobjectIdListLength) {
      print('no if: $listQuestionIndex e $cobjectIdList');
      getCobject(listQuestionIndex + 1, context, cobjectIdList);
    } else {
      String discipline = cobjectList[0].discipline;
      String year = cobjectList[0].year;

      SharedPreferences prefs;
      prefs = await SharedPreferences.getInstance();

      prefs.setBool(discipline, true);
      indexTextQuestion = 0;
      cobjectList.clear();
      cobjectIdList.clear();
      listQuestionIndex = 0;
      questionIndex = 0;

      switch (discipline) {
        case "Português":
          langOk = true;
          break;
        case "Matemática":
          mathOk = true;
          break;
        case "Ciências":
          sciOk = true;
          break;
        default:
      }

      // Navigator.of(context).pushReplacementNamed("/");
      Navigator.of(context).pushReplacementNamed(
          BlockConclusionScreen.routeName,
          arguments: BlockConclusionArguments(
              discipline: discipline.toUpperCase(), year: year));
      // }
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
    String value,
    List<String> cobjectIdList,
    int cobjectIdListLength,
    int cobjectQuestionsLength}) {
  double screenHeight = MediaQuery.of(context).size.height;
  double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
  double minButtonWidth = MediaQuery.of(context).size.width < 411 ? 180 : 259;
  // timeEnd = DateTime.now().millisecondsSinceEpoch;

  // print("Time start e time end no submit answer: $timeEnd or $timeStart");

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
          Answer().sendAnswerToApi(
            pieceId,
            isCorrect,
            22,
            intervalResolution: 1234566,
            groupId: groupId != null ? groupId : "",
            value: value != null ? value : "",
          );

          // ! O erro está vindo daqui, quando tenta subtrair timeStart do timeEnd. Motivo: timeStart vem null
          // print(
          //     'No submitAnswer: cobjectidListLength: $cobjectIdListLength e cobjectQuestionsLength: $cobjectQuestionsLength');
          submitLogic(context, questionIndex, listQuestionIndex, questionType,
              pieceId: pieceId,
              isCorrect: isCorrect,
              finalTime: 22,
              intervalResolution: 1234566,
              cobjectList: cobjectList,
              cobjectIdList: cobjectIdList,
              cobjectIdListLength: cobjectIdListLength,
              cobjectQuestionsLength: cobjectQuestionsLength);
        },
      ),
    ),
  );
}

class ElessonCardWidget extends StatelessWidget {
  bool blockDone;
  String backgroundImage;
  Function onTap;
  double screenWidth;
  String text;
  BuildContext context;
  ElessonCardWidget({
    Key key,
    this.blockDone,
    this.backgroundImage,
    this.onTap,
    this.screenWidth,
    this.text,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Future<String> retorno = onTap(context);
      },
      child: Container(
        margin: EdgeInsets.all(2),
        height: 166,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36.0),
            side: BorderSide(
              width: blockDone ? 4 : 0,
              color: Color.fromRGBO(0, 220, 140, 0.4),
            ),
          ),
          elevation: 5,
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Stack(
            children: [
              Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
                width: screenWidth,
              ),
              Container(
                height: 166.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Color(0XFFFFFFFF).withOpacity(0),
                      Color(0XFF0000FF).withOpacity(0.4),
                      //Colors.black,
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 18, right: 18, top: 105),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: blockDone
                              ? Color.fromRGBO(0, 220, 140, 1)
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "ElessonIconLib"),
                    ),
                    Icon(
                      ElessonIconLib.chevron_right,
                      color: blockDone
                          ? Color.fromRGBO(0, 220, 140, 1)
                          : Colors.white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
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
Widget LoadingGestureDetector(
    {Widget child,
    Function onLongPress,
    Function setState,
    int definedPosition,
    double widthScreen,
    bool enableMargin}) {
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
