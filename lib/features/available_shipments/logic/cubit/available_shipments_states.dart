import '../../data/models/available_shipment_model.dart';

abstract class AvailableShipmentsStates {}

class AvailableShipmentsInitialState extends AvailableShipmentsStates {}

class AvailableShipmentsLoadingState extends AvailableShipmentsStates {}

class AvailableShipmentsPagingLoadingState extends AvailableShipmentsStates {}

class AvailableShipmentsLoadedState extends AvailableShipmentsStates {
  final List<AvailableShipmentModel> availableShipments;
  AvailableShipmentsLoadedState(this.availableShipments);
}

class AvailableShipmentsErrorState extends AvailableShipmentsStates {
  final String message;
  AvailableShipmentsErrorState(this.message);
}
