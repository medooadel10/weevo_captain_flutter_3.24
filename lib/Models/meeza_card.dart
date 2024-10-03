import 'meeza_transaction.dart';
import 'meeza_upg.dart';

class MeezaCard {
  String? message;
  String? status;
  MeezaUpgResponse? upgResponse;
  MeezaTransaction? transaction;

  MeezaCard({this.message, this.status, this.upgResponse, this.transaction});

  MeezaCard.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    upgResponse = json['upg_response'] != null
        ? MeezaUpgResponse.fromJson(json['upg_response'])
        : null;
    transaction = json['transaction'] != null
        ? MeezaTransaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    if (upgResponse != null) {
      data['upg_response'] = upgResponse?.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction?.toJson();
    }
    return data;
  }
}
