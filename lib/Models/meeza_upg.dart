class MeezaUpgResponse {
  String? message;
  bool? success;
  String? acsUrl;
  String? actionCode;
  int? amountByPoint;
  int? amountWithoutPoint;
  String? authCode;
  bool? cardinalChallengeComplete;
  bool? cardinalChallengeRequired;
  bool? cardinalChallengeRequiredWithoutCardinalSDK;
  String? cardinalCruiseJWT;
  bool? cardinalNotChallengeRequired;
  bool? challengeRequired;
  String? cyberSourceFingerPrintOrgId;
  String? cyberSourceFingerPrintReference;
  String? cyberSourceMerchantId;
  String? cyberSourceOrgUnitId;
  String? displayData;
  String? fingerPrintServerUrl;
  String? gatewayType;
  bool? isApplePay;
  bool? isSamsungPay;
  String? mWActionCode;
  String? mWMessage;
  String? merchantReference;
  String? networkReference;
  String? orderNumber;
  String? paReq;
  String? pointMessage;
  bool? pointSuccess;
  bool? preChallengeRequired;
  String? receiptNumber;
  String? refNumber;
  String? responseURL;
  String? returnURL;
  int? systemReference;
  String? threeDSTxnId;
  String? threeDSUrl;
  String? transactionNo;
  String? n3dHostCardinalJSUrl;
  String? authenticationTransactionId;

  MeezaUpgResponse(
      {this.message,
      this.success,
      this.acsUrl,
      this.actionCode,
      this.amountByPoint,
      this.amountWithoutPoint,
      this.authCode,
      this.cardinalChallengeComplete,
      this.cardinalChallengeRequired,
      this.cardinalChallengeRequiredWithoutCardinalSDK,
      this.cardinalCruiseJWT,
      this.cardinalNotChallengeRequired,
      this.challengeRequired,
      this.cyberSourceFingerPrintOrgId,
      this.cyberSourceFingerPrintReference,
      this.cyberSourceMerchantId,
      this.cyberSourceOrgUnitId,
      this.displayData,
      this.fingerPrintServerUrl,
      this.gatewayType,
      this.isApplePay,
      this.isSamsungPay,
      this.mWActionCode,
      this.mWMessage,
      this.merchantReference,
      this.networkReference,
      this.orderNumber,
      this.paReq,
      this.pointMessage,
      this.pointSuccess,
      this.preChallengeRequired,
      this.receiptNumber,
      this.refNumber,
      this.responseURL,
      this.returnURL,
      this.systemReference,
      this.threeDSTxnId,
      this.threeDSUrl,
      this.transactionNo,
      this.n3dHostCardinalJSUrl,
      this.authenticationTransactionId});

  MeezaUpgResponse.fromJson(Map<String, dynamic> json) {
    message = json['Message'];
    success = json['Success'];
    acsUrl = json['AcsUrl'];
    actionCode = json['ActionCode'];
    amountByPoint = json['AmountByPoint'];
    amountWithoutPoint = json['AmountWithoutPoint'];
    authCode = json['AuthCode'];
    cardinalChallengeComplete = json['CardinalChallengeComplete'];
    cardinalChallengeRequired = json['CardinalChallengeRequired'];
    cardinalChallengeRequiredWithoutCardinalSDK =
        json['CardinalChallengeRequiredWithoutCardinalSDK'];
    cardinalCruiseJWT = json['CardinalCruiseJWT'];
    cardinalNotChallengeRequired = json['CardinalNotChallengeRequired'];
    challengeRequired = json['ChallengeRequired'];
    cyberSourceFingerPrintOrgId = json['CyberSourceFingerPrintOrgId'];
    cyberSourceFingerPrintReference = json['CyberSourceFingerPrintReference'];
    cyberSourceMerchantId = json['CyberSourceMerchantId'];
    cyberSourceOrgUnitId = json['CyberSourceOrgUnitId'];
    displayData = json['DisplayData'];
    fingerPrintServerUrl = json['FingerPrintServerUrl'];
    gatewayType = json['GatewayType'];
    isApplePay = json['IsApplePay'];
    isSamsungPay = json['IsSamsungPay'];
    mWActionCode = json['MWActionCode'];
    mWMessage = json['MWMessage'];
    merchantReference = json['MerchantReference'];
    networkReference = json['NetworkReference'];
    orderNumber = json['OrderNumber'];
    paReq = json['PaReq'];
    pointMessage = json['PointMessage'];
    pointSuccess = json['PointSuccess'];
    preChallengeRequired = json['PreChallengeRequired'];
    receiptNumber = json['ReceiptNumber'];
    refNumber = json['RefNumber'];
    responseURL = json['ResponseURL'];
    returnURL = json['ReturnURL'];
    systemReference = json['SystemReference'];
    threeDSTxnId = json['ThreeDSTxnId'];
    threeDSUrl = json['ThreeDSUrl'];
    transactionNo = json['TransactionNo'];
    n3dHostCardinalJSUrl = json['_3dHostCardinalJSUrl'];
    authenticationTransactionId = json['authenticationTransactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Message'] = message;
    data['Success'] = success;
    data['AcsUrl'] = acsUrl;
    data['ActionCode'] = actionCode;
    data['AmountByPoint'] = amountByPoint;
    data['AmountWithoutPoint'] = amountWithoutPoint;
    data['AuthCode'] = authCode;
    data['CardinalChallengeComplete'] = cardinalChallengeComplete;
    data['CardinalChallengeRequired'] = cardinalChallengeRequired;
    data['CardinalChallengeRequiredWithoutCardinalSDK'] =
        cardinalChallengeRequiredWithoutCardinalSDK;
    data['CardinalCruiseJWT'] = cardinalCruiseJWT;
    data['CardinalNotChallengeRequired'] = cardinalNotChallengeRequired;
    data['ChallengeRequired'] = challengeRequired;
    data['CyberSourceFingerPrintOrgId'] = cyberSourceFingerPrintOrgId;
    data['CyberSourceFingerPrintReference'] = cyberSourceFingerPrintReference;
    data['CyberSourceMerchantId'] = cyberSourceMerchantId;
    data['CyberSourceOrgUnitId'] = cyberSourceOrgUnitId;
    data['DisplayData'] = displayData;
    data['FingerPrintServerUrl'] = fingerPrintServerUrl;
    data['GatewayType'] = gatewayType;
    data['IsApplePay'] = isApplePay;
    data['IsSamsungPay'] = isSamsungPay;
    data['MWActionCode'] = mWActionCode;
    data['MWMessage'] = mWMessage;
    data['MerchantReference'] = merchantReference;
    data['NetworkReference'] = networkReference;
    data['OrderNumber'] = orderNumber;
    data['PaReq'] = paReq;
    data['PointMessage'] = pointMessage;
    data['PointSuccess'] = pointSuccess;
    data['PreChallengeRequired'] = preChallengeRequired;
    data['ReceiptNumber'] = receiptNumber;
    data['RefNumber'] = refNumber;
    data['ResponseURL'] = responseURL;
    data['ReturnURL'] = returnURL;
    data['SystemReference'] = systemReference;
    data['ThreeDSTxnId'] = threeDSTxnId;
    data['ThreeDSUrl'] = threeDSUrl;
    data['TransactionNo'] = transactionNo;
    data['_3dHostCardinalJSUrl'] = n3dHostCardinalJSUrl;
    data['authenticationTransactionId'] = authenticationTransactionId;
    return data;
  }
}
