import 'package:equatable/equatable.dart';

class UserModel extends Equatable{
  int? id;
  String? name;
  String? user_name;
  int? user_type_id;

  UserModel({
    this.id,
    this.name = 'Nome do usuário',
    this.user_name,
    this.user_type_id = 3,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        user_name: json["user_name"],
        user_type_id: json["user_type_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_name": user_name,
        "user_type_id": user_type_id,
      };

  Map<String, dynamic> toJsonUpdate() => {
        "id": id,
        "name": name,
        "user_name": user_name,
        "user_type_id": user_type_id,
      };

  Map<String, dynamic> toJsonAdd() => {
        "name": name,
        "user_name": user_name,
        "user_type_id": user_type_id,
      };

  //empty
  factory UserModel.empty() => UserModel(
        id: 0,
        name: 'Aluno(a)',
        user_name: 'Nome do usuário',
        user_type_id: 0,
      );

  @override
  List<Object?> get props => [id, name, user_name, user_type_id];
}
