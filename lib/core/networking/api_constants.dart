class ApiConstants {
  static const String baseUrl = 'https://eg.api.weevoapp.com'; // Production
  //static const String baseUrl = 'https://api-dev-mobile.weevoapp.com'; // Debug
  static const String shippingOffersUrl =
      '${ApiConstants.baseUrl}/api/v1/captain/shipping-offers';
  static const String myShipmentsUrl =
      '${ApiConstants.baseUrl}/api/v1/captain/my-shipments';
  static const String myShipmentsDetailsUrl =
      '${ApiConstants.baseUrl}/api/v1/captain/shipments';
  static const String wasullyDetails =
      '${ApiConstants.baseUrl}/api/v1/captain/wasuliy';
  static const String availableShipmentsUrl =
      '${ApiConstants.baseUrl}/api/v1/captain/available-offer-based-shipments';
  static const String wasullySendOfferUrl =
      '${ApiConstants.baseUrl}/api/v1/captain/wasuliy/shipping-offers/send-offer';
  static const String wasullyShippingOffers =
      '${ApiConstants.baseUrl}/api/v1/captain/wasuliy/shipping-offers';
  static const String wasullyApplyShipmentUrl =
      '${ApiConstants.baseUrl}/api/v1/captain/wasuliy/available-shipments/apply-to-shipment';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
