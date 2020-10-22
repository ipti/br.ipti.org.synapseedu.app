import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

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

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height * 0.93;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: TemplateSlider(
        linkImage: cobjectList[0].questions[0].header['image'] != '' ? BASE_URL + '/image/' + cobjectList[0].questions[0].header['image'] : '',
        sound: soundButton(context, cobjectList[0].questions[0]),
        title: Text(
          cobjectList[0].questions[questionIndex].header["text"],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        activityScreen: DAD(heightScreen - 12, widthScreen, cobjectList[0].questions[questionIndex]),
      ),
      //bottomNavigationBar: BottomNavibar(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget DAD(double heightScreen, double widthScreen, Question question) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Wrap(
        children: <Widget>[
          //<=================TITULO=====================>
          Container(
            height: heightScreen * 0.15,
            width: widthScreen,
            color: Colors.green,
          ),
          Container(
            height: heightScreen * 0.85,
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //<=================PRIMEIRA=====================>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Draggable(
                      data: 1,
                      child: dragSender(0, widthScreen, question),
                      feedback: dragSender(0, widthScreen, question),
                      childWhenDragging: dragSenderInvisible(widthScreen),
                    ),
                    DragTarget(
                      builder: (context, List<int> candidateData, rejectedData) {
                        return dragReceiver(3, widthScreen, question);
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        valueFirstReceiver = data;
                        tradeValue(1, data);
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
                    Draggable(
                      data: 2,
                      child: dragSender(1, widthScreen, question),
                      feedback: dragSender(1, widthScreen, question),
                      childWhenDragging: dragSenderInvisible(
                        widthScreen,
                      ),
                    ),
                    DragTarget(
                      builder: (context, List<int> candidateData, rejectedData) {
                        return dragReceiver(4, widthScreen, question);
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        valueSecondReceiver = data;
                        tradeValue(2, data);
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
                    Draggable(
                      data: 3,
                      child: dragSender(2, widthScreen, question),
                      feedback: dragSender(2, widthScreen, question),
                      childWhenDragging: dragSenderInvisible(
                        widthScreen,
                      ),
                    ),
                    DragTarget(
                      builder: (context, List<int> candidateData, rejectedData) {
                        return dragReceiver(5, widthScreen, question);
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      onAccept: (data) {
                        valueThirdReceiver = data;
                        tradeValue(3, data);
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
          ),
          // submitAnswer(context, cobjectList, 'PRE', ++questionIndex, listQuestionIndex),
        ],
      ),
    );
  }

  Widget dragSenderInvisible(double widthScreen) {
    return Container(
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  Widget dragSender(int index, double widthScreen, Question question) {
    String grouping = (index + 1).toString();
    return Container(
      margin: EdgeInsets.only(
        left: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(BASE_URL + '/image/' + question.pieces[grouping]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.lightGreen,
          width: 2,
        ),
      ),
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  Widget dragReceiver(int index, double widthScreen, Question question) {
    String grouping = (index + 1).toString();
    switch (grouping) {
      case '4':
        grouping = '1_1';
        break;
      case '5':
        grouping = '2_1';
        break;
      case '6':
        grouping = '3_1';
        break;
    }
    return Container(
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(BASE_URL + '/image/' + question.pieces[grouping]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.lightGreen,
          width: 2,
        ),
      ),
      width: widthScreen / 2.6,
      height: widthScreen / 2.6,
    );
  }

  void tradeValue(int receiverIndex, int data) {
    switch (receiverIndex) {
      case 1:
        valueSecondReceiver == data
            ? valueSecondReceiver = 0
            : valueThirdReceiver == data
                ? valueThirdReceiver = 0
                : {};
        break;
      case 2:
        valueFirstReceiver == data
            ? valueFirstReceiver = 0
            : valueThirdReceiver == data
                ? valueThirdReceiver = 0
                : {};
        break;
      case 3:
        valueFirstReceiver == data
            ? valueFirstReceiver = 0
            : valueSecondReceiver == data
                ? valueSecondReceiver = 0
                : {};
        break;
    }
  }
}
