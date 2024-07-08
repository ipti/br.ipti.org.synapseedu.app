import 'package:auto_size_text/auto_size_text.dart';
import 'package:elesson/app/feature/qrcode/qrcode_module.dart';
import 'package:flutter/material.dart';

import '../../../core/block/data/model/block_model.dart';

class LeasonDownloadPage extends StatefulWidget {
  final BlockModel block;

  const LeasonDownloadPage({required this.block, super.key});

  @override
  State<LeasonDownloadPage> createState() => _LeasonDownloadPageState();
}

class _LeasonDownloadPageState extends State<LeasonDownloadPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefa #${widget.block.id}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: size.width * 0.8,
              height: 50,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrCodeModule(blockModelOffline: widget.block)));
                  },
                  child: Center(child: Text("Iniciar Aula", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic')))),
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green, width: 2)),
                          width: 30,
                          height: 30,
                          child: Icon(Icons.task_alt, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
