import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/data_offline.dart';
import '../models/bill.dart';
import '../colors.dart';
import '../screens/member_screen.dart';

class BillCard extends StatelessWidget {
  final Bill bill;
  const BillCard({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context, listen: false);
    return Dismissible(
      key: ValueKey(bill.id),
      onDismissed: (_) {
        provider.deleteBill(bill.id);
      },
      child: ChangeNotifierProvider.value(
        value: bill,
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(MemberScreen.name, arguments: bill.id);
          },
          child: Container(
            height: 70.0,
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill.title,
                        textScaleFactor: 1.2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        DateFormat('MMMM dd, yyyy').format(bill.date),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                const Icon(Icons.person, color: green, size: 20.0),
                Consumer<Bill>(builder: (_, bl, __) {
                  return Text(
                    bl.members.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blue,
                    ),
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
