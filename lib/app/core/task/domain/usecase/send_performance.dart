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

  UserProvider userProvider = UserProvider();

  Future<Either<Failure, Performance>> call({required TaskModel task, required UserAnswer userAnswer}) async {
    var metaData = MetaDataModel.generate(task: task, userAnswer: userAnswer);

    print("TIPO: ${metaData.runtimeType}");
    print("METADATA: ${metaData.toJson()}");

    DateTime tempoAgora = DateTime.now();
    Performance performance = Performance(
      taskId: task.id!,
      createdAt: tempoAgora,
      userId: userAnswer.userId,
      isCorrect: false,
      timeResolution: tempoAgora.second - userAnswer.performanceTime.second,
      metadata: metaData,
    );

    switch (task.template_id) {
      case 1:
        performance.isCorrect = task.body!.components.first.id == userAnswer.AnswerMte.id;
        return await performanceRepository.sendPerformanceMTE(performance);
      case 2:
        // performance.isCorrect = task.body!.components.first.text == userAnswer.AnswerPre;
        return await performanceRepository.sendPerformancePRE(performance);
      case 3:
        List<int> correctAnswers = task.body!.components.sublist(3,6).map((e) => e.id!).toList();

        for(int i = 0; i < correctAnswers.length; i++){
          if(correctAnswers[i] != userAnswer.answerDdrop[i].component_id){
            performance.isCorrect = false;
          }
        }

        return await performanceRepository.sendPerformanceAEL(performance);
      default:
        return Left(Failure('Tipo de tarefa não suportado'));
    }
  }

}
