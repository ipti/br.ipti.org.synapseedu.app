import 'dart:typed_data';
import 'package:sembast/sembast.dart';
import '../../../../util/network/cachedStorage.dart';
import '../../../shared/domain/repository/cacheRepository.dart';
import 'multimedia_remote_datasource.dart';

class MultimediaCachedDataSourceImpl extends IMultimediaRemoteDatasource {
  late Database db;
  late StoreRef store;

  MultimediaCachedDataSourceImpl() {
    db = CachedStorage().db;
    store = CachedStorage().store;
  }

  @override
  Future<Stream<Uint8List>> downloadSound(String nameAudio) async {
    var res = await store.record(nameAudio).get(db);
    List<int> resList = (res as List<dynamic>).map((e) => e as int).toList();
    return Stream.fromIterable([Uint8List.fromList(resList)]);
  }

  @override
  Future<List<int>> getBytesByMultimediaReference(String reference) async {
    var res = await store.record(reference).get(db);
    List<int> resList = (res as List<dynamic>).map((e) => e as int).toList();
    return resList;
  }

  @override
  Future<String> getImageMultimediaReference(int multimediaId) async {
    return MULTIMEDIA_BYTES_CACHE_KEY + multimediaId.toString();
  }

  @override
  Future<String> getSoundByMultimediaId(int id) async {
    return MULTIMEDIA_BYTES_CACHE_KEY + id.toString();
  }

  @override
  Future<String> getTextById(int id) async {
    return await store.record("${TEXT_CACHE_KEY}${id}").get(db) as String;
  }

  @override
  Future<String> getTextOfImage(String base64Image, String googleApiToken) {
    // TODO: implement getTextOfImage
    throw UnimplementedError();
  }
}
