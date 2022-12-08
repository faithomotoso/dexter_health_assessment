import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late final String _taskId;
  late final DocumentReference _shiftRef;
  late final DocumentReference _residentRef;
  late final DocumentReference _nurseRef;
  late final String? _dueDate;
  late final String? _completedDate;
  late final bool _completed;
  late final String _action;

  String get action => _action;
  bool get isCompleted => _completed;
  String get shiftId => _shiftRef.path;
  DocumentReference get residentRef => _residentRef;
  DateTime? get dueDate {
    if (_dueDate == null) return null;
    return DateTime.tryParse(_dueDate!);
  }


  Task.fromDocumentSnapshot({required DocumentSnapshot document}) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    this._taskId = document.id;
    this._shiftRef = data["shift_id"] as DocumentReference;
    this._residentRef = data["resident_id"] as DocumentReference;
    this._nurseRef = data["nurse_id"] as DocumentReference;
    this._dueDate = (data["due_date"] as String).isEmpty
        ? null
        : data["due_date"] as String;
    this._completed = (data["completed"] as bool);
    this._completedDate = (data["completed_date"] as String).isEmpty
        ? null
        : data["completed_date"] as String;
    this._action = data["action"] as String;
  }

  bool belongsToShift({required String shiftId}) {
    return this.shiftId == "shifts/$shiftId";
  }
}
