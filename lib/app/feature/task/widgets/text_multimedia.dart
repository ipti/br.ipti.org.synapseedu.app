import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/task/widgets/shimmer_load_multimedia.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

class TextMultimedia extends StatelessWidget {
  final MultimediaUseCase getMultimediaUseCase;
  final bool? disableMaxHeight;
  final ElementModel elementModel;
  final Function? audioCallback;
  final bool hasAudio;

  const TextMultimedia({Key? key, required this.elementModel, required this.getMultimediaUseCase, this.disableMaxHeight, this.audioCallback, this.hasAudio = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (elementModel.multimedia_id == null) return Container();
    Size size = MediaQuery.of(context).size;
    double height = ((size.height - 24) * 0.145) - 12;

    return FutureBuilder(
      future: getMultimediaUseCase.getTextById(elementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return ShimmerLoadMultimedia(width: size.width - 32, height: height);
        return snapshot.data!.fold(
          (l) => Container(),
          (r) => Container(
            width: size.width - 32,
            child: Stack(alignment: Alignment.centerLeft,
              children: [
                if(hasAudio)IconButton(onPressed: () => print("Pressed"), icon: Icon(Icons.mic), color: Colors.blue),
                Center(child: Text(r, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Mulish'))),
              ],
            ),
            height: disableMaxHeight ?? false ? null : height,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        );
      },
    );
  }
}
// onTap: () {
// print("PLAY");
// // audioCallback!();
// },