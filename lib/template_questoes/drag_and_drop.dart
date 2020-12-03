import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fdottedline/fdottedline.dart';
import 'dart:math';
import 'share/image_detail_screen.dart';
import 'model.dart';

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

class DragAndDrop extends StatefulWidget {
  static const routeName = '/DDROP';

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  var cobjectList = new List<Cobject>();
  int questionIndex;
  int listQuestionIndex;

  bool isCorrect = false;
  bool accepted = false;

  //<=======RECEIVER VALUES=======>
  int valueFirstReceiver = 0;
  int valueSecondReceiver = 0;
  int valueThirdReceiver = 0;

  //<==========showSender=========>
  bool showFirstSender = true;
  bool showSecondSender = true;
  bool showThirdSender = true;

  //<========linkreceiver=========>
  String urlFirstBox = '';
  String urlSecondBox = '';
  String urlThirdBox = '';

  //<========colorReceiver========>
  Color colorFirstReceiverAccepted;
  Color colorSecondReceiverAccepted;
  Color colorThirdReceiverAccepted;

  Random random = new Random();
  var randomNumber = [0, 0, 0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int aux;
    for (int i = 0; i < 3; i++) {
      aux = random.nextInt(3) + 1;
      print("$aux");
      if (!randomNumber.contains(aux)) {
        randomNumber[i] = aux;
      } else {
        i--;
      }
    }
    print("lista de sorteados: $randomNumber");
  }

  String pieceId = "";

  @override
  Widget build(BuildContext context) {
    //pieceId = cobjectList[0].questions[questionIndex].pieceId;
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    String questionText = cobjectList[0].questions[questionIndex].header["text"];

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height * 0.93;
    Stopwatch chronometer = Stopwatch();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: TemplateSlider(
        linkImage: cobjectList[0].questions[0].header['image'] != '' ? BASE_URL + '/image/' + cobjectList[0].questions[0].header['image'] : "",
        sound: cobjectList[0].questions[0].header["sound"],
        title: Text(
          cobjectList[0].description.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        text: Text(
          cobjectList[0].questions[questionIndex].header["text"].toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        activityScreen: activityScreen(heightScreen - 12, widthScreen, cobjectList[0].questions[questionIndex], questionText, chronometer),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget activityScreen(double heightScreen, double widthScreen, Question question, String questionText, Stopwatch chronometer) {
    String pieceId = cobjectList[0].questions[questionIndex].pieceId;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Wrap(
        children: <Widget>[
          //<=================TITULO=====================>
          Container(
            padding: EdgeInsets.only(top: 12, left: 16, right: 16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 76, 0.1),
                spreadRadius: 1,
              ),
            ]),
            height: heightScreen * 0.15,
            width: widthScreen,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  playSound(cobjectList[0].questions[questionIndex].header["sound"]);
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    questionText.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: fonteDaLetra,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: heightScreen * 0.85,
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Stack(children: [
              Center(child: Image.asset('assets/img/divisoria.png', scale: .9)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //<=================PRIMEIRA=====================>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showFirstSender == true
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: sender(1, 1, widthScreen, question),
                            )
                          : undo(1, widthScreen),
                      receiver(4, widthScreen, question),
                    ],
                  ),
                  //<=================SEGUNDA=====================>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showSecondSender == true
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: sender(2, 2, widthScreen, question),
                            )
                          : undo(2, widthScreen),
                      receiver(5, widthScreen, question),
                    ],
                  ),
                  //<=================TERCEIRA=====================>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showThirdSender == true
                          ? Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: sender(3, 3, widthScreen, question),
                            )
                          : undo(3, widthScreen),
                      receiver(6, widthScreen, question),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          valueFirstReceiver != 0 && valueSecondReceiver != 0 && valueThirdReceiver != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: submitAnswer(context, cobjectList, 'DDROP', ++questionIndex, listQuestionIndex, pieceId, isCorrect),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget receiver(int posicao, double widthScreen, Question question) {
    int wret = randomNumber[posicao - 4];
    switch (wret) {
      case 1:
        return DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            return Container(
              margin: EdgeInsets.only(right: 16),
              width: widthScreen / 2.35,
              height: widthScreen / 2.6,
              child: Stack(
                children: [
                  GestureDetector(
                    child: box(1, widthScreen, question),
                    // onLongPress: () {
                    //   if (question.pieces["1_1"]["image"].isNotEmpty)
                    //     Navigator.of(context)
                    //         .pushNamed(ImageDetailScreen.routeName, arguments: DetailScreenArguments(grouping: "1_1", question: question));
                    // },
                  ),
                  LoadingGestureDetector(
                    definedPosition: posicao,
                    setState: setState,
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question));
                    },
                    child: dragReceiverTemplate(1, widthScreen, question),
                  ),
                ],
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            colorFirstReceiverAccepted = data == 1
                ? Color.fromRGBO(189, 0, 255, 0.4)
                : data == 2
                    ? Color.fromRGBO(255, 138, 0, 0.4)
                    : Color.fromRGBO(0, 203, 255, 0.2);
            updateSender(data);
            tradeValue(1, data);
            updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 1, question);

            sendMetaData(
                isCorrect: data == 1 ? true : false,
                finalTime: 0,
                groupId: "1",
                intervalResolution: DateTime.now().millisecondsSinceEpoch - timeStart,
                value: "",
                pieceId: pieceId.toString());

            verifyIsCorrect();
            print("""
                            1_1: $valueFirstReceiver
                            2_1: $valueSecondReceiver
                            3_1: $valueThirdReceiver
                            <---------------------->
                          """);
          },
        );
        break;
      case 2:
        return DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            return Container(
              margin: EdgeInsets.only(right: 16),
              width: widthScreen / 2.35,
              height: widthScreen / 2.6,
              child: Stack(
                children: [
                  GestureDetector(
                    child: box(2, widthScreen, question),
                    // onLongPress: () {
                    //   if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                    //     Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                    //         arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question));
                    // },
                  ),
                  LoadingGestureDetector(
                    definedPosition: posicao,
                    setState: setState,
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question));
                    },
                    child: dragReceiverTemplate(2, widthScreen, question),
                  ),
                ],
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            colorSecondReceiverAccepted = data == 1
                ? Color.fromRGBO(189, 0, 255, 0.4)
                : data == 2
                    ? Color.fromRGBO(255, 138, 0, 0.4)
                    : Color.fromRGBO(0, 203, 255, 0.2);
            updateSender(data);
            tradeValue(2, data);
            updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 2, question);
            verifyIsCorrect();
            print("""
                            1_1: $valueFirstReceiver
                            2_1: $valueSecondReceiver
                            3_1: $valueThirdReceiver
                            <---------------------->
                          """);
          },
        );
        break;
      case 3:
        return DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            return Container(
              margin: EdgeInsets.only(right: 16),
              width: widthScreen / 2.35,
              height: widthScreen / 2.6,
              child: Stack(
                children: [
                  GestureDetector(
                    child: box(3, widthScreen, question),
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question));
                    },
                  ),
                  LoadingGestureDetector(
                    definedPosition: posicao,
                    setState: setState,
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question));
                    },
                    child: dragReceiverTemplate(3, widthScreen, question),
                  ),
                ],
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (data) {
            colorThirdReceiverAccepted = data == 1
                ? Color.fromRGBO(189, 0, 255, 0.4)
                : data == 2
                    ? Color.fromRGBO(255, 138, 0, 0.4)
                    : Color.fromRGBO(0, 203, 255, 0.2);
            updateSender(data);
            tradeValue(3, data);
            updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 3, question);
            verifyIsCorrect();
            print("""
                            1_1: $valueFirstReceiver
                            2_1: $valueSecondReceiver
                            3_1: $valueThirdReceiver
                            <---------------------->
                           """);
          },
        );
        break;
    }
  }

  Widget sender(int data, int index, double widthScreen, Question question) {
    return Draggable(
      data: data,
      child: LoadingGestureDetector(
        definedPosition: 1,
        setState: setState,
        onLongPress: () {
          if (question.pieces["${index}"]["image"].isNotEmpty)
            Navigator.of(context).pushNamed(ImageDetailScreen.routeName, arguments: DetailScreenArguments(grouping: "${index}", question: question));
        },
        child: dragSenderTemplate(index, widthScreen, question),
      ),
      feedback: dragSenderTemplate(index, widthScreen, question),
      childWhenDragging: dragSenderInvisible(widthScreen),
    );
  }

  Widget undo(int index, double widthScreen) {
    return GestureDetector(
      onTap: () {
        updateSender(index);
        clearReceiver(index);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16),
        child: FDottedLine(
          child: Container(
            width: widthScreen / 2.6,
            height: widthScreen / 2.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/undoIcon.png",
                  color: index == 1
                      ? Color.fromRGBO(189, 0, 255, 0.4)
                      : index == 2
                          ? Color.fromRGBO(255, 138, 0, 0.4)
                          : Color.fromRGBO(0, 203, 255, 0.4),
                ),
                Text(
                  'DESFAZER',
                  style: TextStyle(
                      color: index == 1
                          ? Color.fromRGBO(189, 0, 255, 0.4)
                          : index == 2
                              ? Color.fromRGBO(255, 138, 0, 0.4)
                              : Color.fromRGBO(0, 203, 255, 0.4),
                      fontWeight: FontWeight.bold,
                      fontSize: fonteDaLetra),
                ),
              ],
            ),
          ),
          color: index == 1
              ? Color.fromRGBO(189, 0, 255, 0.4)
              : index == 2
                  ? Color.fromRGBO(255, 138, 0, 0.4)
                  : Color.fromRGBO(0, 203, 255, 0.4),
          strokeWidth: 4,
          corner: FDottedLineCorner.all(12),
          dottedLength: 6,
        ),
      ),
    );
  }

  Widget box(int index, double widthScreen, Question question) {
    return Container(
      margin: EdgeInsets.only(right: 0, left: widthScreen * 0.039),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(BASE_URL + '/image/' + question.pieces['$index' + '_1']["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Color.fromRGBO(189, 0, 255, 0.2),
          width: 2,
        ),
      ),
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  Widget dragSenderInvisible(double widthScreen) {
    return Container(
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  Widget dragSenderTemplate(int index, double widthScreen, Question question) {
    return Container(
      // margin: EdgeInsets.only(
      //   left: 16,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(BASE_URL + '/image/' + question.pieces[index.toString()]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: index == 1
              ? Color.fromRGBO(189, 0, 255, 0.2)
              : index == 2
                  ? Color.fromRGBO(255, 138, 0, 0.2)
                  : Color.fromRGBO(0, 203, 255, 0.2),
          width: 2,
        ),
      ),
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  Widget dragReceiverTemplate(int index, double widthScreen, Question question) {
    String urlToThisReceiver = '';
    bool show = false;
    switch (index) {
      case 1:
        if (urlFirstBox != '') {
          show = true;
          urlToThisReceiver = urlFirstBox;
        }
        break;
      case 2:
        if (urlSecondBox != '') {
          show = true;
          urlToThisReceiver = urlSecondBox;
        }
        break;
      case 3:
        if (urlThirdBox != '') {
          show = true;
          urlToThisReceiver = urlThirdBox;
        }
        break;
    }
    return show != false
        ? Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(urlToThisReceiver),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                //ioleirru
                color: index == 1
                    ? colorFirstReceiverAccepted
                    : index == 2
                        ? colorSecondReceiverAccepted
                        : colorThirdReceiverAccepted,
                width: 2,
              ),
            ),
            width: widthScreen / 2.6,
            height: widthScreen / 2.6,
          )
        : dragSenderInvisible(widthScreen);
  }

  void updateReceiver(String url, int index, Question question) {
    switch (index) {
      case 1:
        urlFirstBox = url;
        break;
      case 2:
        urlSecondBox = url;
        break;
      case 3:
        urlThirdBox = url;
        break;
    }
  }

  void tradeValue(int receiverIndex, int data) {
    switch (receiverIndex) {
      case 1:
        if (valueFirstReceiver != 0) {
          updateSender(valueFirstReceiver);
          valueFirstReceiver = data;
        } else if (valueSecondReceiver == data) {
          valueSecondReceiver = 0;
          valueFirstReceiver = data;
          updateSender(2);
        } else if (valueThirdReceiver == data) {
          valueThirdReceiver = 0;
          valueFirstReceiver = data;
          updateSender(3);
        } else {
          valueFirstReceiver = data;
        }
        break;
      case 2:
        if (valueSecondReceiver != 0) {
          updateSender(valueSecondReceiver);
          valueSecondReceiver = data;
        } else if (valueFirstReceiver == data) {
          valueFirstReceiver = 0;
          valueSecondReceiver = data;
          updateSender(1);
        } else if (valueThirdReceiver == data) {
          valueThirdReceiver = 0;
          valueSecondReceiver = data;
          updateSender(3);
        } else {
          valueSecondReceiver = data;
        }
        break;
      case 3:
        if (valueThirdReceiver != 0) {
          updateSender(valueThirdReceiver);
          valueThirdReceiver = data;
        } else if (valueFirstReceiver == data) {
          valueFirstReceiver = 0;
          valueThirdReceiver = data;
          updateSender(1);
        } else if (valueSecondReceiver == data) {
          valueSecondReceiver = 0;
          valueThirdReceiver = data;
          updateSender(2);
        } else {
          valueThirdReceiver = data;
        }
        break;
    }
  }

  void updateSender(int index) {
    setState(() {
      switch (index) {
        case 1:
          showFirstSender = !showFirstSender;
          break;
        case 2:
          showSecondSender = !showSecondSender;
          break;
        case 3:
          showThirdSender = !showThirdSender;
          break;
      }
    });
  }

  void verifyIsCorrect() {
    if (valueFirstReceiver == 1 && valueSecondReceiver == 2 && valueThirdReceiver == 3) {
      isCorrect = true;
    }
  }

  void clearReceiver(int index) {
    if (valueFirstReceiver == index) {
      valueFirstReceiver = 0;
      urlFirstBox = '';
    } else if (valueSecondReceiver == index) {
      valueSecondReceiver = 0;
      urlSecondBox = '';
    } else {
      valueThirdReceiver = 0;
      urlThirdBox = '';
    }
  }
}
