import 'package:elesson/activity_selection/activity_selection_view.dart';
import 'package:elesson/share/question_widgets.dart';
import 'share/button_widgets.dart';
import 'package:flutter/services.dart';

import 'share/template_slider.dart';
import 'package:flutter/material.dart';
import 'question_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'model.dart';
import 'share/image_detail_screen.dart';

// const String BASE_URL = 'https://elesson.com.br/app/library';

final cobjectProvider = Provider<Cobjects>((ref) {
  return Cobjects();
});

// final cobjectProvider = StateNotifierProvider<Cobjects>((ref) {
//   return Cobjects();
// });

// final questionChangeNotifierProvider = ChangeNotifierProvider<Cobjects>((ref) {
//   return Cobjects();
// });

class MultipleChoiceQuestion extends ConsumerWidget {
  static const routeName = '/MTE';

  var cobjectList = new List<Cobject>();
  int questionIndex;
  String questionType;
  bool isCorrect = false;

  List<bool> _buttonPressed = [false, false, false];
  int _selectedButton = 3;

  final buttonStateProvider = StateProvider<bool>((ref) {
    return false;
  });

  void changeButtonColor(BuildContext context, index) {
    for (int i = 0; i < 3; i++) {
      if (_buttonPressed[i] == true && i != index) {
        _buttonPressed[i] = false;
        context.read(buttonStateProvider).state = false;
      }
    }
    if (_buttonPressed[index] == false) {
      _buttonPressed[index] = !_buttonPressed[index];
      context.read(buttonStateProvider).state = true;
    }
    _selectedButton = index;
  }

  // Widget que retorna o quadro que representa o piece, seja ele uma imagem ou texto.
  Widget piece(
      int index,
      BuildContext context,
      ScopedReader watch,
      Question question,
      double buttonHeight,
      double screenHeight,
      double textCardHeight) {
    final buttonState = watch(buttonStateProvider).state;

    String grouping = (index + 1).toString();
    // double cardHeight = 158.29;

    // Define o tamanho do card com base nas dimensões do dispositivo, seguindo as proporções presentes no Figma.
    double availableSpaceForCards =
        screenHeight - textCardHeight - buttonHeight - 12 - 32;
    double marginBetweenCards = 0.0147 * availableSpaceForCards;
    double cardHeight =
        (availableSpaceForCards - 24 - 2 * marginBetweenCards) / 3;
    double cardWidth = question.pieces[grouping]["image"].isNotEmpty
        ? cardHeight
        : double.infinity;

    bool audio = false;

    return Card(
      margin: EdgeInsets.only(
          bottom: index < 2 ? marginBetweenCards : 0, left: 12, right: 12),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: cardHeight, maxWidth: cardWidth),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      // Define a cor das bordas do card dependendo se ele está selecionado ou não.
                      color: _buttonPressed[index]
                          ? Color(0xFF00DC8C)
                          : Color(0x6E729166),
                      width: 3)),
              minWidth: 200,
              padding: const EdgeInsets.all(0),
              // color: _buttonPressed[index] ? Colors.amber : Colors.green[300],
              child: Hero(
                tag: grouping,
                child: question.pieces[grouping]["image"].isNotEmpty
                    ? Image.network(
                        BASE_URL +
                            '/image/' +
                            question.pieces[grouping]["image"],
                      )
                    // ? Image.asset('assets/img/placeholder.jpg')
                    : Container(
                        height: cardHeight,
                        child: Text(
                          question.pieces[grouping]["text"].toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: fonteDaLetra),
                        ),
                        margin: const EdgeInsets.all(20),
                      ),
              ),
              // height: cardHeight,
              // minWidth: cardHeight,
              highlightColor: Color(0xFF00DC8C),
              splashColor: Color(0xFF00DC8C),
              onLongPress: () {
                // if (question.pieces[grouping]["image"].isNotEmpty)
                Navigator.of(context).pushNamed(
                  ImageDetailScreen.routeName,
                  arguments: DetailScreenArguments(
                      grouping: grouping, question: question),
                );
              },
              onPressed: () {
                changeButtonColor(context, index);
                if (showConfirmButton == false) showConfirmButton = true;
                // Muda a flag isCorrect com base na resposta correta fornecida pela questão. Se a resposta atual selecionada for a certa,
                // a flag receberá true. Ao pressionar o botão de confirmar, ela será enviada como parâmetro.
                question.pieces["correctAnswer"] == index + 1
                    ? isCorrect = true
                    : isCorrect = false;
                // setState(() {
                //   for (int i = 0; i < 3; i++) {
                //     if (_buttonPressed[i] == true && i != index)
                //       _buttonPressed[i] = false;
                //   }
                //   if (_buttonPressed[index] == false)
                //     _buttonPressed[index] = !_buttonPressed[index];
                //   _selectedButton = index;
                // });
              },
            ),
          ),
          if (audio == true)
            IconButton(
              icon: Icon(Icons.volume_up),
              highlightColor: Theme.of(context).primaryColor,
              splashColor: Theme.of(context).primaryColor,
              onPressed: () {
                playSound(
                  question.pieces[grouping]["sound"],
                );
              },
            ),
        ],
      ),
    );
  }

  bool fetch = false;
  bool showConfirmButton = false;

  // Stopwatch elapsedTimer = Stopwatch();
  bool cond = true;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    // elapsedTimer.start();
    cobjectList = args.cobjectList;
    questionIndex = args.questionIndex;
    var listQuestionIndex = args.listQuestionIndex;
    double screenHeight = MediaQuery.of(context).size.height;
    double textCardHeight = 0.0985 * screenHeight;
    double buttonHeight =
        48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;

    String imageLink = cobjectList[0].questions[questionIndex].header["image"];
    // if (imageLink.isEmpty) print('O link tá vazio: "$imageLink"');
    // if (imageLink == null) print('O link tá null: $imageLink');

    String pieceId = cobjectList[0].questions[questionIndex].pieceId;

    if (cond == true) {
      // List<String> cobjectIdList = getCobjectList("1");
      // print(cobjectIdList);
      // print(cobjectIdList.length);
    }
    cond = false;

    // final cobjectProvidersState = watch(cobjectProvider.state);
    SystemChrome.setEnabledSystemUIOverlays([]);
    String questionDescription = cobjectList[0].description;
    // final questionChangeNotifier = watch(questionChangeNotifierProvider);
    // print(elapsedTimer.elapsed);
    Stopwatch chronometer = Stopwatch();
    return Scaffold(
      // bottomNavigationBar: bottomNavBar(context),
      body: TemplateSlider(
        showConfirmButton: showConfirmButton,
        title: Text(
          questionDescription.toUpperCase(),
          textAlign: TextAlign.justify,
          maxLines: 3,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fonteDaLetra,
            fontFamily: 'Mulish',
          ),
        ),
        linkImage: imageLink.isNotEmpty
            ? 'https://elesson.com.br/app/library/image/' + imageLink
            : null,
        activityScreen: Container(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      height: textCardHeight,
                      child: Text(
                        cobjectList[0]
                            .questions[questionIndex]
                            .header["text"]
                            .toUpperCase(),
                        textAlign: TextAlign.justify,
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fonteDaLetra,
                          fontFamily: 'Mulish',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                      child: Column(
                        children: [
                          // Monta as escolhas em uma coluna, com base na função que retorna um Widget de piece unitário.
                          piece(
                              0,
                              context,
                              watch,
                              cobjectList[0].questions[questionIndex],
                              buttonHeight,
                              screenHeight,
                              textCardHeight),
                          piece(
                              1,
                              context,
                              watch,
                              cobjectList[0].questions[questionIndex],
                              buttonHeight,
                              screenHeight,
                              textCardHeight),
                          piece(
                              2,
                              context,
                              watch,
                              cobjectList[0].questions[questionIndex],
                              buttonHeight,
                              screenHeight,
                              textCardHeight),
                        ],
                      ),
                    ),
                    // Caso nenhuma opção esteja selecionada, _selectedButton = 3. Conforme uma resposta é selecionada, ele mudará para
                    // 0, 1 ou 2, fazendo o botão aparecer.
                    if (_selectedButton < 3)
                      // Enviar isCorrect
                      submitAnswer(context, cobjectList, 'MTE', ++questionIndex,
                          listQuestionIndex, pieceId, isCorrect,
                          groupId: (_selectedButton + 1).toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}