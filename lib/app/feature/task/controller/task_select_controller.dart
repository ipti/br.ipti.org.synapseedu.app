import 'package:elesson/app/core/task/domain/usecase/get_task_usecase.dart';
import 'package:elesson/app/feature/task/page/task_view_page.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:flutter/material.dart';

import 'task_view_controller.dart';

class TaskSelectController extends ChangeNotifier {
  final GetTaskUseCase getTaskUseCase;
  TaskSelectController({required this.getTaskUseCase});

  SubmitButtonStatus _searchButtonStatus = SubmitButtonStatus.Idle;
  SubmitButtonStatus get searchButtonStatus => _searchButtonStatus;

  final TextEditingController taskIdController = TextEditingController();

  void resetSubmitStatusButton() {
    _searchButtonStatus = SubmitButtonStatus.Idle;
    notifyListeners();
  }

  void submitSearchTaskById(BuildContext context, TaskViewController taskViewController) async {
    _searchButtonStatus = SubmitButtonStatus.Loading;
    notifyListeners();
    final taskId = int.parse(taskIdController.text);
    final res = await getTaskUseCase.getTaskById(taskId);
    res.fold(
      (l) {
        print("L");
        // _submitButtonStatus = SubmitButtonStatus.Error;
        _searchButtonStatus = SubmitButtonStatus.Idle;
        notifyListeners();
      },
      (r) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskViewPage(taskModel: r, taskViewController: taskViewController)));
        // _submitButtonStatus = SubmitButtonStatus.Success;
        // _submitButtonStatus = SubmitButtonStatus.Idle;
        // notifyListeners();
        // print(r.toJson());
      },
    );
  }


}
