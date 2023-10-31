import 'package:elesson/app/core/task/data/model/choises_performance_model.dart';
import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/util/enums/task_types.dart';

import '../../domain/entity/ddrop_option_entity.dart';
import '../../domain/entity/user_answer.dart';
import 'container_model.dart';

abstract class MetaDataModel {
  final String template_type;
  final int body_component_id;

  MetaDataModel({required this.template_type, required this.body_component_id});

  factory MetaDataModel.generate({required TaskModel task, required UserAnswer userAnswer}) {
    String templateAbbreviations = TemplateTypes.values.firstWhere((element) => element.templateId == task.template_id).name;
    switch (task.template_id) {
      case 1:
        return MetaDataModelMTE(
          template_type: templateAbbreviations,
          body_component_id: userAnswer.AnswerMte.id!,
        );
      case 2:
        return MetaDataModelPRE(
          template_type: templateAbbreviations,
          body_component_id: task.body!.components.first.id!,
          text: userAnswer.AnswerPre,
        );
      case 3:
        return MetaDataModelAEL(
          template_type: templateAbbreviations,
          componentModel: task.body!,
          userChoises: userAnswer.answerDdrop,
        );
      case 5:
        return MetaDataModelMTE(
          template_type: templateAbbreviations,
          body_component_id: userAnswer.AnswerMte.id!,
        );
      case 6:
        return MetaDataModelMTE(
          template_type: templateAbbreviations,
          body_component_id: userAnswer.AnswerMte.id!,
        );
      default:
        print("Não localizado");
        return MetaDataModelMTE(
          template_type: "",
          body_component_id: 0,
        );
    }
  }

  factory MetaDataModel.empty() {
    return MetaDataModelMTE(template_type: "", body_component_id: 0);
  }

  //toJson()
  Map<String, dynamic> toJson() => {"erro": "Não implementado"};
}

class MetaDataModelMTE extends MetaDataModel {
  MetaDataModelMTE({required super.template_type, required super.body_component_id});

  Map<String, dynamic> toJson() => {
        "template_type": template_type,
        "body_component_id": body_component_id,
      };
}

class MetaDataModelPRE extends MetaDataModel {
  final String text;

  MetaDataModelPRE({required this.text, required super.template_type, required super.body_component_id});

  Map<String, dynamic> toJson() => {
        "template_type": template_type,
        "body_component_id": body_component_id,
        "text": text,
      };
}

class MetaDataModelAEL extends MetaDataModel {
  final ContainerModel componentModel;
  final List<DdropOptionEntity> userChoises;
  bool performanceStatus = true;
  late List<int> _correctAnswers;
  List<ChoisesModel> _choisesList = [];

  MetaDataModelAEL({required this.componentModel, required this.userChoises, required super.template_type}) : super(body_component_id: 0) {
    _correctAnswers = componentModel.components.sublist(0, 3).map((e) => e.id!).toList();
    for (int i = 0; i < _correctAnswers.length; i++) {
      List<ComponentModel> listComponentsFixed = componentModel.components.sublist(3, 6);
      bool isCorrect = _correctAnswers[i] == this.userChoises[i].component_id;
      _choisesList.add(
        ChoisesModel(
          body_component_id_top: userChoises[i].component_id,
          body_component_id_down: listComponentsFixed[i].id!,
          is_correct: isCorrect,
          time_resolution: userChoises[i].time,
        ),
      );

      if (isCorrect == false) performanceStatus = false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "template_type": template_type,
      "choices": _choisesList.map((e) => e.toJson()).toList(),
    };
  }
}
