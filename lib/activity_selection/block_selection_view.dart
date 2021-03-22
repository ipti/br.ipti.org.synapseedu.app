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
String studentName;

class _BlockSelectionState extends State<BlockSelection> {
  SharedPreferences prefs;

  @override
  void didChangeDependencies() async {
    prefs = await SharedPreferences.getInstance();
    langOk = prefs.getBool('Português') ?? false;
    mathOk = prefs.getBool('Matemática') ?? false;
    sciOk = prefs.getBool('Ciências') ?? false;
    studentName = prefs.getString('student_name') ?? 'Aluno(a)';
    print("Recuperado: $studentName");
    setState(() {});
    super.didChangeDependencies();
  }

  void redirectToQuestion(
      int cobjectIdIndex, String disciplineId, String discipline) async {
    var blockId = await ApiBlock.getBlockByDiscipline(disciplineId);
    var responseBlock = await ApiBlock.getBlock(blockId);
    List<String> cobjectIdList = [];
    int cobjectId = prefs.getInt('last_cobject_$discipline') ?? 0;
    int questionIndex = prefs.getInt('last_question_$discipline') ?? 0;
    responseBlock.data[0]["cobject"].forEach((cobject) {
      // print(cobject["id"]);
      cobjectIdList.add(cobject["id"]);
    });
    print(cobjectIdList);

    getCobject(cobjectId, context, cobjectIdList, piecesetIndex: questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(
                text: "Oi, $studentName",
                heightScreen: heightScreen,
                bottomMargin: 20),
            Text('INICIAR AVALIAÇÕES',
                style: TextStyle(
                    color: Color(0XFF6E7291),
                    fontWeight: FontWeight.bold,
                    fontFamily: "ElessonIconLib",
                    fontSize: 18)),
            SizedBox(height: 36.0),
            !mathOk
                ? ElessonCardWidget(
                    blockDone: mathOk,
                    backgroundImage: "assets/img/mate.png",
                    text: "MATEMÁTICA 1º ANO",
                    textModulo: 'MÓDULO 1',
                    screenWidth: widthScreen,
                    onTap: (value) {
                      if (mathOk == false)
                        redirectToQuestion(0, '2', 'Matemática');
                      else
                        print("Você já fez essa tarefinha!");
                    },
                    context: context,
                  )
                : Container(),
            !langOk
                ? ElessonCardWidget(
                    blockDone: langOk,
                    backgroundImage: "assets/img/ling.png",
                    text: "LINGUAGENS 1º ANO",
                    textModulo: 'MÓDULO 1',
                    screenWidth: widthScreen,
                    onTap: (value) {
                      // if (langOk == false)
                      redirectToQuestion(0, '1', 'Português');
                      // else
                      //   print("Você já fez essa tarefinha!");
                    },
                    context: context,
                  )
                : Container(),
            !sciOk
                ? ElessonCardWidget(
                    blockDone: sciOk,
                    backgroundImage: "assets/img/cien.png",
                    text: "CIÊNCIAS 1º ANO",
                    textModulo: 'MÓDULO 1',
                    screenWidth: widthScreen,
                    onTap: (value) {
                      // if (sciOk == false) redirectToQuestion(0, '3','Ciências');
                      // else print("Você já fez essa tarefinha!");
                      print("Este bloco estará disponível em breve!");
                    },
                    context: context,
                  )
                : Container(),
            mathOk == true || sciOk == true || langOk == true
                ? Text('AVALIAÇÕES CONCLUÍDAS',
                    style: TextStyle(
                        color: Color(0XFF6E7291),
                        fontWeight: FontWeight.bold,
                        fontFamily: "ElessonIconLib",
                        fontSize: 18))
                : Container(),
            SizedBox(height: 10.0),
            mathOk
                ? ElessonCardWidget(
                    blockDone: mathOk,
                    backgroundImage: "assets/img/mate.png",
                    text: "MATEMÁTICA 1º ANO",
                    textModulo: 'MÓDULO 1',
                    screenWidth: widthScreen,
                    onTap: (value) {
                      // if (mathOk == false)
                      redirectToQuestion(0, '2', 'Matemática');
                      // else
                      //   print("Você já fez essa tarefinha!");
                    },
                    context: context,
                  )
                : Container(),
            langOk
                ? ElessonCardWidget(
                    blockDone: langOk,
                    backgroundImage: "assets/img/ling.png",
                    text: "LINGUAGENS 1º ANO",
                    textModulo: 'MÓDULO 1',
                    screenWidth: widthScreen,
                    onTap: (value) {
                      if (langOk == false)
                        redirectToQuestion(0, '1', 'Português');
                      else
                        print("Você já fez essa tarefinha!");
                    },
                    context: context,
                  )
                : Container(),
            sciOk
                ? ElessonCardWidget(
                    blockDone: sciOk,
                    backgroundImage: "assets/img/cien.png",
                    text: "CIÊNCIAS 1º ANO",
                    textModulo: 'MÓDULO 1',
                    screenWidth: widthScreen,
                    onTap: (value) {
                      // if (sciOk == false) redirectToQuestion(0, '3','Ciências');
                      // else print("Você já fez essa tarefinha!");
                      print("Este bloco estará disponível em breve!");
                    },
                    context: context,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
