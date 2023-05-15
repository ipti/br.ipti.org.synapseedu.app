import 'dart:async';

import 'package:elesson/app/feature/providers/userProvider.dart';
import 'package:elesson/app/feature/shared/widgets/card_widget.dart';
import 'package:elesson/app/feature/shared/widgets/init_title.dart';
import 'package:elesson/degree_selection/degree_selection_view.dart';
import 'package:elesson/share/api.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'block_selection.dart';

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

  // void redirectToQuestion(
  //     int cobjectIdIndex, String disciplineId, String discipline) async {
  // Future<Function> redirectToQuestion(
  //     {int cobjectIdIndex,
  //     String disciplineId,
  //     String discipline,
  //     String blockId,
  //     BuildContext context}) async {
  //   print('Classroom fk: $classroomFk');
  //   var blockId = studentUuid != null
  //       ? prefs.getString('block_$disciplineId')
  //       : await ApiBlock.getBlockByDiscipline(disciplineId);
  //   var responseBlock = await ApiBlock.getBlock(blockId);
  //   ApiBlock.getBlock(blockId).then((value) {
  //     var responseBlock = value;
  //     List<String> cobjectIdList = [];
  //     int cobjectId = prefs.getInt('last_cobject_$discipline') ?? 0;
  //     int questionIndex = prefs.getInt('last_question_$discipline') ?? 0;
  //     responseBlock.data[0]["cobject"].forEach((cobject) {
  //       // print(cobject["id"]);
  //       cobjectIdList.add(cobject["id"]);
  //     });
  //     print(cobjectIdList);

  //     getCobject(cobjectId, context, cobjectIdList,
  //         piecesetIndex: questionIndex);
  //   });
  // }
  // @override
  // loadingBgBlur() => 0.0;

  @override
  loader() {
    return CircularProgressIndicator();
  }

  Key? scaffoldKey;

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
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            initTitle(text: "Oi, ${userProvider?.user?.name ?? "Aluno(a)"}", heightScreen: heightScreen, bottomMargin: 20),
            Text('INICIAR AVALIAÇÕES', style: TextStyle(color: Color(0XFF6E7291), fontWeight: FontWeight.bold, fontFamily: "ElessonIconLib", fontSize: 18)),
            SizedBox(height: 36.0),
            userProvider?.user?.user_type_id != 3
                ? Column(
                    children: [
                      Container(
                        width: widthScreen * 0.8,
                        height: heightScreen * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                              width: widthScreen * 0.55,
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
                      Container(
                        width: widthScreen * 0.8,
                        height: heightScreen * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                              width: widthScreen * 0.55,
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
                    screenWidth: widthScreen,
                    onTap: (value) async {
                      if (classroomFk == "-1") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => DegreeSelectionView(
                                  cobjectIdIndex: 0,
                                  discipline: 'Matemática',
                                  disciplineId: '2',
                                  studentUuid: studentUuid,
                                )));
                      } else {
                        await BlockSelectionLogic().redirectToQuestion(
                          cobjectIdIndex: 0,
                          discipline: 'Matemática',
                          disciplineId: '2',
                          studentUuid: studentUuid,
                          classroomFk: classroomFk,
                          context: context,
                        );
                        // try {
                        //   await this.performFuture(
                        //       await BlockSelectionLogic().redirectToQuestion(
                        //     cobjectIdIndex: 0,
                        //     discipline: 'Matemática',
                        //     disciplineId: '2',
                        //     studentUuid: studentUuid,
                        //     classroomFk: classroomFk,
                        //     context: context,
                        //   ));
                        // } catch (e) {
                        //   callSnackBar(context);
                        // }
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
                    screenWidth: widthScreen,
                    onTap: (value) async {
                      if (classroomFk == "-1") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => DegreeSelectionView(
                                  cobjectIdIndex: 0,
                                  discipline: 'Português',
                                  disciplineId: '1',
                                  studentUuid: studentUuid,
                                )));
                      } else {
                        // await this.performFuture(
                        //     await BlockSelectionLogic().redirectToQuestion(
                        //   cobjectIdIndex: 0,
                        //   discipline: 'Português',
                        //   disciplineId: '1',
                        //   studentUuid: studentUuid,
                        //   classroomFk: classroomFk,
                        //   context: context,
                        // ));
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
                    screenWidth: widthScreen,
                    onTap: (value) async {
                      blockId = await ApiBlock.getBlockByDiscipline("3");
                      // if (blockId != "-1")
                      //   try {
                      //     await this.performFuture(await BlockSelectionLogic()
                      //         .redirectToQuestion(
                      //             cobjectIdIndex: 0,
                      //             disciplineId: '3',
                      //             discipline: 'Ciências',
                      //             blockId: blockId,
                      //             studentUuid: studentUuid,
                      //             context: context));
                      //   } catch (e) {}
                      // else
                      //   callSnackBar(context);
                      if (classroomFk == "-1") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => DegreeSelectionView(
                                  cobjectIdIndex: 0,
                                  discipline: 'Ciências',
                                  disciplineId: '3',
                                  studentUuid: studentUuid,
                                )));
                      } else {
                        // await this.performFuture(
                        //     await BlockSelectionLogic().redirectToQuestion(
                        //   cobjectIdIndex: 0,
                        //   discipline: 'Ciências',
                        //   disciplineId: '3',
                        //   studentUuid: studentUuid,
                        //   classroomFk: classroomFk,
                        //   context: context,
                        // ));

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
                    screenWidth: widthScreen,
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
                    screenWidth: widthScreen,
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
                    screenWidth: widthScreen,
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
