import 'credit_status_transaction.dart';

class CreditStatus {
  String? message;
  String? status;
  CreditStatusTransaction? transaction;

  CreditStatus({this.message, this.status, this.transaction});

  CreditStatus.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    transaction = json['transaction'] != null
        ? CreditStatusTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (transaction != null) {
      data['transaction'] = transaction?.toJson();
    }
    return data;
  }
}
