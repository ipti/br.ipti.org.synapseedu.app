import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fdottedline/fdottedline.dart';

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

  bool accepted = false;

  //<=======RECEIVER VALUES========>
  int valueFirstReceiver = 0;
  int valueSecondReceiver = 0;
  int valueThirdReceiver = 0;

  bool showConfirmButton = false;

  //<==========showSender=========>
  bool showFirstSender = true;
  bool showSecondSender = true;
  bool showThirdSender = true;

  //<========linkreceiver=========>
  String urlFirstBox = '';
  String urlSecondBox = '';
  String urlThirdBox = '';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    String questionText = cobjectList[0].questions[questionIndex].header["text"];

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height * 0.93;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: TemplateSlider(
        linkImage: cobjectList[0].questions[0].header['image'] != '' ? BASE_URL + '/image/' + cobjectList[0].questions[0].header['image'] : "",
        sound: soundButton(context, cobjectList[0].questions[0]),
        title: Text(
          cobjectList[0].description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fonteDaLetra, fontWeight: FontWeight.bold),
        ),
        text: Text(
          cobjectList[0].questions[questionIndex].header["text"],
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fonteDaLetra, fontWeight: FontWeight.bold),
        ),
        activityScreen: DAD(heightScreen - 12, widthScreen, cobjectList[0].questions[questionIndex], questionText),
      ),
    );
  }

  Widget DAD(double heightScreen, double widthScreen, Question question, String questionText) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Wrap(
        children: <Widget>[
          //<=================TITULO=====================>
          Container(
            padding: EdgeInsets.only(top: 12, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 76, 0.1),
                  spreadRadius: 1,
                ),
              ],
            ),
            height: heightScreen * 0.15,
            width: widthScreen,
            child: Center(
              child: Text(
                questionText,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: fonteDaLetra),
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
                      showFirstSender == true ? sender(1, 1, widthScreen, question) : undo(1, widthScreen),
                      DragTarget(
                        builder: (context, List<int> candidateData, rejectedData) {
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            width: widthScreen / 2.35,
                            height: widthScreen / 2.6,
                            child: Stack(
                              children: [
                                box(1, widthScreen, question),
                                dragReceiverTemplate(1, widthScreen, question),
                              ],
                            ),
                          );
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        onAccept: (data) {
                          updateSender(data);
                          tradeValue(1, data);
                          updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 1, question);
                          print("""
                            1: $valueFirstReceiver
                            2: $valueSecondReceiver
                            3: $valueThirdReceiver
                            <---------------------->
                          """);
                        },
                      ),
                    ],
                  ),
                  //<=================SEGUNDA=====================>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showSecondSender == true ? sender(2, 2, widthScreen, question) : undo(2, widthScreen),
                      DragTarget(
                        builder: (context, List<int> candidateData, rejectedData) {
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            width: widthScreen / 2.35,
                            height: widthScreen / 2.6,
                            child: Stack(
                              children: [
                                box(2, widthScreen, question),
                                dragReceiverTemplate(2, widthScreen, question),
                              ],
                            ),
                          );
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        onAccept: (data) {
                          updateSender(data);
                          tradeValue(2, data);
                          updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 2, question);
                          print("""
                            1: $valueFirstReceiver
                            2: $valueSecondReceiver
                            3: $valueThirdReceiver
                            <---------------------->
                          """);
                        },
                      ),
                    ],
                  ),
                  //<=================TERCEIRA=====================>
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showThirdSender == true ? sender(3, 3, widthScreen, question) : undo(3, widthScreen),
                      DragTarget(
                        builder: (context, List<int> candidateData, rejectedData) {
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            width: widthScreen / 2.35,
                            height: widthScreen / 2.6,
                            child: Stack(
                              children: [
                                box(3, widthScreen, question),
                                dragReceiverTemplate(3, widthScreen, question),
                              ],
                            ),
                          );
                        },
                        onWillAccept: (data) {
                          return true;
                        },
                        onAccept: (data) {
                          updateSender(data);
                          tradeValue(3, data);
                          updateReceiver(BASE_URL + '/image/' + question.pieces[data.toString()]["image"], 3, question);
                          print("""
                            1: $valueFirstReceiver
                            2: $valueSecondReceiver
                            3: $valueThirdReceiver
                            <---------------------->
                           """);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
          valueFirstReceiver != 0 && valueSecondReceiver != 0 && valueThirdReceiver != 0
              ? submitAnswer(context, cobjectList, 'PRE', ++questionIndex, listQuestionIndex)
              : Container(),
        ],
      ),
    );
  }

  Widget sender(int data, int index, double widthScreen, Question question) {
    return Draggable(
      data: data,
      child: dragSenderTemplate(index, widthScreen, question),
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
                Icon(Icons.settings_backup_restore),
                Text(
                  'DESFAZER',
                  style: TextStyle(color: Color.fromRGBO(189, 0, 255, 0.4), fontWeight: FontWeight.bold, fontSize: fonteDaLetra),
                ),
              ],
            ),
          ),
          color: Color.fromRGBO(189, 0, 255, 0.2),
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
        color: Colors.grey,
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
      margin: EdgeInsets.only(
        left: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(BASE_URL + '/image/' + question.pieces[index.toString()]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Color.fromRGBO(110, 114, 145, 0.2),
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
                color: Color.fromRGBO(189, 0, 255, 0.4),
                width: 2,
              ),
            ),
            width: widthScreen / 2.6,
            height: widthScreen / 2.6,
          )
        : dragSenderInvisible(widthScreen);
  }

  void updateReceiver(String data, int index, Question question) {
    String grouping = (index).toString();
    switch (index) {
      case 1:
        urlFirstBox = data;
        break;
      case 2:
        urlSecondBox = data;
        break;
      case 3:
        urlThirdBox = data;
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
          print('value2: $valueSecondReceiver');
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
          print('value3: $valueThirdReceiver');
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
