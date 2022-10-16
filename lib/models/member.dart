import 'package:flutter/material.dart';

class Member with ChangeNotifier {
  final int _id, _billId;
  final String _name;
  double _totalSpent = 0;

  int get id => _id;
  int get billId => _billId;
  String get name => _name;
  double get totalSpent => _totalSpent;

  set totalSpent(double value) {
    _totalSpent = value;
    notifyListeners();
  }

  Member({
    required int id,
    required int billId,
    required String name,
    required double totalSpent,
  })  : _id = id,
        _billId = billId,
        _name = name,
        _totalSpent = totalSpent;

  Map<String, dynamic> toMap() {
    return {
      'billId': _billId,
      'name': _name,
      'totalSpent': _totalSpent.toString(),
    };
  }

  factory Member.fromJson(Map<String, dynamic> value) {
    return Member(
        id: value['id'],
        billId: value['billId'],
        name: value['name'],
        totalSpent: double.parse(value['totalSpent']));
  }
}
