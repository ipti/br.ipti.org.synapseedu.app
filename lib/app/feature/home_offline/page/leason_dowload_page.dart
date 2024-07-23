import 'package:auto_size_text/auto_size_text.dart';
import 'package:elesson/app/feature/qrcode/qrcode_module.dart';
import 'package:flutter/material.dart';

import '../../../core/block/data/model/block_model.dart';
import '../../select_student/select_student_module.dart';
import '../controller/offline_controller.dart';

class LeasonDownloadPage extends StatefulWidget {
  final BlockModel block;
  final OfflineController offlineController;

  const LeasonDownloadPage({required this.block, required this.offlineController, super.key});

  @override
  State<LeasonDownloadPage> createState() => _LeasonDownloadPageState();
}

class _LeasonDownloadPageState extends State<LeasonDownloadPage> {
  /// 0 - verifying
  /// 1 - verified
  /// 2 - error block

  int startButtonStatus = 0;
  List<int> errorTasks = [];

  String getTitleButton() {
    if (startButtonStatus == 0) return "Verificando...";
    if (startButtonStatus == 1) return "Iniciar Aula";
    if (startButtonStatus == 2) return "Tarefas não baixadas!";
    return "ERRO";
  }

  Color getColorButton() {
    if (startButtonStatus == 0) return Colors.blue;
    if (startButtonStatus == 1) return Colors.green;
    if (startButtonStatus == 2) return Colors.red;
    return Colors.red;
  }

  Future<bool> verifyIfTasksIsCached() async {
    await Future.delayed(Duration(seconds: 2));
    bool block = false;
    widget.block.tasks.forEach((taskId) async {
      bool res = await widget.offlineController.verifyTaskInCache(taskId);
      if (res == false) {
        errorTasks.add(taskId);
        block = true;
      }
      ;
    });
    return !block;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Aula #${widget.block.id}'),
      ),
      body: FutureBuilder(
          future: verifyIfTasksIsCached(),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              startButtonStatus = 0;
            else if (snapshot.data == false)
              startButtonStatus = 2;
            else
              startButtonStatus = 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width * 0.8,
                    height: 50,
                    decoration:
                        BoxDecoration(color: getColorButton(), borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
                    child: TextButton(
                        onPressed: startButtonStatus == 1
                            ? () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SelectStudentModule(blockModelOffline: widget.block, offlineController: widget.offlineController)), (route) => false) : null,
                        child: Center(child: Text(getTitleButton(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic')))),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.block.tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: size.width * 0.8,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  "Tarefa ${widget.block.tasks[index]}",
                                  textAlign: TextAlign.start,
                                  minFontSize: 14,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic'),
                                ),
                              ),
                              SizedBox(width: 5),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10), border: Border.all(color: startButtonStatus == 0 ? Colors.blue : Colors.green, width: 2)),
                                width: 30,
                                height: 30,
                                child: startButtonStatus == 0
                                    ? Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircularProgressIndicator(color: Colors.blue),
                                      )
                                    : errorTasks.contains(widget.block.tasks[index])
                                        ? Icon(Icons.error_outline, color: Colors.red)
                                        : Icon(Icons.task_alt, color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
