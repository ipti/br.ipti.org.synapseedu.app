class BreakPointModel{
  int last_resolved_task_id;
  DateTime created_at;

  BreakPointModel({required this.last_resolved_task_id, required this.created_at});

  factory BreakPointModel.fromJson(Map<String, dynamic> json) {
    return BreakPointModel(
      last_resolved_task_id: json['last_resolved_task_id'],
      created_at: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "last_resolved_task_id": last_resolved_task_id,
      "created_at": created_at.toString(),
    };
  }
}