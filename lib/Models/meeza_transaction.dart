import 'meeza_details.dart';

class MeezaTransaction {
  int? id;
  String? amount;
  String? netAmount;
  String? bankCharge;
  String? internalCharge;
  int? driverId;
  String? transactionableType;
  int? transactionableId;
  String? dateTime;
  String? createdAt;
  String? updatedAt;
  MeezaDetails? details;

  MeezaTransaction(
      {this.id,
      this.amount,
      this.netAmount,
      this.bankCharge,
      this.internalCharge,
      this.driverId,
      this.transactionableType,
      this.transactionableId,
      this.dateTime,
      this.createdAt,
      this.updatedAt,
      this.details});

  MeezaTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    netAmount = json['net_amount'];
    bankCharge = json['bank_charge'];
    internalCharge = json['internal_charge'];
    driverId = json['driver_id'];
    transactionableType = json['transactionable_type'];
    transactionableId = json['transactionable_id'];
    dateTime = json['date_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    details =
        json['details'] != null ? MeezaDetails.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['net_amount'] = netAmount;
    data['bank_charge'] = bankCharge;
    data['internal_charge'] = internalCharge;
    data['driver_id'] = driverId;
    data['transactionable_type'] = transactionableType;
    data['transactionable_id'] = transactionableId;
    data['date_time'] = dateTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (details != null) {
      data['details'] = details?.toJson();
    }
    return data;
  }
}
