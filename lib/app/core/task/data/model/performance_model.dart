import '../../../../util/enums/task_types.dart';
import 'metadata_model.dart';

class Performance {
  int? id;
  int student_id;
  int taskId;
  bool isCorrect;
  int timeResolution;
  DateTime createdAt;
  int? block_id;
  MetaDataModel metadata;

  Performance({
    this.id,
    required this.student_id,
    required this.taskId,
    required this.isCorrect,
    this.block_id,
    required this.timeResolution,
    required this.createdAt,
    required this.metadata,
  });

  //fromjson
  factory Performance.fromJson(Map<String, dynamic> json) {
    print(json['meta_data']['template_id']);

    return Performance(
        id: json['id'],
        student_id: json['student_id'],
        taskId: json['task_id'],
        isCorrect: json['is_correct'],
        block_id: json['block_id'],
        timeResolution: json['time_resolution'],
        createdAt: DateTime.parse(json['created_at']),
        metadata: MetaDataModel.fromJson(json['meta_data']),
        // metadata: json['meta_data'] != null ? MetaDataModel.fromJson(json['meta_data']) : MetaDataModelMTE(),
        );
  }

  Map<String, dynamic> toJson({required TemplateTypes templateType}) {
    Map<String, dynamic> jsonGenerated = {
      "student_id": student_id,
      "task_id": taskId,
      "is_correct": isCorrect,
      "time_resolution": timeResolution,
      "block_id": block_id,
      "created_at": createdAt.toString(),
      "meta_data": templateType == TemplateTypes.MTE
          ? (metadata as MetaDataModelMTE).toJson()
          : templateType == TemplateTypes.PRE
              ? (metadata as MetaDataModelPRE).toJson()
              : (metadata as MetaDataModelAEL).toJson(),
    };
    if (id != null) {
      jsonGenerated['id'] = id!;
    }
    return jsonGenerated;
  }

  //empty
  static Performance empty() {
    return Performance(
      student_id: 0,
      taskId: 0,
      isCorrect: false,
      timeResolution: 0,
      createdAt: DateTime.now(),
      metadata: MetaDataModel.empty(),
    );
  }
}
