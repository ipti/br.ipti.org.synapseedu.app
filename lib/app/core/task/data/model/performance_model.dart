import '../../../../util/enums/task_types.dart';
import 'metadata_model.dart';

class Performance {
  int? id;
  int userId;
  int taskId;
  bool isCorrect;
  int timeResolution;
  DateTime createdAt;
  MetaDataModel metadata;

  Performance({
    this.id,
    required this.userId,
    required this.taskId,
    required this.isCorrect,
    required this.timeResolution,
    required this.createdAt,
    required this.metadata,
  });

  //fromjson
  factory Performance.fromJson(Map<String, dynamic> json) {
    print(json);
    return Performance(
      id: json['id'],
      userId: json['user_id'],
      taskId: json['task_id'],
      isCorrect: json['is_correct'],
      timeResolution: json['time_resolution'],
      createdAt: DateTime.parse(json['created_at']),
      metadata: MetaDataModel.empty()
      // metadata: json['meta_data'] != null ? MetaDataModel.fromJson(json['meta_data']) : MetaDataModelMTE(),
    );
  }

  Map<String, dynamic> toJson({required TemplateTypes templateType}) {
    Map<String, dynamic> jsonGenerated = {
      "user_id": userId,
      "task_id": taskId,
      "is_correct": isCorrect,
      "time_resolution": timeResolution,
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
}
