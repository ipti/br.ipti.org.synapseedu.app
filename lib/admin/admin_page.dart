import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/share/api.dart';
import 'package:elesson/share/general_widgets.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  SharedPreferences prefs;
  TextEditingController cobjectId = TextEditingController();
  // @override
  // void didChangeDependencies() async {
  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {});
  //   super.didChangeDependencies();
  // }

  void redirectToQuestion(int cobjectIdIndex, String disciplineId, String discipline) async {
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
            initTitle(text: "Oi, $studentName", heightScreen: heightScreen, bottomMargin: 20),
            Text('INICIAR AVALIAÇÕES', style: TextStyle(color: Color(0XFF6E7291), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: 18)),
            SizedBox(height: 36.0),
            ElessonCardWidget(
              blockDone: false,
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
            ),
            ElessonCardWidget(
              blockDone: false,
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
            ),
            ElessonCardWidget(
              blockDone: false,
              backgroundImage: "assets/img/cien.png",
              text: "CIÊNCIAS 1º ANO",
              textModulo: 'MÓDULO 1',
              screenWidth: widthScreen,
              onTap: (value) {
                if (sciOk == false)
                  redirectToQuestion(0, '3', 'Ciências');
                else
                  print("Você já fez essa tarefinha!");
                // print("Este bloco estará disponível em breve!");
              },
              context: context,
            ),
            Container(
              width: widthScreen * 0.8,
              height: heightScreen * 0.1,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                    width: widthScreen * 0.55,
                    child: TextFormField(
                      textAlign: TextAlign.center,decoration: InputDecoration(hintText: 'Digite o ID do CObject',border: InputBorder.none),
                      controller: cobjectId,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      getCobject(0,context,[cobjectId.text]);
                      // ApiCobject.getQuestao(0,[cobjectId.text])cobjectId.text;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red,
                      ),
                      width: widthScreen * 0.2,
                      height: heightScreen * 0.05,
                      child: Center(
                        child: Text(
                          'BUSCAR',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
