import 'dart:typed_data';

import 'package:dartz/dartz.dart' as Dartz;
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/entity/ddrop_option_entity.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/image_multimedia.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

import '../image_multimedia.dart';
import 'ddrop_modal_image.dart';

class DdropTarget extends StatefulWidget {
  final ElementModel element;
  final GetMultimediaUseCase getMultimediaUseCase;
  final TaskViewController taskController;


  DdropTarget({Key? key, required this.element, required this.getMultimediaUseCase, required this.taskController}) : super(key: key);

  @override
  _DdropTargetState createState() => _DdropTargetState();
}

class _DdropTargetState extends State<DdropTarget> {
  DdropOptionEntity? ddropOptionEntity;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DragTarget(
      onWillAccept: (data) => true,
      onAccept: (DdropOptionEntity data) {
        widget.taskController.addDdropOptions(data);
        setState(() => ddropOptionEntity = data);
      },
      builder: (context, List<dynamic> candidateData, rejectedData) {
        return Container(
          width: size.width / 2.6 + 20,
          height: size.width / 2.6,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              FutureBuilder(
                future: widget.getMultimediaUseCase.getBytesByMultimediaId(widget.element.multimedia_id!),
                builder: (context, AsyncSnapshot<Dartz.Either<Failure, List<int>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return CircularProgressIndicator();
                  return snapshot.data!.fold((l) => CircularProgressIndicator(), (r) => DdropModalImage(bytesImage: Uint8List.fromList(r)));
                },
              ),
              Positioned(top: 0, right: 20, child: ddropOptionEntity != null ? DdropModalImage(bytesImage: ddropOptionEntity!.imageBytes!) : Container()),
            ],
          ),
        );
      },
    );
  }
}
