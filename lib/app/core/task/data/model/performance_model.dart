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

  Map<String, dynamic> toJson({required TemplateTypes templateType}) {
    var jsonGenerated = {
      "user_id": userId,
      "task_id": taskId,
      "is_correct": isCorrect,
      "time_resolution": timeResolution,
      "created_at": createdAt,
      "meta_data": templateType == TemplateTypes.MTE
          ? (metadata as MetaDataModelMTE).toJson()
          : templateType == TemplateTypes.PRE
              ? (metadata as MetaDataModelPRE).toJson()
              : (metadata as MetaDataModelDDROP).toJson(),
    };
    if (id != null) {
      jsonGenerated['id'] = id!;
    }
    return jsonGenerated;
  }
}
