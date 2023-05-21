import 'package:elesson/template_questoes/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

class TextQuestion extends ConsumerWidget {
  static const routeName = '/TXT';

  List<Cobject> cobjectList = [];
  List<String?>? cobjectIdList = [];
  int? questionIndex;
  int? cobjectIndex;
  int? cobjectIdListLength;
  int? cobjectQuestionsLength;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // final ScreenArguments args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    cobjectList = [];
    cobjectIdList = [];
    questionIndex = 1;
    cobjectIndex = 1;
    cobjectIdListLength = 1;
    cobjectQuestionsLength = 1;

    String questionDescription = cobjectList[0].description!;
    String headerText = cobjectList[0].questions[questionIndex!].header["text"]!;

    String questionText =
        cobjectList[0].questions[questionIndex!].pieces['1']['text'];
    String? pieceId = cobjectList[0].questions[questionIndex!].pieceId;
    Stopwatch chronometer = Stopwatch();

    return Scaffold(
      // body: TemplateSlider(
      //   headerView: HeaderView(containerModel: ContainerModel.empty()),
      //   // taskViewController: TaskViewController(),
      //   // currentId: cobjectIdList![cobjectIndex!],
      //   // cobjectIdList: cobjectIdList,
      //   // cobjectIdListLength: cobjectIdListLength,
      //   // cobjectQuestionsLength: cobjectQuestionsLength,
      //   // isTextTemplate: true,
      //   // cobjectIndex: cobjectIndex,
      //   // questionIndex: questionIndex,
      //   // title: questionDescription.toUpperCase(),
      //   // sound: cobjectList[0].questions[questionIndex!].header["sound"],
      //   // linkImage: cobjectList[0].questions[0].header["image"]!.isNotEmpty
      //   //     ? 'https://apielesson.azurewebsites.net/app/library/image/' +
      //   //         cobjectList[0].questions[0].header["image"]!
      //   //     : null,
      //   // text: Text(
      //   //   headerText,
      //   //   style: TextStyle(
      //   //     fontWeight: FontWeight.bold,
      //   //     fontSize: fonteDaLetra,
      //   //     fontFamily: 'Mulish',
      //   //   ),
      //   // ),
      //   bodyView: Container(
      //     child: Wrap(
      //       children: [
      //         Text(
      //           questionText,
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: fonteDaLetra,
      //             fontFamily: 'Mulish',
      //           ),
      //         ),
      //         submitAnswer(context, cobjectList, 'TXT', questionIndex!+1,
      //             cobjectIndex, pieceId, true,
      //             cobjectIdListLength: cobjectIdListLength,
      //             cobjectQuestionsLength: cobjectQuestionsLength,
      //             cobjectIdList: cobjectIdList),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
