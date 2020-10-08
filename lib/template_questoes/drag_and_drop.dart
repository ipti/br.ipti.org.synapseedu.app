import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import 'model.dart';

final cobject = Provider<Cobjects>((ref) {
  return Cobjects();
});

class DragAndDrop extends StatefulWidget {
  static const routeName = '/DDROP';

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  var CObject = new List<dynamic>();

  String BASE_URL = 'https://elesson.com.br/app/library';

  bool accepted = false;

  //<=======RECEIVER VALUES========>
  int VALUE_FirstReceiver = 0;
  int VALUE_SecondReceiver = 0;
  int VALUE_ThirdReceiver = 0;

  @override
  Widget build(BuildContext context) {
    context.read(cobject).fetchCobjects(CObject);
    List<Question> question = context.read(cobject).items;

    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    CObject = args.CObject;
    print('SAIDA: $CObject');

    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: TemplateSlider(
        title: Text(
          question[0].header["text"],
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        activityScreen: DAD(larguraTela,question[0]),
      ),
    );
  }

  Widget DAD(double larguraTela, Question question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //<=================PRIMEIRA=====================>
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Draggable(
              data: 1,
              child: DragSender(0, larguraTela, question),
              feedback: DragSender(0, larguraTela, question),
              childWhenDragging: DragSenderInvisible(larguraTela),
            ),
            DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return DragReceiver(3, larguraTela, question);
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                VALUE_FirstReceiver = data;
                TradeValue(1, data);
                print("""
                  1: $VALUE_FirstReceiver
                  2: $VALUE_SecondReceiver
                  3: $VALUE_ThirdReceiver
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
              child: DragSender(1, larguraTela, question),
              feedback: DragSender(1, larguraTela, question),
              childWhenDragging: DragSenderInvisible(
                larguraTela,
              ),
            ),
            DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return DragReceiver(4, larguraTela, question);
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                VALUE_SecondReceiver = data;
                TradeValue(2, data);
                print("""
                  1: $VALUE_FirstReceiver
                  2: $VALUE_SecondReceiver
                  3: $VALUE_ThirdReceiver
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
              child: DragSender(2, larguraTela, question),
              feedback: DragSender(2, larguraTela, question),
              childWhenDragging: DragSenderInvisible(
                larguraTela,
              ),
            ),
            DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return DragReceiver(5, larguraTela, question);
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                VALUE_ThirdReceiver = data;
                TradeValue(3, data);
                print("""
                  1: $VALUE_FirstReceiver
                  2: $VALUE_SecondReceiver
                  3: $VALUE_ThirdReceiver
                  <---------------------->
                  """);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget DragSenderInvisible(double larguraTela) {
    return Container(
      width: larguraTela * 0.3,
      height: larguraTela * 0.3,
    );
  }

  Widget DragSender(int index, double larguraTela, Question question) {
    String grouping = (index + 1).toString();
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(BASE_URL + '/image/' + question.pieces[grouping]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.lightGreen,
          width: 2,
        ),
      ),
      width: larguraTela * 0.3,
      height: larguraTela * 0.3,
    );
  }

  Widget DragReceiver(int index, double larguraTela, Question question) {
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
          image: NetworkImage(BASE_URL + '/image/' + question.pieces[grouping]["image"]),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.lightGreen,
          width: 2,
        ),
      ),
      width: larguraTela * 0.3,
      height: larguraTela * 0.3,
    );
  }

  void TradeValue(int ReceiverAtual, int data) {
    switch (ReceiverAtual) {
      case 1:
        VALUE_SecondReceiver == data
            ? VALUE_SecondReceiver = 0
            : VALUE_ThirdReceiver == data ? VALUE_ThirdReceiver = 0 : {};
        break;
      case 2:
        VALUE_FirstReceiver == data
            ? VALUE_FirstReceiver = 0
            : VALUE_ThirdReceiver == data ? VALUE_ThirdReceiver = 0 : {};
        break;
      case 3:
        VALUE_FirstReceiver == data
            ? VALUE_FirstReceiver = 0
            : VALUE_SecondReceiver == data ? VALUE_SecondReceiver = 0 : {};
        break;
    }
  }
}
