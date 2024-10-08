class TransactionDetails {
  int? id;
  int? transactionId;
  String? method;
  String? status;
  String? description;
  String? notes;
  String? transactionRefNumber;
  String? dateTime;
  String? createdAt;
  String? updatedAt;
  String? payout;

  TransactionDetails(
      {this.id,
      this.transactionId,
      this.method,
      this.status,
      this.description,
      this.notes,
      this.transactionRefNumber,
      this.dateTime,
      this.createdAt,
      this.updatedAt,
      this.payout});

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    method = json['method'];
    status = json['status'];
    description = json['description'];
    notes = json['notes'];
    transactionRefNumber = json['transaction_ref_number'];
    dateTime = json['date_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    payout = json['payout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['method'] = method;
    data['status'] = status;
    data['description'] = description;
    data['notes'] = notes;
    data['transaction_ref_number'] = transactionRefNumber;
    data['date_time'] = dateTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['payout'] = payout;
    return data;
  }
}
