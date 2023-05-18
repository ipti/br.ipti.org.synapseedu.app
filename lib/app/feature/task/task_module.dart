import 'package:dio/dio.dart';
import 'package:elesson/app/core/task/data/datasource/task_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/task_repository_interface.dart';
import 'package:elesson/app/core/task/domain/repository/task_repository_impl.dart';
import 'package:elesson/app/core/task/domain/usecase/get_task_usecase.dart';
import 'package:elesson/app/feature/task/controller/task_select_controller.dart';
import 'package:elesson/app/feature/task/page/task_select_page.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/TaskViewController.dart';

class TaskModule extends StatefulWidget {
  static const routeName = '/task-module';
  const TaskModule({Key? key}) : super(key: key);

  @override
  State<TaskModule> createState() => _TaskModuleState();
}

class _TaskModuleState extends State<TaskModule> {
  late UserProvider _userProvider;

  late TaskRemoteDataSource _taskRemoteDataSource;
  late TaskRepositoryInterface _taskRepository;
  late GetTaskUseCase _getTaskUseCase;

  late TaskSelectController _taskSelectController;
  late TaskViewController _taskViewController;

  @override
  void initState() {
    super.initState();
    Dio dioAuthed = DioAuthed().dio;
    _taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dioAuthed);
    _taskRepository = TaskRepositoryImpl(taskRemoteDataSource: _taskRemoteDataSource);
    _getTaskUseCase = GetTaskUseCase(taskRepository: _taskRepository);

    _taskSelectController = TaskSelectController(getTaskUseCase: _getTaskUseCase);
    _taskViewController = TaskViewController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _taskSelectController,
      builder: (context, child) => TaskSelectPage(taskSelectController: _taskSelectController, taskViewController: _taskViewController, userProvider: _userProvider),
    );
  }
}
