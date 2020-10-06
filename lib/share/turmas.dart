class Turmas {
  Classroom classroom;

  Turmas({this.classroom});

  factory Turmas.fromJson(Map<String, dynamic> json) => Turmas(
    classroom: Classroom.fromJson(json["classroom"]),
  );

  Map<String, dynamic> toJson() => {
    "classroom": classroom.toJson(),
  };
}

class Classroom {
  String id;
  String name;

  Classroom({this.id, this.name});

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
      id: json["id"],
      name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    id:id,
    name:name,
  };
}
