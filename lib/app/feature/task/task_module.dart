import 'package:dio/dio.dart';
import 'package:elesson/app/core/task/data/datasource/multimedia_remote_datasource.dart';
import 'package:elesson/app/core/task/data/datasource/performance_remote_datasource.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/core/task/domain/repository/multimedia_repository_impl.dart';
import 'package:elesson/app/core/task/domain/usecase/get_multimedia_usecase.dart';
import 'package:elesson/app/feature/task/page/task_view_page.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/task/data/repository/performance_repository_interface.dart';
import '../../core/task/domain/repository/performance_repository_impl.dart';
import '../../core/task/domain/usecase/send_performance.dart';
import 'controller/task_view_controller.dart';

class TaskModule extends StatefulWidget {
  static const routeName = '/task-module';
  final TaskModel taskModel;

  const TaskModule({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<TaskModule> createState() => _TaskModuleState();
}

class _TaskModuleState extends State<TaskModule> {
  late IMultimediaRemoteDatasource _multimediaRemoteDataSource;
  late IPerformanceRemoteDatasource _performanceRemoteDataSource;
  late IMultimediaRepository _multimediaRepository;
  late IPerformanceRepository _performanceRepository;
  late GetMultimediaUseCase _getMultimediaUseCase;
  late SendPerformanceUseCase _sendPerformanceUseCase;
  late TaskViewController _taskViewController;

  @override
  void initState() {
    super.initState();
    Dio dioAuthed = DioAuthed().dio;

    _multimediaRemoteDataSource = MultimediaRemoteDataSourceImpl(dio: dioAuthed);
    _multimediaRepository = MultimediaRepositoryImpl(multimediaRemoteDataSource: _multimediaRemoteDataSource);
    _getMultimediaUseCase = GetMultimediaUseCase(multimediaRepository: _multimediaRepository);

    _performanceRemoteDataSource = PerformanceRemoteDatasource(dio: dioAuthed);
    _performanceRepository = PerformanceRepositoryImpl(performanceRemoteDataSource: _performanceRemoteDataSource);
    _sendPerformanceUseCase = SendPerformanceUseCase(performanceRepository: _performanceRepository);
  }

  @override
  void didChangeDependencies() {
    int userId = Provider.of<UserProvider>(context, listen: false).user.id;
    _taskViewController = TaskViewController(
      getMultimediaUseCase: _getMultimediaUseCase,
      sendPerformanceUseCase: _sendPerformanceUseCase,
      task: widget.taskModel,
      userId: userId,
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _taskViewController,
      builder: (context, child) => TaskViewPage(taskViewController: _taskViewController, taskModel: widget.taskModel),
    );
  }
}
