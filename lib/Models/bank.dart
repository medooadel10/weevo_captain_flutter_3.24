import 'banks.dart';

class Bank {
  List<Banks>? banks;

  Bank({this.banks});

  Bank.fromJson(Map<String, dynamic> json) {
    if (json['banks'] != null) {
      banks = [];
      json['banks'].forEach((v) {
        banks?.add(Banks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banks != null) {
      data['banks'] = banks?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
