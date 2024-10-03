import '../../data/models/wasully_cancel_shipment_response.dart';
import '../../data/models/wasully_model.dart';
import '../../data/models/wasully_offer_response_body.dart';

class WasullyDetailsState {}

class WasullyDetailsInitialState extends WasullyDetailsState {}

class WasullyDetailsLoadingState extends WasullyDetailsState {}

class WasullyDetailsSuccessState extends WasullyDetailsState {
  final WasullyModel wasullyModel;

  WasullyDetailsSuccessState(this.wasullyModel);
}

class WasullyDetailsErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailsErrorState(this.error);
}

class WasullyCancelLoadingState extends WasullyDetailsState {}

class WasullyCancelSuccessState extends WasullyDetailsState {}

class WasullyCancelErrorState extends WasullyDetailsState {
  final String error;
  WasullyCancelErrorState(this.error);
}

class WasullyRestoreLoadingState extends WasullyDetailsState {}

class WasullyRestoreSuccessState extends WasullyDetailsState {}

class WasullyRestoreErrorState extends WasullyDetailsState {
  final String error;
  WasullyRestoreErrorState(this.error);
}

class WasullyDetailsSendOfferLoadingState extends WasullyDetailsState {}

class WasullyDetailsSendOfferSuccessState extends WasullyDetailsState {
  final WasullyOfferResponseBody data;

  WasullyDetailsSendOfferSuccessState(this.data);
}

class WasullyDetailsSendOfferErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailsSendOfferErrorState(this.error);
}

class WasullyDetailsApplyShipmentLoadingState extends WasullyDetailsState {}

class WasullyDetailsApplyShipmentSuccessState extends WasullyDetailsState {}

class WasullyDetailsApplyShipmentErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailsApplyShipmentErrorState(this.error);
}

class WasullyDetailsCancelShipmentLoadingState extends WasullyDetailsState {}

class WasullyDetailsCancelShipmentSuccessState extends WasullyDetailsState {
  final WasullyCancelShipmentResponse data;
  WasullyDetailsCancelShipmentSuccessState(this.data);
}

class WasullyDetailsCancelShipmentErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailsCancelShipmentErrorState(this.error);
}

class WasullyDetailsOnMyWayLoadingState extends WasullyDetailsState {}

class WasullyDetailsOnMyWaySuccessState extends WasullyDetailsState {}

class WasullyDetailsOnMyWayErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailsOnMyWayErrorState(this.error);
}

class WasullyDetailshandleShipmentSuccessState extends WasullyDetailsState {
  final String merchantNationalId;

  WasullyDetailshandleShipmentSuccessState(this.merchantNationalId);
}

class WasullyDetailshandleShipmentErrorState extends WasullyDetailsState {
  final String error;
  WasullyDetailshandleShipmentErrorState(this.error);
}

class WasullyDetailshandleShipmentLoadingState extends WasullyDetailsState {}
