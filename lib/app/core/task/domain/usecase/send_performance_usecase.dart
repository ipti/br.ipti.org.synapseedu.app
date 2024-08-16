import 'package:elesson/app/core/task/data/model/performance_model.dart';
import 'package:elesson/app/core/task/domain/entity/user_answer.dart';
import 'package:elesson/app/util/enums/task_types.dart';
import '../../data/repository/performance_repository_interface.dart';
import '../../../../util/failures/failures.dart';
import '../../data/model/metadata_model.dart';
import '../../data/model/task_model.dart';
import 'package:dartz/dartz.dart';

class SendPerformanceUseCase {
  final IPerformanceRepository performanceRepository;

  SendPerformanceUseCase({required this.performanceRepository});

  Future<Either<Failure, bool>> call({String correctAnswerPre = "", required TaskModel task, required UserAnswer userAnswer}) async {
    var metaData = MetaDataModel.generate(task: task, userAnswer: userAnswer);

    DateTime tempoAgora = DateTime.now();
    Performance performance = Performance(
      taskId: task.id!,
      createdAt: tempoAgora,
      student_id: userAnswer.userId,
      isCorrect: true,
      block_id: task.block_id,
      timeResolution: tempoAgora.millisecondsSinceEpoch - userAnswer.performanceTime.millisecondsSinceEpoch,
      metadata: metaData,
    );


    switch (task.template_id) {
      case 1:
      case 5:
      case 6:
        performance.isCorrect = task.body!.components.first.id == userAnswer.AnswerMte.id;
        print("PERFORMANCE MTE: ${performance.toJson(templateType: TemplateTypes.MTE)}");
        await performanceRepository.sendPerformanceMTE(performance);
        return performance.isCorrect ? Right(true) : Left(Failure('Resposta incorreta'));
      case 2:
        performance.isCorrect = correctAnswerPre.toUpperCase() == userAnswer.AnswerPre.toUpperCase();
        print("PERFORMANCE PRE: ${performance.toJson(templateType: TemplateTypes.PRE)}");
        await performanceRepository.sendPerformancePRE(performance);
        return performance.isCorrect ? Right(true) : Left(Failure('Resposta incorreta'));
      case 3:
        performance.isCorrect = (metaData as MetaDataModelAEL).performanceStatus;
        print("PERFORMANCE AEL: ${performance.toJson(templateType: TemplateTypes.AEL)}");
        await performanceRepository.sendPerformanceAEL(performance);
        return performance.isCorrect ? Right(true) : Left(Failure('Resposta incorreta'));
      default:
        return Right(true);
        return Left(Failure('Tipo de tarefa não suportado'));
    }
  }

  Future<Either<Failure, bool>> offlineToOnline({required Performance performance}) async {
    print("OFFLINE TO ONLINE: ${performance.metadata.runtimeType}");
    performance.metadata = MetaDataModelMTE(template_type: "MTE", body_component_id: 1);
    switch (performance.metadata.runtimeType) {
      case MetaDataModelMTE:
        print("MTE ${performance.toJson(templateType: TemplateTypes.MTE)}");
        Either<Failure, Performance> res = await performanceRepository.sendPerformanceMTE(performance);
        return res.fold((l) => Left(l), (r) => Right(true));
      case MetaDataModelPRE:
        Either<Failure, Performance> res = await performanceRepository.sendPerformancePRE(performance);
        return res.fold((l) => Left(l), (r) => Right(true));
      case MetaDataModelAEL:
        Either<Failure, Performance> res = await performanceRepository.sendPerformanceAEL(performance);
        return res.fold((l) => Left(l), (r) => Right(true));
      default:
        // return Right(true);
        return Left(Failure('Tipo de tarefa não suportado'));
    }
  }
}
