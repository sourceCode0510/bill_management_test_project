import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_offline.dart';
import './member_card.dart';
import '../colors.dart';

class MemberList extends StatefulWidget {
  final int billId;
  const MemberList({Key? key, required this.billId}) : super(key: key);

  @override
  State<MemberList> createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  late Future _memberList;
  Future _getList() async {
    final provider = Provider.of<Data>(context, listen: false);
    return await provider.fetchMembers(widget.billId);
  }

  @override
  void initState() {
    super.initState();
    _memberList = _getList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memberList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return Consumer<Data>(
              builder: (_, db, __) {
                var list = db.members
                    .where((element) => element.billId == widget.billId)
                    .toList();
                return list.isNotEmpty
                    ? ListView.separated(
                        itemCount: list.length,
                        itemBuilder: (_, i) => MemberCard(member: list[i]),
                        separatorBuilder: (_, i) => const Divider(),
                      )
                    : const Center(
                        child: Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.people,
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
