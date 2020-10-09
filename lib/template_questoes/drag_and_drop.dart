import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
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
  var cobject = new List<dynamic>();
  int questionIndex;

  bool accepted = false;

  //<=======RECEIVER VALUES========>
  int valueFirstReceiver = 0;
  int valueSecondReceiver = 0;
  int valueThirdReceiver = 0;

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    cobject = args.cobject;
    questionIndex = args.questionIndex;

    // print('SAIDA: $cobject');

    context.read(cobjectProvider).fetchCobjects(cobject);
    List<Question> question = context.read(cobjectProvider).items;

    double widthScreen = MediaQuery.of(context).size.width;
    return cobject.isNotEmpty
        ? Scaffold(
            resizeToAvoidBottomPadding: true,
            body: TemplateSlider(
              sound: soundButton(context, question[0]),
              title: Text(
                question[questionIndex].header["text"],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
              ),
              activityScreen: DAD(widthScreen, question[questionIndex]),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('CARREGANDO...'),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
  }

  // ignore: non_constant_identifier_names
  Widget DAD(double widthScreen, Question question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //<=================PRIMEIRA=====================>
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }

  Widget dragSenderInvisible(double widthScreen) {
    return Container(
      width: widthScreen * 0.3,
      height: widthScreen * 0.3,
    );
  }

  Widget dragSender(int index, double widthScreen, Question question) {
    print('dragSender');
    String grouping = (index + 1).toString();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
              BASE_URL + '/image/' + question.pieces[grouping]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.lightGreen,
          width: 2,
        ),
      ),
      width: widthScreen * 0.3,
      height: widthScreen * 0.3,
    );
  }

  Widget dragReceiver(int index, double widthScreen, Question question) {
    print('dragReceiver');
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
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
              BASE_URL + '/image/' + question.pieces[grouping]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.lightGreen,
          width: 2,
        ),
      ),
      width: widthScreen * 0.3,
      height: widthScreen * 0.3,
    );
  }

  void tradeValue(int receiverIndex, int data) {
    switch (receiverIndex) {
      case 1:
        valueSecondReceiver == data
            ? valueSecondReceiver = 0
            // ignore: unnecessary_statements
            : valueThirdReceiver == data ? valueThirdReceiver = 0 : {};
        break;
      case 2:
        valueFirstReceiver == data
            ? valueFirstReceiver = 0
            // ignore: unnecessary_statements
            : valueThirdReceiver == data ? valueThirdReceiver = 0 : {};
        break;
      case 3:
        valueFirstReceiver == data
            ? valueFirstReceiver = 0
            // ignore: unnecessary_statements
            : valueSecondReceiver == data ? valueSecondReceiver = 0 : {};
        break;
    }
  }
}
