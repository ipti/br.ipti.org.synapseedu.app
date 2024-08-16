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
    print("DDROP ENTITY: ${json}");
    return DdropOptionEntity(
      elementModel: ElementModel.fromMap(json['elementModel']),
      imageBytes: json['imageBytes'] != null ? json['imageBytes'] : [],
      component_id: json['imageBytes'] != null ? json['component_id'] : 1,
      time: json['imageBytes'] != null ? json['time']: 1,
    );
  }

  @override
  List<Object?> get props => [elementModel];

}
