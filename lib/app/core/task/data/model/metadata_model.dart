import 'package:elesson/app/core/task/data/model/component_model.dart';

abstract class Metadata {
  final String template_type;
  final int body_component_id;

  Metadata({required this.template_type, required this.body_component_id});
}

class MetadataMTE extends Metadata {
  MetadataMTE({required super.template_type, required super.body_component_id});

  Map<String, dynamic> toJson() => {
        "template_type": template_type,
        "body_component_id": body_component_id,
      };
}

class MetadataPRE extends Metadata {
  final String text;

  MetadataPRE({required this.text, required super.template_type, required super.body_component_id});

  Map<String, dynamic> toJson() => {
        "template_type": template_type,
        "body_component_id": body_component_id,
        "text": text,
      };
}

class MetadataDDROP extends Metadata {
  final ComponentModel componentModel;

  MetadataDDROP({required this.componentModel, required super.template_type, required super.body_component_id});

  Map<String, dynamic> toJson() {
    List<dynamic> choisesList = componentModel.elements!
        .map((e) => {
              "body_component_id_top": 367,
              "body_component_id_down": 368,
              "is_correct": true,
              "time_resolution": 554,
            })
        .toList();

    return {
      "template_type": template_type,
      "choices": choisesList,
    };
  }
}
