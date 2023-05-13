import 'dart:async';

import 'package:elesson/share/api.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:elesson/share/snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockSelectionLogic {
  Future<void> redirectToQuestion(
      {int? cobjectIdIndex,
      String? disciplineId,
      String? discipline,
      String? studentUuid,
      BuildContext? context,
      String? classroomFk}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentUuid = prefs.getString('student_uuid')??'';

    var blockId = studentUuid != null
        ? prefs.getString('block_${classroomFk}_$disciplineId')
        : await (ApiBlock.getBlockByDiscipline(disciplineId!) as FutureOr<String>);
    print('blockId: $blockId');
    // var responseBlock = await ApiBlock.getBlock(blockId);
    // print('responseblock: $responseBlock');
    ApiBlock.getBlock(blockId).then((value) {
      var responseBlock = value;
      if (responseBlock != "-1") {
        List<String?> cobjectIdList = [];
        int cobjectId = prefs.getInt('last_cobject_$discipline') ?? 0;
        int questionIndex = prefs.getInt('last_question_$discipline') ?? 0;
        responseBlock.data[0]["cobject"].forEach((cobject) {
          // print(cobject["id"]);
          cobjectIdList.add(cobject["id"]);
        });
        print(cobjectIdList);

        getCobject(cobjectId, context, cobjectIdList,
            piecesetIndex: questionIndex);
      } else
        callSnackBar(context!);
    });
  }
}
