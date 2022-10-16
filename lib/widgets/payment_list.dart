import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_offline.dart';
import './payment_card.dart';
import '../colors.dart';

class PaymentList extends StatefulWidget {
  final Map<String, int> ids;
  const PaymentList({Key? key, required this.ids}) : super(key: key);

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  late Future _paymentList;
  Future _getList() async {
    final provider = Provider.of<Data>(context, listen: false);

    return await provider.fetchPayments(widget.ids['memberId']!);
  }

  @override
  void initState() {
    super.initState();
    _paymentList = _getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _paymentList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return Consumer<Data>(
              builder: (_, db, __) {
                var list = db.payments;
                return list.isNotEmpty
                    ? ListView.separated(
                        itemCount: list.length,
                        itemBuilder: (_, i) => PaymentCard(payment: list[i]),
                        separatorBuilder: (_, i) => const Divider(),
                      )
                    : const Center(
                        child: Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.payment,
                            size: 120.0,
                            color: blue,
                          ),
                        ),
                      );
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
