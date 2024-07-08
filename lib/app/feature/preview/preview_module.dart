import 'package:elesson/app/core/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'package:elesson/app/core/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:elesson/app/core/auth/data/repository/auth_repository_interface.dart';
import 'package:elesson/app/core/task/data/repository/task_repository_interface.dart';
import 'package:elesson/app/core/auth/domain/repository/auth_repository_impl.dart';
import 'package:elesson/app/core/task/data/datasource/task_remote_datasource.dart';
import 'package:elesson/app/core/task/domain/repository/task_repository_impl.dart';
import 'package:elesson/app/core/task/domain/usecase/get_task_usecase.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:elesson/app/util/network/constants.dart';
import 'controller/preview_controller.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


class PreviewModule extends StatefulWidget {
  final int id;

  const PreviewModule({required this.id});

  @override
  State<PreviewModule> createState() => _PreviewModuleState();
}

class _PreviewModuleState extends State<PreviewModule> {

  late PreviewController _previewController;

  @override
  void initState() {
    super.initState();
    Dio dio = Dio();
    dio.options.baseUrl = URLBASE;
    dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 90));

    Dio dioAuthed = DioAuthed().dio;

    ITaskRemoteDataSource _taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dioAuthed);
    ITaskRepository _taskRepository = TaskRepositoryImpl(taskRemoteDataSource: _taskRemoteDataSource);
    GetTaskUseCase _getTaskUseCase = GetTaskUseCase(taskRepository: _taskRepository);

    AuthRemoteDataSource _authRemoteDatasourceImpl = AuthRemoteDatasourceImpl(dio: dio);
    AuthLocalDataSource _authLocalDatasourceImpl = AuthLocalDatasourceImpl();
    AuthRepositoryInterface authRepository = AuthRepositoryImpl(authLocalDataSource: _authLocalDatasourceImpl, authRemoteDataSource: _authRemoteDatasourceImpl);
    AuthUseCase _authUseCase = AuthUseCase(authRepository: authRepository);
    _previewController = PreviewController(authUseCase: _authUseCase, getTaskUseCase: _getTaskUseCase);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _previewController.submitSearchTaskById(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
