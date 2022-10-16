import 'package:flutter/material.dart';

class Bill with ChangeNotifier {
  final int _id;
  final String _title;
  int _members = 0;
  final DateTime _date;

  int get id => _id;
  String get title => _title;
  int get members => _members;
  DateTime get date => _date;

  set members(int value) {
    _members = value;
    notifyListeners();
  }

  Bill({
    required int id,
    required String title,
    required int members,
    required DateTime date,
  })  : _id = id,
        _title = title,
        _members = members,
        _date = date;

  Map<String, dynamic> toMap() {
    return {
      'title': _title,
      'members': _members,
      'date': _date.toString(),
    };
  }

  factory Bill.fromJson(Map<String, dynamic> value) {
    return Bill(
        id: value['id'],
        title: value['title'],
        members: value['members'],
        date: DateTime.parse(value['date']));
  }
}
