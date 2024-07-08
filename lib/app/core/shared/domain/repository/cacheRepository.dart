import 'package:elesson/app/core/task/data/model/task_model.dart';
import 'package:elesson/app/util/network/cachedStorage.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../block/data/model/block_model.dart';

final BLOCK_CACHE_KEY = "BLOCK_CACHED_";
final TASKS_CACHE_KEY = "TASKS_CACHED_";
final MULTIMEDIA_BYTES_CACHE_KEY = "MULTIMEDIA_BYTES_CACHED_";
final TEXT_CACHE_KEY = "TEXT_CACHED_";
final PERFORMANCE_CACHE_KEY = "PERFORMANCE_CACHED_";

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

  // syncDB() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   await dir.create(recursive: true);
  //   var dbPath = join(dir.path, 'local_tasks.db');
  //   db = await databaseFactoryIo.openDatabase(dbPath);
  //   print("DB: $db");
  // }

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
      print("ERRO AO SALVAR MULTIMEDIA BYTES: $e");
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
      print("ERRO AO SALVAR TEXTO: $e");
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
}
