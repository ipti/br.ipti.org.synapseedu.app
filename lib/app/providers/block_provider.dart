import 'package:flutter/material.dart';

import '../core/qrcode/data/model/block_model.dart';
import '../core/task/data/model/task_model.dart';

class BlockProvider extends ChangeNotifier {
  BlockModel currentBlock = BlockModel.empty();

  BlockModel get block => currentBlock;
  int currentTaskIndex = 0;

  List<TaskModel> tasksLoaded = [];

  TaskModel getNextTask() {
    if (tasksLoaded.length == 0) {
      return TaskModel.empty();
    }
    TaskModel task = tasksLoaded.first.copyWith();
    tasksLoaded.removeAt(0);
    return task;
  }

  void setNewBlock(BlockModel newBlock) {
    currentBlock = newBlock;
    currentTaskIndex = block.tasks.indexOf(newBlock.breakPoint.last_resolved_task_id) +1;
    if (currentTaskIndex == -1) currentTaskIndex = 0;
  }

  get firstTaskId {
    if(currentBlock.tasks.length == 0 || currentBlock.tasks.length <= currentTaskIndex) return null;
    return currentBlock.tasks[currentTaskIndex];
  }

  int? get nextTaskId {
    if (currentTaskIndex >= currentBlock.tasks.length - 1) return null;
    currentTaskIndex++;
    return currentBlock.tasks[currentTaskIndex];
  }
}
