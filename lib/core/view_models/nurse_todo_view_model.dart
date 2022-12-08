import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_health_assessment/core/models/task.dart';
import 'package:flutter/foundation.dart';

class NurseTodoViewModel extends ChangeNotifier {
  Future<bool> markTaskAsDone({required Task task}) async {
    late bool success;
    await FirebaseFirestore.instance
        .collection("tasks")
        .doc(task.taskId)
        .update({
      "completed": true,
      "completed_date": FieldValue.serverTimestamp()
    }).then((value) => success = true, onError: (e) {
      log("Error updating document: $e");
      success = false;
    });

    return success;
  }
}
