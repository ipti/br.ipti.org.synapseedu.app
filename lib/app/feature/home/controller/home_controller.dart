import 'package:elesson/app/core/task/domain/usecase/get_task_usecase.dart';
import 'package:elesson/app/feature/task/task_module.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:flutter/material.dart';


class HomeController extends ChangeNotifier {
  final GetTaskUseCase getTaskUseCase;
  HomeController({required this.getTaskUseCase});

  SubmitButtonStatus _searchButtonStatus = SubmitButtonStatus.Idle;
  SubmitButtonStatus get searchButtonStatus => _searchButtonStatus;

  final TextEditingController taskIdController = TextEditingController();

  Future submitSearchTaskById(BuildContext context) async {
    print("Entrou aqui");
    _searchButtonStatus = SubmitButtonStatus.Loading;
    // notifyListeners();
    final taskId = int.parse(taskIdController.text);
    final res = await getTaskUseCase.getTaskById(taskId);
    res.fold(
      (l) {
        _searchButtonStatus = SubmitButtonStatus.Error;
        // notifyListeners();
        Future.delayed(Duration(seconds: 2));
      },
      (r) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskModule(taskModel: r)));
      },
    );
    _searchButtonStatus = SubmitButtonStatus.Idle;
    // notifyListeners();
  }
}
