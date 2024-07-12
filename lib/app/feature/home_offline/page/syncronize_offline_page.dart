import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:elesson/app/core/task/domain/usecase/send_performance_usecase.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:flutter/material.dart';

import '../../../core/task/data/model/performance_model.dart';
import '../../../util/enums/task_types.dart';
import '../../../util/failures/failures.dart';

class syncronizeOfflinePage extends StatefulWidget {
  final SendPerformanceUseCase sendPerformanceUseCase;
  final OfflineController offlineController;

  const syncronizeOfflinePage({super.key, required this.offlineController, required this.sendPerformanceUseCase});

  @override
  State<syncronizeOfflinePage> createState() => _syncronizeOfflinePageState();
}

class _syncronizeOfflinePageState extends State<syncronizeOfflinePage> {
  List<Performance> performancesToSync = [];
  List<Performance> performancesSynced = [];

  List<Performance> allPerformances = [];
  int currentSyncTaskId = 0;

  Future<void> syncPerformances() async {
    await Future.forEach(performancesToSync, (performance) async {
      setState(() => currentSyncTaskId = performance.taskId);
      dartz.Either<Failure, bool> resUploadPerformance = await widget.sendPerformanceUseCase.offlineToOnline(performance: performance);
      await resUploadPerformance.fold((l) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro ao sincronizar performance [${l.message}]")));
        throw Exception("Erro ao sincronizar performance [${l.message}]");
      }, (r) async {
        bool resRemove = await widget.offlineController.moveToSyncedPerformanceInCache(performance);
        if (resRemove) {
          performancesSynced.add(performance);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erro Atualizar lista de performances")));
          throw Exception("Erro Atualizar lista de performances");
        }
      });
    });
    performancesToSync.removeWhere((element) => performancesSynced.contains(element));
    setState(() => currentSyncTaskId = 0);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sincronização finalizada")));
  }

  Future<void> getPerformances() async {
    performancesToSync = await widget.offlineController.getAllPerformancesPending();
    performancesSynced = await widget.offlineController.getAllPerformancesSynced();

    allPerformances = [...performancesToSync, ...performancesSynced];

    allPerformances.sort((a, b) => a.student_id.compareTo(b.student_id));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sincronização'),
        actions: [
          IconButton(
              onPressed: currentSyncTaskId == 0
                  ? () async {
                      setState(() {
                        currentSyncTaskId = -1;
                      });

                      await widget.offlineController.clearSyncedTasks();

                      setState(() {
                        allPerformances.removeWhere((element) => performancesSynced.contains(element));
                        performancesSynced = [];
                        currentSyncTaskId = 0;
                      });
                    }
                  : null,
              icon: Icon(Icons.delete_forever))
        ],
      ),
      body: FutureBuilder(
        future: allPerformances.isEmpty ? getPerformances() : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Erro ao carregar performances"));
          }

          if (performancesSynced.isEmpty && allPerformances.isEmpty) {
            return Center(child: Text("Nenhuma performance encontrada"));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
                  child: TextButton(
                      onPressed: currentSyncTaskId == 0 ? () async => await syncPerformances() : null,
                      child: Center(child: Text(currentSyncTaskId  == 0 ? "Iniciar Sincronização" : "Sincronizando...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic')))),
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: allPerformances.length,
                  itemBuilder: (context, index) {
                    Performance performance = allPerformances[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width * 0.8,
                        // height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AutoSizeText(
                                "[${performance.student_id}] Performance #${performance.taskId}",
                                textAlign: TextAlign.start,
                                minFontSize: 14,
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic'),
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green, width: 2)),
                              width: 30,
                              height: 30,
                              child: Icon(
                                performancesSynced.contains(performance)
                                    ? Icons.check
                                    : currentSyncTaskId == performance.taskId
                                        ? Icons.sync
                                        : Icons.warning_amber,
                                color: Colors.green,
                                size: 20,
                              ),
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
        },
      ),
    );
  }
}
