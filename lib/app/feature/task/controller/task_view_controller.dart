import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/model/component_model.dart';
import 'package:elesson/app/core/task/data/model/element_model.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/domain/entity/ddrop_option_entity.dart';
import 'package:elesson/app/core/task/domain/entity/screen_entity.dart';
import 'package:elesson/app/core/task/domain/usecase/Multimedia_usecase.dart';
import 'package:elesson/app/feature/task/widgets/audio_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_sender.dart';
import 'package:elesson/app/feature/task/widgets/ddrop/ddrop_target.dart';
import 'package:elesson/app/feature/task/widgets/image_multimedia.dart';
import 'package:elesson/app/feature/task/widgets/text_modal_invible.dart';
import 'package:elesson/app/feature/task/widgets/text_multimedia.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:elesson/app/util/enums/multimedia_types.dart';
import 'package:elesson/app/util/enums/sound_status.dart';
import 'package:elesson/app/util/enums/task_types.dart';
import 'package:elesson/app/util/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundpool/soundpool.dart';
import 'package:wakelock/wakelock.dart';
import '../../../core/task/data/model/my_bytes_source.dart';
import '../../../core/task/domain/entity/user_answer.dart';
import '../../../core/task/domain/usecase/send_performance_usecase.dart';
import '../../../util/failures/failures.dart';

class TaskViewController extends ChangeNotifier {
  final MultimediaUseCase getMultimediaUseCase;
  final SendPerformanceUseCase sendPerformanceUseCase;
  final TaskModel task;
  final int userId;
  AudioPlayer audioPlayer;
  Soundpool soundpool;

  bool isDownloadingAudio = false;

  TaskViewController({required this.getMultimediaUseCase, required this.sendPerformanceUseCase, required this.task, required this.userId, required this.audioPlayer, required this.soundpool}) {
    soundIdByMultimediaId = [];
  }

  SoundStatusEnum soundStatus = SoundStatusEnum.Idle;
  late DateTime performanceTime;
  late ComponentModel correctAnswer;

  List<Map<int, MyBytesSource>> soundIdByMultimediaId = [];

  /*
  * STATUS DO BOTÃO DE SUBMISSÃO
  * */
  SubmitButtonStatus _submitButtonStatus = SubmitButtonStatus.Disabled;

  SubmitButtonStatus get buttonStatus => _submitButtonStatus;

  int multimediaIdPlayingAudio = 0;

  //set
  set buttonStatus(SubmitButtonStatus value) {
    _submitButtonStatus = value;
    notifyListeners();
  }

  Future<void> sendPerformance(int blockid) async {
    task.block_id = blockid;
    Either<Failure, bool> res = await sendPerformanceUseCase.call(
      task: task,
      correctAnswerPre: correctAnswerPre,
      userAnswer: UserAnswer(
        AnswerMte: componentSelected,
        AnswerPre: preController.text,
        answerDdrop: ddropOptions.value,
        performanceTime: performanceTime,
        userId: userId,
      ),
    );
    res.fold(
      (l) => _submitButtonStatus = SubmitButtonStatus.Error,
      (r) => r ? _submitButtonStatus = SubmitButtonStatus.Success : _submitButtonStatus = SubmitButtonStatus.Error,
    );
    notifyListeners();
  }

  /*
  * ENTIDADE RESPONSAVEL POR ARMAZENAR OS WIDGETS DA TELA
  * */
  ScreenEntity screenEntity = ScreenEntity(bodyWidget: Container(), headerWidgets: []);

  /*
  * DDROP
  * */
  ValueNotifier<List<DdropOptionEntity>> ddropOptions = ValueNotifier([DdropOptionEntity(), DdropOptionEntity(), DdropOptionEntity()]);

  void addDdropOptions(int position, DdropOptionEntity options, DateTime time) {
    ddropOptions.value[position] = options;
    ddropOptions.value[position].time = DateTime.now().millisecondsSinceEpoch - performanceTime.millisecondsSinceEpoch;
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
  String correctAnswerPre = "";
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
  ComponentModel componentSelected = ComponentModel();

  void changeComponentSelected(ComponentModel componentModel) {
    if (componentSelected == componentModel) {
      componentSelected = ComponentModel();
      notifyListeners();
      _submitButtonStatus = SubmitButtonStatus.Disabled;
      notifyListeners();
      return;
    }
    componentSelected = componentModel;
    _submitButtonStatus = SubmitButtonStatus.Idle;
    notifyListeners();
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
    if (screenEntity.headerWidgets.length == 2 && screenEntity.headerWidgets.first.runtimeType == ImageMultimedia) {
      screenEntity.headerWidgets.insert(0, TextModalInvisible());
    } else if (screenEntity.headerWidgets.length == 2 && screenEntity.headerWidgets.last.runtimeType == ImageMultimedia) {
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
    ElementModel audioElement = componentModel.elements!.singleWhere((element) => element.type_id == MultimediaTypes.audio.type_id, orElse: () => ElementModel());
    int? audioMultimediaId = audioElement != ElementModel() ? audioElement.multimedia_id : null;

    switch (element.type_id) {
      case 1:
        element.mainElement = true;
        return [
          TextMultimedia(
            taskViewController: this,
            componentModel: componentModel,
            getMultimediaUseCase: getMultimediaUseCase,
            audioCallback: () => playSoundByMultimediaId(audioMultimediaId),
            audioMultimediaId: audioMultimediaId,
          )
        ];
      case 2:
        return [ImageMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase,bodyElement: false)];
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

  void getCorrectAnswerPre(ElementModel elementModel) async {
    await getMultimediaUseCase.getTextById(elementModel.multimedia_id!).then((value) => value.fold((l) => null, (r) {
          print("Lida resposta correta: ${r}");
          return this.correctAnswerPre = r;
        }));
  }

  void renderTemplateBodyTask(TaskModel taskModel) {
    taskModel.body!.components.sort((a, b) => a.position!.compareTo(b.position!));
    taskModel.body!.components.forEach((component) => component.elements!.first.mainElement = true);
    TemplateTypes templateType = TemplateTypes.values[taskModel.template_id! - 1];

    List<Widget> subTitulo = taskModel.header!.components.last.elements!.last.type_id == MultimediaTypes.text.type_id
        ? [
            // TextMultimedia(componentModel: taskModel.header!.components.last, getMultimediaUseCase: getMultimediaUseCase, taskViewController: this),
            Divider(height: 0, thickness: 1, color: Colors.grey.withOpacity(0.2))
          ]
        : [];

    late Widget activityBody;

    switch (templateType) {
      case TemplateTypes.MTE:
        List<Widget> childrenRandomed = taskModel.body!.components
            .map((componentModel) => componentModel.elements!.first.type_id == MultimediaTypes.text.type_id
                ? TextMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase, taskViewController: this, isMte: true)
                : ImageMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true, taskViewController: this))
            .toList();
        childrenRandomed.shuffle();
        activityBody = Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: childrenRandomed,
            ),
          ),
        );
        break;
      case TemplateTypes.MTE2:
        List<Widget> childrenRandomed = taskModel.body!.components
            .map((componentModel) => componentModel.elements!.first.type_id == MultimediaTypes.text.type_id
                ? TextMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase, taskViewController: this, isMte: true)
                : ImageMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase, bodyElement: true, taskViewController: this))
            .toList();
        childrenRandomed.shuffle();
        activityBody = Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: childrenRandomed,
            ),
          ),
        );
        break;
      case TemplateTypes.MTE4:
        bool isTextType = taskModel.body!.components.any((componentModel) => componentModel.elements!.first.type_id == MultimediaTypes.text.type_id);
        List<Widget> childrenRandomed = taskModel.body!.components
            .map(
              (componentModel) => isTextType
                  ? TextMultimedia(componentModel: componentModel, getMultimediaUseCase: getMultimediaUseCase, taskViewController: this, isMte: true)
                  : ImageMultimedia(
                      componentModel: componentModel,
                      getMultimediaUseCase: getMultimediaUseCase,
                      bodyElement: true,
                      taskViewController: this,
                      ismte4: true,
                    ),
            )
            .toList();
        childrenRandomed.shuffle();
        if (isTextType) {
          activityBody = Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: childrenRandomed,
              ),
            ),
          );
        } else {
          activityBody = Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: childrenRandomed.sublist(0, 2),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: childrenRandomed.sublist(2, 4),
                  ),
                ],
              ),
            ),
          );
        }

        break;
      case TemplateTypes.PRE:
        preController.addListener(() => validationPre());
        // subTitulo = TextMultimedia(elementModel: taskModel.body!.components[0].elements!.first, getMultimediaUseCase: getMultimediaUseCase);
        getCorrectAnswerPre(taskModel.body!.components[0].elements!.first);
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
                  style: TextStyle(color: Color(0xFF0000FF), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Comic'),
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
                                child: Center(child: SpinKitCubeGrid(color: Colors.indigoAccent, size: 50)),
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
                  child: Icon(Icons.camera, size: 40, color: Colors.white),
                ),
              ),
            ],
          ),
        );
        break;
      case TemplateTypes.AEL:
        int position = 0;
        List<Widget> childrenRandomed = taskModel.body!.components.sublist(3, 6).map((component) {
          position++;
          return DdropTarget(component: component, getMultimediaUseCase: getMultimediaUseCase, taskController: this, position: position - 1);
        }).toList();
        childrenRandomed.shuffle();

        ddropOptions.addListener(() => validationDdrop());
        activityBody = Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: taskModel.body!.components
                      .sublist(0, 3)
                      .map((component) => DdropSender(component: component, getMultimediaUseCase: getMultimediaUseCase, taskController: this))
                      .toList(),
                ),
                Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: childrenRandomed),
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
                  taskViewController: this,
                  componentModel: taskModel.body!.components[0],
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
        ...subTitulo,
        activityBody,
      ],
    );
  }

  // ==================================================================================================== SOUND
  AudioStreamControl? streamControl;

  Future playSoundByMultimediaId(int? multimediaId) async {

    if (multimediaId == null) return;
    if(audioPlayer.playing == true) {
      multimediaIdPlayingAudio = 0;
      audioPlayer.stop();
      return;
    }

    if (soundIdByMultimediaId.any((element) => element.containsKey(multimediaId))) {
      await playSound(multimediaId);
    } else {
      isDownloadingAudio = true;
      notifyListeners();
      Either<Failure, Uint8List> res = await getMultimediaUseCase.getSoundByMultimediaId(multimediaId);
      return res.fold((l) => null, (r) async {
        soundIdByMultimediaId.add({multimediaId: MyBytesSource(r)});
        await playSound(multimediaId);
      });
    }
  }

  Future<void> playSound(int multimediaId) async {
    multimediaIdPlayingAudio = multimediaId;
    await audioPlayer.setAudioSource(soundIdByMultimediaId.firstWhere((element) => element.containsKey(multimediaId)).values.last);
    await audioPlayer.play();
    multimediaIdPlayingAudio = 0;
    audioPlayer.stop();
    return;
  }

  void forceNotifyListener() {
    notifyListeners();
  }
}
