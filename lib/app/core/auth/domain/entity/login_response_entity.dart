import 'package:elesson/app/core/auth/domain/entity/login_entity.dart';
import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable{
  int id;
  String name;
  String user_name;
  int user_type_id;
  LoginEntity? loginEntity = LoginEntity.empty();

  LoginResponseEntity({
    required this.id,
    required this.name,
    required this.user_name,
    required this.user_type_id,
    this.loginEntity
  });

  factory LoginResponseEntity.fromMap(Map<String, dynamic> map) {
    return LoginResponseEntity(
      id:  map['id'] ?? 0,
      name: map['name'] ?? "Nome não encontrado",
      user_name: map['user_name'] ?? "Nome não encontrado",
      user_type_id: map['user_type_id'] ?? 0,
      loginEntity: map['login_entity'] ?? LoginEntity.empty(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_name': user_name,
      'user_type_id': user_type_id,
    };
  }

  //empty
  factory LoginResponseEntity.empty() => LoginResponseEntity(
    id: 0,
    name: "",
    user_name: "",
    user_type_id: 0,
  );

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, user_name, user_type_id];
}