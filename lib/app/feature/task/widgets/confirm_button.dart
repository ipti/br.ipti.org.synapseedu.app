import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/task_module.dart';
import 'package:elesson/app/providers/block_provider.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/home_module.dart';

class ConfirmButtonWidget extends StatefulWidget {
  final TaskViewController taskViewController;

  ConfirmButtonWidget({Key? key, required this.taskViewController}) : super(key: key);

  @override
  State<ConfirmButtonWidget> createState() => _ConfirmButtonWidgetState();
}

class _ConfirmButtonWidgetState extends State<ConfirmButtonWidget> {
  late BlockProvider blockProvider;

  @override
  void didChangeDependencies() {
    print("DID");
    blockProvider = Provider.of<BlockProvider>(context, listen: false);
    super.didChangeDependencies();
  }
  String confirmButtonText = 'CONFIRMAR';

  Color confirmButtonBorderColor = Color.fromRGBO(0, 220, 140, 1);

  Color confirmButtonTextColor = Color.fromRGBO(0, 220, 140, 1);

  SubmitButtonStatus oldState = SubmitButtonStatus.Disabled;

  void changeConfirmButton(SubmitButtonStatus newState) {
    if (oldState != newState) {
      oldState = newState;
      switch (widget.taskViewController.buttonStatus) {
        case SubmitButtonStatus.Idle:
          confirmButtonText = 'CONFIRMAR';
          confirmButtonBorderColor = Color(0xFF0000FF);
          confirmButtonTextColor = Color(0xFF0000FF);
          break;
        case SubmitButtonStatus.Error:
          confirmButtonText = 'ERROR';
          confirmButtonBorderColor = Color.fromRGBO(255, 51, 0, 1);
          confirmButtonTextColor = Color.fromRGBO(255, 51, 0, 1);
          break;
        case SubmitButtonStatus.Success:
          confirmButtonText = 'CORRETA';
          confirmButtonBorderColor = Color.fromRGBO(0, 220, 140, 1);
          confirmButtonTextColor = Color.fromRGBO(0, 220, 140, 1);
          break;
        default:
          break;
      }
    }
  }

  bool blockButton = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.taskViewController,
      builder: (context, child) {
        changeConfirmButton(widget.taskViewController.buttonStatus);

        return widget.taskViewController.buttonStatus == SubmitButtonStatus.Disabled
            ? Container()
            : Expanded(
                child: MaterialButton(
                  elevation: 2,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: double.maxFinite,
                  textColor: Color.fromRGBO(0, 220, 140, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: confirmButtonBorderColor),
                  ),
                  child: Text(
                    confirmButtonText,
                    style: TextStyle(
                      color: confirmButtonTextColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: !blockButton ? () async {
                    blockButton = true;
                    widget.taskViewController.sendPerformance();
                    await Future.delayed(Duration(seconds: 3));
                    TaskModel nextTaskId = blockProvider.getNextTask();
                    if (nextTaskId == TaskModel.empty()) {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeModule()), (route) => false);
                      return;
                    }
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TaskModule(taskModel: nextTaskId)));
                  } : null,
                ),
              );
      },
    );
  }
}
