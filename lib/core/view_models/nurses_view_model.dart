import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_health_assessment/core/models/user.dart';
import 'package:flutter/foundation.dart';

class NursesViewModel extends ChangeNotifier {

  late StreamSubscription<QuerySnapshot> _nursesSubscription;
  final Set<User> _users = HashSet();


  NursesViewModel() {
    _nursesSubscription = FirebaseFirestore.instance.collection("users")
        .snapshots().listen((snapshot) {
          for (DocumentChange docChange in snapshot.docChanges) {
            _users.add(User.fromDocumentSnapshot(document: docChange.doc));
          }
          notifyListeners();
    });
  }


}