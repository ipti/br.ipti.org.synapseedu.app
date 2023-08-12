import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/util/enums/button_status.dart';
import 'package:flutter/material.dart';

class ConfirmButtonWidget extends StatelessWidget {
  final TaskViewController taskViewController;

  ConfirmButtonWidget({Key? key, required this.taskViewController}) : super(key: key);

  String confirmButtonText = 'CONFIRMAR';
  Color confirmButtonBorderColor = Color.fromRGBO(0, 220, 140, 1);
  Color confirmButtonTextColor = Color.fromRGBO(0, 220, 140, 1);

  SubmitButtonStatus oldState = SubmitButtonStatus.Disabled;

  void changeConfirmButton(SubmitButtonStatus newState) {
    if (oldState != newState) {
      oldState = newState;
      switch (taskViewController.buttonStatus) {
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
          confirmButtonText = 'SUCCESS';
          confirmButtonBorderColor = Color.fromRGBO(0, 220, 140, 1);
          confirmButtonTextColor = Color.fromRGBO(0, 220, 140, 1);
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: taskViewController,
      builder: (context, child) {
        changeConfirmButton(taskViewController.buttonStatus);

        return taskViewController.buttonStatus == SubmitButtonStatus.Disabled
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
                  onPressed: () async {
                    taskViewController.sendPerformance();
                    // await Future.delayed(Duration(seconds: 5));
                    // Navigator.of(context).pop();
                  },
                ),
              );
      },
    );
  }
}
