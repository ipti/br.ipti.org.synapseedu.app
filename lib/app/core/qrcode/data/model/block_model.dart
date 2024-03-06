import 'break_point_model.dart';
import 'block_values.dart';
import 'lesson_model.dart';

class BlockModel {
  int id;
  BlockValues teacher;
  BlockValues student;
  BlockValues discipline;
  List<int> tasks;
  BreakPointModel breakPoint;
  Map<String, Lesson> lessons;

  BlockModel({required this.id, required this.teacher, required this.student, required this.discipline, required this.tasks, required this.breakPoint, required this.lessons});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
        id: json['id'],
        teacher: BlockValues.fromJson(json['teacher']),
        student: BlockValues.fromJson(json['student']),
        discipline: BlockValues.fromJson(json['discipline']),
        tasks: json['tasks'] != null ? (json['tasks'] as List<dynamic>).map((e) => int.parse(e.toString())).toList() : [],
        breakPoint: BreakPointModel.fromJson(json['break_point']),
        lessons: Map.from(json["lessons"]).map((k, v) => MapEntry<String, Lesson>(k, Lesson.fromJson(v))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "teacher": teacher.toJson(),
      "student": student.toJson(),
      "discipline": discipline.toJson(),
      "tasks": tasks,
      "breakPoint": breakPoint.toJson(),
      "lessons": Map.from(lessons).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
  }

  static BlockModel empty() {
    return BlockModel(
      id: 0,
      teacher: BlockValues.empty(),
      student: BlockValues.empty(),
      discipline: BlockValues.empty(),
      tasks: [],
      breakPoint: BreakPointModel(last_resolved_task_id: 0, created_at: DateTime.now()),
      lessons: {},
    );
  }
}
