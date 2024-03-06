import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/shared/contants/ddrop_colors.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/shimmer_load_multimedia.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/task/data/model/component_model.dart';
import '../../../util/enums/multimedia_types.dart';

class TextMultimedia extends StatelessWidget {
  final MultimediaUseCase getMultimediaUseCase;
  final bool? disableMaxHeight;
  final ComponentModel componentModel;
  final Function? audioCallback;
  final int? audioMultimediaId;
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
      this.audioMultimediaId,
      this.isMte = false,
      required this.taskViewController}) {
    findedElementModel = componentModel.elements!.firstWhere((element) => element.type_id == MultimediaTypes.text.type_id);
  }

  @override
  Widget build(BuildContext context) {
    if (findedElementModel.multimedia_id == null) return Container();
    Size size = MediaQuery.of(context).size;
    double height = ((size.height - 24) * 0.17);
    heightWidth = isMte ? (max(size.height, size.width) / 2.2) : min(size.height, size.width) - 30;

    return FutureBuilder(
      future: getMultimediaUseCase.getTextById(findedElementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return ShimmerLoadMultimedia(width: size.width - 32, height: height);
        print("SNAPSHOT: ${snapshot.data}");
        return snapshot.data!.fold(
          (l) => Container(),
          (r) => AnimatedBuilder(
            animation: taskViewController,
            builder: (context, child) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if(isMte && componentModel.body_id!=null) taskViewController.changeComponentSelected(componentModel);
                  if (audioCallback != null) {
                    audioCallback!();
                    return;
                  }
                },
                child: Container(
                  width: isMte ? heightWidth : size.width,
                  height: disableMaxHeight ?? false ? heightWidth : height,
                  decoration: isMte
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border:
                              Border.all(width: 2, color: componentModel == taskViewController.componentSelected ? Color(0xFF0000FF) : Color.fromRGBO(110, 114, 145, 0.2)),
                        )
                      : null,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (audioMultimediaId != null)
                        Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: firstColor, width: 2)),
                            width: 50,
                            height: 50,
                            child: StreamBuilder(
                                stream: taskViewController.audioPlayer.playbackEventStream,
                                builder: (context, AsyncSnapshot<PlaybackEvent> snapshot) {
                                  ProcessingState? state = snapshot.data?.processingState;
                                  if (state == ProcessingState.ready) {
                                    taskViewController.isDownloadingAudio = false;
                                  }
                                  if (taskViewController.isDownloadingAudio) return Icon(Icons.downloading, color: Colors.blue);
                                  if (state == ProcessingState.idle) {
                                    taskViewController.isDownloadingAudio = false;
                                    return Icon(Icons.play_arrow, color: Colors.blue);
                                  }
                                  if (state == ProcessingState.ready && taskViewController.multimediaIdPlayingAudio == audioMultimediaId) {
                                    return Icon(Icons.pause, color: Colors.blue);
                                  } else {
                                    return Icon(Icons.play_arrow, color: Colors.blue);
                                  }
                                })),
                      SizedBox(width: 5),
                      Expanded(
                        child: AutoSizeText(
                          r,
                          textAlign: isMte ? TextAlign.center : TextAlign.start,
// maxLines: 2,
                          minFontSize: 14,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            fontFamily: 'Comic',
                          ),
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
