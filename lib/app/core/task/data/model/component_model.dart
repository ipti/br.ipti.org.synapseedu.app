import 'package:equatable/equatable.dart';
import 'element_model.dart';

class ComponentModel extends Equatable{
  int? id;
  int? position;
  int? head_id;
  int? body_id;
  List<ElementModel>?  elements;

  ComponentModel({this.id, this.position, this.head_id, this.body_id, this.elements});

  factory ComponentModel.fromMap(Map<String, dynamic> json) {
    return ComponentModel(
      id: json['id'] ?? null,
      position: json['position']?? null,
      head_id: json['head_id']?? null,
      body_id: json['body_id']?? null,
      elements: json['elements'] != null ? (json['elements'] as List<dynamic>).map((e) => ElementModel.fromMap(e as Map<String, dynamic>)).toList() : [],
    );
  }

  Map<String, dynamic> toMap() {
    return head_id != null
        ? {'id': id, 'position': position, 'head_id': head_id, 'elements': elements?.map((e) => e.toMap()).toList()}
        : {'id': id, 'position': position, 'body_id': body_id, 'elements': elements?.map((e) => e.toMap()).toList()};
  }

  @override
  List<Object?> get props => [id, position, head_id, body_id, elements];
}
