import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/domain/entity/ddrop_option_entity.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_modal_image.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_modal_invisible.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_sender_undo.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:elesson/template_questoes/share/image_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/task/data/model/component_model.dart';
import 'ddrop_shimmer_modal.dart';

class DdropSender extends StatelessWidget {
  final MultimediaUseCase getMultimediaUseCase;
  final ComponentModel component;
  final TaskViewController taskController;

  DdropSender({Key? key, required this.component, required this.getMultimediaUseCase, required this.taskController}) : super(key: key);

  Uint8List? bytesImage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMultimediaUseCase.getBytesByMultimediaId(component.elements!.first.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, List<int>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return DdropShimmerModal();
        return snapshot.data!.fold(
          (l) => Container(),
          (r) {
            bytesImage = Uint8List.fromList(r);
            DdropOptionEntity ddropOptionEntity = DdropOptionEntity(elementModel: component.elements!.first, imageBytes: bytesImage,component_id: component.id!);

            return ValueListenableBuilder<List<DdropOptionEntity>>(
              valueListenable: taskController.ddropOptions,
              builder: (context, ddropOptions, child) {
                return ddropOptions.contains(ddropOptionEntity)
                    ? DdropSenderUndo(callback: () => taskController.removeDdropOptions(ddropOptionEntity))
                    : Draggable(
                        data: ddropOptionEntity,
                        child: GestureDetector(
                          onLongPress: () => Navigator.of(context).pushNamed(ImageDetailScreen.routeName, arguments: DetailScreenArguments()),
                          child: DdropModalImage(bytesImage: bytesImage!),
                        ),
                        feedback: DdropModalImage(bytesImage: bytesImage!),
                        childWhenDragging: DdropModalInvisible(),
                      );
              },
            );
          },
        );
      },
    );
  }
}
