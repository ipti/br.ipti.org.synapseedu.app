class Lesson {
  final int lessonId;
  final List<int> tasksId;

  Lesson({
    required this.lessonId,
    required this.tasksId,
  });

  Lesson copyWith({
    int? lessonId,
    List<int>? tasksId,
  }) =>
      Lesson(
        lessonId: lessonId ?? this.lessonId,
        tasksId: tasksId ?? this.tasksId,
      );

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    lessonId: json["lesson_id"],
    tasksId: List<int>.from(json["tasks_id"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "lesson_id": lessonId,
    "tasks_id": List<dynamic>.from(tasksId.map((x) => x)),
  };
}
