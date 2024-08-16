class TeacherClassroomModel {
  final String schoolName;
  final int teacherId;
  final String teacherName;
  final int classroomId;
  final String classroomName;
  final int classroomCreatedYear;
  final String classroomYearName;
  final int classroomYearStage;
  final int studentId;
  final String studentName;

  TeacherClassroomModel({
      required this.schoolName,
      required this.teacherId,
      required this.teacherName,
      required this.classroomId,
      required this.classroomName,
      required this.classroomCreatedYear,
      required this.classroomYearName,
      required this.classroomYearStage,
      required this.studentId,
      required this.studentName});

  factory TeacherClassroomModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassroomModel(
      schoolName: json['school_name'],
      teacherId: json['teacher_id'],
      teacherName: json['teacher_name'],
      classroomId: json['classroom_id'],
      classroomName: json['classroom_name'],
      classroomCreatedYear: json['classroom_created_year'],
      classroomYearName: json['classroom_year_name'],
      classroomYearStage: json['classroom_year_stage'],
      studentId: json['student_id'],
      studentName: json['student_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['school_name'] = schoolName;
    map['teacher_id'] = teacherId;
    map['teacher_name'] = teacherName;
    map['classroom_id'] = classroomId;
    map['classroom_name'] = classroomName;
    map['classroom_created_year'] = classroomCreatedYear;
    map['classroom_year_name'] = classroomYearName;
    map['classroom_year_stage'] = classroomYearStage;
    map['student_id'] = studentId;
    map['student_name'] = studentName;
    return map;
  }

}