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
import 'ddrop_shimmer_modal.dart';

class DdropTarget extends StatefulWidget {
  final ElementModel element;
  final GetMultimediaUseCase getMultimediaUseCase;
  final TaskViewController taskController;
  final int position;

  DdropTarget({Key? key, required this.element, required this.getMultimediaUseCase, required this.taskController, required this.position}) : super(key: key);

  @override
  _DdropTargetState createState() => _DdropTargetState();
}

class _DdropTargetState extends State<DdropTarget> {
  late Future<Dartz.Either<Failure, List<int>>> loadTargetImage = widget.getMultimediaUseCase.getBytesByMultimediaId(widget.element.multimedia_id!);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DragTarget(
      onAccept: (DdropOptionEntity data) => widget.taskController.addDdropOptions(widget.position, data),
      builder: (context, List<dynamic> candidateData, rejectedData) {
        return SizedBox(
          width: size.width > size.height ? (size.width / 2.6) / 3 + 20 : size.width / 2.6 + 20,
          height: size.width > size.height ? (size.width / 2.6) / 3 : size.width / 2.6,
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
