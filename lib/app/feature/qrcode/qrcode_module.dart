import 'package:dio/dio.dart';
import 'package:elesson/app/providers/block_provider.dart';
import 'package:elesson/app/util/network/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/auth/data/datasource/local/auth_local_datasource.dart';
import '../../core/auth/data/datasource/remote/auth_remote_datasource.dart';
import '../../core/auth/data/repository/auth_repository_interface.dart';
import '../../core/auth/domain/entity/auth_entity.dart';
import '../../core/auth/domain/repository/auth_repository_impl.dart';
import '../../core/auth/domain/usecases/auth_usecase.dart';
import '../../core/block/data/datasource/block_remote_datasource.dart';
import '../../core/block/data/model/block_model.dart';
import '../../core/block/domain/repository/block_repository_impl.dart';
import '../../core/block/domain/usecase/get_block_usecase.dart';
import '../../core/task/data/repository/block_repository_interface.dart';
import '../../util/network/dio_authed/dio_authed.dart';
import 'controller/qrcode_controller.dart';
import 'page/qrcode_page.dart';

class QrCodeModule extends StatefulWidget {
  final BlockModel? blockModelOffline;
  const QrCodeModule({super.key, this.blockModelOffline});

  @override
  State<QrCodeModule> createState() => _QrCodeModuleState();
}

class _QrCodeModuleState extends State<QrCodeModule> {
  late IBlockRemoteDataSource _blockRemoteDataSource;
  late IBlockRepository _blockRepository;
  late GetBlockUsecase _getBlockUseCase;

  late QrCodeController _qrCodeController;
  late BlockProvider _blockProvider;

  @override
  void initState() {
    super.initState();
    Dio dioAuthed = DioAuthed().dio;

    _blockRemoteDataSource = BlockRemoteDataSourceImpl(dio: dioAuthed);
    _blockRepository = BlockRepositoryImpl(blockRemoteDataSource: _blockRemoteDataSource);
    _getBlockUseCase = GetBlockUsecase(repository: _blockRepository);

    _blockProvider = Provider.of<BlockProvider>(context, listen: false);

    AuthRemoteDataSource _authRemoteDatasourceImpl = AuthRemoteDatasourceImpl(dio: Dio()..options.baseUrl = URLBASE);
    AuthLocalDataSource _authLocalDatasourceImpl = AuthLocalDatasourceImpl();
    AuthRepositoryInterface authRepository = AuthRepositoryImpl(authLocalDataSource: _authLocalDatasourceImpl, authRemoteDataSource: _authRemoteDatasourceImpl);
    AuthUseCase _authUseCase = AuthUseCase(authRepository: authRepository);

    _authUseCase.getAccessToken(AuthEntity(username: "editor", password: "iptisynpaseeditor2022"));

    _qrCodeController = QrCodeController(getBlockUsecase: _getBlockUseCase, blockProvider: _blockProvider, authUseCase: _authUseCase);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
          animation: _qrCodeController,
          builder: (context, child) => QrCodePage(qrCodeController: _qrCodeController, blockModelOffline: widget.blockModelOffline)
          ),
    );
  }
}
