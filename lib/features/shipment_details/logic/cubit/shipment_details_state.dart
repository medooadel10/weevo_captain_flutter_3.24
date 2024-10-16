part of 'shipment_details_cubit.dart';

@freezed
abstract class ShipmentDetailsState with _$ShipmentDetailsState {
  const factory ShipmentDetailsState.initial() = _Initial;
  const factory ShipmentDetailsState.loading() = Loading;
  const factory ShipmentDetailsState.success(ShipmentDetailsModel data) =
      Success;
  const factory ShipmentDetailsState.error(String error) = Error;

  const factory ShipmentDetailsState.changeProductIndex(int value) =
      ChangeProductIndex;

  const factory ShipmentDetailsState.cancelShipmentLoading() =
      CancelShipmentLoading;

  const factory ShipmentDetailsState.cancelShipmentSuccess() =
      CancelShipmentSuccess;

  const factory ShipmentDetailsState.cancelShipmentError(String error) =
      CancelShipmentError;

  const factory ShipmentDetailsState.updatePriceLoading() = UpdatePriceLoading;

  const factory ShipmentDetailsState.updatePriceSuccess() = UpdatePriceSuccess;

  const factory ShipmentDetailsState.updatePriceError(String error) =
      UpdatePriceError;

  const factory ShipmentDetailsState.restoreCancelLoading() =
      RestoreCancelLoading;

  const factory ShipmentDetailsState.restoreCancelSuccess() =
      RestoreCancelSuccess;

  const factory ShipmentDetailsState.restoreCancelError(String error) =
      RestoreCancelError;
}
