import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_modal_invisible.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_target.dart';
import 'package:flutter/material.dart';

import 'feature/task/widgets/ddrop/ddrop_sender.dart';
import 'feature/task/widgets/ddrop/ddrop_sender_undo.dart';
import 'feature/task/widgets/image_multimedia.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // DdropSenderUndo(),
                // DdropSenderUndo(),
                // DdropSender(element: taskModel.body!.components[0].elements!.first,getMultimediaUseCase: getMultimediaUseCase,),
                // ImageMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                // ImageMultimedia(elementModel: taskModel.body!.components[1].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                // ImageMultimedia(elementModel: taskModel.body!.components[2].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
              ],
            ),
            SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // DdropTarget(),
                // DdropTarget(),
                DdropModalInvisible(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
