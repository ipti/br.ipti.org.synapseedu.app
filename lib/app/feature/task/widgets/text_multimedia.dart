import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/shared/contants/ddrop_colors.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/shimmer_load_multimedia.dart';
import 'package:elesson/app/util/enums/sound_status.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

import '../../../core/task/data/model/component_model.dart';
import '../../../util/enums/multimedia_types.dart';

class TextMultimedia extends StatelessWidget {
  final MultimediaUseCase getMultimediaUseCase;
  final bool? disableMaxHeight;
  final ComponentModel componentModel;
  final Function? audioCallback;
  final bool hasAudio;
  final TaskViewController taskViewController;
  final bool isMte;
  late double heightWidth;
  ElementModel findedElementModel = ElementModel();

  TextMultimedia(
      {Key? key,
      required this.componentModel,
      required this.getMultimediaUseCase,
      this.disableMaxHeight,
      this.audioCallback,
      this.hasAudio = false,
      this.isMte = false,
      required this.taskViewController}) {
    findedElementModel =
        componentModel.elements!.firstWhere((element) => element.type_id == MultimediaTypes.text.type_id);
  }

  @override
  Widget build(BuildContext context) {
    if (findedElementModel.multimedia_id == null) return Container();
    Size size = MediaQuery.of(context).size;
    double height = ((size.height - 24) * 0.145) - 12;
    heightWidth = isMte ? (max(size.height, size.width) / 2.2) : min(size.height, size.width) - 30;
    // if (size.width > size.height) heightWidth = heightWidth / 2[p

    return FutureBuilder(
      future: getMultimediaUseCase.getTextById(findedElementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return ShimmerLoadMultimedia(width: size.width - 32, height: height);
        return snapshot.data!.fold(
          (l) => Container(),
          (r) => ValueListenableBuilder(
            valueListenable: taskViewController.componentSelected,
            builder: (context, value, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (audioCallback != null) {
                    audioCallback!();
                    return;
                  }
                  isMte ? taskViewController.changeComponentSelected(componentModel) : () {};
                },
                child: Container(
                  width: isMte ? heightWidth : size.width,
                  height: disableMaxHeight ?? false ? heightWidth : height,
                  decoration: isMte
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              width: 2,
                              color: componentModel == value ? Color(0xFF0000FF) : Color.fromRGBO(110, 114, 145, 0.2)),
                        )
                      : null,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (hasAudio)
                        AnimatedBuilder(
                          animation: taskViewController,
                          builder: (context, child) {
                            return taskViewController.soundStatus == SoundStatusEnum.Playing
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: firstColor,width: 2)),
                                    width: 50,
                                    height: 50,
                                    child: Icon(Icons.pause, color: Colors.blue, size: 40))
                                : taskViewController.soundStatus == SoundStatusEnum.Loading
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: firstColor,width: 2)),
                                        width: 50,
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
                                        ))
                                    : Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: firstColor,width: 2)),
                                        width: 50,
                                        height: 50,
                                        child: Icon(Icons.play_arrow, color: Colors.blue, size: 40));
                          },
                        ),
                      SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          r,
                          textAlign: isMte ? TextAlign.center : TextAlign.start,
                          // maxLines: 2,
                          minFontSize: 16,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic',),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
