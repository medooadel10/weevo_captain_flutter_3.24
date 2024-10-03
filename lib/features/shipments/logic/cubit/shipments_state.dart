import '../../data/models/shipment_model.dart';

abstract class ShipmentsStates {}

class ShipmentsInitialState extends ShipmentsStates {}

class ShipmentsChangeFilterState extends ShipmentsStates {
  final int index;

  ShipmentsChangeFilterState(this.index);
}

class ShipmentsLoadingState extends ShipmentsStates {}

class ShipmentsSuccessState extends ShipmentsStates {
  final List<ShipmentModel> shipments;

  ShipmentsSuccessState(this.shipments);
}

class ShipmentsErrorState extends ShipmentsStates {
  final String message;

  ShipmentsErrorState(this.message);
}

class ShipmentsPagingLoadingState extends ShipmentsStates {}
