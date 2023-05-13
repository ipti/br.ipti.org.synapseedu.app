class LoginResponseEntity{
  int id;
  String name;
  String user_name;
  int user_type_id;

  LoginResponseEntity({
    required this.id,
    required this.name,
    required this.user_name,
    required this.user_type_id,
  });

  factory LoginResponseEntity.fromMap(Map<String, dynamic> map) {
    return LoginResponseEntity(
      id:  map['id'] ?? 0,
      name: map['name'] ?? "Nome não encontrado",
      user_name: map['user_name'] ?? "Nome não encontrado",
      user_type_id: map['user_type_id'] ?? 0,
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
}