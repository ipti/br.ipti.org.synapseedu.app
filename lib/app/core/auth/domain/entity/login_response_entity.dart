import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable{
  int id;
  String name;
  String user_name;
  int user_type_id;
  int? teacher_id;

  LoginResponseEntity({
    required this.id,
    required this.name,
    required this.user_name,
    required this.user_type_id,
    this.teacher_id,
  });

  factory LoginResponseEntity.fromMap(Map<String, dynamic> map) {
    return LoginResponseEntity(
      id:  map['id'] ?? 0,
      name: map['name'] ?? "Nome não encontrado",
      user_name: map['user_name'] ?? "Nome não encontrado",
      user_type_id: map['user_type_id'] ?? 0,
      teacher_id: map['teacher_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_name': user_name,
      'user_type_id': user_type_id,
      'teacher_id': teacher_id,
    };
  }

  factory LoginResponseEntity.empty() => LoginResponseEntity(
    id: 0,
    name: "",
    user_name: "",
    user_type_id: 0,
    teacher_id: null,
  );

  @override
  List<Object?> get props => [id, name, user_name, user_type_id, teacher_id];
}