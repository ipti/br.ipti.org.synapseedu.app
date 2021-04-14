import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/confirm_button_widget.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fdottedline/fdottedline.dart';
import '../share/image_detail_screen.dart';
import '../model.dart';
import 'ddrop_function.dart';

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
  var cobjectIdList = new List<String>();
  var cobjectIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int aux;
    randomNumber = [0,0,0];
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
  int cobjectQuestionsLength;
  int cobjectIdLength;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    cobjectIdList = args.cobjectIdList;
    questionIndex = args.questionIndex;
    cobjectIndex = args.cobjectIndex;
    cobjectQuestionsLength = args.cobjectQuestionsLength;
    cobjectIdLength = args.cobjectIdLength;

    String questionText = cobjectList[0].questions[questionIndex].header["text"];

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height * 0.93;
    Stopwatch chronometer = Stopwatch();
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: TemplateSlider(
        cobjectIdList: cobjectIdList,
        cobjectIdListLength: cobjectIdLength,
        questionIndex: questionIndex,
        cobjectIndex: cobjectIndex,
        cobjectQuestionsLength: cobjectQuestionsLength,
        cobjectList: cobjectList,
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
        activityScreen: activityScreen(heightScreen - 12, widthScreen, cobjectList[0].questions[questionIndex], questionText, chronometer,
            cobjectIdList: cobjectIdList, cobjectList: cobjectList, questionIndex: questionIndex, cobjectQuestionsLength: cobjectQuestionsLength, cobjectIdLength: cobjectIdLength),
      ),
    );
  }

  Widget activityScreen(double heightScreen, double widthScreen, Question question, String questionText, Stopwatch chronometer,
      {List<String> cobjectIdList, List<Cobject> cobjectList, int questionIndex, int cobjectQuestionsLength, int cobjectIdLength}) {
    String pieceId = cobjectList[0].questions[questionIndex].pieceId;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Wrap(
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
                      child: Center(
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
              ),
              Container(
                // color: Colors.red,
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
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              valueFirstReceiver != 0 && valueSecondReceiver != 0 && valueThirdReceiver != 0
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: ConfirmButtonWidget(
                          // buttonHeight: buttonHeight,
                          context: context,
                          cobjectList: cobjectList,
                          cobjectIdList: cobjectIdList,
                          questionType: 'DDROP',
                          questionIndex: ++questionIndex,
                          cobjectIndex: cobjectIndex,
                          cobjectIdListLength: cobjectIdLength,
                          cobjectQuestionsLength: cobjectQuestionsLength,
                          pieceId: pieceId,
                          isCorrect: isCorrect,
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
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
                  box(index: 1, widthScreen: widthScreen, question: question,cor: valueFirstReceiver == 1 ? Color(0xFFBD00FF).withOpacity(0.2) : valueFirstReceiver == 3 ? Color(0xFF00CBFF).withOpacity(0.2) : valueFirstReceiver == 2 ? Color(0xFFFF8A00).withOpacity(0.2) : null),
                  LoadingGestureDetector(
                    enableMargin: true,
                    widthScreen: widthScreen,
                    definedPosition: posicao,
                    setState: setState,
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question, heroString: 'box1'));
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
            updateSender(data, setState);
            tradeValue(1, data, setState);
            updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 1, question);

            sendMetaData(
                isCorrect: data == 1 ? true : false,
                finalTime: 0,
                groupId: "1",
                intervalResolution: 1 - DateTime.now().millisecondsSinceEpoch,
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
                  box(index: 2, widthScreen: widthScreen, question: question,cor: valueSecondReceiver == 1 ? Color(0xFFBD00FF).withOpacity(0.2) : valueSecondReceiver == 3 ? Color(0xFF00CBFF).withOpacity(0.2) : valueSecondReceiver == 2 ? Color(0xFFFF8A00).withOpacity(0.2) : null),
                  LoadingGestureDetector(
                    enableMargin: true,
                    widthScreen: widthScreen,
                    definedPosition: posicao,
                    setState: setState,
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question, heroString: 'box2'));
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
            updateSender(data, setState);
            tradeValue(2, data, setState);
            updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 2, question);
            sendMetaData(
                isCorrect: data == 2 ? true : false,
                finalTime: 0,
                groupId: "2",
                intervalResolution: 1 - DateTime.now().millisecondsSinceEpoch,
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
      case 3:
        return DragTarget(
          builder: (context, List<int> candidateData, rejectedData) {
            return Container(
              margin: EdgeInsets.only(right: 16),
              width: widthScreen / 2.35,
              height: widthScreen / 2.6,
              child: Stack(
                children: [
                  box(index: 3, widthScreen: widthScreen, question: question,cor: valueThirdReceiver == 1 ? Color(0xFFBD00FF).withOpacity(0.2) : valueThirdReceiver == 3 ? Color(0xFF00CBFF).withOpacity(0.2) : valueThirdReceiver == 2 ? Color(0xFFFF8A00).withOpacity(0.2) : null),
                  LoadingGestureDetector(
                    enableMargin: true,
                    widthScreen: widthScreen,
                    definedPosition: posicao,
                    setState: setState,
                    onLongPress: () {
                      if (question.pieces["${randomNumber[posicao - 4]}_1"]["image"].isNotEmpty)
                        Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                            arguments: DetailScreenArguments(grouping: "${randomNumber[posicao - 4]}_1", question: question, heroString: 'box3'));
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
            updateSender(data, setState);
            tradeValue(3, data, setState);
            updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 3, question);
            sendMetaData(
                isCorrect: data == 3 ? true : false,
                finalTime: 0,
                groupId: "3",
                intervalResolution: 1 - DateTime.now().millisecondsSinceEpoch,
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
    }
  }

  Widget sender(int data, int index, double widthScreen, Question question) {
    return Draggable(
      data: data,
      child: Hero(
        tag: index == 1
            ? 'sender1'
            : index == 2
                ? 'sender2'
                : 'sender3',
        child: LoadingGestureDetector(
          widthScreen: widthScreen,
          definedPosition: index,
          setState: setState,
          onLongPress: () {
            if (question.pieces["${index}"]["image"].isNotEmpty)
              Navigator.of(context).pushNamed(ImageDetailScreen.routeName,
                  arguments: DetailScreenArguments(
                      grouping: "${index}",
                      question: question,
                      heroString: index == 1
                          ? 'sender1'
                          : index == 2
                              ? 'sender2'
                              : 'sender3'));
          },
          child: dragSenderTemplate(index, widthScreen, question),
        ),
      ),
      feedback: dragSenderTemplate(index, widthScreen, question),
      childWhenDragging: dragSenderInvisible(widthScreen),
    );
  }

  Widget undo(int index, double widthScreen) {
    setState(() {
      switch (index) {
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
      }
    });
    return GestureDetector(
      onTap: () {
        updateSender(index, setState);
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

  Widget box({int index, double widthScreen, Question question, Color cor}) {
    return Hero(
      tag: index == 1
          ? 'box1'
          : index == 2
              ? 'box2'
              : 'box3',
      child: Container(
        margin: EdgeInsets.only(right: 0, left: widthScreen * 0.039),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(BASE_URL + '/image/' + question.pieces['$index' + '_1']["image"]),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: cor != null ? cor : Color(0xFF6E7291).withOpacity(0.2),
            width: 2,
          ),
        ),
        width: widthScreen / 2.6,
        height: widthScreen / 2.6,
      ),
    );
  }

  Widget dragSenderInvisible(double widthScreen) {
    return Container(
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  Widget dragSenderTemplate(int index, double widthScreen, Question question) {
    return Stack(
      children: [
        Container(
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
        ),
        Material(type: MaterialType.transparency,child: Center(child: Container(color: Colors.white,child: Text(question.pieces[index.toString()]['text'],style: TextStyle(fontWeight: FontWeight.bold),),)))
      ],
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
            //margin: EdgeInsets.only(right: 0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(urlToThisReceiver),
                fit: BoxFit.cover,
              ),
              border: Border.all(
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
}
