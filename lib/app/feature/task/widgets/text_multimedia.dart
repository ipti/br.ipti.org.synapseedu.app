import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/shared/contants/ddrop_colors.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/shimmer_load_multimedia.dart';
import 'package:elesson/app/util/enums/sound_status.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextMultimedia extends StatelessWidget {
  final MultimediaUseCase getMultimediaUseCase;
  final bool? disableMaxHeight;
  final ElementModel elementModel;
  final Function? audioCallback;
  final bool hasAudio;
  final TaskViewController taskViewController;

  TextMultimedia(
      {Key? key, required this.elementModel, required this.getMultimediaUseCase, this.disableMaxHeight, this.audioCallback, this.hasAudio = false, required this.taskViewController});

  @override
  Widget build(BuildContext context) {
    if (elementModel.multimedia_id == null) return Container();
    Size size = MediaQuery
        .of(context)
        .size;
    double height = ((size.height - 24) * 0.145) - 12;

    return FutureBuilder(
      future: getMultimediaUseCase.getTextById(elementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return ShimmerLoadMultimedia(width: size.width - 32, height: height);
        return snapshot.data!.fold(
              (l) => Container(),
              (r) =>
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (audioCallback != null) audioCallback!();
                },
                child: Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (hasAudio)
                        AnimatedBuilder(animation: taskViewController, builder: (context, child) {
                          return taskViewController.soundStatus == SoundStatusEnum.Playing
                              ? SizedBox(width: 30, child: Icon(Icons.pause_circle_outline, color: Colors.blue))
                              : taskViewController.soundStatus == SoundStatusEnum.Loading
                              ? SizedBox(width: 30, child: CircularProgressIndicator(color: Colors.blue,strokeWidth: 2))
                              : SizedBox(width: 30, child: Icon(Icons.play_circle_outline, color: Colors.blue));
                        },),
                      SizedBox(
                        width: size.width - (hasAudio ? 46 : 10),
                        child: Text(r, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Mulish')),
                      ),
                    ],
                  ),
                  height: disableMaxHeight ?? false ? null : height,
                ),
              ),
        );
      },
    );
  }
}
