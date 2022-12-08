import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_health_assessment/core/models/shift.dart';
import 'package:dexter_health_assessment/core/models/task.dart';
import 'package:dexter_health_assessment/main.dart';
import 'package:dexter_health_assessment/utils/snackbar_messages.dart';
import 'package:flutter/foundation.dart';

class TaskMover extends ChangeNotifier {
  Future moveTaskToShift({required Task task, required Shift newShift}) async {
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(task.taskId)
        .update({
      "shift_id":
          FirebaseFirestore.instance.doc("shifts/${newShift.documentId}")
    }).then((value) {
      navigatorKey.currentState!.pop();
      showSuccessMessage(message: "Task moved successfully!");
    }, onError: (err) {
      log("Error moving task to another shift $err");
      showErrorMessage(
          message: "An error occurred while moving this task to another shift");
    });
  }
}
