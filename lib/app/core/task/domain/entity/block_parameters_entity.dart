class BlockParameterEntity{
  int teacherId;
  int studentId;
  int disciplineId;

  BlockParameterEntity({required this.teacherId, required this.studentId, required this.disciplineId});

  factory BlockParameterEntity.fromJson(Map<String, dynamic> json) {
    return BlockParameterEntity(
      teacherId: json['teacherId'],
      studentId: json['studentId'],
      disciplineId: json['disciplineId'],
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