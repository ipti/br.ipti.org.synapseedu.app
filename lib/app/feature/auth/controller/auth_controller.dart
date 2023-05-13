import 'package:dartz/dartz.dart';
import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/app/core/auth/data/model/user_model.dart';
import 'package:elesson/app/core/auth/domain/entity/auth_entity.dart';
import 'package:elesson/app/core/auth/domain/entity/login_response_entity.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:elesson/app/feature/providers/userProvider.dart';
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
        //TODO: remover isso quando deixar tudo padronizado, apenas uma solução temporaria já que existem outras classes ainda fora do padrão de arquitetura que usam esse recurso
        if (res.isRight()) {
          LoginResponseEntity loginResponseEntity = res.getOrElse(() => LoginResponseEntity.empty());
          UserModel userModel = UserModel(
            id: loginResponseEntity.id,
            user_name: loginResponseEntity.user_name,
            name: loginResponseEntity.name,
            user_type_id: loginResponseEntity.user_type_id,
          );
          context.read<UserProvider>().setUser(userModel);
          Navigator.of(context).pushNamedAndRemoveUntil(BlockSelection.routeName, (route) => false);
        }
      });
    });
  }

  Future<Either<Failure, LoginResponseEntity>> login() async {
    Either<Failure, LoginResponseEntity> res = await authUseCase.login(_authLoginEntity);
    return res.fold((l) {
      _showFeedback = true;
      _feedback = l.message;
      _showLoading = false;
      notifyListeners();
      return Left(RestFailure(l.message));
    }, (r) {
      _showFeedback = true;
      _feedback = "Bem vindo, ${r.user_name}";
      _showLoading = false;
      // FeaturePermission().setUserType(r.user_type_id);
      notifyListeners();
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
