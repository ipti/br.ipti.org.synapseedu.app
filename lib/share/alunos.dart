class Alunos {
  bool valid;
  Person person;

  Alunos({this.valid, this.person});

  factory Alunos.fromJson(Map<String, dynamic> json) => Alunos(
    valid: json["valid"],
    person: Person.fromJson(json["person"]),
  );

  Map<String, dynamic> toJson() => {
    "valid": valid,
    "person": person.toJson(),
  };
}

class Person {
  String id;
  String name;

  Person({this.id, this.name});

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    id:id,
    name:name,
  };
}
