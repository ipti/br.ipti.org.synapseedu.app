class AlunoData {
  bool? valid;
  List<String>? error;
  List<Person>? person;
  List<Actor>? actor;
  List<Personage>? personage;

  AlunoData({this.valid, this.error, this.person, this.actor, this.personage});

  factory AlunoData.fromJson(Map<String, dynamic> json) {
    return AlunoData(valid: json['valid'], error: json['error'], person: json['person'], actor: json['actor'], personage: json['personage']);
  }
}

class Person {
  String? id;
  String? name;
  String? login;
  String? email;
  String? password;
  String? mother_name;
  String? father_name;
  String? phone;

  Person({this.id, this.name, this.login, this.email, this.password, this.mother_name, this.father_name, this.phone});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        id: json['id'],
        name: json['name'],
        login: json['login'],
        email: json['email'],
        password: json['password'],
        mother_name: json['mother_name'],
        father_name: json['father_name'],
        phone: json['phone']);
  }
}

class Actor {
  String? id;
  String? person_id;
  String? personage_id;
  String? classroom_fk;
  String? fk_id;
  String? source;
  String? personId;
  String? personageId;
  String? classroomFk;
  String? fkId;

  Actor({this.id, this.person_id, this.personage_id, this.classroom_fk, this.fk_id, this.source, this.personId, this.personageId, this.classroomFk, this.fkId});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      person_id: json['person_id'],
      personage_id: json['personage_id'],
      classroom_fk: json['classroom_fk'],
      fk_id: json['fk_id'],
      source: json['source'],
      personId: json['personId'],
      personageId: json['personageId'],
      classroomFk: json['classroomFk'],
      fkId: json['fkId'],
    );
  }
}

class Personage {
  String? id;
  String? name;

  Personage({this.id, this.name});

  factory Personage.fromJson(Map<String, dynamic> json) {
    return Personage(id: json['id'], name: json['name']);
  }
}
