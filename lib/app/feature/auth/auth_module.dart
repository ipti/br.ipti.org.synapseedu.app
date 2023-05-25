import 'package:dartz/dartz.dart' as Dartz;
import 'package:dio/dio.dart';
import 'package:elesson/app/core/auth/data/datasource/local/auth_local_datasource.dart';
import 'package:elesson/app/core/auth/data/repository/auth_repository_interface.dart';
import 'package:elesson/app/core/auth/domain/entity/login_response_entity.dart';
import 'package:elesson/app/core/auth/domain/repository/auth_repository_impl.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:elesson/app/feature/auth/page/home_page.dart';
import 'package:elesson/app/feature/home/home_module.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:elesson/app/util/network/constants.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import '../../core/auth/data/datasource/remote/auth_remote_datasource.dart';
import 'controller/auth_controller.dart';

class AuthModule extends StatefulWidget {
  static const routeName = '/auth-module';

  const AuthModule({Key? key}) : super(key: key);

  @override
  State<AuthModule> createState() => _AuthModuleState();
}

class _AuthModuleState extends State<AuthModule> {
  late AuthController _authController;
  late AuthLocalDataSource authLocalDatasourceImpl;
  late Dio dio;
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    dio.options.baseUrl = URLBASE;

    AuthRemoteDataSource authRemoteDatasourceImpl = AuthRemoteDatasourceImpl(dio: dio);
    authLocalDatasourceImpl = AuthLocalDatasourceImpl();

    AuthRepositoryInterface authRepository = AuthRepositoryImpl(authLocalDataSource: authLocalDatasourceImpl, authRemoteDataSource: authRemoteDatasourceImpl);

    AuthUseCase _authUseCase = AuthUseCase(authRepository: authRepository);
    _authController = AuthController(authUseCase: _authUseCase);
  }
  Future<LoginResponseEntity> verifyLogin() async {
    initialized = true;
    Dartz.Either<Failure, LoginResponseEntity> res = await _authController.verifyLogin();
    return res.fold((l) => LoginResponseEntity.empty(), (r) {
      Provider.of<UserProvider>(context,listen: false).setUser(r);
      return r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: initialized ? null : verifyLogin(),
        builder: (context, AsyncSnapshot<LoginResponseEntity> snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return snapshot.data != LoginResponseEntity.empty()
                ? HomeModule()
                : AnimatedBuilder(
                    animation: _authController,
                    builder: (context, child) => AuthScreen(authController: _authController),
                  );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
