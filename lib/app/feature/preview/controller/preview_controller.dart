import 'dart:developer';

import 'package:elesson/app/core/auth/domain/entity/auth_entity.dart';
import 'package:elesson/app/core/auth/domain/usecases/auth_usecase.dart';
import 'package:flutter/material.dart';

import '../../../core/task/domain/usecase/get_task_usecase.dart';
import '../../task/task_module.dart';

class PreviewController extends ChangeNotifier {
  final AuthUseCase authUseCase;
  final GetTaskUseCase getTaskUseCase;

  PreviewController({required this.authUseCase, required this.getTaskUseCase});

  AuthEntity _webAppAuthEntity = AuthEntity(username: "editor", password: "iptisynpaseeditor2022");

  Future<bool> getAcessToken() async {
    return await authUseCase.getAccessToken(_webAppAuthEntity).then((value ) {
      return value.fold((l) {
        log("Erro: ${l.message}");
        return false;
      }, (r) {
        log("Logado com Sucesso");
        return true;
      });
    });
  }

  void submitSearchTaskById(BuildContext context, int taskId) async {
    final bool = await getAcessToken();
    if (bool) {
      final res = await getTaskUseCase.getTaskById(taskId);
      res.fold(
        (l) {
          log("Erro: ${l.message}");
        },
        (r) {
          return Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskModule(taskModel: r)));
        },
      );
    }
  }
}
