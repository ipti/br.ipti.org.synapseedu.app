import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockSelection extends StatefulWidget {
  static const routeName = '/block-selection';
  @override
  _BlockSelectionState createState() => _BlockSelectionState();
}

class _BlockSelectionState extends State<BlockSelection> {
  SharedPreferences prefs;
  bool langOk = false;
  bool mathOk = false;
  bool sciOk = false;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    langOk = prefs.getBool('linguagens') ?? true;
    mathOk = prefs.getBool('matematica') ?? false;
    sciOk = prefs.getBool('ciencias') ?? false;
    super.didChangeDependencies();
  }

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
          elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "Linguagens",
              screenWidth: widthScreen,
              onTap: () {},
              blockDone: langOk,
              context: context),
          elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "Matemática",
              screenWidth: widthScreen,
              onTap: () {},
              blockDone: mathOk,
              context: context),
          elessonCard(
              backgroundImage: "assets/img/cover.png",
              text: "Ciências",
              screenWidth: widthScreen,
              onTap: () {},
              blockDone: sciOk,
              context: context),
        ],
      ),
    );
  }
}
