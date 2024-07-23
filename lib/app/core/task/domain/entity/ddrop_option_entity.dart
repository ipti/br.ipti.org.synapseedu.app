import 'dart:typed_data';

import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:equatable/equatable.dart';

class DdropOptionEntity extends Equatable {
  final ElementModel? elementModel;
  final Uint8List? imageBytes;
  final int component_id;
  late int time;

  DdropOptionEntity({this.elementModel, this.imageBytes, this.component_id = 0, this.time = 0});

  //fromjson
  factory DdropOptionEntity.fromJson(Map<String, dynamic> json) {
    return DdropOptionEntity(
      elementModel: ElementModel.fromMap(json['elementModel']),
      imageBytes: json['imageBytes'],
      component_id: json['component_id'],
      time: json['time'],
    );
  }

  @override
  List<Object?> get props => [elementModel];

}
