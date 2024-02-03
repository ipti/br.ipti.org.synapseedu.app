import 'dart:math';
import 'dart:typed_data';

import 'package:dartz/dartz.dart' as Dartz;
import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/domain/entity/ddrop_option_entity.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

import 'ddrop_modal_image.dart';
import 'ddrop_shimmer_modal.dart';

class DdropTarget extends StatefulWidget {
  final ComponentModel component;
  final MultimediaUseCase getMultimediaUseCase;
  final TaskViewController taskController;
  final int position;

  DdropTarget({Key? key, required this.component, required this.getMultimediaUseCase, required this.taskController, required this.position}) : super(key: key);

  @override
  _DdropTargetState createState() => _DdropTargetState();
}

class _DdropTargetState extends State<DdropTarget> {
  late Future<Dartz.Either<Failure, List<int>>> loadTargetImage = widget.getMultimediaUseCase.getBytesByMultimediaId(widget.component.elements!.first.multimedia_id!);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isHorizontal = size.width > size.height;
    double heightWidth = 200;
    double horizontalWidth = size.width / 2;
    if (isHorizontal) {
      heightWidth = horizontalWidth / 2.5;
    } else {
      heightWidth = size.width / 3;
    }
    heightWidth = min(size.height/3.5 , heightWidth);

    return DragTarget(
      onAccept: (DdropOptionEntity data) => widget.taskController.addDdropOptions(widget.position, data, DateTime.now()),
      builder: (context, List<dynamic> candidateData, rejectedData) {
        return SizedBox(
          width: heightWidth+20,
          height: heightWidth,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              FutureBuilder(
                future: loadTargetImage,
                builder: (context, AsyncSnapshot<Dartz.Either<Failure, List<int>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return DdropShimmerModal();
                  return snapshot.data!.fold((l) => CircularProgressIndicator(), (r) => DdropModalImage(bytesImage: Uint8List.fromList(r)));
                },
              ),
              ValueListenableBuilder<List<DdropOptionEntity>>(
                valueListenable: widget.taskController.ddropOptions,
                builder: (context, ddropOptions, child) {
                  return Positioned(
                    top: 0,
                    right: 20,
                    child: ddropOptions[widget.position] != DdropOptionEntity() ? DdropModalImage(bytesImage: ddropOptions[widget.position].imageBytes!) : Container(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
