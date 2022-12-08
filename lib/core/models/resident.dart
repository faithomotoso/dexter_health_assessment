import 'package:cloud_firestore/cloud_firestore.dart';

class Resident {
  late final String _residentId;
  late final String _firstName;
  late final String _lastName;
  late final String _gender;
  late final String _roomNumber;

  String get fullName => "$_firstName $_lastName";
  String get roomNumber => _roomNumber;
  String get residentId => _residentId;

  Resident.fromDocumentSnapshot({required DocumentSnapshot document}) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    this._residentId = document.id;
    this._firstName = data["first_name"] as String;
    this._lastName = data["last_name"] as String;
    this._gender = data["gender"] as String;
    this._roomNumber = data["room_number"] as String;
  }

  @override
  bool operator ==(Object other) {
    return other is Resident && other._residentId == _residentId;
  }

  @override
  int get hashCode {
    return Object.hashAll([_residentId]);
  }
}