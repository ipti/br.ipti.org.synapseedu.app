import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/template_questoes/share/description_format.dart';
import 'package:flutter/material.dart';

// import 'question_provider.dart';
import 'model.dart';
import 'share/image_detail_screen.dart';

// const String BASE_URL = 'https://apielesson.azurewebsites.net/app/library';

// final cobjectProvider = Provider<Cobjects>((ref) {
//   return Cobjects();
// });

class MultipleChoiceQuestion extends StatelessWidget{
  static const routeName = '/MTE';

  List<Cobject> cobjectList = [];
  late int questionIndex;
  String? questionType;
  bool isCorrect = false;
  DateTime? startTime;

  List<bool> _buttonPressed = [false, false, false];
  int _selectedButton = 3;

  // final buttonStateProvider = StateProvider<bool>((ref) {
  //   return false;
  // });

  void changeButtonColor(BuildContext context, index) {
    for (int i = 0; i < 3; i++) {
      if (_buttonPressed[i] == true && i != index) {
        _buttonPressed[i] = false;
        // context.read(buttonStateProvider).state = false;
      }
    }
    if (_buttonPressed[index] == false) {
      _buttonPressed[index] = !_buttonPressed[index];
      // context.read(buttonStateProvider).state = true;
    }
    _selectedButton = index;
  }

  Widget piece(int index, BuildContext context, Question question, double buttonHeight, double screenHeight, double textCardHeight) {
    String grouping = (index + 1).toString();
    double availableSpaceForCards = screenHeight - textCardHeight - buttonHeight - 12 - 32;
    double marginBetweenCards = 0.0147 * availableSpaceForCards;
    double cardHeight = (availableSpaceForCards - 24 - 2 * marginBetweenCards) / 3;
    double cardWidth = question.pieces[grouping]["image"].isNotEmpty ? cardHeight : double.infinity;

    bool audio = false;

    return Card(
      margin: EdgeInsets.only(bottom: index < 2 ? marginBetweenCards : 0, left: 12, right: 12),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 2,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: cardHeight, maxWidth: cardWidth, minHeight: cardHeight, minWidth: cardWidth),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: _buttonPressed[index] ? Color(0xFF00DC8C) : Color(0x6E729166),
                  width: 3,
                ),
              ),
              minWidth: 200,
              padding: const EdgeInsets.all(0),
              child: Hero(
                tag: grouping,
                child: question.pieces[grouping]["image"].isNotEmpty
                    ? Image.network(
                        BASE_URL + '/image/' + question.pieces[grouping]["image"],
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                            ),
                          );
                        },
                        errorBuilder: (context, exception, stackTrace) {
                          // print('erro');
                          // callSnackBar(context);
                          return Container();
                        },
                      )
                    : Material(
                        type: MaterialType.transparency,
                        child: Container(
                          height: cardHeight,
                          child: Center(
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                question.pieces[grouping]["text"].toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.w800, fontSize: fonteDaLetra),
                              ),
                            ),
                          ),
                          margin: const EdgeInsets.all(20),
                        ),
                      ),
              ),
              highlightColor: Color(0xFF00DC8C),
              splashColor: Color(0xFF00DC8C),
              onLongPress: () {
                // if (question.pieces[grouping]["image"].isNotEmpty)
                Navigator.of(context).pushNamed(
                  ImageDetailScreen.routeName,
                  arguments: DetailScreenArguments(grouping: grouping, question: question),
                );
              },
              onPressed: () {
                changeButtonColor(context, index);
                if (showConfirmButton == false) showConfirmButton = true;
                // Muda a flag isCorrect com base na resposta correta fornecida pela questão. Se a resposta atual selecionada for a certa,
                // a flag receberá true. Ao pressionar o botão de confirmar, ela será enviada como parâmetro.
                question.pieces["correctAnswer"] == index + 1 ? isCorrect = true : isCorrect = false;
                // print('Correto: ${question.pieces["correctAnswer"]}');
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

  Stopwatch elapsedTimer = Stopwatch();
  bool timer = false;
  List<String?>? cobjectIdList;
  int? cobjectIdListLength;
  int? cobjectQuestionsLength;
  List<int> pieceOrder = [0, 1, 2];
  bool pieceOrdered = false;
  Widget? questionDescriptionWidget;

  @override
  Widget build(BuildContext context) {
    // final ScreenArguments args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    // elapsedTimer.start();
    cobjectList = [];
    cobjectIdList =[];
    questionIndex = 1;
    cobjectIdListLength = 1;
    cobjectQuestionsLength = 1;
    var cobjectIndex = 1;
    double screenHeight = MediaQuery.of(context).size.height;
    double textCardHeight = 0.0985 * screenHeight;
    double buttonHeight = 48 > screenHeight * 0.0656 ? 48 : screenHeight * 0.0656;
    // print(
    //     'COBJECT LIST ID ${cobjectIdList[0]} e qindex ${cobjectList[0].questions[questionIndex]}');

    String imageLink = cobjectList[0].questions[questionIndex].header["image"]!;

    String? pieceId = cobjectList[0].questions[questionIndex].pieceId;

    // final cobjectProvidersState = watch(cobjectProvider.state);
    String questionDescription = cobjectList[0].description!;
    // final questionChangeNotifier = watch(questionChangeNotifierProvider);

    // playerTituloSegundaTela.setUrl(BASE_URL +
    //     '/sound/' +
    //     cobjectList[0].questions[questionIndex].header["sound"]);

    if (!pieceOrdered) {
      pieceOrdered = true;
      pieceOrder.shuffle();
      questionDescriptionWidget = formatDescription(cobjectList[0].questions[questionIndex].header["text"]!.toUpperCase());
    }

    return Scaffold(
      // bottomNavigationBar: bottomNavBar(context),
      // body: TemplateSlider(
      //   headerView: HeaderView(containerModel: ContainerModel.empty()),
      //   // taskViewController: TaskViewController(),
      //   // currentId: cobjectIdList![cobjectIndex],
      //   // showConfirmButton: showConfirmButton,
      //   // title: questionDescription.toUpperCase(),
      //   // text: questionDescriptionWidget,
      //   // linkImage: imageLink.isNotEmpty ? 'https://apielesson.azurewebsites.net/app/library/image/' + imageLink : null,
      //   bodyView: Container(
      //     child: Wrap(
      //       alignment: WrapAlignment.center,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.only(bottom: 48),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Container(
      //                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      //                 height: textCardHeight + 32,
      //                 child: GestureDetector(
      //                   // onTap: () => playerTituloSegundaTela.resume(),
      //                   child: Center(
      //                     child: questionDescriptionWidget,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      //                 child: Column(
      //                   children: [
      //                     // Monta as escolhas em uma coluna, com base na função que retorna um Widget de piece unitário.
      //                     piece(pieceOrder[0], context, cobjectList[0].questions[questionIndex], buttonHeight, screenHeight, textCardHeight),
      //                     piece(pieceOrder[1], context, cobjectList[0].questions[questionIndex], buttonHeight, screenHeight, textCardHeight),
      //                     piece(pieceOrder[2], context, cobjectList[0].questions[questionIndex], buttonHeight, screenHeight, textCardHeight),
      //                   ],
      //                 ),
      //               ),
      //               // Caso nenhuma opção esteja selecionada, _selectedButton = 3. Conforme uma resposta é selecionada, ele mudará para
      //               // 0, 1 ou 2, fazendo o botão aparecer.
      //               if (_selectedButton < 3)
      //                 ConfirmButtonWidget(
      //                   context: context,
      //                   cobjectList: cobjectList,
      //                   cobjectIdList: cobjectIdList,
      //                   questionType: 'MTE',
      //                   questionIndex: ++questionIndex,
      //                   cobjectIndex: cobjectIndex,
      //                   cobjectIdListLength: cobjectIdListLength,
      //                   cobjectQuestionsLength: cobjectQuestionsLength,
      //                   pieceId: pieceId,
      //                   isCorrect: isCorrect,
      //                   groupId: (_selectedButton + 1).toString(),
      //                 ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
