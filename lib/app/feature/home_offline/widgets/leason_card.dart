import 'package:auto_size_text/auto_size_text.dart';
import 'package:elesson/app/core/block/data/model/block_model.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:flutter/material.dart';

class LeasonCard extends StatefulWidget {
  final OfflineController offlineController;
  final BlockModel block;

  const LeasonCard({required this.offlineController, required this.block, super.key});

  @override
  State<LeasonCard> createState() => _LeasonCardState();
}

class _LeasonCardState extends State<LeasonCard> {
  ///1 - not downloaded
  ///2 - downloading
  ///3 - downloaded

  int status = 1;
  int currentTaskDownloading = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
        child: InkWell(
          onTap: () async {
            setState(() {
              status = 2;
            });
            // await widget.offlineController.cacheRepository.clearCache();
            bool resSaveBlockCache = await widget.offlineController.saveBlockToCache(widget.block);

            // bool res = await widget.offlineController.downloadTaskToCache(widget.block.tasks[0]);

            if (resSaveBlockCache) {
              await Future.forEach(widget.block.tasks, (idTask) async {
                bool res = await widget.offlineController.downloadTaskToCache(idTask);
                print("SALVANDO TASK #$idTask: $res");
                setState(() {
                  currentTaskDownloading++;
                });
              });
              setState(() {
                status = 3;
              });
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AutoSizeText(
                  "Aula #${widget.block.id} | ${widget.block.tasks.length} tarefas",
                  textAlign: TextAlign.start,
                  minFontSize: 14,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic'),
                ),
              ),
              SizedBox(width: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green, width: 2)),
                // width: 30,
                height: 30,
                child: Row(
                  children: [
                    if (status == 2) Text(currentTaskDownloading.toString() + "/" + widget.block.tasks.length.toString()),
                    status == 2
                        ? CircularProgressIndicator()
                        : Icon(status == 1 ? Icons.download_for_offline_outlined : Icons.download_done, color: status == 1 ? Colors.red : Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
