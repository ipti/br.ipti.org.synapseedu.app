import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/auth/domain/entity/auth_response_entity.dart';
import 'package:elesson/app/util/failures/failures.dart';
import '../../domain/entity/login_entity.dart';
import '../../domain/entity/login_response_entity.dart';

abstract class AuthRepositoryInterface {
  Future<Either<Failure, AuthResponseEntity>> getAccessToken(String username, String password);
  Future<Either<Failure, LoginResponseEntity>> login(LoginEntity authLoginEntity);

  Future<Either<Failure, String>> getStoredAccessToken();
  Future<Either<Failure, bool>> storeAccessToken(String token);

  Future<Either<Failure, bool>> storeUserData(LoginResponseEntity loginResponseEntity);
  Future<Either<Failure, LoginResponseEntity>> getStoredUserData();

  Future<Either<Failure, bool>> logout();
}
