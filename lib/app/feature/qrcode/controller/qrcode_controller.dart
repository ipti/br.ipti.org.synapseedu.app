import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/block/domain/usecase/get_block_usecase.dart';
import 'package:elesson/app/feature/task/task_module.dart';
import 'package:elesson/app/providers/block_provider.dart';
import 'package:flutter/material.dart';
import '../../../core/auth/domain/usecases/auth_usecase.dart';
import '../../../core/block/data/model/block_model.dart';
import '../../../core/block/domain/entity/block_parameters_entity.dart';
import '../../../util/failures/failures.dart';

///Essa controladora deve ser instanciada com o
///parametro "getBlockUsecase" caso queira receber
///dados do bloco
class QrCodeController extends ChangeNotifier {
  final BlockProvider blockProvider;
  final GetBlockUsecase getBlockUsecase;
  final AuthUseCase authUseCase;

  QrCodeController({required this.getBlockUsecase, required this.blockProvider, required this.authUseCase});

  String _screenMessage = "APONTE PARA A CHAVE \n DE ACESSO";

  String get screenMessage => _screenMessage;

  Future<void> setBlockOffline(BuildContext context, BlockModel blockModel) async {
    blockProvider.setNewBlock(blockModel);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TaskModule(taskId: blockProvider.firstTaskId, offline: true)));
  }

  //BlockParameterEntity(disciplineId: 2, teacherId: 5, studentId: 1)
  Future<void> getBlock(BuildContext context, BlockParameterEntity blockParameterEntity) async {
    _screenMessage = "Buscando Questões...";
    notifyListeners();
    Either<Failure, BlockModel> res = await getBlockUsecase.call(blockParameterEntity);
    res.fold(
      (l) {
        log(l.toString(), name: "QR CODE");
        _screenMessage = "Erro ao encontrar questões!";
        notifyListeners();
      },
      (r) {
        blockProvider.setNewBlock(r);
        int? taskId = blockProvider.firstTaskId;
        if (taskId == null) {
          _screenMessage = "Você Já Terminou Este Bloco!";
          notifyListeners();
          return;
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TaskModule(taskId: blockProvider.firstTaskId)));
      },
    );
  }
}
