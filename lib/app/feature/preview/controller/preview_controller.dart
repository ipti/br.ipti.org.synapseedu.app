import 'dart:developer';

import 'package:elesson/app/core/auth/domain/entity/auth_entity.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';

class PreviewController extends ChangeNotifier{
  final AuthUseCase authUseCase;
  PreviewController({required this.authUseCase});

  AuthEntity _webAppAuthEntity = AuthEntity(username: "editor", password: "iptisynpaseeditor2022");

  Future<void> getAcessToken()async{
    await authUseCase.getAccessToken(_webAppAuthEntity).then((value) {
      value.fold((l) {
        log("Erro: ${l.message}");
      }, (r) {
        log("Logado com Sucesso");
      });
    });
    print("Finalizou getAcessToken");
    return;
  }
}