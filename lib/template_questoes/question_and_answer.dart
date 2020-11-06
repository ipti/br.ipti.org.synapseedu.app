import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/api.dart';
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

import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'dart:async';
import 'dart:io' as io;

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

// ignore: must_be_immutable
class SingleLineTextQuestion extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  SingleLineTextQuestion({localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  static const routeName = '/PRE';

  _SingleLineTextQuestionState createState() => new _SingleLineTextQuestionState();
}

class _SingleLineTextQuestionState extends State<SingleLineTextQuestion> {
  // ignore: non_constant_identifier_names
  var cobjectList = new List<Cobject>();
  int questionIndex;
  int listQuestionIndex;

  double opacityFaleAgora = 0;

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
    _speech = stt.SpeechToText();
    _textController.text = "";
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

  // Future<String> VoiceToText() async {
  //   var response = await dio.post(
  //     "https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=pt-BR",
  //     headers: {'Ocp-Apim-Subscription-Key': 'b21db0729fc14cc7b6de72e1f44322dd',
  //       'Content-Type':'audio/wav'},
  //     body: {
  //       'query': 'chicken soup',
  //       'brand': 'acme',
  //     },
  //   );
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
    String questionText = cobjectList[0].questions[questionIndex].header["text"];
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
        linkImage: 'https://elesson.com.br/app/library/image/' + cobjectList[0].questions[0].header["image"],
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
                      margin: EdgeInsets.only(right: 16, left: 16, top: screenHeight * 0.2),
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
                          maxLines: 3,
                          minLines: 1,
                          enableSuggestions: false,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _textController,
                          autofocus: false,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0000FF),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Mulish',
                          ),
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
                              ? (screenHeight * 0.93) - 18 - (48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656)
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
                            playSound(cobjectList[0].questions[questionIndex].header["sound"]);
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
                    Container(
                      width: widthScreen,
                      margin: EdgeInsets.only(top: screenHeight * 0.65),
                      child: Center(
                        child: Text(
                          "FALE AGORA...",
                          style: TextStyle(
                            fontSize: widthScreen * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0000FF).withOpacity(opacityFaleAgora),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onLongPressStart: (details) {
                        _listen();
                        buttonBackground = Color(0xFF0000FF).withOpacity(0.6);
                        iconBackground = Colors.white;
                        opacityFaleAgora = 1;
                      },
                      onLongPressEnd: (details) {
                        setState(() {
                          buttonBackground = Colors.white;
                          iconBackground = Color(0xFF0000FF);
                          opacityFaleAgora = 0;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.80, left: widthScreen * 0.45),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(0, 0, 255, 1)),
                          color: buttonBackground,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Icon(
                          Icons.mic,
                          size: 40,
                          color: iconBackground,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Aciona o botão de confirmar apenas quando algum texto é digitado na tela.
                if (_textController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: submitAnswer(
                        context, cobjectList, 'PRE', ++questionIndex, listQuestionIndex, pieceId, true, _textController.text.toUpperCase()),
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

  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            _textController.text = _text.toUpperCase(); // se quiser acrescentar no lugar de substituir é só usar um += no lugar do =
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
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
        customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

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
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
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
    Future.delayed(Duration(seconds: 2), () {
      ConversorVoiceToText().conversorVoice(_current?.path);
    });
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(_current.path, isLocal: true);
  }
}
