import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/feature/task/widgets/shimmer_load_multimedia.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

class TextMultimedia extends StatelessWidget {
  final GetMultimediaUseCase getMultimediaUseCase;
  final bool? disableMaxHeight;
  final ElementModel elementModel;
  const TextMultimedia({Key? key, required this.elementModel, required this.getMultimediaUseCase, this.disableMaxHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (elementModel.multimedia_id == null) return Container();
    Size size = MediaQuery.of(context).size;
    double height = ((size.height - 24) * 0.145) - 12;

    return FutureBuilder(
      future: getMultimediaUseCase.getTextById(elementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return ShimmerLoadMultimedia(width: size.width-32,height: height);
        return snapshot.data!.fold(
          (l) => Container(),
          (r) => Container(
            child: Center(
              child: Text(
                r,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Mulish'),
              ),
            ),
            height: disableMaxHeight ?? false ? null : height,
            padding: EdgeInsets.symmetric(horizontal: 16),
            // margin: EdgeInsets.only(top: 12),
          ),
        );
      },
    );
  }
}
