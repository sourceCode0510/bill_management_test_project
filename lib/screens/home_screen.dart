import 'package:bill_management/models/bill.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_offline.dart';
import '../colors.dart';
import '../widgets/logo.dart';
import '../widgets/add_button.dart';
import '../widgets/bill_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const name = '/home_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.85,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SplitLogo(),
                      //
                      SizedBox(height: 40.0),
                      //
                      Text(
                        'Bills',
                        textScaleFactor: 1.2,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, color: blue),
                      ),
                      //
                      SizedBox(height: 10.0),
                      //
                      Expanded(child: BillList())
                    ],
                  ),
                ),
              ),
              //
              Positioned(
                bottom: 5,
                width: MediaQuery.of(context).size.width,
                child: AddButton(
                  title: 'Add Bill',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const BillForm(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BillForm extends StatefulWidget {
  const BillForm({Key? key}) : super(key: key);

  @override
  State<BillForm> createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  final _title = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_title.text != '') {
                var newFile = Bill(
                    id: 0,
                    title: _title.text,
                    members: 0,
                    date: DateTime.now());
                provider.addBill(newFile);
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(blue),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: green, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
