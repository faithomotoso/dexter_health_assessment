import 'dart:collection';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/resident.dart';

class ResidentsViewModel extends ChangeNotifier {
  final Set<Resident> _residents = HashSet();

  Set<Resident> get residents => _residents;

  ResidentsViewModel() {
    init();
  }

  void init() {
    FirebaseFirestore.instance
        .collection("residents")
        .snapshots()
        .listen((event) {
      for (DocumentSnapshot snapshot in event.docs) {
        if (snapshot.data() != null) {
          _residents.add(Resident.fromDocumentSnapshot(document: snapshot));
        }
      }
      notifyListeners();
    }, onError: (err) async {
          log("Error listening to residents snapshot: $err");
          await Future.delayed(const Duration(seconds: 3));
          init();
    });
  }
}
