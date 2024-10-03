class OpayModel {
  OpayModel({
    this.message,
    this.status,
    this.callbackUrl,
    this.reference,
    this.transaction,
  });

  String? message;
  String? status;
  String? callbackUrl;
  String? reference;
  OpayTransaction? transaction;

  factory OpayModel.fromJson(Map<String, dynamic> json) => OpayModel(
        message: json["message"],
        status: json["status"],
        callbackUrl: json["callbackUrl"],
        reference: json["reference"],
        transaction: OpayTransaction.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "callbackUrl": callbackUrl,
        "reference": reference,
        "transaction": transaction?.toJson(),
      };
}

class OpayTransaction {
  OpayTransaction({
    this.id,
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
    this.details,
  });

  int? id;
  String? amount;
  String? netAmount;
  String? bankCharge;
  String? internalCharge;
  int? driverId;
  String? transactionableType;
  int? transactionableId;
  DateTime? dateTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  Details? details;

  factory OpayTransaction.fromJson(Map<String, dynamic> json) =>
      OpayTransaction(
        id: json["id"],
        amount: json["amount"],
        netAmount: json["net_amount"],
        bankCharge: json["bank_charge"],
        internalCharge: json["internal_charge"],
        driverId: json["driver_id"],
        transactionableType: json["transactionable_type"],
        transactionableId: json["transactionable_id"],
        dateTime: DateTime.parse(json["date_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        details: Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "net_amount": netAmount,
        "bank_charge": bankCharge,
        "internal_charge": internalCharge,
        "driver_id": driverId,
        "transactionable_type": transactionableType,
        "transactionable_id": transactionableId,
        "date_time": dateTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "details": details?.toJson(),
      };
}

class Details {
  Details({
    this.transactionId,
    this.paymentGatewayHandler,
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
    this.updatedAt,
  });

  int? transactionId;
  String? paymentGatewayHandler;
  String? method;
  String? status;
  dynamic description;
  dynamic notes;
  dynamic transactionRefNumber;
  dynamic mpgSessionVersion;
  dynamic mpgSessionId;
  dynamic mpgSuccessIndicator;
  dynamic upgSystemRef;
  DateTime? dateTime;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        transactionId: json["transaction_id"],
        paymentGatewayHandler: json["payment-gateway-handler"],
        method: json["method"],
        status: json["status"],
        description: json["description"],
        notes: json["notes"],
        transactionRefNumber: json["transaction_ref_number"],
        mpgSessionVersion: json["mpg_session_version"],
        mpgSessionId: json["mpg_session_id"],
        mpgSuccessIndicator: json["mpg_success_indicator"],
        upgSystemRef: json["upg_system_ref"],
        dateTime: DateTime.parse(json["date_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "payment-gateway-handler": paymentGatewayHandler,
        "method": method,
        "status": status,
        "description": description,
        "notes": notes,
        "transaction_ref_number": transactionRefNumber,
        "mpg_session_version": mpgSessionVersion,
        "mpg_session_id": mpgSessionId,
        "mpg_success_indicator": mpgSuccessIndicator,
        "upg_system_ref": upgSystemRef,
        "date_time": dateTime?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
