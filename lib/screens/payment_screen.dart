import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_offline.dart';
import '../colors.dart';
import '../models/payment.dart';
import '../widgets/add_button.dart';
import '../widgets/payment_list.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const name = '/payment_screen';
  @override
  Widget build(BuildContext context) {
    var ids = ModalRoute.of(context)!.settings.arguments as Map<String, int>;
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back,
                            color: green, size: 30.0),
                      ),
                      //
                      const SizedBox(height: 20.0),
                      //
                      Expanded(child: PaymentList(ids: ids)),
                    ],
                  ),
                ),
              ),
              //
              Positioned(
                bottom: 5,
                width: MediaQuery.of(context).size.width,
                child: AddButton(
                  title: 'Add Payment',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => PaymentForm(ids: ids),
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

class PaymentForm extends StatefulWidget {
  final Map<String, int> ids;
  const PaymentForm({Key? key, required this.ids}) : super(key: key);

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _amount = TextEditingController();
  final _remark = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Amount',
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _remark,
            decoration: const InputDecoration(
              hintText: 'Remarks',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_amount.text != '') {
                var newFile = Payment(
                    id: 0,
                    billId: widget.ids['billId']!,
                    memberId: widget.ids['memberId']!,
                    remark: _remark.text,
                    amount: double.parse(_amount.text));
                provider.addPayment(newFile);
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
