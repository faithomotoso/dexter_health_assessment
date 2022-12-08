import 'package:flutter/material.dart';

class Heading5 extends StatelessWidget {
  final String heading;

  Heading5({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontWeight: FontWeight.w500),
    );
  }
}

class MiniHeading extends StatelessWidget {
  final String heading;

  MiniHeading({required this.heading});

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }
}
