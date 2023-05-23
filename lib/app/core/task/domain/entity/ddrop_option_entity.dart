import 'dart:typed_data';

import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:equatable/equatable.dart';

class DdropOptionEntity extends Equatable {
  final ElementModel? elementModel;
  final Uint8List? imageBytes;

  DdropOptionEntity({this.elementModel, this.imageBytes});

  @override
  List<Object?> get props => [elementModel];
}
