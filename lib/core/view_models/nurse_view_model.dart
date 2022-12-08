import 'dart:collection';

import 'package:dexter_health_assessment/core/models/user.dart';
import 'package:flutter/cupertino.dart';

import '../models/shift.dart';

class NurseViewModel extends ChangeNotifier {
  User? _user;
  final Set<Shift> _shifts = HashSet();

  User? get user => _user;
  Set<Shift> get shifts => _shifts;

  void assignUser({required User user}) {
    clearUser();
    _user = user;
    notifyListeners();
  }

  void assignShifts({required List<Shift> shifts, bool notify = true}) {
    _shifts.addAll(shifts);
    if (notify) notifyListeners();
  }

  void clearUser() {
    _user = null;
    _shifts.clear();
  }
}