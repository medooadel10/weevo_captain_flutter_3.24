class WasullyCancelShipmentResponse {
  final String message;
  final String merchantMessage;

  WasullyCancelShipmentResponse(this.message, this.merchantMessage);

  factory WasullyCancelShipmentResponse.fromJson(Map<String, dynamic> json) =>
      WasullyCancelShipmentResponse(
        json['message'],
        json['merchant_message'],
      );
}
