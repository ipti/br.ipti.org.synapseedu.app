import 'package:elesson/app/core/task/data/model/performance_model.dart';
import 'package:elesson/app/core/task/domain/entity/user_answer.dart';
import '../../data/repository/performance_repository_interface.dart';
import 'package:elesson/app/providers/userProvider.dart';
import '../../../../util/failures/failures.dart';
import '../../data/model/metadata_model.dart';
import '../../data/model/task_model.dart';
import 'package:dartz/dartz.dart';

class SendPerformanceUseCase {
  final IPerformanceRepository performanceRepository;

  SendPerformanceUseCase({required this.performanceRepository});

  Future<Either<Failure, Performance>> call({String correctAnswerPre = "",required TaskModel task, required UserAnswer userAnswer}) async {
    var metaData = MetaDataModel.generate(task: task, userAnswer: userAnswer);

    DateTime tempoAgora = DateTime.now();
    Performance performance = Performance(
      taskId: task.id!,
      createdAt: tempoAgora,
      student_id: userAnswer.userId,
      isCorrect: true,
      block_id: task.block_id,
      timeResolution: tempoAgora.millisecondsSinceEpoch- userAnswer.performanceTime.millisecondsSinceEpoch,
      metadata: metaData,
    );

    switch (task.template_id) {
      case 1:
        performance.isCorrect = task.body!.components.first.id == userAnswer.AnswerMte.id;
        return await performanceRepository.sendPerformanceMTE(performance);
      case 2:
        performance.isCorrect = correctAnswerPre.toUpperCase() == userAnswer.AnswerPre.toUpperCase();
        return await performanceRepository.sendPerformancePRE(performance);
      case 3:
        performance.isCorrect = (metaData as MetaDataModelAEL).performanceStatus;
        return await performanceRepository.sendPerformanceAEL(performance);
      default:
        return Left(Failure('Tipo de tarefa não suportado'));
    }
  }
}
