import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/auth/domain/entity/auth_entity.dart';
import 'package:elesson/app/core/auth/domain/entity/login_response_entity.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:elesson/app/feature/home/home_module.dart';
import 'package:elesson/app/providers/userProvider.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/auth/domain/entity/login_entity.dart';

class AuthController extends ChangeNotifier {
  final AuthUseCase authUseCase;

  AuthController({required this.authUseCase});

  AuthEntity _webAppAuthEntity = AuthEntity(username: "editor", password: "iptisynpaseeditor2022");
  LoginEntity _authLoginEntity = LoginEntity.empty();

  LoginEntity get authLoginEntity => _authLoginEntity;
  set authLoginEntity(LoginEntity value) {
    _authLoginEntity = value;
  }

  getAcessToken(BuildContext context) async {
    _showLoading = true;
    notifyListeners();
    await authUseCase.getAccessToken(_webAppAuthEntity).then((value) {
      value.fold((l) {
        _showFeedback = true;
        _feedback = l.message;
        _showLoading = false;
        notifyListeners();
      }, (r) async {
        Either<Failure, LoginResponseEntity> res = await login();
        if (res.isRight()) {
          LoginResponseEntity loginResponseEntity = res.getOrElse(() => LoginResponseEntity.empty());
          context.read<UserProvider>().setUser(loginResponseEntity);
          Navigator.of(context).pushNamedAndRemoveUntil(HomeModule.routeName, (route) => false);
        }
      });
    });
  }

  Future<Either<Failure, LoginResponseEntity>> login() async {
    Either<Failure, LoginResponseEntity> res = await authUseCase.login(_authLoginEntity);
    return res.fold((l) {
      _feedback = l.message;
      _showFeedback = true;
      _showLoading = false;
      notifyListeners();
      return Left(RestFailure(l.message));
    }, (r) {
      _feedback = "Bem vindo, ${r.user_name}";
      _showFeedback = true;
      _showLoading = false;
      notifyListeners();
      return Right(r);
    });
  }

  //verifyLogin
  Future<Either<Failure, LoginResponseEntity>> verifyLogin() async {
    Either<Failure, LoginResponseEntity> res = await authUseCase.getLoginIfExist();
    return res.fold((l) {
      _feedback = l.message;
      _showFeedback = true;
      _showLoading = false;
      return Left(RestFailure(_feedback));
    }, (r) {
      _feedback = "Bem vindo de volta, ${r.user_name}";
      _showFeedback = true;
      _showLoading = false;
      return Right(r);
    });
  }

  String _feedback = "";

  String get feedback => _feedback;

  bool _showLoading = false;

  bool get showLoading => _showLoading;

  bool _showFeedback = false;

  bool get showFeedback => _showFeedback;
}
