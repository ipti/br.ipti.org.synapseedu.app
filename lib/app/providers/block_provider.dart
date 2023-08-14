import 'package:flutter/material.dart';

import '../core/qrcode/data/model/block_model.dart';
import '../core/task/data/model/task_model.dart';

class BlockProvider extends ChangeNotifier {
  BlockModel currentBlock = BlockModel.empty();

  BlockModel get block => currentBlock;
  int currentTaskIndex = 0;

  List<TaskModel> tasksLoaded = [];

  TaskModel getNextTask() {
    if (currentTaskIndex >= currentBlock.tasks.length - 1) {
      return TaskModel.empty();
    }
    currentTaskIndex++;
    TaskModel task = tasksLoaded.first.copyWith();
    tasksLoaded.removeAt(0);
    return task;
  }

  void setNewBlock(BlockModel newBlock) {
    currentBlock = newBlock;
    currentTaskIndex = block.tasks.indexOf(newBlock.breakPoint.last_resolved_task_id);
    if (currentTaskIndex == -1) currentTaskIndex = 0;
  }

  get firstTaskId => currentBlock.tasks[currentTaskIndex];

  int? get nextTaskId {
    if (currentTaskIndex >= currentBlock.tasks.length - 1) return null;
    print("++");
    currentTaskIndex++;
    return currentBlock.tasks[currentTaskIndex];
  }
}
