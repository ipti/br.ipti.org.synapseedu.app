import 'package:flutter/material.dart';

import '../core/block/data/model/block_model.dart';
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
    currentTaskIndex = newBlock.breakPoint.last_resolved_task_id == 0 ? 0 : block.tasks.indexOf(newBlock.breakPoint.last_resolved_task_id)+1;
    if (currentTaskIndex == -1) currentTaskIndex = 0;
  }

  get firstTaskId {
    if(currentBlock.lessons.values.first.tasksId.length == 0 || currentBlock.lessons.values.first.tasksId.length <= currentTaskIndex) return null;
    return currentBlock.lessons.values.first.tasksId[currentTaskIndex];
  }

  int? get nextTaskId {
    if (currentTaskIndex >= currentBlock.lessons.values.first.tasksId.length - 1) return null;
    currentTaskIndex++;
    return currentBlock.lessons.values.first.tasksId[currentTaskIndex];
  }

  Future<bool> saveBlockInCache() async {
    // await _cacheRepository.saveBlock(currentBlock);
    return true;
  }

  Future<bool> loadBlockFromCache() async {
    // currentBlock = await _cacheRepository.getBlock();
    return true;
  }
}
