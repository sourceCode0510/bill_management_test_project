import 'package:flutter/material.dart';
import '../colors.dart';

class SplitLogo extends StatelessWidget {
  const SplitLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textScaleFactor: 1.6,
      text: const TextSpan(children: [
        TextSpan(
            text: 'Split ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blue,
            )),
        TextSpan(
            text: 'That',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: green,
            )),
      ]),
    );
  }
}
