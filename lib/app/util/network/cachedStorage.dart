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
      print("Iniciando DB");
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, 'local_tasks.db');
      db = await databaseFactoryIo.openDatabase(dbPath);
      print("DB Pronto");
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
