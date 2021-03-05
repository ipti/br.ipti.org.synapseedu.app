import 'package:elesson/share/api.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockSelection extends StatefulWidget {
  static const routeName = '/block-selection';
  @override
  _BlockSelectionState createState() => _BlockSelectionState();
}

bool langOk = false;
bool mathOk = false;
bool sciOk = false;

class _BlockSelectionState extends State<BlockSelection> {
  SharedPreferences prefs;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    langOk = prefs.getBool('Português') ?? false;
    mathOk = prefs.getBool('Matemática') ?? false;
    sciOk = prefs.getBool('Ciências') ?? false;
    super.didChangeDependencies();
  }

  void redirectToQuestion(int cobjectIdIndex, String disciplineId) async {
    var blockId = await ApiBlock.getBlockByDiscipline(disciplineId);
    var responseBlock = await ApiBlock.getBlock(blockId);
    List<String> cobjectIdList = [];

    responseBlock.data[0]["cobject"].forEach((cobject) {
      // print(cobject["id"]);
      cobjectIdList.add(cobject["id"]);
    });

    getCobject(0, context, cobjectIdList);
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
          ElessonCardWidget(
            blockDone: langOk,
            backgroundImage: "assets/img/cover.png",
            text: "Linguagens",
            screenWidth: widthScreen,
            onTap: (value) {
              if (langOk == false)
                redirectToQuestion(0, '1');
              else
                print("Você já fez essa tarefinha!");
            },
            context: context,
          ),
          ElessonCardWidget(
            blockDone: mathOk,
            backgroundImage: "assets/img/cover.png",
            text: "Matemática",
            screenWidth: widthScreen,
            onTap: (value) {
              if (mathOk == false)
                redirectToQuestion(0, '2');
              else
                print("Você já fez essa tarefinha!");
            },
            context: context,
          ),
          ElessonCardWidget(
            blockDone: sciOk,
            backgroundImage: "assets/img/cover.png",
            text: "Ciências",
            screenWidth: widthScreen,
            onTap: (value) {
              // if (sciOk == false) redirectToQuestion(0, '3');
              // else print("Você já fez essa tarefinha!");
              print("Este bloco estará disponível em breve!");
            },
            context: context,
          ),
        ],
      ),
    );
  }
}
