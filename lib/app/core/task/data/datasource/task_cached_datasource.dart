import 'package:elesson/app/util/network/cachedStorage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../../../shared/domain/repository/cacheRepository.dart';
import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'task_remote_datasource.dart';

class TaskCachedDataSourceImpl extends ITaskRemoteDataSource {
  DatabaseFactory dbFactory = databaseFactoryIo;
  late Database db;
  late StoreRef store;

  TaskCachedDataSourceImpl() {
    db = CachedStorage().db;
    store = CachedStorage().store;
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    var record = await store.record("${TASKS_CACHE_KEY}${id}").get(db);

    if (record != null) {
      TaskModel taskModel = TaskModel.fromJson(record as Map<String, dynamic>);
      return taskModel;
    }
    return TaskModel();
  }
}
