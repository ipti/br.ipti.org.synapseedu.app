import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
import 'package:elesson/app/feature/task/widgets/template_slider.dart';
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
    widget.taskViewController.correctAnswer = widget.taskModel.body!.components.firstWhere((element) => element.position == 1);
    widget.taskViewController.renderTaskJson(widget.taskModel);
    widget.taskViewController.performanceTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TemplateSlider(taskViewController: widget.taskViewController),
      ),
    );
  }
}
