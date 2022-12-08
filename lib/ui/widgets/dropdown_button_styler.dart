import 'package:flutter/material.dart';

class DropdownButtonStyler extends StatelessWidget {
  final DropdownButton dropdownButton;

  DropdownButtonStyler({required this.dropdownButton});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: dropdownButton,
      ),
    );
  }
}
