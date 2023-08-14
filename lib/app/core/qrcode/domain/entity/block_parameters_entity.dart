class BlockParameterEntity{
  int teacherId;
  int studentId;
  int disciplineId;

  BlockParameterEntity({required this.teacherId, required this.studentId, required this.disciplineId});

  factory BlockParameterEntity.fromJson(Map<String, dynamic> json) {
    return BlockParameterEntity(
      teacherId: json['teacher_id'],
      studentId: json['inep_id'],
      disciplineId: json['discipline_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "teacherId": teacherId,
      "studentId": studentId,
      "disciplineId": disciplineId,
    };
  }

}