import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:elesson/share/snackbar_widget.dart';
import 'package:flutter/material.dart';

class ImageMultimedia extends StatelessWidget {

  final double width;
  final ElementModel elementModel;
  final GetMultimediaUseCase getMultimediaUseCase;

  const ImageMultimedia({Key? key, required this.elementModel, required this.getMultimediaUseCase, this.width = 100}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getMultimediaUseCase.getBytesByMultimediaId(elementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Either<Failure, List<int>>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return CircularProgressIndicator();
        return snapshot.data!.fold((l) => Center(child: Text('Erro ao carregar imagem')), (r) {
          Uint8List imageData = Uint8List.fromList(r);
          return Expanded(
            child: Container(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      width: 2,
                      color: Color.fromRGBO(110, 114, 145, 0.2),
                    ),
                  ),
                  child: Image.memory(
                    imageData,
                    fit: BoxFit.cover,
                    errorBuilder: (context, exception, stackTrace) {
                      callSnackBar(context);
                      return Container();
                    },
                  ),
                ),
              ),
              padding: EdgeInsets.only(left: 16, right: 16),
              height: (size.height-24) * 0.70,
            ),
          );
        });
      },
    );
  }
}
