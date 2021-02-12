import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';

class BlockSelection extends StatefulWidget {
  static const routeName = '/block-selection';
  @override
  _BlockSelectionState createState() => _BlockSelectionState();
}

class _BlockSelectionState extends State<BlockSelection> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          initTitle(
              text: "Escolha o bloco de atividades",
              heightScreen: heightScreen,
              bottomMargin: 36),
          SizedBox(height: 36.0),
          Container(
            margin: EdgeInsets.all(0),
            child: elessonCard(
                backgroundImage: "assets/img/cover.png",
                text: "Linguagens",
                screenWidth: widthScreen,
                onTap: () {
                  // getCobjectList(blockId)
                },
                context: context),
          ),
          elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "Matemática",
              screenWidth: widthScreen,
              onTap: () {},
              context: context),
          elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "Ciências",
              screenWidth: widthScreen,
              onTap: () {},
              context: context),
        ],
      ),
    );
  }
}
