import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../animation/currency_animation.dart';
import '../models/data_offline.dart';
import '../colors.dart';

class SummaryCard extends StatelessWidget {
  final int billId;
  const SummaryCard({
    Key? key,
    required this.billId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Total Spent',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Consumer<Data>(builder: (_, db, __) {
                  return CurrencyAnimation(
                    amount: db.totalSpendings,
                    scaleFactor: 1.5,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blue,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 70.0, child: VerticalDivider()),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Per Person Share',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Consumer<Data>(builder: (_, pp, __) {
                  return CurrencyAnimation(
                    amount: pp.perPersonShare,
                    scaleFactor: 1.5,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blue,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
