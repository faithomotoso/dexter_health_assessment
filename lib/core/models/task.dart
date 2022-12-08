import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late final String _taskId;
  late final DocumentReference _shiftRef;
  late final DocumentReference _residentRef;
  late final DocumentReference _nurseRef;
  String? _dueDate;
  String? _completedDate;
  late final bool _completed;
  late final String _action;

  String get action => _action;

  bool get isCompleted => _completed;

  String get shiftId => _shiftRef.path;

  DocumentReference get residentRef => _residentRef;

  String get taskId => _taskId;

  DateTime? get dueDate {
    if (_dueDate == null) return null;
    return DateTime.tryParse(_dueDate!);
  }

  Task.fromDocumentSnapshot({required DocumentSnapshot document}) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    log("Task raw data: $data");
    this._taskId = document.id;
    this._shiftRef = data["shift_id"] as DocumentReference;
    this._residentRef = data["resident_id"] as DocumentReference;
    this._nurseRef = data["nurse_id"] as DocumentReference;
    if (data.containsKey("due_date")) {
      this._dueDate = (data["due_date"] as String).isEmpty
          ? null
          : data["due_date"] as String;
    }
    this._completed = (data["completed"] as bool);

    var cDate = data["completed_date"];
    if (cDate is Timestamp) {
      this._completedDate = cDate.toDate().toString();
    }

    this._action = data["action"] as String;
  }

  bool belongsToShift({required String shiftId}) {
    return this.shiftId == "shifts/$shiftId";
  }
}
