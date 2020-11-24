import 'package:elesson/share/general_widgets.dart';
import 'package:flutter/material.dart';
import '../share/elesson_icon_lib_icons.dart';

class StartAndSendTest extends StatelessWidget {
  static const routeName = '/startandsendtest';

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //o nome da pessoa vai ser capturado do banco de dados
          initTitle(text: "Oi, João", heightScreen: heightScreen, bottomMargin: 36),
          elessonCard(text: "COMEÇAR PROVINHA", screenWidth: widthScreen, backgroundImage: "assets/img/cover.png"),
          SizedBox(height: 36),
          GestureDetector(
            //todo implementar aqui o que vai acontecer quando clicarem no botão de enviar prova fisica
            onTap: null,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.1), width: 1.4),
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(left: 24, right: 24),
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    ElessonIconLib.settings,
                    color: Color(0xFF0000FF),
                  ),
                  Text(
                    "ENVIAR PROVA FÍSICA",
                    style:
                        TextStyle(color: Color(0XFF0000FF), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: heightScreen * 0.024),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
