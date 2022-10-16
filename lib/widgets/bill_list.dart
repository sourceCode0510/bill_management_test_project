import 'package:bill_management/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_offline.dart';
import './bill_card.dart';

class BillList extends StatefulWidget {
  const BillList({Key? key}) : super(key: key);

  @override
  State<BillList> createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  late Future _billList;
  Future _getList() async {
    final provider = Provider.of<Data>(context, listen: false);
    return await provider.fetchBills();
  }

  @override
  void initState() {
    super.initState();
    _billList = _getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _billList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return Consumer<Data>(
              builder: (_, db, __) {
                var list = db.bills;
                return list.isNotEmpty
                    ? ListView.separated(
                        itemCount: list.length,
                        itemBuilder: (_, i) => BillCard(bill: list[i]),
                        separatorBuilder: (_, i) => const Divider(),
                      )
                    : const Center(
                        child: Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.list_alt_outlined,
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
