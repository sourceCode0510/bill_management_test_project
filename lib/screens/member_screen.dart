import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_offline.dart';
import '../colors.dart';
import '../widgets/add_button.dart';
import '../widgets/summary_card.dart';
import '../widgets/member_list.dart';
import '../models/member.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({Key? key}) : super(key: key);
  static const name = '/member_screen';

  @override
  Widget build(BuildContext context) {
    var billId = ModalRoute.of(context)!.settings.arguments as int;
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
                      SummaryCard(billId: billId),
                      //
                      const SizedBox(height: 40.0),
                      //
                      const Text(
                        'Members',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                      //
                      const SizedBox(height: 20.0),
                      //
                      Expanded(child: MemberList(billId: billId)),
                    ],
                  ),
                ),
              ),
              //
              Positioned(
                bottom: 5,
                width: MediaQuery.of(context).size.width,
                child: AddButton(
                  title: 'Add Member',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => MemberForm(
                        billId: billId,
                      ),
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

class MemberForm extends StatefulWidget {
  final int billId;
  const MemberForm({Key? key, required this.billId}) : super(key: key);

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Data>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              hintText: 'Name',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_name.text != '') {
                var newFile = Member(
                    id: 0,
                    billId: widget.billId,
                    name: _name.text,
                    totalSpent: 0);
                provider.addMember(newFile);
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
