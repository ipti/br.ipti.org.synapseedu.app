import 'package:dio/dio.dart';
import 'package:elesson/app/core/task/data/datasource/multimedia_remote_datasource.dart';
import 'package:elesson/app/core/task/data/datasource/task_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/core/task/data/repository/task_repository_interface.dart';
import 'package:elesson/app/core/task/domain/repository/task_repository_impl.dart';
import 'package:elesson/app/core/task/domain/repository/multimedia_repository_impl.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/core/task/domain/usecase/get_task_usecase.dart';
import 'package:elesson/app/feature/home/controller/home_controller.dart';
import 'package:elesson/app/feature/home/page/home_page.dart';
import 'package:elesson/app/feature/task/controller/task_view_controller.dart';
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
  late IMultimediaRemoteDatasource _multimediaRemoteDataSource;

  late ITaskRepository _taskRepository;
  late IMultimediaRepository _multimediaRepository;

  late GetTaskUseCase _getTaskUseCase;
  late GetMultimediaUseCase _getMultimediaUseCase;

  late HomeController _taskSelectController;
  late TaskViewController _taskViewController;

  @override
  void initState() {
    super.initState();
    Dio dioAuthed = DioAuthed().dio;

    _taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dioAuthed);
    _multimediaRemoteDataSource = MultimediaRemoteDataSourceImpl(dio: dioAuthed);

    _taskRepository = TaskRepositoryImpl(taskRemoteDataSource: _taskRemoteDataSource);
    _multimediaRepository = MultimediaRepositoryImpl(multimediaRemoteDataSource: _multimediaRemoteDataSource);

    _getTaskUseCase = GetTaskUseCase(taskRepository: _taskRepository);
    _getMultimediaUseCase = GetMultimediaUseCase(multimediaRepository: _multimediaRepository);

    _taskSelectController = HomeController(getTaskUseCase: _getTaskUseCase);
    _taskViewController = TaskViewController(getMultimediaUseCase: _getMultimediaUseCase);
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
        builder: (context, child) => HomePage(taskSelectController: _taskSelectController, taskViewController: _taskViewController, userProvider: _userProvider),
      ),
    );
  }
}
