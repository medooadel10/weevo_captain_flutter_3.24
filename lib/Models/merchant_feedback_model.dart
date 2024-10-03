class MerchantFeedbackModel {
  final String message;
  final bool hasMessage;
  final double rateNumber;
  final String username;
  final String imageUrl;

  MerchantFeedbackModel({
    required this.message,
    required this.hasMessage,
    required this.rateNumber,
    required this.imageUrl,
    required this.username,
  });
}
