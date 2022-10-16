import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../animation/currency_animation.dart';
import '../models/data_offline.dart';
import '../models/member.dart';
import '../screens/payment_screen.dart';

String getInitials(String full) {
  var splits = full.split(' ').toList();
  String initial = '';
  for (int i = 0; i < splits.length; i++) {
    initial += splits[i].characters.first;
  }
  return initial.toUpperCase();
}

class MemberCard extends StatelessWidget {
  final Member member;
  const MemberCard({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context, listen: false);
    return Dismissible(
      key: ValueKey(member.id),
      onDismissed: (_) {
        provider.deleteMember(member.id, member.billId);
      },
      child: ChangeNotifierProvider.value(
        value: member,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              PaymentScreen.name,
              arguments: {'billId': member.billId, 'memberId': member.id},
            );
          },
          child: Container(
            height: 70.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  child: Text(
                    getInitials(member.name),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //
                const SizedBox(width: 10.0),
                //
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        member.name,
                        textScaleFactor: 1.2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Consumer<Member>(builder: (_, mm, __) {
                        return Text(
                          'total Spent: ${NumberFormat.currency(locale: 'en_In', symbol: '₹').format(mm.totalSpent)}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                //
                const SizedBox(width: 10.0),
                //
                Consumer<Data>(builder: (_, db, __) {
                  double rAmount = member.totalSpent - db.perPersonShare;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: rAmount.isNegative
                        ? [
                            const Text('Will Give'),
                            const SizedBox(height: 5.0),
                            CurrencyAnimation(
                              amount: rAmount * -1,
                              scaleFactor: 1.0,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ]
                        : [
                            const Text('Will Get'),
                            const SizedBox(height: 5.0),
                            CurrencyAnimation(
                              amount: rAmount,
                              scaleFactor: 1.0,
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
