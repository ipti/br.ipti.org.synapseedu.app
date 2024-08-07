import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:elesson/app/core/block/data/datasource/block_remote_datasource.dart';
import 'package:elesson/app/core/task/data/datasource/performance_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/block_repository_interface.dart';
import 'package:elesson/app/core/task/domain/usecase/send_performance_usecase.dart';
import 'package:elesson/app/feature/home_offline/controller/offline_controller.dart';
import 'package:elesson/app/feature/home_offline/page/leason_dowload_page.dart';
import 'package:elesson/app/feature/home_offline/page/syncronize_offline_page.dart';
import 'package:elesson/app/feature/home_offline/page/teacher_blocks_page.dart';
import 'package:elesson/app/util/network/cachedStorage.dart';
import 'package:elesson/app/util/network/dio_authed/dio_authed.dart';
import 'package:flutter/material.dart';

import '../../core/auth/data/datasource/local/auth_local_datasource.dart';
import '../../core/auth/data/datasource/remote/auth_remote_datasource.dart';
import '../../core/auth/data/repository/auth_repository_interface.dart';
import '../../core/auth/domain/entity/auth_entity.dart';
import '../../core/auth/domain/repository/auth_repository_impl.dart';
import '../../core/auth/domain/usecases/auth_usecase.dart';
import '../../core/block/data/model/block_model.dart';
import '../../core/block/domain/repository/block_repository_impl.dart';
import '../../core/shared/domain/repository/cacheRepository.dart';
import '../../core/task/data/repository/performance_repository_interface.dart';
import '../../core/task/domain/repository/performance_repository_impl.dart';
import '../../util/network/constants.dart';

class HomePageOfflineModule extends StatefulWidget {
  const HomePageOfflineModule({super.key});

  @override
  State<HomePageOfflineModule> createState() => _HomePageOfflineModuleState();
}

class _HomePageOfflineModuleState extends State<HomePageOfflineModule> {
  TextEditingController _teacherCodeController = TextEditingController();


  late CacheRepository cacheRepository;
  late DioAuthed dioAuthed;
  late IBlockRemoteDataSource blockRemoteDataSource;
  late IBlockRepository blockRepository;
  late OfflineController offlineController;
  late IPerformanceDatasource _performanceDatasource;
  late IPerformanceRepository _performanceRepository;
  late SendPerformanceUseCase sendPerformanceUseCase;

  @override
  void initState() {
    AuthRemoteDataSource _authRemoteDatasourceImpl = AuthRemoteDatasourceImpl(dio: Dio()..options.baseUrl = URLBASE);
    AuthLocalDataSource _authLocalDatasourceImpl = AuthLocalDatasourceImpl();
    AuthRepositoryInterface authRepository = AuthRepositoryImpl(authLocalDataSource: _authLocalDatasourceImpl, authRemoteDataSource: _authRemoteDatasourceImpl);
    AuthUseCase _authUseCase = AuthUseCase(authRepository: authRepository);

    _authUseCase.getAccessToken(AuthEntity(username: "editor", password: "iptisynpaseeditor2022"));

    dioAuthed = DioAuthed();

    blockRemoteDataSource = BlockRemoteDataSourceImpl(dio: dioAuthed.dio);
    blockRepository = BlockRepositoryImpl(blockRemoteDataSource: blockRemoteDataSource);

    cacheRepository = CacheRepository();
    offlineController = OfflineController.instance;

    _performanceDatasource = PerformanceRemoteDatasource(dio: dioAuthed.dio);
    _performanceRepository = PerformanceRepositoryImpl(performanceDataSource: _performanceDatasource);
    sendPerformanceUseCase = SendPerformanceUseCase(performanceRepository: _performanceRepository);

    super.initState();
  }

  List<int> cachedBlocksIds = [];
  bool inited = false;
  bool searchByCode = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Offline'),
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => syncronizeOfflinePage(offlineController: offlineController, sendPerformanceUseCase: sendPerformanceUseCase)))
                    .then((value) => setState(() => inited = false));
              },
              icon: Icon(Icons.sync)),
        ],
      ),
      body: FutureBuilder(
          future: inited ? null : cacheRepository.getListCachedBlocs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              inited = true;
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data != null) {
              cachedBlocksIds = snapshot.data as List<int>;
            }
            return SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Código do professor", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

                      // Container(
                      //   width: size.width * 0.7,
                      //   height: 40,
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 3, color: Color.fromRGBO(110, 114, 145, 0.2))),
                      //   padding: EdgeInsets.symmetric(horizontal: 5),
                      //   child: TextFormField(controller: _teacherCodeController, keyboardType: TextInputType.number, decoration: InputDecoration(border: InputBorder.none)),
                      // ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: size.width * 0.7,
                            height: 40,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 3, color: Color.fromRGBO(110, 114, 145, 0.2))),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: TextFormField(controller: _teacherCodeController, keyboardType: TextInputType.number, decoration: InputDecoration(border: InputBorder.none)),
                          ),
                          IconButton(
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                              onPressed: () async {
                                List<BlockModel> res =
                                    await blockRepository.getBlockByTeacherId(int.parse(_teacherCodeController.text)).then((value) => value.fold((l) => [], (r) => r));
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => TeacherBlocksPage(list_block: res, offlineController: offlineController)))
                                    .then((value) => setState(() {
                                          inited = false;
                                        }));
                              },
                              icon: Icon(Icons.send)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  cachedBlocksIds.isEmpty
                      ? Expanded(child: Center(child: Text("Nenhuma aula disponível Offline", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))))
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Aulas disponíveis", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                IconButton(
                                  onPressed: () async {
                                    await cacheRepository.refreshDB();
                                    cachedBlocksIds = await cacheRepository.getListCachedBlocs();
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: cachedBlocksIds.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      width: size.width * 0.8,
                                      height: 50,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: Color.fromRGBO(110, 114, 145, 0.2))),
                                      child: InkWell(
                                        onTap: () async {
                                          BlockModel block = await cacheRepository.getBlock(cachedBlocksIds[index]);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => LeasonDownloadPage(block: block, offlineController: offlineController)),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: AutoSizeText(
                                                "Aula ${cachedBlocksIds[index]}",
                                                textAlign: TextAlign.start,
                                                minFontSize: 14,
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25, fontFamily: 'Comic'),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.green, width: 2)),
                                              width: 30,
                                              height: 30,
                                              child: Icon(Icons.task_alt, color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          }),
    );
  }
}
