import 'package:equatable/equatable.dart';
import 'container_model.dart';

class TaskModel extends Equatable{
  int? id;
  String? description;
  int? year_id;
  int? year_year;
  String? year_name;
  int? goal_id;
  String? goal_name;
  int? discipline_id;
  String? discipline_name;
  int? template_id;
  String? template_name;
  String? template_alias;
  int? theme_id;
  String? theme_name;
  int? head_id;
  int? body_id;
  int? status_id;
  DateTime? create_at = DateTime.now();
  DateTime? update_at;
  int? published;
  DateTime? published_date;
  int? user_id;
  String? user_name;
  int? total_comments;
  int? total_resolved_comments;
  int? block_id;
  ContainerModel? header;
  ContainerModel? body;

  TaskModel({
    this.id,
    this.description,
    this.year_id,
    this.year_year,
    this.year_name,
    this.goal_id,
    this.discipline_id,
    this.discipline_name,
    this.goal_name,
    this.template_id,
    this.template_name,
    this.template_alias,
    this.theme_id = 1,
    this.theme_name,
    this.head_id,
    this.body_id,
    this.status_id,
    this.create_at,
    this.update_at,
    this.total_comments,
    this.total_resolved_comments,
    this.published = 0,
    this.published_date,
    this.user_id,
    this.user_name,
    this.block_id,
    this.header,
    this.body,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        description: json['description'],
        year_id: json['year_id'],
        year_year: json['year_year'],
        year_name: json['year_name'],
        goal_id: json['goal_id'],
        goal_name: json['goal_name'],
        discipline_id: json['discipline_id'],
        discipline_name: json['discipline_name'],
        template_id: json['template_id'] ?? 1,
        template_name: json['template_name'],
        template_alias: json['template_alias'],
        theme_id: json['theme_id']  ?? 1,
        theme_name: json['theme_name'],
        head_id: json['head_id'],
        body_id: json['body_id'],
        status_id: json['status_id'],
        create_at: json['create_at'] != null ? DateTime.parse(json['create_at']) : DateTime.now(),
        update_at: json['update_at'] != null ? DateTime.parse(json['update_at']) : null,
        total_comments: json['total_comments'] ?? 0,
        total_resolved_comments: json['total_resolved_comments'] ?? 0,
        published: json['published'] ?? 0,
        published_date: json['published_date'] != null ? DateTime.parse(json['published_date']) : null,
        user_id: json['user_id'],
        user_name: json['user_name'],
        block_id: json['block_id'],
        header: json['header'] != null ? ContainerModel.fromMap(json['header']) : ContainerModel(components: []),
        body: json['body'] != null ? ContainerModel.fromMap(json['body']) : ContainerModel(components: []),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "year_id": year_id,
        "year_year": year_year,
        "year_name": year_name,
        "goal_id": goal_id,
        "goal_name": goal_name,
        "discipline_id": discipline_id,
        "discipline_name": discipline_name,
        "template_id": template_id,
        "template_name": template_name,
        "template_alias": template_alias,
        "theme_id": theme_id,
        "theme_name": theme_name,
        "head_id": head_id,
        "body_id": body_id,
        "status_id": status_id,
        "create_at": create_at?.toIso8601String(),
        "update_at": update_at!= null ? update_at!.toIso8601String() : null,
        "total_comments": total_comments,
        "total_resolved_comments": total_resolved_comments,
        "published": published,
        "published_date": published_date,
        "user_id": user_id,
        "user_name": user_name,
        "block_id": block_id,
        "header": header?.toMap(),
        "body": body?.toMap()
      };

  //empty
  static TaskModel empty() => TaskModel(
        id: 0,
        description: '',
        year_id: 0,
        year_year: 0,
        year_name: '',
        goal_id: 0,
        goal_name: '',
        discipline_id: 0,
        discipline_name: '',
        template_id: 0,
        template_name: '',
        template_alias: '',
        theme_id: 0,
        theme_name: '',
        head_id: 0,
        body_id: 0,
        status_id: 0,
        create_at: DateTime.now(),
        update_at: null,
        total_comments: 0,
        total_resolved_comments: 0,
        published: 0,
        published_date: null,
        user_id: 0,
        user_name: '',
        block_id: 0,
        header: ContainerModel.empty(),
        body: ContainerModel.empty(),
      );

  TaskModel copyWith({
    int? id,
    String? description,
    int? year_id,
    int? year_year,
    String? year_name,
    int? goal_id,
    String? goal_name,
    int? discipline_id,
    String? discipline_name,
    int? template_id,
    String? template_name,
    String? template_alias,
    int? theme_id,
    String? theme_name,
    int? head_id,
    int? body_id,
    int? status_id,
    DateTime? create_at,
    DateTime? update_at,
    int? published,
    DateTime? published_date,
    int? user_id,
    String? user_name,
    int? block_id,
    ContainerModel? header,
    ContainerModel? body,
  }) =>
      TaskModel(
        id: id ?? this.id,
        description: description ?? this.description,
        year_id: year_id ?? this.year_id,
        year_year: year_year ?? this.year_year,
        year_name: year_name ?? this.year_name,
        goal_id: goal_id ?? this.goal_id,
        goal_name: goal_name ?? this.goal_name,
        discipline_id: discipline_id ?? this.discipline_id,
        discipline_name: discipline_name ?? this.discipline_name,
        template_id: template_id ?? this.template_id,
        template_name: template_name ?? this.template_name,
        template_alias: template_alias ?? this.template_alias,
        theme_id: theme_id ?? this.theme_id,
        theme_name: theme_name ?? this.theme_name,
        head_id: head_id ?? this.head_id,
        body_id: body_id ?? this.body_id,
        status_id: status_id ?? this.status_id,
        create_at: create_at ?? this.create_at,
        update_at: update_at ?? this.update_at,
        published: published ?? this.published,
        published_date: published_date ?? this.published_date,
        user_id: user_id ?? this.user_id,
        user_name: user_name ?? this.user_name,
        block_id: block_id ?? this.block_id,
        header: header ?? this.header,
        body: body ?? this.body,
      );

  @override
  List<Object?> get props => [
        id,
        description,
        year_id,
        year_year,
        year_name,
        goal_id,
        goal_name,
        discipline_id,
        discipline_name,
        template_id,
        template_name,
        template_alias,
        theme_id,
        theme_name,
        head_id,
        body_id,
        status_id,
        // create_at,
        update_at,
        total_comments,
        total_resolved_comments,
        published,
        published_date,
        // user_id,
        // user_name,
        header,
        body,
      ];
}
