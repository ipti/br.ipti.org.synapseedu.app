import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ElementModel extends Equatable {
  int? id;
  int? position;
  String? description;
  int? head_component_id;
  int? body_component_id;
  int? multimedia_id;
  int? type_id;
  Uint8List? audioBytes;
  bool mainElement = false;
  TextEditingController textController = TextEditingController();

  ElementModel({this.id, this.position, this.description, this.head_component_id, this.body_component_id, this.multimedia_id, this.type_id, this.audioBytes, this.mainElement = false});

  factory ElementModel.fromMap(Map<String, dynamic> map) {
    return ElementModel(
      id: map['id'] ?? null,
      position: map['position'] ?? null,
      description: map['description'] ?? null,
      head_component_id: map['head_component_id'] ?? null,
      body_component_id: map['body_component_id'] ?? null,
      multimedia_id: map['multimedia_id'] ?? null,
      type_id: map['type_id'] ?? null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position': position,
      'description': description,
      'head_component_id': head_component_id,
      'body_component_id': body_component_id,
      'multimedia_id': multimedia_id,
      'type_id': type_id,
    };
  }

  @override
  List<Object?> get props => [id, position, description, head_component_id, body_component_id, multimedia_id, type_id, textController.hashCode];
}
