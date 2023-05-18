import 'dart:async';

import 'package:elesson/app/feature/shared/widgets/card_widget.dart';
import 'package:elesson/app/feature/shared/widgets/init_title.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/degree_selection/degree_selection_view.dart';
import 'package:elesson/share/api.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'block_selection.dart';

//TODO: VAI DE BASE

class BlockSelection extends StatefulWidget {
  static const routeName = '/block-selection';

  @override
  _BlockSelectionState createState() => _BlockSelectionState();
}

bool langOk = false;
bool mathOk = false;
bool sciOk = false;
String? studentUuid;
String? blockId = "";
String? studentName;
String? classroomFk;

class _BlockSelectionState extends State<BlockSelection> {
  late SharedPreferences prefs;
  UserProvider? userProvider;

  @override
  void didChangeDependencies() async {
    userProvider ??= Provider.of<UserProvider>(context);
    prefs = await SharedPreferences.getInstance();
    langOk = prefs.getBool('Português') ?? false;
    mathOk = prefs.getBool('Matemática') ?? false;
    sciOk = prefs.getBool('Ciências') ?? false;
    studentUuid = prefs.getString('student_uuid');
    studentName = prefs.getString('student_name') ?? 'Aluno(a)';
    classroomFk = prefs.getString('classroomFk') ?? '-1';
    isGuest = prefs.getBool('is_guest') ?? true;

    print("Recuperado: $studentName");
    setState(() {});
    super.didChangeDependencies();
  }


  TextEditingController cobjectId = TextEditingController();
  TextEditingController blockIdController = TextEditingController();

  void redirectToQuestion(int cobjectIdIndex, String disciplineId, String discipline, {String? blockChosen}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var blockId = blockChosen ?? await (ApiBlock.getBlockByDiscipline(disciplineId) as FutureOr<String>);
    var responseBlock = await ApiBlock.getBlock(blockId);
    List<String?> cobjectIdList = [];
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(text: "Oi, ${userProvider?.user.name ?? "Aluno(a)"}", heightScreen: size.height, bottomMargin: 20),
            Text('INICIAR AVALIAÇÕES', style: TextStyle(color: Color(0XFF6E7291), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: 18)),
            SizedBox(height: 36.0),
            userProvider?.user.user_type_id != 3
                ? Column(
                    children: [
                      Container(
                        width: size.width * 0.8,
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                              width: size.width * 0.55,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(hintText: 'Digite o ID do CObject', border: InputBorder.none),
                                controller: cobjectId,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                getCobject(0, context, [cobjectId.text]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                width: size.width * 0.2,
                                height: size.height * 0.05,
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
                      Container(
                        width: size.width * 0.8,
                        height: size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                              width: size.width * 0.55,
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(hintText: 'Digite o ID do bloco', border: InputBorder.none),
                                controller: blockIdController,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                redirectToQuestion(0, '1', 'Teste', blockChosen: blockIdController.text);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                width: size.width * 0.2,
                                height: size.height * 0.05,
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
                      SizedBox(height: 36.0),
                    ],
                  )
                : Container(),
            !mathOk
                ? ElessonCardWidget(
                    blockDone: mathOk,
                    backgroundImage: "assets/img/mate.png",
                    text: "MATEMÁTICA",
                    textModulo: 'MÓDULO 1',
                    screenWidth: size.width,
                    onTap: (value) async {
                      if (classroomFk == "-1") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => DegreeSelectionView(
                              cobjectIdIndex: 0,
                              discipline: 'Matemática',
                              disciplineId: '2',
                              studentUuid: studentUuid,
                            ),
                          ),
                        );
                      } else {
                        await BlockSelectionLogic().redirectToQuestion(
                          cobjectIdIndex: 0,
                          discipline: 'Matemática',
                          disciplineId: '2',
                          studentUuid: studentUuid,
                          classroomFk: classroomFk,
                          context: context,
                        );
                      }
                    },
                    context: context,
                  )
                : Container(),
            !langOk
                ? ElessonCardWidget(
                    blockDone: langOk,
                    backgroundImage: "assets/img/ling.png",
                    text: "LINGUAGEM",
                    textModulo: 'MÓDULO 1',
                    screenWidth: size.width,
                    onTap: (value) async {
                      if (classroomFk == "-1") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => DegreeSelectionView(
                              cobjectIdIndex: 0,
                              discipline: 'Português',
                              disciplineId: '1',
                              studentUuid: studentUuid,
                            ),
                          ),
                        );
                      } else {
                        await BlockSelectionLogic().redirectToQuestion(
                          cobjectIdIndex: 0,
                          discipline: 'Português',
                          disciplineId: '1',
                          studentUuid: studentUuid,
                          classroomFk: classroomFk,
                          context: context,
                        );
                      }
                    },
                    context: context,
                  )
                : Container(),
            !sciOk
                ? ElessonCardWidget(
                    blockDone: sciOk,
                    backgroundImage: "assets/img/cien.png",
                    text: "CIÊNCIAS",
                    textModulo: 'MÓDULO 1',
                    screenWidth: size.width,
                    onTap: (value) async {
                      blockId = await ApiBlock.getBlockByDiscipline("3");
                      if (classroomFk == "-1") {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => DegreeSelectionView(
                              cobjectIdIndex: 0,
                              discipline: 'Ciências',
                              disciplineId: '3',
                              studentUuid: studentUuid,
                            ),
                          ),
                        );
                      } else {
                        await BlockSelectionLogic().redirectToQuestion(
                          cobjectIdIndex: 0,
                          discipline: 'Ciências',
                          disciplineId: '3',
                          studentUuid: studentUuid,
                          classroomFk: classroomFk,
                          context: context,
                        );
                      }
                    },
                    context: context,
                  )
                : Container(),
            mathOk == true || sciOk == true || langOk == true
                ? Text('AVALIAÇÕES CONCLUÍDAS', style: TextStyle(color: Color(0XFF6E7291), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: 18))
                : Container(),
            SizedBox(height: 10.0),
            mathOk
                ? ElessonCardWidget(
                    blockDone: mathOk,
                    backgroundImage: "assets/img/mate.png",
                    text: "MATEMÁTICA",
                    textModulo: 'MÓDULO 1',
                    screenWidth: size.width,
                    onTap: (value) {
                      // if (mathOk == false)
                      // redirectToQuestion(0, '2', 'Matemática');
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
                    text: "LINGUAGEM",
                    textModulo: 'MÓDULO 1',
                    screenWidth: size.width,
                    onTap: (value) {
                      // if (langOk == false)
                      //   redirectToQuestion(0, '1', 'Português');
                      // else
                      //   print("Você já fez essa tarefinha!");
                    },
                    context: context,
                  )
                : Container(),
            sciOk
                ? ElessonCardWidget(
                    blockDone: sciOk,
                    backgroundImage: "assets/img/cien.png",
                    text: "CIÊNCIAS",
                    textModulo: 'MÓDULO 1',
                    screenWidth: size.width,
                    onTap: (value) {
                      // if (sciOk == false) redirectToQuestion(0, '3','Ciências');
                      // else print("Você já fez essa tarefinha!");
                      // print("Este bloco estará disponível em breve!");
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
