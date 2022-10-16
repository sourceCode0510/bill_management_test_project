import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyAnimation extends StatelessWidget {
  final double amount;
  final double scaleFactor;
  final TextStyle style;
  const CurrencyAnimation(
      {Key? key,
      required this.amount,
      required this.scaleFactor,
      required this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: amount),
      duration: const Duration(milliseconds: 800),
      builder: (_, double ob, child) => Text(
        NumberFormat.currency(locale: 'en_In', symbol: '₹').format(ob),
        textScaleFactor: scaleFactor,
        style: style,
      ),
    );
  }
}
