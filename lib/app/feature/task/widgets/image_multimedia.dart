import 'dart:math';
import 'dart:typed_data';
import 'package:dartz/dartz.dart' as Dartz;
import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/util/enums/multimedia_types.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';

import 'shimmer_load_multimedia.dart';

class ImageMultimedia extends StatefulWidget {
  final bool bodyElement;
  final ComponentModel componentModel;
  final MultimediaUseCase getMultimediaUseCase;
  final TaskViewController? taskViewController;

  ImageMultimedia({Key? key, required this.componentModel, required this.getMultimediaUseCase, this.bodyElement = false, this.taskViewController}) : super(key: key);

  @override
  _ImageMultimediaState createState() => _ImageMultimediaState();
}

class _ImageMultimediaState extends State<ImageMultimedia> {
  late double heightWidth;
  ElementModel findedElementModel = ElementModel();

  @override
  void initState() {
    super.initState();
    findedElementModel = widget.componentModel.elements!.firstWhere((element) => element.type_id == MultimediaTypes.image.type_id);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    heightWidth = widget.bodyElement ? (max(size.height, size.width) / 4.3) : min(size.height, size.width) - 30;

    if(size.width > size.height) heightWidth = heightWidth / 2;

    return FutureBuilder(
      future: widget.getMultimediaUseCase.getBytesByMultimediaId(findedElementModel.multimedia_id!),
      builder: (context, AsyncSnapshot<Dartz.Either<Failure, List<int>>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return ShimmerLoadMultimedia(width: heightWidth, height: heightWidth);
        return snapshot.data!.fold(
          (l) => Center(child: Text('Erro ao carregar imagem')),
          (r) {
            Uint8List imageData = Uint8List.fromList(r);

            if (widget.taskViewController == null) {
              return Container(
                height: heightWidth,
                width: heightWidth,
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
            }

            return ValueListenableBuilder(
              valueListenable: widget.taskViewController!.componentSelected,
              builder: (context, value, child) {
                return GestureDetector(
                  onTap: () => widget.bodyElement ? widget.taskViewController!.changeComponentSelected(widget.componentModel) : null,
                  child: Container(
                    height: heightWidth,
                    width: heightWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(width: 2, color: widget.componentModel == value ? Color(0xFF0000FF) : Color.fromRGBO(110, 114, 145, 0.2)),
                      image: DecorationImage(
                        image: MemoryImage(imageData),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
