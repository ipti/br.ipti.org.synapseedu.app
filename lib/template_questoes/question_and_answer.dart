import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/model.dart';
import 'package:elesson/template_questoes/question_provider.dart';
import 'package:elesson/template_questoes/share/template_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_riverpod/all.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io' as io;

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

// ignore: must_be_immutable
class SingleLineTextQuestion extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  SingleLineTextQuestion({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  static const routeName = '/PRE';

  _SingleLineTextQuestionState createState() =>
      new _SingleLineTextQuestionState();
}

class _SingleLineTextQuestionState extends State<SingleLineTextQuestion> {
  // ignore: non_constant_identifier_names
  var cobjectList = new List<Cobject>();
  int questionIndex;
  int listQuestionIndex;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  // ignore: override_on_non_overriding_member
  void dispose() {
    _textController.dispose();
  }

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  void initState() {
    super.initState();
    _init();
  }

  void submitButton(BuildContext context) {
    // print(context.read(buttonStateProvider).state);
    context.read(buttonStateProvider).state = true;
  }

  bool hasPermission;
  _getPermission() async {
    hasPermission = await FlutterAudioRecorder.hasPermissions;
  }

  // // var recorder;
  // _initializeRecorder() async {
  //   recorder = FlutterAudioRecorder("file_path.wav"); // .wav .aac .m4a
  //   await recorder.initialized;
  // }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    _getPermission();
    // _initializeRecorder();

    // final path = _localPath;

    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    listQuestionIndex = args.listQuestionIndex;

    String questionDescription = cobjectList[0].description;
    String questionText =
        cobjectList[0].questions[questionIndex].header["text"];
    String pieceId = cobjectList[0].questions[questionIndex].pieceId;

    double widthScreen = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.93;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      body: TemplateSlider(
        title: Text(
          questionDescription.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        text: Text(
          questionText.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        sound: cobjectList[0].questions[questionIndex].header["sound"],
        linkImage: 'https://elesson.com.br/app/library/image/' +
            cobjectList[0].questions[0].header["image"],
        isPreTemplate: true,
        activityScreen: Form(
          key: _formKey,
          child: SingleChildScrollView(
            reverse: false,
            child: Wrap(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          right: 16, left: 16, top: screenHeight * 0.2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color.fromRGBO(189, 0, 255, 0.2),
                          width: 2,
                        ),
                      ),
                      height: screenHeight / 3,
                      child: Center(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          autocorrect: false,
                          maxLines: 1,
                          minLines: 1,
                          keyboardType: TextInputType.multiline,
                          controller: _textController,
                          autofocus: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Escreva a resposta aqui',
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          // Utiliza o onChanged em conjunto com o provider para renderizar a UI assim que o form
                          // receber um texto, acionando o botão. O condicional faz com que a UI seja renderizada
                          // apenas uma vez enquanto o texto estiver sendo digitado.
                          onChanged: (val) {
                            if (_textController.text.length == 1) {
                              submitButton(context);
                            }
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Não se esqueça de digitar a resposta!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                      //padding: EdgeInsets.only(left: 16, right: 16, bottom: 0),
                      margin: EdgeInsets.only(
                          bottom: _textController.text.isNotEmpty
                              ? (screenHeight * 0.93) -
                                  18 -
                                  (48 > screenHeight * 0.0656
                                      ? 48
                                      : screenHeight * 0.0656)
                              : screenHeight * 0.92),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 76, 0.1),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      height: screenHeight * 0.15,
                      width: widthScreen,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            playSound(cobjectList[0]
                                .questions[questionIndex]
                                .header["sound"]);
                          },
                          child: Text(
                            questionText.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fonteDaLetra,
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_currentStatus == RecordingStatus.Initialized) {
                          print("File path of the record: ${_current?.path}");
                          print("Format: ${_current?.audioFormat}");
                          print("começou");
                          _start();
                        }
                        if (_currentStatus == RecordingStatus.Recording) {
                          print("parou");
                          _stop();
                        }
                      },
                      // onLongPressStart: (details) {
                      //   if (_currentStatus == RecordingStatus.Initialized) {
                      //     print("File path of the record: ${_current?.path}");
                      //     print("Format: ${_current?.audioFormat}");
                      //     print("começou");
                      //     _start();
                      //   }
                      // },
                      // onLongPressEnd: (details) {
                      //   print("parou");
                      //   if (_currentStatus == RecordingStatus.Recording) {
                      //     _stop();
                      //   }
                      // },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue),
                        margin: EdgeInsets.only(
                            top: screenHeight * 0.75, left: widthScreen * 0.45),
                        child: Center(child: Icon(Icons.mic)),
                      ),
                    ),
                    OutlineButton(
                      padding: EdgeInsets.all(6),
                      borderSide: BorderSide(
                        color: Color.fromRGBO(0, 0, 255, 1),
                      ),
                      color: buttonBackground,
                      textColor: Color(0xFF0000FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Icon(
                        Icons.volume_up,
                        size: 40,
                        color: Color(0xFF0000FF),
                      ),
                      onPressed: () {
                        onPlayAudio();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Aciona o botão de confirmar apenas quando algum texto é digitado na tela.
                if (_textController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: submitAnswer(
                        context,
                        cobjectList,
                        'PRE',
                        ++questionIndex,
                        listQuestionIndex,
                        pieceId,
                        true,
                        _textController.text),
                    // SizedBox(height: 15),
                    // if (_textController.text.isNotEmpty)
                    //   Padding(
                    //     padding: const EdgeInsets.only(bottom: 4.0),
                    //     child: submitAnswer(context, cobjectList, 'PRE',
                    //         ++questionIndex, listQuestionIndex),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        print("INITOU");
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}
