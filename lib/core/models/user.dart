import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late final String _documentId;
  late final String _firstName;
  late final String _lastName;

  String get documentId => _documentId;

  String get firstName => _firstName;

  String get lastName => _lastName;

  @override
  bool operator ==(Object other) {
    return other is User && other.documentId == this.documentId;
  }

  @override
  int get hashCode => Object.hashAll([documentId]);

  User.fromDocumentSnapshot({required DocumentSnapshot document}) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    this._documentId = document.id;
    this._firstName = data["first_name"];
    this._lastName = data["last_name"];
  }
}
