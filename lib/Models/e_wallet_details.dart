class EWalletDetails {
  int? transactionId;
  String? method;
  String? status;
  String? description;
  String? notes;
  String? transactionRefNumber;
  String? mpgSessionVersion;
  String? mpgSessionId;
  String? mpgSuccessIndicator;
  String? upgSystemRef;
  String? dateTime;
  String? createdAt;
  String? updatedAt;

  EWalletDetails(
      {this.transactionId,
      this.method,
      this.status,
      this.description,
      this.notes,
      this.transactionRefNumber,
      this.mpgSessionVersion,
      this.mpgSessionId,
      this.mpgSuccessIndicator,
      this.upgSystemRef,
      this.dateTime,
      this.createdAt,
      this.updatedAt});

  EWalletDetails.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    method = json['method'];
    status = json['status'];
    description = json['description'];
    notes = json['notes'];
    transactionRefNumber = json['transaction_ref_number'];
    mpgSessionVersion = json['mpg_session_version'];
    mpgSessionId = json['mpg_session_id'];
    mpgSuccessIndicator = json['mpg_success_indicator'];
    upgSystemRef = json['upg_system_ref'];
    dateTime = json['date_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['method'] = method;
    data['status'] = status;
    data['description'] = description;
    data['notes'] = notes;
    data['transaction_ref_number'] = transactionRefNumber;
    data['mpg_session_version'] = mpgSessionVersion;
    data['mpg_session_id'] = mpgSessionId;
    data['mpg_success_indicator'] = mpgSuccessIndicator;
    data['upg_system_ref'] = upgSystemRef;
    data['date_time'] = dateTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
