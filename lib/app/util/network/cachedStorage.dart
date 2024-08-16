import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class CachedStorage {
  static final CachedStorage _singleton = CachedStorage._internal();

  DatabaseFactory dbFactory = databaseFactoryIo;
  late Database db;
  var store = StoreRef.main();

  Future<bool> initDB() async {
    try{
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, 'local_tasks.db');
      print("DATABASE: ${dbPath}");
      db = await databaseFactoryIo.openDatabase(dbPath);
      return true;
    } catch(e){
      print("Erro ao iniciar DB");
      return false;
    }
  }

  refreshDB() async {
    await db.checkForChanges();
  }

  factory CachedStorage() => _singleton;

  CachedStorage._internal(){
    // initDB();
  }
}
