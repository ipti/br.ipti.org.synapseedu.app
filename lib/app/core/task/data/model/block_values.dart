class BlockValues{
  int id;
  String nome;

  BlockValues({required this.id, required this.nome});

  factory BlockValues.fromJson(Map<String, dynamic> json) {
    return BlockValues(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nome": nome,
    };
  }

  static BlockValues empty() {
    return BlockValues(
      id: 0,
      nome: "",
    );
  }
}