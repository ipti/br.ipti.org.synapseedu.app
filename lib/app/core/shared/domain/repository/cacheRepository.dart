import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/util/network/cachedStorage.dart';
import 'package:sembast/sembast.dart';
import '../../../../util/enums/task_types.dart';
import '../../../block/data/model/block_model.dart';
import '../../../task/data/model/performance_model.dart';

final BLOCK_CACHE_KEY = "BLOCK_CACHED_";
final TASKS_CACHE_KEY = "TASKS_CACHED_";
final MULTIMEDIA_BYTES_CACHE_KEY = "MULTIMEDIA_BYTES_CACHED_";
final TEXT_CACHE_KEY = "TEXT_CACHED_";
final PERFORMANCE_PENDING_CACHE_KEY = "PERFORMANCE_PENDING_CACHED_";
final PERFORMANCE_SYNCED_CACHE_KEY = "PERFORMANCE_SYNCED_CACHED_";

/// DEFAULT CACHE KEY
/// KEY+ID
/// ex: BLOCK_CACHED_1

class CacheRepository {
  // DatabaseFactory dbFactory = databaseFactoryIo;
  late Database db;
  late StoreRef store;

  CacheRepository() {
    db = CachedStorage().db;
    store = CachedStorage().store;
  }

  Future refreshDB()async{
    await db.checkForChanges();
  }

  Future<List<int>> getListCachedBlocs() async {

    var res = await store.findKeys(db, finder: Finder(filter: Filter.custom((record) => record.key.toString().startsWith(BLOCK_CACHE_KEY))));
    return res.map((e) => int.parse(e.toString().replaceAll(BLOCK_CACHE_KEY, ""))).toList();
  }

  Future<void> saveBlock(BlockModel block) async {
    await store.record("${BLOCK_CACHE_KEY}${block.id}").add(db, block.toJson());
  }

  Future<BlockModel> getBlock(int id) async {
    var record = await store.record("${BLOCK_CACHE_KEY}${id}").get(db);
    return BlockModel.fromJson(record as Map<String, dynamic>);
  }

  Future<bool> saveTasks(TaskModel task) async {
    try {
      await store.record("${TASKS_CACHE_KEY}${task.id}").add(db, task.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveMultimediaBytes(List<int> multimediaBytes, int multimediaId) async {
    try {
      await store.record("${MULTIMEDIA_BYTES_CACHE_KEY}${multimediaId}").add(db, multimediaBytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<int>> getMultimediaBytes(int multimediaId) async {
    var record = await store.record("${MULTIMEDIA_BYTES_CACHE_KEY}${multimediaId}").get(db);
    return record as List<int>;
  }

  Future<bool> saveText(String text, int multimediaId) async {
    try {
      await store.record("${TEXT_CACHE_KEY}${multimediaId}").add(db, text);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getText(int multimediaId) async {
    var record = await store.record("${TEXT_CACHE_KEY}${multimediaId}").get(db);
    return record as String;
  }

  Future<bool> clearCache() async {
    await store.delete(db);
    return true;
  }

  Future<bool> verifyTaskInCache(int id) async {
    var record = await store.record("${TASKS_CACHE_KEY}${id}").get(db);
    return record != null;
  }

  Future<List<Performance>> getAllPerformanceFromStudent(int studentId) async {
    var performanceValuesList = await store.find(db, finder: Finder(filter: Filter.custom((record) => record.key.toString().endsWith("_${studentId}"))));
    return performanceValuesList.map((e) => Performance.fromJson(e.value as Map<String, dynamic>)).toList();
  }

  Future<List<Performance>> getAllPerformancesPending() async {
    var all = await store.findKeys(db);
    print(all.where((element) => element.toString().contains("PERFORMANCE")).toList());
    var performanceValuesList = await store.find(db, finder: Finder(filter: Filter.custom((record) => record.key.toString().startsWith(PERFORMANCE_PENDING_CACHE_KEY))));
    // print(performanceValuesList.length);
    return performanceValuesList.map((e) => Performance.fromJson(e.value as Map<String, dynamic>)).toList();
  }

  Future<List<Performance>> getAllPerformancesSynced() async {
    var performanceValuesList = await store.find(db, finder: Finder(filter: Filter.custom((record) => record.key.toString().startsWith(PERFORMANCE_SYNCED_CACHE_KEY))));
    return performanceValuesList.map((e) => Performance.fromJson(e.value as Map<String, dynamic>)).toList();
  }

  Future<bool> moveToSyncedPerformanceInCache(Performance performance) async {
    try{
      var resAdd = await store.record("${PERFORMANCE_SYNCED_CACHE_KEY}${performance.taskId}_${performance.student_id}").put(db, performance.toJson(templateType: templateTypesfromTemplateId(performance.taskId)));
      if(resAdd == null) return false;
      var resDelete = await store.record("${PERFORMANCE_PENDING_CACHE_KEY}${performance.taskId}_${performance.student_id}").delete(db);
      return resDelete != null;
    } catch(e){
      return false;
    }
  }

  Future<bool> clearSyncedTasks() async {
    var res = await store.delete(db, finder: Finder(filter: Filter.custom((record) => record.key.toString().startsWith(PERFORMANCE_SYNCED_CACHE_KEY))));
    return res != null;
  }
}
