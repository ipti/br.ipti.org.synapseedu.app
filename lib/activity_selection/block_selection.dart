import 'package:elesson/share/api.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockSelectionLogic {
  Future<Function> redirectToQuestion(
      {int cobjectIdIndex,
      String disciplineId,
      String discipline,
      String blockId,
      String studentUuid,
      BuildContext context,
      String classroomFk}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentUuid = prefs.getString('student_uuid');
    String hey = prefs.getString('block_${classroomFk}_$disciplineId');
    print("$classroomFk e $disciplineId ou $hey e $studentUuid");
    var blockId = studentUuid != null
        ? prefs.getString('block_${classroomFk}_$disciplineId')
        : await ApiBlock.getBlockByDiscipline(disciplineId);
    print('blockId: $blockId');
    var responseBlock = await ApiBlock.getBlock(blockId);
    ApiBlock.getBlock(blockId).then((value) {
      var responseBlock = value;
      List<String> cobjectIdList = [];
      int cobjectId = prefs.getInt('last_cobject_$discipline') ?? 0;
      int questionIndex = prefs.getInt('last_question_$discipline') ?? 0;
      responseBlock.data[0]["cobject"].forEach((cobject) {
        // print(cobject["id"]);
        cobjectIdList.add(cobject["id"]);
      });
      print(cobjectIdList);

      getCobject(cobjectId, context, cobjectIdList,
          piecesetIndex: questionIndex);
    });
  }
}