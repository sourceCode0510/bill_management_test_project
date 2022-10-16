class Payment {
  final int _id, _billId, _memberId;
  final String _remark;
  final double _amount;

  int get id => _id;
  int get billId => _billId;
  int get memberId => _memberId;
  String get remark => _remark;
  double get amount => _amount;

  Payment({
    required int id,
    required int billId,
    required int memberId,
    required String remark,
    required double amount,
  })  : _id = id,
        _billId = billId,
        _memberId = memberId,
        _remark = remark,
        _amount = amount;

  Map<String, dynamic> toMap() {
    return {
      'billId': _billId,
      'memberId': _memberId,
      'remark': _remark,
      'amount': _amount.toString(),
    };
  }

  factory Payment.fromJson(Map<String, dynamic> value) {
    return Payment(
        id: value['id'],
        billId: value['billId'],
        memberId: value['memberId'],
        remark: value['remark'],
        amount: double.parse(value['amount']));
  }
}
