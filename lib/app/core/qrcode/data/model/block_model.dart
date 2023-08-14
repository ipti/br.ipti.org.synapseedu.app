import 'break_point_model.dart';
import 'block_values.dart';

class BlockModel {
  int id;
  BlockValues teacher;
  BlockValues student;
  BlockValues discipline;
  List<int> tasks;
  BreakPointModel breakPoint;

  BlockModel(
      {required this.id, required this.teacher, required this.student, required this.discipline, required this.tasks, required this.breakPoint});

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      id: json['id'],
      teacher: BlockValues.fromJson(json['teacher']),
      student: BlockValues.fromJson(json['student']),
      discipline: BlockValues.fromJson(json['discipline']),
      tasks: json['tasks'].cast<int>(),
      breakPoint: BreakPointModel.fromJson(json['break_point']),
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
    );
  }
}
