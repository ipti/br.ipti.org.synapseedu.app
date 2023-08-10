import '../../../../util/enums/task_types.dart';
import 'metadata_model.dart';

class Performance {
  int id;
  int userId;
  int taskId;
  bool isCorrect;
  int timeResolution;
  int createdAt;
  Metadata metadata;

  Performance({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.isCorrect,
    required this.timeResolution,
    required this.createdAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson({required TemplateTypes templateType}) => {
        "id": id,
        "user_id": userId,
        "task_id": taskId,
        "is_correct": isCorrect,
        "time_resolution": timeResolution,
        "created_at": createdAt,
        "meta_data": templateType == TemplateTypes.MTE
            ? (metadata as MetadataMTE).toJson()
            : templateType == TemplateTypes.PRE
                ? (metadata as MetadataPRE).toJson()
                : (metadata as MetadataDDROP).toJson(),
      };
}
