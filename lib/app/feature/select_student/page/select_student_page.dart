import 'package:auto_size_text/auto_size_text.dart';
import 'package:elesson/app/core/block/data/model/block_model.dart';
import 'package:elesson/app/core/block/data/model/break_point_model.dart';
import 'package:elesson/app/core/home_offline/data/model/TeacherClassroomModel.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../core/auth/domain/entity/login_response_entity.dart';
import '../../../core/block/domain/entity/block_parameters_entity.dart';
import '../../../core/task/data/model/performance_model.dart';
import '../../../providers/userProvider.dart';
import '../../../util/config.dart';
import '../../qrcode/controller/qrcode_controller.dart';

class SelectStudentPage extends StatefulWidget {
  final QrCodeController qrCodeController;
  final BlockModel? blockModelOffline;
  final OfflineController offlineController;

  const SelectStudentPage({required this.qrCodeController, super.key, this.blockModelOffline, required this.offlineController});

  @override
  State<SelectStudentPage> createState() => _SelectStudentPageState();
}

class _SelectStudentPageState extends State<SelectStudentPage> {
  List<String> SchoolList = <String>["Selecione a escola (Todos)"];
  List<String> ClassYearlList = <String>["Selecione o ano (Todos)"];
  String dropdownSchool = 'Selecione a escola (Todos)';
  String dropdownYear = 'Selecione o ano (Todos)';
  bool answerFeedbackSwitched = false;
  bool processing = false;

  List<TeacherClassroomModel> allStudents = [];
  List<TeacherClassroomModel> filredStudents = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleção de aluno"),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.9,
          child: FutureBuilder(
              future: allStudents.isEmpty ? widget.offlineController.getStudentsOfTeacher(2) : null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (allStudents.isEmpty) {
                  allStudents = (snapshot.data ?? []);
                }

                if (dropdownSchool == "Selecione a escola (Todos)" || dropdownYear == "Selecione o ano (Todos)") {
                  filredStudents = allStudents;
                }

                if (dropdownSchool != "Selecione a escola (Todos)") {
                  filredStudents = allStudents.where((element) => element.schoolName == dropdownSchool).toList();
                }

                if (dropdownYear != "Selecione o ano (Todos)") {
                  filredStudents = filredStudents.where((element) => element.classroomYearName == dropdownYear).toList();
                }

                allStudents.forEach((element) {
                  if (SchoolList.contains(element.schoolName) == false) {
                    SchoolList.add(element.schoolName);
                  }
                  if (ClassYearlList.contains(element.classroomYearName) == false) {
                    ClassYearlList.add(element.classroomYearName);
                  }
                });

                List<Widget> dropdownWidgets = [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    width: size.width > 600 ? size.width * 0.4 : size.width * 0.9,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      items: SchoolList.map((String e) => DropdownMenuItem<String>(value: e, child: Text(e, style: TextStyle(fontWeight: FontWeight.bold)))).toList(),
                      onChanged: (value) => setState(() => dropdownSchool = value!),
                      value: dropdownSchool,
                      underline: Container(),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    width: size.width > 600 ? size.width * 0.4 : size.width * 0.9,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      items: ClassYearlList.map((String e) => DropdownMenuItem<String>(value: e, child: Text(e, style: TextStyle(fontWeight: FontWeight.bold)))).toList(),
                      onChanged: (value) => setState(() => dropdownYear = value!),
                      value: dropdownYear,
                      underline: Container(),
                    ),
                  ),
                ];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),

                    size.width > 600
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: dropdownWidgets,
                          )
                        : Column(
                            children: dropdownWidgets,
                          ),

                    SizedBox(height: 5),
                    Flexible(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(height: 10),
                        itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            BlockParameterEntity blockParameterEntity = BlockParameterEntity(
                              teacherId: widget.blockModelOffline?.teacher.id ?? 1,
                              studentId: filredStudents[index].studentId,
                              disciplineId: widget.blockModelOffline?.discipline.id ?? 1,
                              enableFeedback: answerFeedbackSwitched,
                            );

                            answerFeedback = blockParameterEntity.enableFeedback;
                            UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                            userProvider
                                .setUser(LoginResponseEntity(id: blockParameterEntity.studentId, name: filredStudents[index].studentName, user_name: "Aluno", user_type_id: 5));
                            List<Performance> studentPerformances = await widget.offlineController.getAllPerformanceFromStudent(blockParameterEntity.studentId);
                            List<int> alreadyResolvedTasks = studentPerformances.map((e) => e.taskId).toList();
                            bool alreadyResolvedLesson = alreadyResolvedTasks.any((alreadyResolvedTaskId) => alreadyResolvedTaskId == widget.blockModelOffline?.tasks.last);
                            if (alreadyResolvedLesson) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.blue,
                                showCloseIcon: true,
                                content: Center(child: Text("Aluno já respondeu essa tarefa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                              ));
                              return;
                            }

                            int lastTaskResolvedInCurrentLesson = 0;
                            widget.blockModelOffline?.tasks.forEach((currentBlockTaskId) {
                              if (alreadyResolvedTasks.contains(currentBlockTaskId)) {
                                lastTaskResolvedInCurrentLesson = currentBlockTaskId;
                              }
                            });
                            widget.blockModelOffline?.breakPoint = BreakPointModel(last_resolved_task_id: lastTaskResolvedInCurrentLesson, created_at: DateTime.now());
                            // widget.blockModelOffline?.breakPoint.last_resolved_task_id = lastTaskResolvedInCurrentLesson;
                            widget.qrCodeController.setBlockOffline(context, widget.blockModelOffline!);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
                            child: SizedBox(
                                height: 50,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText("${filredStudents[index].studentName}", overflow: TextOverflow.clip, style: TextStyle(fontWeight: FontWeight.bold)),
                                  ],
                                )),
                          ),
                        ),
                        shrinkWrap: true,
                        itemCount: filredStudents.length,
                      ),
                    ),
                    // Text("Digite o identificador do aluno", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    // SizedBox(height: 20),
                    // Container(
                    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //     child: TextFormField(
                    //       controller: _idAlunoController,
                    //       decoration: InputDecoration(border: InputBorder.none, labelText: "Código do aluno"),
                    //       style: TextStyle(fontSize: 20),
                    //       keyboardType: TextInputType.number,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 50,
                    //     decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
                    //     child: TextButton(
                    //       onPressed: processing
                    //           ? null
                    //           : () async {
                    //               if (_idAlunoController.text.isEmpty) {
                    //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //                   backgroundColor: Colors.blue,
                    //                   showCloseIcon: true,
                    //                   content: Center(
                    //                       child: Text(
                    //                     "Digite o código do aluno",
                    //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //                   )),
                    //                 ));
                    //                 return;
                    //               }
                    //               BlockParameterEntity blockParameterEntity =
                    //                   BlockParameterEntity(teacherId: widget.blockModelOffline?.teacher.id ?? 1, studentId: int.parse(_idAlunoController.text), disciplineId: widget.blockModelOffline?.discipline.id ?? 1, enableFeedback: answerFeedbackSwitched);
                    //               answerFeedback = blockParameterEntity.enableFeedback;
                    //               UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                    //               userProvider.setUser(LoginResponseEntity(id: blockParameterEntity.studentId, name: "Aluno", user_name: "Aluno", user_type_id: 5));
                    //
                    //               List<Performance> studentPerformances = await widget.offlineController.getAllPerformanceFromStudent(blockParameterEntity.studentId);
                    //
                    //               //Verificando se o aluno já respondeu essa tarefa
                    //               List<int> alreadyResolvedTasks = studentPerformances.map((e) => e.taskId).toList();
                    //
                    //               bool alreadyResolvedLesson = alreadyResolvedTasks.any((alreadyResolvedTaskId) => alreadyResolvedTaskId == widget.blockModelOffline?.tasks.last);
                    //               if (alreadyResolvedLesson) {
                    //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //                   backgroundColor: Colors.blue,
                    //                   showCloseIcon: true,
                    //                   content: Center(child: Text("Aluno já respondeu essa tarefa", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    //                 ));
                    //                 return;
                    //               }
                    //
                    //
                    //               //Encontrando a ultima atividade dessa aula que ele respondeu
                    //               int lastTaskResolvedInCurrentLesson = widget.blockModelOffline!.tasks.first;
                    //
                    //               widget.blockModelOffline?.tasks.forEach((currentBlockTaskId) {
                    //                 if (alreadyResolvedTasks.contains(currentBlockTaskId)) {
                    //                   lastTaskResolvedInCurrentLesson = currentBlockTaskId;
                    //                 }
                    //               });
                    //               widget.blockModelOffline?.breakPoint.last_resolved_task_id = lastTaskResolvedInCurrentLesson;
                    //               widget.qrCodeController.setBlockOffline(context, widget.blockModelOffline!);
                    //             },
                    //       child: Center(
                    //         child: processing
                    //             ? CircularProgressIndicator()
                    //             : Text("Confirmar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic')),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: size.height * 0.1),
                    Divider(),
                    Text("Configuração das tarefas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    //retorno visual
                    Row(
                      children: [
                        Switch(
                          value: answerFeedbackSwitched,
                          onChanged: (value) => setState(() => answerFeedbackSwitched = value),
                        ),
                        Text("Feedback de resposta", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
