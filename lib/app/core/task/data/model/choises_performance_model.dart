class ChoisesModel {
  final int body_component_id_top;
  final int body_component_id_down;
  final bool is_correct;
  final int time_resolution;

  ChoisesModel({
    required this.body_component_id_top,
    required this.body_component_id_down,
    required this.is_correct,
    required this.time_resolution,
  });

  factory ChoisesModel.fromJson(Map<String, dynamic> json) => ChoisesModel(
        body_component_id_top: json['body_component_id_top'],
        body_component_id_down: json['body_component_id_down'],
        is_correct: json['is_correct'],
        time_resolution: json['time_resolution'],
      );

  Map<String, dynamic> toJson() => {
        "body_component_id_top": body_component_id_top,
        "body_component_id_down": body_component_id_down,
        "is_correct": is_correct,
        "time_resolution": time_resolution,
      };
}