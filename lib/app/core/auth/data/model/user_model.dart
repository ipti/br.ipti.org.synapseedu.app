class UserModel {
  int? id;
  String? name;
  String? user_name;
  String? password;
  int? user_type_id;

  UserModel({
    this.id,
    this.name = 'Nome do usuário',
    this.password,
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
        "password": password,
        "user_type_id": user_type_id,
      };

  Map<String, dynamic> toJsonAdd() => {
        "name": name,
        "user_name": user_name,
        "password": password,
        "user_type_id": user_type_id,
      };
}
