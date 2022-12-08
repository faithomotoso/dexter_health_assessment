import 'package:dexter_health_assessment/main.dart';
import 'package:flutter/material.dart';

void showSuccessMessage({required String message}) {
  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: Colors.green,
  ));
}

void showErrorMessage({required String message}) {
  scaffoldMessengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    ),
  );
}
