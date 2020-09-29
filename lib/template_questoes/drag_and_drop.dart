import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';

class DragAndDrop extends StatefulWidget {
  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {
  bool accepted = false;

  //<=======SENDER URL========>
  String URL_FirstSender =
      "https://i1.wp.com/socientifica.com.br/wp-content/uploads/2019/05/image_7150_1e-Hubble-Legacy-Field.jpg?resize=1140%2C1053&ssl=1";
  String URL_SecondSender =
      "https://i1.wp.com/socientifica.com.br/wp-content/uploads/2019/05/image_7150_1e-Hubble-Legacy-Field.jpg?resize=1140%2C1053&ssl=1";
  String URL_ThirdSender =
      "https://i1.wp.com/socientifica.com.br/wp-content/uploads/2019/05/image_7150_1e-Hubble-Legacy-Field.jpg?resize=1140%2C1053&ssl=1";

  //<=======RECEIVER URL========>
  String URL_FirstReceiver = "https://upload.wikimedia.org/wikipedia/commons/d/d0/Alvorada_de_outono_na_Imagem_de_Minas.JPG";
  String URL_SecondReceiver = "https://upload.wikimedia.org/wikipedia/commons/d/d0/Alvorada_de_outono_na_Imagem_de_Minas.JPG";
  String URL_ThirdReceiver = "https://upload.wikimedia.org/wikipedia/commons/d/d0/Alvorada_de_outono_na_Imagem_de_Minas.JPG";

  //<=======RECEIVER VALUES========>
  int VALUE_FirstReceiver = 0;
  int VALUE_SecondReceiver = 0;
  int VALUE_ThirdReceiver = 0;

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: TemplateSlider(
        activityScreen: DAD(larguraTela),
      ),
    );
  }

  Widget DAD(double larguraTela) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //<=================PRIMEIRA=====================>
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Draggable(
              data: 1,
              child: DragSender(larguraTela, URL_FirstSender),
              feedback: DragSender(larguraTela, URL_FirstSender),
              childWhenDragging: DragSenderInvisible(larguraTela),
            ),
            DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return DragReceiver(larguraTela, URL_FirstReceiver);
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
              child: DragSender(larguraTela, URL_SecondSender),
              feedback: DragSender(larguraTela, URL_SecondSender),
              childWhenDragging: DragSenderInvisible(
                larguraTela,
              ),
            ),
            DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return DragReceiver(larguraTela, URL_SecondReceiver);
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
              child: DragSender(larguraTela, URL_ThirdSender),
              feedback: DragSender(larguraTela, URL_ThirdSender),
              childWhenDragging: DragSenderInvisible(
                larguraTela,
              ),
            ),
            DragTarget(
              builder: (context, List<int> candidateData, rejectedData) {
                return DragReceiver(larguraTela, URL_ThirdReceiver);
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

  Widget DragSender(double larguraTela, String url_imagem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(url_imagem),
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

  Widget DragReceiver(double larguraTela, String url_imagem) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(url_imagem),
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
        VALUE_SecondReceiver == data ? VALUE_SecondReceiver = 0 : VALUE_ThirdReceiver == data ? VALUE_ThirdReceiver = 0 : {};
        break;
      case 2:
        VALUE_FirstReceiver == data ? VALUE_FirstReceiver = 0 : VALUE_ThirdReceiver == data ? VALUE_ThirdReceiver = 0 : {};
        break;
      case 3:
        VALUE_FirstReceiver == data ? VALUE_FirstReceiver = 0 : VALUE_SecondReceiver == data ? VALUE_SecondReceiver = 0 : {};
        break;
    }
  }
}
