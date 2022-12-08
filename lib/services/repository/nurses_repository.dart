import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class NursesRepository {

  NursesRepository() {
    init();
  }

  void init() {
    FirebaseFirestore.instance.collection("users")
        .snapshots().listen((event) { });
  }
}