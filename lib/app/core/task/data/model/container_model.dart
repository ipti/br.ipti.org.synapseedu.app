import 'package:equatable/equatable.dart';

import 'component_model.dart';

class ContainerModel extends Equatable{
  int? id;
  String? description;
  List<ComponentModel> components = List<ComponentModel>.empty();

  ContainerModel({this.id, this.description, required this.components});

  factory ContainerModel.fromMap(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'] != null? json['id'] : 0,
      description: json['description'] != null ? json['description'] : "",
      components: json['components'] != null ? (json['components'] as List<dynamic>).map((e) => ComponentModel.fromMap(e as Map<String, dynamic>)).toList() : [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'description': description,
        "components": components.map((e) => e.toMap()).toList(),
      };

  factory ContainerModel.empty() => ContainerModel(components: List<ComponentModel>.empty());

  @override
  List<Object?> get props => [id, description, components];
}
