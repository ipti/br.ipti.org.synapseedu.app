import 'dart:math';
import 'dart:typed_data';
import 'package:dartz/dartz.dart' as Dartz;
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

import 'shimmer_load_multimedia.dart';

class ImageMultimedia extends StatefulWidget {
  final double? width;
  final bool bodyElement;
  final ElementModel elementModel;
  final GetMultimediaUseCase getMultimediaUseCase;

  ImageMultimedia({Key? key, required this.elementModel, required this.getMultimediaUseCase, this.bodyElement = false, this.width}) : super(key: key);

  @override
  _ImageMultimediaState createState() => _ImageMultimediaState();
}

class _ImageMultimediaState extends State<ImageMultimedia> {
  late double heightWidth;

  @override
  Widget build(BuildContext context) {
    print("Render IMAGE MULTIMEDIA");
    Size size = MediaQuery.of(context).size;
    if (widget.width == null) {
      heightWidth = widget.bodyElement ? (max(size.height, size.width) / 4.3) : min(size.height, size.width) - 30;
    }
    return FutureBuilder(
      future: widget.getMultimediaUseCase.getBytesByMultimediaId(widget.elementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Dartz.Either<Failure, List<int>>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return ShimmerLoadMultimedia(width: widget.width ?? heightWidth, height: widget.width ?? heightWidth);
        return snapshot.data!.fold(
          (l) => Center(child: Text('Erro ao carregar imagem')),
          (r) {
            Uint8List imageData = Uint8List.fromList(r);
            return Container(
              height: widget.width ?? heightWidth,
              width: widget.width ?? heightWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2)),
                image: DecorationImage(
                  image: MemoryImage(imageData),
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
