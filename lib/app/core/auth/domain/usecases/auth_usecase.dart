import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/auth/data/repository/auth_repository_interface.dart';
import 'package:elesson/app/core/auth/domain/entity/login_entity.dart';
import 'package:elesson/app/util/failures/failures.dart';
import '../entity/auth_entity.dart';
import '../entity/auth_response_entity.dart';
import '../entity/login_response_entity.dart';

class AuthUseCase {
  final AuthRepositoryInterface authRepository;
  AuthUseCase({required this.authRepository});

  Future<Either<Failure, LoginResponseEntity>> verifyAuth() async {
    final result = await authRepository.getStoredUserData();
    if (result.isLeft()) {
      authRepository.logout();
    }
    return result;
  }

  //getAccessToken
  Future<Either<Failure, AuthResponseEntity>> getAccessToken(AuthEntity authEntity) async {
    Either<Failure, AuthResponseEntity> authResponseEntity = await authRepository.getAccessToken(authEntity.username, authEntity.password);

    authResponseEntity.fold(
      id,
      (authToken) => _cacheTokenValues(authToken),
    );

    return authResponseEntity;
  }

  Future<Either<Failure, LoginResponseEntity>> login(LoginEntity authLoginEntity) async {
    Either<Failure, LoginResponseEntity> loginResponseEntity = await authRepository.login(authLoginEntity);

    loginResponseEntity.fold(
      id,
      (authToken) => _cacheSessionValues(authToken),
    );

    return loginResponseEntity;
  }

  Future _cacheSessionValues(LoginResponseEntity response) async {
    await Future.wait([authRepository.storeUserData(response)]);
  }

  Future _cacheTokenValues(AuthResponseEntity response) async {
    await Future.wait([
      authRepository.storeAccessToken(response.token),
    ]);
  }
}
