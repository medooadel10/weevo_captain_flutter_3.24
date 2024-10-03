part of 'wasully_handle_shipment_cubit.dart';

abstract class WasullyHandleShipmentState {}

class WasullyHandleShipmentInitial extends WasullyHandleShipmentState {}

class WasullyHandleShipmentRefreshQrCodeLoading
    extends WasullyHandleShipmentState {}

class WasullyhandleShipmentRefreshQrCodeSuccess
    extends WasullyHandleShipmentState {
  final RefreshQrcode refreshQrcode;

  WasullyhandleShipmentRefreshQrCodeSuccess(this.refreshQrcode);
}

class WasullyHandleShipmentRefreshQrCodeError
    extends WasullyHandleShipmentState {
  final String error;

  WasullyHandleShipmentRefreshQrCodeError(this.error);
}

class WasullyHandleShipmentValidateQrCodeLoading
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentValidateQrCodeSuccess
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentValidateQrCodeError
    extends WasullyHandleShipmentState {
  final String error;

  WasullyHandleShipmentValidateQrCodeError(this.error);
}

class WasullyHandleShipmentReviewMerchantLoading
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentReviewMerchantSuccess
    extends WasullyHandleShipmentState {}

class WasullyHandleShipmentReviewMerchantError
    extends WasullyHandleShipmentState {
  final String error;

  WasullyHandleShipmentReviewMerchantError(this.error);
}
