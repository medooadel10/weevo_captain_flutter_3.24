import 'credit_card_transaction.dart';

class CreditCard {
  String? message;
  String? status;
  String? checkoutUrl;
  CreditCardTransaction? transaction;

  CreditCard({this.message, this.status, this.checkoutUrl, this.transaction});

  CreditCard.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    checkoutUrl = json['checkout_url'];
    transaction = json['transaction'] != null
        ? CreditCardTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['checkout_url'] = checkoutUrl;
    if (transaction != null) {
      data['transaction'] = transaction?.toJson();
    }
    return data;
  }
}
