import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_health_assessment/core/models/shift.dart';
import 'package:dexter_health_assessment/main.dart';
import 'package:dexter_health_assessment/utils/snackbar_messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../models/resident.dart';
import '../models/user.dart';

class AddTaskViewModel extends ChangeNotifier {
  Shift? _selectedShift;
  Resident? _selectedResident;
  Set<Resident> residents = HashSet();

  Shift? get selectedShift => _selectedShift;

  Resident? get selectedResident => _selectedResident;

  void selectShift({required Shift shift}) {
    _selectedShift = shift;
    notifyListeners();
  }

  void selectResident({required Resident resident}) {
    _selectedResident = resident;
    notifyListeners();
  }

  Future createTask(
      {required String taskDescription, required User nurse}) async {
    if (selectedShift == null) {
      showErrorMessage(message: "Please select a shift");
      return;
    }

    bool success = false;

    await FirebaseFirestore.instance.collection("tasks").add({
      "action": taskDescription,
      "nurse_id": FirebaseFirestore.instance.doc("nurses/${nurse.documentId}"),
      if (selectedResident != null)
        "resident_id": FirebaseFirestore.instance
            .doc("residents/${selectedResident?.residentId}"),
      "shift_id": FirebaseFirestore.instance
          .doc("shifts/${_selectedShift!.documentId}"),
      "completed": false
    }).then((value) => success = true, onError: (e) {
      log("Error creating new task $e");
    });

    if (success) {
      showSuccessMessage(message: "Task created successfully!");
      navigatorKey.currentState!.pop();
      clear();
    } else {
      showErrorMessage(message: "Error creating new task");
    }
  }

  void clear() {
    _selectedShift = null;
    _selectedResident = null;
  }
}
