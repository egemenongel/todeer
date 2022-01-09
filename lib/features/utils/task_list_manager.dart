import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/features/models/task.dart';

class TaskListManager extends ChangeNotifier {
  final List<TaskModel> _taskList = [];
  bool duration = true;
  int total = 0;
  int completedCount = 0;
  int l = 0;
  UnmodifiableListView<TaskModel> get taskList {
    return UnmodifiableListView(_taskList);
  }

  int getDone(AsyncSnapshot snapshot) {
    completedCount = 0;
    for (var task in snapshot.data.docs) {
      if (task.get("isCompleted") == true) completedCount++;
    }
    return completedCount;
  }

  int get listLength {
    return _taskList.length;
  }

  addTask(TaskModel taskModel) {
    _taskList.add(taskModel);
    notifyListeners();
  }

  removeTask(taskModel) {
    _taskList.remove(taskModel);
    notifyListeners();
  }

  clearCurrentList() {
    _taskList.clear();
    notifyListeners();
  }

  checkboxToggle(TaskModel task) {
    task.toggle();
    notifyListeners();
  }

  changeBool(bool value) {
    duration = value;
    notifyListeners();
  }

  void sumDuration(dynamic list) {
    var sum = 0;
    for (DocumentSnapshot task in list) {
      if (task.get("isCompleted") == true) {
        if ((int.tryParse(task.get("duration"))) is int) {
          sum += int.parse(task.get("duration"));
        } else {
          sum = sum;
        }
        if ((task.get("startTime").toString().length > 1) &&
            task.get("finishTime").toString().length > 1) {
          if (int.parse(task.get("startTime").toString().split(":")[0]) >
              int.parse(task.get("finishTime").toString().split(":")[0])) {
            sum += 24 * 60 +
                durationCalculator(task.get("startTime"),
                    task.get("finishTime")); // Absolute value
          } else {
            sum += durationCalculator(
                task.get("startTime"), task.get("finishTime"));
          }
        } else {
          sum = sum;
        }
      }
    }
    total = sum;
    notifyListeners();
  }

  int durationCalculator(String startTime, String finishTime) {
    String startHours = startTime.split(":"[0])[0];
    String startMins = startTime.split(":"[0])[1];
    int startMinutes = int.parse(startHours) * 60 + int.parse(startMins);

    String finishHours = finishTime.split(":"[0])[0];
    String finishMins = finishTime.split(":"[0])[1];
    int finishMinutes = int.parse(finishHours) * 60 + int.parse(finishMins);
    int duration = finishMinutes - startMinutes;
    return duration;
  }
}
