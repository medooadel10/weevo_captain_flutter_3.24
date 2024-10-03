import 'e_wallet_transaction.dart';

class EWallet {
  String? message;
  String? status;
  EWalletTransaction? transaction;

  EWallet({this.message, this.status, this.transaction});

  EWallet.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    transaction = json['transaction'] != null
        ? EWalletTransaction.fromJson(json['transaction'])
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
