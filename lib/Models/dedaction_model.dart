class DeductionModel {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  DeductionModel(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  DeductionModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
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
  Details? details;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
        json['details'] != null ? Details.fromJson(json['details']) : null;
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

class Details {
  int? id;
  int? transactionId;
  String? status;
  String? description;
  String? notes;
  String? chargeableType;
  int? chargeableId;
  String? flag;
  String? externalRefNumber;
  String? dateTime;
  String? createdAt;
  String? updatedAt;

  Details(
      {this.id,
      this.transactionId,
      this.status,
      this.description,
      this.notes,
      this.chargeableType,
      this.chargeableId,
      this.flag,
      this.externalRefNumber,
      this.dateTime,
      this.createdAt,
      this.updatedAt});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    status = json['status'];
    description = json['description'];
    notes = json['notes'];
    chargeableType = json['chargeable_type'];
    chargeableId = json['chargeable_id'];
    flag = json['flag'];
    externalRefNumber = json['external_ref_number'];
    dateTime = json['date_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['status'] = status;
    data['description'] = description;
    data['notes'] = notes;
    data['chargeable_type'] = chargeableType;
    data['chargeable_id'] = chargeableId;
    data['flag'] = flag;
    data['external_ref_number'] = externalRefNumber;
    data['date_time'] = dateTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
