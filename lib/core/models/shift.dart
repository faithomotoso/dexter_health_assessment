import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Shift {
  late final String _documentId;
  late String _nurseId;
  late DateTime _startTime;
  late DateTime _endTime;

  DateTime get startTime => _startTime;

  DateTime get endTime => _endTime;

  String get nurseId => _nurseId;

  String get documentId => _documentId;

  Shift.fromDocumentSnapshot({required DocumentSnapshot document}) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    this._documentId = document.id;
    this._nurseId = (data["nurse_id"] as DocumentReference).path;
    this._startTime = (data["start_time"] as Timestamp).toDate();
    this._endTime = (data["end_time"] as Timestamp).toDate();
  }

  // Determines if the shift is currently active
  bool get isActiveShift {
    DateTime now = DateTime.now().toUtc();
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return true;
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    return other is Shift && other.documentId == documentId;
  }

  @override
  int get hashCode {
    return Object.hashAll([documentId]);
  }

}
