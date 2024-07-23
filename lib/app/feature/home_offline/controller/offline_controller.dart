import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:elesson/app/core/shared/domain/repository/cacheRepository.dart';
import 'package:elesson/app/core/task/data/datasource/multimedia_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/feature/task/controller/multimedia_controller.dart';
import 'package:elesson/app/util/enums/multimedia_types.dart';
import 'package:flutter/material.dart';

import '../../../core/block/data/model/block_model.dart';
import '../../../core/task/data/datasource/task_remote_datasource.dart';
import '../../../core/task/data/model/performance_model.dart';
import '../../../core/task/data/model/task_model.dart';
import '../../../core/task/data/repository/task_repository_interface.dart';
import '../../../core/task/domain/repository/multimedia_repository_impl.dart';
import '../../../core/task/domain/repository/task_repository_impl.dart';
import '../../../core/task/domain/usecase/Multimedia_usecase.dart';
import '../../../core/task/domain/usecase/get_task_usecase.dart';
import '../../../util/failures/failures.dart';
import '../../../util/network/dio_authed/dio_authed.dart';

class OfflineController extends ChangeNotifier {
  static final OfflineController _instance = OfflineController._();

  OfflineController._();

  static OfflineController get instance {
    return _instance;
  }

  CacheRepository cacheRepository = CacheRepository();
  Dio dioAuthed = DioAuthed().dio;

  late ITaskRemoteDataSource _taskRemoteDataSource = TaskRemoteDataSourceImpl(dio: dioAuthed);
  late ITaskRepository _taskRepository = TaskRepositoryImpl(taskRemoteDataSource: _taskRemoteDataSource);
  late GetTaskUseCase _getTaskUseCase = GetTaskUseCase(taskRepository: _taskRepository);

  late IMultimediaRemoteDatasource _multimediaRemoteDatasource = MultimediaRemoteDataSourceImpl(dio: dioAuthed);
  late IMultimediaRepository _multimediaRepository = MultimediaRepositoryImpl(multimediaRemoteDataSource: _multimediaRemoteDatasource);
  late MultimediaUseCase _getMultimediaUseCase = MultimediaUseCase(multimediaRepository: _multimediaRepository);

  Future<bool> saveBlockToCache(BlockModel block) async {
    try {
      await cacheRepository.saveBlock(block);
      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  Future<bool> moveToSyncedPerformanceInCache(Performance performance) async {
    return await cacheRepository.moveToSyncedPerformanceInCache(performance);
  }

  Future<bool> downloadTaskToCache(int id) async {
    List<int> imagesIds = [];
    List<int> textIds = [];
    List<int> audioIds = [];

    if (await verifyTaskInCache(id)) return true;
    Either<Failure, TaskModel> taskEithered = await _getTaskUseCase.getTaskById(id);
    TaskModel task = taskEithered.getOrElse(() => TaskModel.empty());

    await cacheRepository.saveTasks(task);

    task.header?.components.forEach((componentModel) => componentModel.elements?.forEach((element) {
          if (element.type_id == MultimediaTypes.image.type_id) imagesIds.add(element.multimedia_id!);
          if (element.type_id == MultimediaTypes.text.type_id) textIds.add(element.multimedia_id!);
          if (element.type_id == MultimediaTypes.audio.type_id) audioIds.add(element.multimedia_id!);
        }));

    task.body?.components.forEach((componentModel) => componentModel.elements?.forEach((element) {
          if (element.type_id == MultimediaTypes.image.type_id) imagesIds.add(element.multimedia_id!);
          if (element.type_id == MultimediaTypes.text.type_id) textIds.add(element.multimedia_id!);
          if (element.type_id == MultimediaTypes.audio.type_id) audioIds.add(element.multimedia_id!);
        }));

    await Future.forEach(imagesIds, (id) async {
      Either<Failure, List<int>> resImage = await _getMultimediaUseCase.getBytesByMultimediaId(id);
      resImage.fold((l) => print(l), (r) async {
        bool resSave = await cacheRepository.saveMultimediaBytes(r, id);
        // Future.delayed(Duration(milliseconds: 500));
      });
    });

    await Future.forEach(audioIds, (id) async {
      Either<Failure, Uint8List> resAudio = await _getMultimediaUseCase.getSoundByMultimediaId(id);
      resAudio.fold((l) => print(l), (r) async {
        bool resSave = await cacheRepository.saveMultimediaBytes(r, id);
        // Future.delayed(Duration(milliseconds: 500));
      });
    });

    await Future.forEach(textIds, (id) async {
      Either<Failure, String> resText = await _getMultimediaUseCase.getTextById(id);
      resText.fold((l) => print(l), (r) async {
        bool resSave = await cacheRepository.saveText(r, id);
        // Future.delayed(Duration(milliseconds: 500));
      });
    });

    return true;
  }

  Future<bool> verifyTaskInCache(int id) async {
    return await cacheRepository.verifyTaskInCache(id);
  }

  Future<List<Performance>> getAllPerformancesPending() async {
    return await cacheRepository.getAllPerformancesPending();
  }

  Future<List<Performance>> getAllPerformancesSynced() async {
    return await cacheRepository.getAllPerformancesSynced();
  }

  Future<void> clearSyncedTasks() async {
    await cacheRepository.clearSyncedTasks();
  }

  Future<List<Performance>> getAllPerformanceFromStudent(int studentId) async {
    return cacheRepository.getAllPerformanceFromStudent(studentId);
  }
}
