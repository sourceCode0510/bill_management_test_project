import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import './bill.dart';
import './member.dart';
import './payment.dart';

class Data with ChangeNotifier {
  List<Bill> _bills = [];
  List<Bill> get bills => _bills;
  List<Member> _members = [];
  List<Member> get members => _members;
  List<Payment> _payments = [];
  List<Payment> get payments => _payments;
  double _totalSpendings = 0;
  double get totalSpendings => _totalSpendings;
  double _perPersonShare = 0;
  double get perPersonShare => _perPersonShare;

  Database? _database;
  Future<Database> get database async {
    final path = join(await getDatabasesPath(), 'bill_management.db');
    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.transaction((txn) async {
        await txn.execute('''CREATE TABLE bills(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          members INTEGER,
          date TEXT
        )''');
        await txn.execute('''CREATE TABLE members(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          billId INTEGER,
          name TEXT,
          totalSpent TEXT
        )''');
        await txn.execute('''CREATE TABLE payments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          billId INTEGER,
          memberId INTEGER,
          amount TEXT,
          remark TEXT
        )''');
      });
    });
    return _database!;
  }

  Future<void> addBill(Bill bill) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .insert(
          'bills',
          bill.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then((value) {
          var newFile = Bill(
              id: value,
              title: bill.title,
              members: bill.members,
              date: bill.date);
          _bills.add(newFile);
          notifyListeners();
        });
      });
    } catch (e) {
      log('add bill : $e');
    }
  }

  Future<void> deleteBill(int billId) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .delete('bills', where: 'id == ?', whereArgs: [billId]).then((_) {
          _bills.removeWhere((element) => element.id == billId);
          notifyListeners();
          deleteAllMembers(billId);
        });
      });
    } catch (e) {
      log('delete bill: $e');
    }
  }

  Future<List<Bill>> fetchBills() async {
    final db = await database;
    try {
      return await db.transaction((txn) async {
        return await txn.query('bills').then((value) {
          var converted = List<Map<String, dynamic>>.from(value);
          List<Bill> newList = List.generate(
              converted.length, (i) => Bill.fromJson(converted[i]));
          _bills = newList;
          return _bills;
        });
      });
    } catch (e) {
      log('fetch bills: $e');
      return [];
    }
  }

  Future<void> updateMemberInBill(int billId, int members) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .update(
          'bills',
          {'members': members},
          where: 'id == ?',
          whereArgs: [billId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then((_) {
          _bills.firstWhere((element) => element.id == billId).members =
              members;
          notifyListeners();
          calculateTotalOfBill();
        });
      });
    } catch (e) {
      log('update memberInBill: $e');
    }
  }

  //
  //
  //
  Future<void> addMember(Member member) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .insert(
          'members',
          member.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then((value) {
          var newFile = Member(
              id: value,
              billId: member.billId,
              name: member.name,
              totalSpent: member.totalSpent);
          _members.add(newFile);
          notifyListeners();
          updateMemberInBill(member.billId, _members.length);
        });
      });
    } catch (e) {
      log('add member : $e');
    }
  }

  Future<List<Member>> fetchMembers(int billId) async {
    final db = await database;
    try {
      return await db.transaction((txn) async {
        return await txn.query(
          'members',
          where: 'billId == ?',
          whereArgs: [billId],
        ).then((value) {
          var converted = List<Map<String, dynamic>>.from(value);
          List<Member> newList = List.generate(
              converted.length, (i) => Member.fromJson(converted[i]));
          _members = newList;
          calculateTotalOfBill();
          return _members;
        });
      });
    } catch (e) {
      log('fetch member: $e');
      return [];
    }
  }

  Future<void> deleteMember(int memberId, int billId) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.delete('members',
            where: 'id == ?', whereArgs: [memberId]).then((_) {
          _members.removeWhere((element) => element.id == memberId);
          notifyListeners();
          updateMemberInBill(billId, _members.length);
          deleteAllPayment(memberId);
        });
      });
    } catch (e) {
      log('delete member: $e');
    }
  }

  Future<void> updateTotalSpent(int memberId, double amount) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .update(
          'members',
          {'totalSpent': amount.toString()},
          where: 'id == ?',
          whereArgs: [memberId],
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then((_) {
          _members.firstWhere((element) => element.id == memberId).totalSpent =
              amount;
          notifyListeners();
          calculateTotalOfBill();
        });
      });
    } catch (e) {
      log('update totalSpent: $e');
    }
  }

  Future<void> deleteAllMembers(int billId) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.delete('members',
            where: 'billId == ?', whereArgs: [billId]).then((_) {
          _members = [];
          notifyListeners();
        });
        await txn.delete('payments',
            where: 'billId == ?', whereArgs: [billId]).then((_) {
          _payments = [];
          notifyListeners();
        });
      });
    } catch (e) {
      log('delete all members: $e');
    }
  }
  //
  //
  //

  Future<void> addPayment(Payment payment) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn
            .insert(
          'payments',
          payment.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then((value) {
          var newFile = Payment(
              id: value,
              billId: payment.billId,
              memberId: payment.memberId,
              remark: payment.remark,
              amount: payment.amount);
          _payments.add(newFile);
          notifyListeners();
          double total = 0;
          for (int i = 0; i < _payments.length; i++) {
            total += _payments[i].amount;
          }
          updateTotalSpent(payment.memberId, total);
        });
      });
    } catch (e) {
      log('add member : $e');
    }
  }

  Future<void> deletePayment(int paymentId, int memberId) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.delete('payments',
            where: 'id == ?', whereArgs: [paymentId]).then((_) {
          _payments.removeWhere((element) => element.id == paymentId);
          notifyListeners();
          double total = 0;
          for (int i = 0; i < _payments.length; i++) {
            total += _payments[i].amount;
          }
          updateTotalSpent(memberId, total);
        });
      });
    } catch (e) {
      log('delete payment: $e');
    }
  }

  Future<List<Payment>> fetchPayments(int memberId) async {
    final db = await database;
    try {
      return await db.transaction((txn) async {
        return await txn.query(
          'payments',
          where: 'memberId == ?',
          whereArgs: [memberId],
        ).then((value) {
          var converted = List<Map<String, dynamic>>.from(value);
          List<Payment> newList = List.generate(
              converted.length, (i) => Payment.fromJson(converted[i]));
          _payments = newList;
          return _payments;
        });
      });
    } catch (e) {
      log('fetch member: $e');
      return [];
    }
  }

  Future<void> deleteAllPayment(int memberId) async {
    final db = await database;
    try {
      await db.transaction((txn) async {
        await txn.delete('payments',
            where: 'memberId == ?', whereArgs: [memberId]).then((_) {
          _payments = [];
          notifyListeners();
        });
      });
    } catch (e) {
      log('delete all pay: $e');
    }
  }

  calculateTotalOfBill() {
    double total = 0;
    for (int i = 0; i < _members.length; i++) {
      total += _members[i].totalSpent;
    }
    if (total != 0) {
      _totalSpendings = total;
      _perPersonShare = _totalSpendings / _members.length;
    } else {
      _totalSpendings = 0;
      _perPersonShare = 0;
    }

    notifyListeners();
  }
}
