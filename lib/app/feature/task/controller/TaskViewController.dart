import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/domain/entity/screen_entity.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/feature/task/widgets/audio_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/image_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/text_multimedia.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:elesson/app/util/enums/multimedia_types.dart';
import 'package:elesson/app/util/enums/task_types.dart';
import 'package:flutter/material.dart';

class TaskViewController extends ChangeNotifier {
  final GetMultimediaUseCase getMultimediaUseCase;

  TaskViewController({required this.getMultimediaUseCase});

  SubmitButtonStatus _submitButtonStatus = SubmitButtonStatus.Idle;

  SubmitButtonStatus get buttonStatus => _submitButtonStatus;

  final TextEditingController taskIdController = TextEditingController();

  ScreenEntity screenEntity = ScreenEntity(bodyWidget: Container(), headerWidgets: []);

  void resetSubmitStatusButton() {
    _submitButtonStatus = SubmitButtonStatus.Idle;
    notifyListeners();
  }

  void renderTaskJson(TaskModel taskToRender) {
    taskToRender.header!.components.sort((a, b) => a.position!.compareTo(b.position!));
    taskToRender.header!.components.forEach((ComponentModel component) {
      renderComponent(componentModel: component, widgetsList: screenEntity.headerWidgets);
    });

    // taskToRender.body!.components.sort((a, b) => a.position!.compareTo(b.position!));
    renderTemplateBodyTask(taskToRender);
  }

  void renderComponent({required ComponentModel componentModel, required List<Widget> widgetsList}) {
    componentModel.elements!.sort((a, b) => a.position!.compareTo(b.position!));

    componentModel.elements!.forEach((ElementModel element) {
      print(element.toMap());
      widgetsList.addAll([...buildWidgetFromElement(componentModel, element)]);
    });
  }

  List<Widget> buildWidgetFromElement(ComponentModel componentModel, ElementModel element) {
    switch (element.type_id) {
      case 1:
        if (componentModel.elements!.length == 1) {
          element.mainElement = true;
          return [TextMultimedia(elementModel: element, getMultimediaUseCase: getMultimediaUseCase)];
        }
        return [];
      case 2:
        print("AAAAAAAAAAAAAAAAAA: ");
        // element.mainElement = true;
        if (componentModel.elements!.any((element) => element.type_id == MultimediaTypes.text.type_id)) {
          return [
            TextMultimedia(
                elementModel: componentModel.elements!.singleWhere((element) => element.type_id == MultimediaTypes.text.type_id), getMultimediaUseCase: getMultimediaUseCase),
            ImageMultimedia(elementModel: element, getMultimediaUseCase: getMultimediaUseCase),
          ];
        }
        return [ImageMultimedia(elementModel: element, getMultimediaUseCase: getMultimediaUseCase)];
      case 3:
        bool onlyAudioElement = componentModel.elements!.length == 1;
        if (onlyAudioElement) {
          element.mainElement = true;
          return [AudioMultimedia(elementModel: element, getMultimediaUseCase: getMultimediaUseCase)];
        }
        return [];
      default:
        return [];
    }
  }

  void renderTemplateBodyTask(TaskModel taskModel) {
    taskModel.body!.components.forEach((component) => component.elements!.first.mainElement = true);
    TemplateTypes templateType = TemplateTypes.values[taskModel.template_id! - 1];

    Widget subTitulo = taskModel.header!.components.last.elements!.last.type_id == MultimediaTypes.text.type_id
        ? TextMultimedia(elementModel: taskModel.header!.components.last.elements!.last, getMultimediaUseCase: getMultimediaUseCase)
        : Container();
    Widget activityBody = Container();

    switch (templateType) {
      case TemplateTypes.MTE:
        activityBody = Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // alignment: WrapAlignment.center,
            children: [
              ImageMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
              ImageMultimedia(elementModel: taskModel.body!.components[1].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
              ImageMultimedia(elementModel: taskModel.body!.components[2].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
            ],
          ),
        );
        break;
      case TemplateTypes.PRE:
        activityBody = Center(
          child: TextMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase),
        );
        break;
      case TemplateTypes.AEL: // AEL
        activityBody = Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ImageMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                  ImageMultimedia(elementModel: taskModel.body!.components[1].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                  ImageMultimedia(elementModel: taskModel.body!.components[2].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                ],
              ),
              SizedBox(height: 100),
              Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ImageMultimedia(elementModel: taskModel.body!.components[3].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                ImageMultimedia(elementModel: taskModel.body!.components[4].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
                ImageMultimedia(elementModel: taskModel.body!.components[5].elements!.first, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true),
              ]),
            ],
          ),
        );
        break;
      case TemplateTypes.TEXT:
        activityBody = Center(
          child: TextMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase),
        );
        break;
      default:
        break;
    }

    screenEntity.bodyWidget = Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        subTitulo,
        activityBody,
      ],
    );
  }
}
