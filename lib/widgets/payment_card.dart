import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/data_offline.dart';
import '../models/payment.dart';
import '../colors.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  const PaymentCard({
    Key? key,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context, listen: false);
    return Dismissible(
      key: ValueKey(payment.id),
      onDismissed: (_) {
        provider.deletePayment(payment.id, payment.memberId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Text(
              payment.remark,
              style: const TextStyle(color: blue),
            ),
            const Spacer(),
            Text(
              NumberFormat.currency(locale: 'en_In', symbol: '₹')
                  .format(payment.amount),
            ),
          ],
        ),
      ),
    );
  }
}
