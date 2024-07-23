import 'package:elesson/app/core/block/data/model/block_model.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:flutter/material.dart';
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
  final TextEditingController _idAlunoController = TextEditingController();

  bool answerFeedbackSwitched = true;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Seleção de aluno"),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Digite o identificador do aluno", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    controller: _idAlunoController,
                    decoration: InputDecoration(border: InputBorder.none, labelText: "Código do aluno"),
                    style: TextStyle(fontSize: 20),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
                  child: TextButton(
                    onPressed: processing
                        ? null
                        : () async {
                            if (_idAlunoController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.blue,
                                showCloseIcon: true,
                                content: Center(
                                    child: Text(
                                  "Digite o código do aluno",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                )),
                              ));
                              return;
                            }
                            BlockParameterEntity blockParameterEntity =
                                BlockParameterEntity(teacherId: widget.blockModelOffline?.teacher.id ?? 1, studentId: int.parse(_idAlunoController.text), disciplineId: widget.blockModelOffline?.discipline.id ?? 1, enableFeedback: answerFeedbackSwitched);
                            answerFeedback = blockParameterEntity.enableFeedback;
                            UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
                            userProvider.setUser(LoginResponseEntity(id: blockParameterEntity.studentId, name: "Aluno", user_name: "Aluno", user_type_id: 5));

                            List<Performance> studentPerformances = await widget.offlineController.getAllPerformanceFromStudent(blockParameterEntity.studentId);

                            //Verificando se o aluno já respondeu essa tarefa
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


                            //Encontrando a ultima atividade dessa aula que ele respondeu
                            int lastTaskResolvedInCurrentLesson = widget.blockModelOffline!.tasks.first;

                            widget.blockModelOffline?.tasks.forEach((currentBlockTaskId) {
                              if (alreadyResolvedTasks.contains(currentBlockTaskId)) {
                                lastTaskResolvedInCurrentLesson = currentBlockTaskId;
                              }
                            });
                            widget.blockModelOffline?.breakPoint.last_resolved_task_id = lastTaskResolvedInCurrentLesson;
                            widget.qrCodeController.setBlockOffline(context, widget.blockModelOffline!);
                          },
                    child: Center(
                      child: processing
                          ? CircularProgressIndicator()
                          : Text("Confirmar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic')),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Divider(),
              Text("Configuração das tarefas", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
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
          ),
        ),
      ),
    );
  }
}
