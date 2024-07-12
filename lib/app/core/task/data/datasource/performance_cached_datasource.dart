import 'package:elesson/app/core/task/data/datasource/performance_remote_datasource.dart';
import 'package:elesson/app/core/task/data/model/metadata_model.dart';
import 'package:elesson/app/core/task/data/model/performance_model.dart';
import 'package:elesson/app/util/enums/task_types.dart';
import 'package:sembast/sembast.dart';

import '../../../../util/network/cachedStorage.dart';
import '../../../shared/domain/repository/cacheRepository.dart';

class PerformanceCachedDataSourceImpl implements IPerformanceDatasource {
  late Database db;
  late StoreRef store;

  PerformanceCachedDataSourceImpl() {
    db = CachedStorage().db;
    store = CachedStorage().store;
  }

  @override
  Future<Performance> sendPerformanceAEL(Performance performance) async {
    print(performance.toJson(templateType: TemplateTypes.AEL));
    await store.record("${PERFORMANCE_PENDING_CACHE_KEY}${performance.taskId}_${performance.student_id}").add(db, performance.toJson(templateType: TemplateTypes.AEL));
    return Performance.empty();
  }

  @override
  Future<Performance> sendPerformanceMTE(Performance performance) async {
    print(performance.toJson(templateType: TemplateTypes.MTE));
    await store.record("${PERFORMANCE_PENDING_CACHE_KEY}${performance.taskId}_${performance.student_id}").add(db, performance.toJson(templateType: TemplateTypes.MTE));
    return Performance.empty();
  }

  @override
  Future<Performance> sendPerformancePRE(Performance performance) async {
    print(performance.toJson(templateType: TemplateTypes.PRE));
    await store.record("${PERFORMANCE_PENDING_CACHE_KEY}${performance.taskId}_${performance.student_id}").add(db, performance.toJson(templateType: TemplateTypes.PRE));
    return Performance.empty();
  }

}
