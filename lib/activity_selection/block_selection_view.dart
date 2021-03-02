import 'package:elesson/share/api.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './activity_selection_view.dart';

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
    langOk = prefs.getBool('linguagens') ?? false;
    mathOk = prefs.getBool('matematica') ?? false;
    sciOk = prefs.getBool('ciencias') ?? false;
    super.didChangeDependencies();
  }

  void redirectToQuestion(int cobjectIdIndex, String disciplineId) async {
    var blockId = await ApiBlock.getBlockByDiscipline(disciplineId);
    var responseBlock = await ApiBlock.getBlock(blockId);
    List<String> cobjectIdList = [];
    print(cobjectIdList);
    responseBlock.data[0]["cobject"].forEach((cobject) {
      // print(cobject["id"]);
      cobjectIdList.add(cobject["id"]);
    });
    print('cobjectIdList no redirect copiado: $cobjectIdList');

    getCobject(0, context, cobjectIdList, disciplineId);
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    print('Tela de seleção de blocos');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          initTitle(
              text: "Escolha o bloco de atividades",
              heightScreen: heightScreen,
              bottomMargin: 36),
          SizedBox(height: 36.0),
          ElessonCardWidget(
            blockDone: langOk,
            backgroundImage: "assets/img/cover.png",
            text: "Linguagens",
            screenWidth: widthScreen,
            onTap: (value) {
              redirectToQuestion(0, '1');
            },
            context: context,
          ),
          ElessonCardWidget(
            blockDone: mathOk,
            backgroundImage: "assets/img/cover.png",
            text: "Matemática",
            screenWidth: widthScreen,
            onTap: (value) {
              print('block math done?: $mathOk');
              redirectToQuestion(0, '2');
            },
            context: context,
          ),
          ElessonCardWidget(
            blockDone: sciOk,
            backgroundImage: "assets/img/cover.png",
            text: "Ciências",
            screenWidth: widthScreen,
            onTap: (value) {
              redirectToQuestion(0, '3');
            },
            context: context,
          ),
        ],
      ),
    );
  }
}
