class BlockValues{
  int id;
  String name;

  BlockValues({required this.id, required this.name});

  factory BlockValues.fromJson(Map<String, dynamic> json) {
    return BlockValues(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  static BlockValues empty() {
    return BlockValues(
      id: 0,
      name: "",
    );
  }
}

