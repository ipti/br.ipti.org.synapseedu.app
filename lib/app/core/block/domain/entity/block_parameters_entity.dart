class BlockParameterEntity{
  int teacherId;
  int studentId;
  int disciplineId;
  bool enableFeedback;

  BlockParameterEntity({required this.teacherId, required this.studentId, required this.disciplineId, this.enableFeedback = true});

  factory BlockParameterEntity.fromJson(Map<String, dynamic> json) {
    return BlockParameterEntity(
      teacherId: json['teacher_id'],
      studentId: json['inep_id'],
      disciplineId: json['discipline_id'],
      enableFeedback: json['enable_feedback']??true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "teacherId": teacherId,
      "studentId": studentId,
      "disciplineId": disciplineId,
      "enableFeedback": enableFeedback,
    };
  }
}