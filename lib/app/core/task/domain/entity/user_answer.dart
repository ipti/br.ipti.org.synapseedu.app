import '../../data/model/component_model.dart';
import 'ddrop_option_entity.dart';

class UserAnswer{
  final int userId;
  final ComponentModel AnswerMte;
  final String AnswerPre;
  final List<DdropOptionEntity> answerDdrop;
  final DateTime performanceTime;

  UserAnswer({required this.userId, required this.AnswerMte,required this.AnswerPre,required this.answerDdrop, required this.performanceTime});
}