import 'package:flutter/material.dart';
import '../colors.dart';

class AddButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const AddButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.add,
        size: 30.0,
        color: green,
      ),
      label: Text(
        title,
        textScaleFactor: 1.5,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: green,
        ),
      ),
    );
  }
}
