import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/domain/entity/screen_entity.dart';
import 'package:elesson/app/feature/task/widgets/audio_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/image_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/text_multimedia.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:elesson/app/util/enums/multimedia_types.dart';
import 'package:flutter/material.dart';

class TaskViewController extends ChangeNotifier {
  SubmitButtonStatus _submitButtonStatus = SubmitButtonStatus.Idle;

  SubmitButtonStatus get buttonStatus => _submitButtonStatus;

  final TextEditingController taskIdController = TextEditingController();

  ScreenEntity screenEntity = ScreenEntity(bodyWidgets: [], headerWidgets: []);

  void resetSubmitStatusButton() {
    _submitButtonStatus = SubmitButtonStatus.Idle;
    notifyListeners();
  }

  void renderTaskJson(TaskModel taskToRender) {
    taskToRender.header!.components.sort((a, b) => a.position!.compareTo(b.position!));
    taskToRender.header!.components.forEach((ComponentModel component) {
      renderComponent(componentModel: component, widgetsList: screenEntity.headerWidgets);
    });

    taskToRender.body!.components.sort((a, b) => a.position!.compareTo(b.position!));
    // renderTemplateBodyTask(taskToRender);
  }

  void renderComponent({required ComponentModel componentModel, required List<Widget> widgetsList}) {
    componentModel.elements!.sort((a, b) => a.position!.compareTo(b.position!));

    componentModel.elements!.forEach((ElementModel element) {
      widgetsList.addAll([...buildWidgetFromElement(componentModel, element)]);
    });
  }

  List<Widget> buildWidgetFromElement(ComponentModel componentModel, ElementModel element) {
    switch (element.type_id) {
      case 1:
        if (componentModel.elements!.length == 1) {
          element.mainElement = true;
          return [TextMultimedia(elementModel: element,), SizedBox(height: 20)];
        }
        return [];
      case 2:
        bool existText = componentModel.elements!.any((element) => element.type_id == MultimediaTypes.text.type_id);
        element.mainElement = true;
        if (existText) {
          return [
            TextMultimedia(elementModel: componentModel.elements!.singleWhere((element) => element.type_id == MultimediaTypes.text.type_id)),
            SizedBox(height: 20),
            ImageMultimedia(elementModel: element),
            SizedBox(height: 20)
          ];
        }
        ElementModel textElement = ElementModel(type_id: MultimediaTypes.text.type_id, position: 1, description: "Elemento de Texto");
        return [TextMultimedia(elementModel: textElement), SizedBox(height: 20), ImageMultimedia(elementModel: element), SizedBox(height: 20)];
      case 3:
        bool onlyAudioElement = componentModel.elements!.length == 1;
        if (onlyAudioElement) {
          element.mainElement = true;
          return [AudioMultimedia(elementModel: element), SizedBox(height: 20)];
        }
        return [];
      default:
        return [];
    }
  }
}
