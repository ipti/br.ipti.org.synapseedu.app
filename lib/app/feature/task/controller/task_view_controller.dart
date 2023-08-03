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
import 'package:elesson/app/feature/task/widgets/text_modal_invible.dart';
import 'package:elesson/app/feature/task/widgets/text_multimedia.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:elesson/app/util/enums/multimedia_types.dart';
import 'package:elesson/app/util/enums/task_types.dart';
import 'package:elesson/app/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wakelock/wakelock.dart';

class TaskViewController extends ChangeNotifier {
  final GetMultimediaUseCase getMultimediaUseCase;

  TaskViewController({required this.getMultimediaUseCase});

  /*
  * STATUS DO BOTÃO DE SUBMISSÃO
  * */
  SubmitButtonStatus _submitButtonStatus = SubmitButtonStatus.Disabled;

  SubmitButtonStatus get buttonStatus => _submitButtonStatus;

  /*
  * ENTIDADE RESPONSAVEL POR ARMAZENAR OS WIDGETS DA TELA
  * */
  ScreenEntity screenEntity = ScreenEntity(bodyWidget: Container(), headerWidgets: []);

  /*
  * DDROP
  * */
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

  void validationDdrop() {
    bool haveEmpty = ddropOptions.value.any((element) => element == DdropOptionEntity());
    if (!haveEmpty) {
      _submitButtonStatus = SubmitButtonStatus.Idle;
      notifyListeners();
    } else if (haveEmpty && _submitButtonStatus == SubmitButtonStatus.Idle) {
      _submitButtonStatus = SubmitButtonStatus.Disabled;
      notifyListeners();
    }
  }

  /*
  * PRE
  * */
  TextEditingController preController = TextEditingController();

  void validationPre() {
    bool isValid = preController.text.isNotEmpty;
    if (isValid) {
      _submitButtonStatus = SubmitButtonStatus.Idle;
      notifyListeners();
    } else if (!isValid && _submitButtonStatus == SubmitButtonStatus.Idle) {
      _submitButtonStatus = SubmitButtonStatus.Disabled;
      notifyListeners();
    }
  }

  Future<void> readTextOfImage() async {
    final res = await getMultimediaUseCase.readTextOfImage();
    res.fold((l) => null, (r) => preController.text = r);
    notifyListeners();
    validationPre();
  }

  /*
  * MTE
  * */
  ValueNotifier<ComponentModel> componentSelected = ValueNotifier(ComponentModel());

  void changeComponentSelected(ComponentModel componentModel) {
    if (componentSelected.value == componentModel) {
      componentSelected.value = ComponentModel();
      componentSelected.notifyListeners();
      _submitButtonStatus = SubmitButtonStatus.Disabled;
      notifyListeners();
      return;
    }
    componentSelected.value = componentModel;
    _submitButtonStatus = SubmitButtonStatus.Idle;
    componentSelected.notifyListeners();
    notifyListeners();
  }

  /*
  * RENDEREIZAÇÃO DOS TEMPLATES
  * */
  void renderTaskJson(TaskModel taskToRender) {
    taskToRender.header!.components.sort((a, b) => a.position!.compareTo(b.position!));
    taskToRender.header!.components.forEach((ComponentModel component) {
      renderHeaderComponent(componentModel: component, widgetsList: screenEntity.headerWidgets);
    });
    if (screenEntity.headerWidgets.length == 2) {
      screenEntity.headerWidgets.insert(2, TextModalInvisible());
    }
    renderTemplateBodyTask(taskToRender);
  }

  void renderHeaderComponent({required ComponentModel componentModel, required List<Widget> widgetsList}) {
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
          return [TextMultimedia(elementModel: element, getMultimediaUseCase: getMultimediaUseCase)];
        }
        return [];
      case 2:
        // element.mainElement = true;
        if (componentModel.elements!.any((element) => element.type_id == MultimediaTypes.text.type_id)) {
          return [
            TextMultimedia(
                elementModel: componentModel.elements!.singleWhere((element) => element.type_id == MultimediaTypes.text.type_id), getMultimediaUseCase: getMultimediaUseCase),
            ImageMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase),
          ];
        }
        return [ImageMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase)];
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
    taskModel.body!.components.sort((a, b) => a.position!.compareTo(b.position!));
    taskModel.body!.components.forEach((component) => component.elements!.first.mainElement = true);
    TemplateTypes templateType = TemplateTypes.values[taskModel.template_id! - 1];

    Widget subTitulo = taskModel.header!.components.last.elements!.last.type_id == MultimediaTypes.text.type_id
        ? TextMultimedia(elementModel: taskModel.header!.components.last.elements!.last, getMultimediaUseCase: getMultimediaUseCase)
        : TextModalInvisible();

    late Widget activityBody;

    switch (templateType) {
      case TemplateTypes.MTE:
        activityBody = Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageMultimedia(componentModel: taskModel.body!.components[0], getMultimediaUseCase: getMultimediaUseCase, bodyElement: true, taskViewController: this),
                ImageMultimedia(componentModel: taskModel.body!.components[1], getMultimediaUseCase: getMultimediaUseCase, bodyElement: true, taskViewController: this),
                ImageMultimedia(componentModel: taskModel.body!.components[2], getMultimediaUseCase: getMultimediaUseCase, bodyElement: true, taskViewController: this),
              ],
            ),
          ),
        );
        break;
      case TemplateTypes.PRE:
        preController.addListener(() => validationPre());
        subTitulo = TextMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase);
        activityBody = Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
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
                  controller: preController,
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
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  Wakelock.enable();
                  showDialog(
                    context: navigatorKey.currentContext!,
                    builder: (context) => AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10))],
                                ),
                                child: Center(
                                  child: SpinKitCubeGrid(
                                    color: Colors.indigoAccent,
                                    size: 50,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                  await readTextOfImage().whenComplete(() => Navigator.of(navigatorKey.currentContext!).pop());
                  Wakelock.disable();
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(0, 0, 255, 1)),
                    color: Color.fromRGBO(0, 0, 255, 1),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Icon(
                    Icons.camera,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case TemplateTypes.AEL:
        ddropOptions.addListener(() => validationDdrop());
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
        _submitButtonStatus = SubmitButtonStatus.Success;
        activityBody = Expanded(
          flex: 1,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextMultimedia(
                  elementModel: taskModel.body!.components[0].elements!.first,
                  getMultimediaUseCase: getMultimediaUseCase,
                  disableMaxHeight: true,
                ),
              ),
            ),
          ),
        );
        break;
      default:
        activityBody = Center(
          child: Text("Ocorreu um erro ao renderizar atividade!"),
        );
        break;
    }

    screenEntity.bodyWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        subTitulo,
        Divider(
          height: 0,
          thickness: 1,
          color: Colors.grey.withOpacity(0.2),
        ),
        activityBody,
      ],
    );
  }
}
