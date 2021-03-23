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
import 'package:speech_to_text/speech_recognition_error.dart';

// O pacote que está em testes. O Dart/Flutter está com problemas de integração com a API da Azure.

import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'dart:async';
import 'dart:io' as io;

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

// ignore: must_be_immutable
class SingleLineTextQuestion extends StatefulWidget {
  static const routeName = '/PRE';
  final LocalFileSystem localFileSystem;

  SingleLineTextQuestion({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _SingleLineTextQuestionState createState() =>
      new _SingleLineTextQuestionState();
}

class _SingleLineTextQuestionState extends State<SingleLineTextQuestion> {
  // ignore: non_constant_identifier_names
  var cobjectList = new List<Cobject>();
  var cobjectIdList = new List<String>();
  int questionIndex;
  int cobjectIndex;

  String alertMessage = "FALE AGORA...";
  String naoEndendivel =
      "Não entendemos o que você quis dizer...\nTente Novamente!";

  double opacityFaleAgora = 0;
  double opacityNaoEntendivel = 0;

  Color colorAlertMessage = Colors.red;
  bool isCorrect = false;

  String correctAnswer;
  bool firstRecording = true;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  @override
  void initState() {
    super.initState();
    _textController.text = "";
  }

  void submitButton(BuildContext context) {
    context.read(buttonStateProvider).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    cobjectIndex = args.cobjectIndex;

    String questionDescription = cobjectList[0].description;
    String questionText =
        cobjectList[0].questions[questionIndex].header["text"];
    String pieceId = cobjectList[0].questions[questionIndex].pieceId;

    correctAnswer = cobjectList[0].questions[0].pieces["1"]["text"];

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
                        right: 16,
                        left: 16,
                        top: screenHeight * 0.2,
                      ),
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
                            hintText: 'Digite a resposta aqui',
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
                          onChanged: (val) {
                            correctAnswer == _textController.text.toString()
                                ? isCorrect = true
                                : isCorrect = false;

                            print(
                                "CORRETA: $correctAnswer , DIGITADA: ${_textController.text.toString()} ");
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
                          child: Container(
                            padding: EdgeInsets.all(20),
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
                    ),
                    Container(
                      width: widthScreen,
                      margin: EdgeInsets.only(top: screenHeight * 0.65),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              naoEndendivel,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: widthScreen * 0.05,
                                fontWeight: FontWeight.bold,
                                color: colorAlertMessage
                                    .withOpacity(opacityNaoEntendivel),
                              ),
                            ),
                            Text(
                              alertMessage,
                              style: TextStyle(
                                fontSize: widthScreen * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0000FF)
                                    .withOpacity(opacityFaleAgora),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Aciona o botão de confirmar apenas quando algum texto é digitado na tela.
                if (_textController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: submitAnswer(
                      context,
                      cobjectList,
                      'PRE',
                      ++questionIndex,
                      cobjectIndex,
                      pieceId,
                      isCorrect,
                      value: _textController.text,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void errorNotification(SpeechRecognitionError a) {
    opacityNaoEntendivel = 1;
    setState(() {
      opacityFaleAgora = 0;
    });
    colorAlertMessage = Colors.red;
  }
}
