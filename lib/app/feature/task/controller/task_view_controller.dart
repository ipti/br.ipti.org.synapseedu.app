import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/domain/entity/ddrop_option_entity.dart';
import 'package:elesson/app/core/task/domain/entity/screen_entity.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/feature/task/widgets/audio_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_sender.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_sender_undo.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_target.dart';
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

  ValueNotifier<List<DdropOptionEntity>> ddropOptions = ValueNotifier([DdropOptionEntity(), DdropOptionEntity(), DdropOptionEntity()]);

  void addDdropOptions(int position, DdropOptionEntity options) {
    ddropOptions.value[position] = options;
    ddropOptions.notifyListeners();
  }

  void removeDdropOptions(DdropOptionEntity optionEntity) {
    int index = ddropOptions.value.indexOf(optionEntity);
    ddropOptions.value[index] = DdropOptionEntity();
    ddropOptions.notifyListeners();
  }

  void resetSubmitStatusButton() {
    _submitButtonStatus = SubmitButtonStatus.Idle;
    ddropOptions.notifyListeners();
  }

  void renderTaskJson(TaskModel taskToRender) {
    taskToRender.header!.components.sort((a, b) => a.position!.compareTo(b.position!));
    taskToRender.header!.components.forEach((ComponentModel component) {
      renderComponent(componentModel: component, widgetsList: screenEntity.headerWidgets);
    });

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

    late Widget activityBody;

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
        subTitulo = Center(
          child: TextMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase),
        );

        activityBody = Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color.fromRGBO(189, 0, 255, 0.2),
                width: 2,
              ),
            ),
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              maxLines: 10,
              minLines: 6,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              // controller: _textController,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF0000FF), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Mulish'),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Digite a resposta aqui',
                contentPadding: const EdgeInsets.all(8.0),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(25.7)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(25.7)),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Não se esqueça de digitar a resposta!';
                }
                return null;
              },
            ),
          ),
        );
        break;
      case TemplateTypes.AEL:
        activityBody = Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DdropSender(element: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase, taskController: this),
                    DdropSender(element: taskModel.body!.components[1].elements!.first, getMultimediaUseCase: getMultimediaUseCase, taskController: this),
                    DdropSender(element: taskModel.body!.components[2].elements!.first, getMultimediaUseCase: getMultimediaUseCase, taskController: this),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DdropTarget(element: taskModel.body!.components[3].elements!.first, getMultimediaUseCase: getMultimediaUseCase, taskController: this, position: 0),
                    DdropTarget(element: taskModel.body!.components[4].elements!.first, getMultimediaUseCase: getMultimediaUseCase, taskController: this, position: 1),
                    DdropTarget(element: taskModel.body!.components[5].elements!.first, getMultimediaUseCase: getMultimediaUseCase, taskController: this, position: 2),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
      case TemplateTypes.TEXT:
        activityBody = Center(
          child: TextMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase),
        );
        break;
      default:
        activityBody = Center(
          child: Text("Ocorreu um erro ao renderizar atividade!"),
        );
        break;
    }

    screenEntity.bodyWidget = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subTitulo,
            Divider(),
          ],
        ),
        activityBody,
      ],
    );
  }
}
