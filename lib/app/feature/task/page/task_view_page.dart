import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/feature/task/controller/TaskViewController.dart';
import 'package:elesson/app/feature/task/widgets/template_slider/template_slider.dart';
import 'package:flutter/material.dart';

class TaskViewPage extends StatefulWidget {
  final TaskModel taskModel;
  final TaskViewController taskViewController;

  const TaskViewPage({Key? key, required this.taskModel, required this.taskViewController}) : super(key: key);

  @override
  _TaskViewPageState createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {

  @override
  void initState() {
    super.initState();
    widget.taskViewController.renderTaskJson(widget.taskModel);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TemplateSlider(
          taskViewController: widget.taskViewController,
          // bodyView: Container(
          //   child: Wrap(
          //     alignment: WrapAlignment.center,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(bottom: 48),
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Container(
          //               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          //               height: 20 + 32,
          //               child: GestureDetector(
          //                 behavior: HitTestBehavior.translucent,
          //                 // onTap: () => playerTituloSegundaTela.resume(),
          //                 child: Center(
          //                   child: Text("Alguma coisa aqui"),
          //                 ),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          //               child: Column(
          //                 children: [],
          //               ),
          //             ),
          //             // Caso nenhuma opção esteja selecionada, _selectedButton = 3. Conforme uma resposta é selecionada, ele mudará para
          //             // 0, 1 ou 2, fazendo o botão aparecer.
          //             // if (_selectedButton < 3)
          //             //   ConfirmButtonWidget(
          //             //     context: context,
          //             //     cobjectList: cobjectList,
          //             //     cobjectIdList: cobjectIdList,
          //             //     questionType: 'MTE',
          //             //     questionIndex: ++questionIndex,
          //             //     cobjectIndex: cobjectIndex,
          //             //     cobjectIdListLength: cobjectIdListLength,
          //             //     cobjectQuestionsLength: cobjectQuestionsLength,
          //             //     pieceId: pieceId,
          //             //     isCorrect: isCorrect,
          //             //     groupId: (_selectedButton + 1).toString(),
          //             //   ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
