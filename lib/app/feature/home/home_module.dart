import 'package:dio/dio.dart';
import 'package:elesson/app/core/task/data/datasource/task_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/task_repository_interface.dart';
import 'package:elesson/app/core/task/domain/repository/task_repository_impl.dart';
import 'package:elesson/app/core/task/domain/usecase/get_task_usecase.dart';
import 'package:elesson/app/feature/home/controller/home_controller.dart';
import 'package:elesson/app/feature/home/page/home_page.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeModule extends StatefulWidget {
  static const routeName = '/home-module';

  const HomeModule({Key? key}) : super(key: key);

  @override
  State<HomeModule> createState() => _HomeModuleState();
}

class _HomeModuleState extends State<HomeModule> {
  late UserProvider _userProvider;

  late ITaskRemoteDataSource _taskRemoteDataSource;

  late ITaskRepository _taskRepository;

  late GetTaskUseCase _getTaskUseCase;

  late HomeController _taskSelectController;

  @override
  void initState() {
    super.initState();
    Dio dioAuthed = DioAuthed().dio;

    _taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dioAuthed);

    _taskRepository = TaskRepositoryImpl(taskRemoteDataSource: _taskRemoteDataSource);

    _getTaskUseCase = GetTaskUseCase(taskRepository: _taskRepository);

    _taskSelectController = HomeController(getTaskUseCase: _getTaskUseCase);
  }

  @override
  void dispose() {
    super.dispose();
    // _taskRemoteDataSource.dispose();
    // _taskRepository.dispose();
    // _getTaskUseCase.dispose();
    _taskSelectController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _taskSelectController,
        builder: (context, child) => HomePage(taskSelectController: _taskSelectController, userProvider: _userProvider),
      ),
    );
  }
}
