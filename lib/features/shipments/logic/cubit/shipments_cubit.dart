import 'package:bloc/bloc.dart';
import 'package:weevo_captain_app/features/shipments/data/models/shipments_response_body.dart';

import '../../../../core/data/models/shipment_status/base_shipment_status.dart';
import '../../data/models/shipment_model.dart';
import '../../data/repos/shipments_repo.dart';
import 'shipments_state.dart';

class ShipmentsCubit extends Cubit<ShipmentsStates> {
  final ShipmentsRepo _shipmentsRepo;
  ShipmentsCubit(this._shipmentsRepo) : super(ShipmentsInitialState());

  int currentFilterIndex = 0;

  void filterAndGetShipments(int index,
      {bool isForcedGetData = false, bool shipmentsCompleted = false}) async {
    if (!isForcedGetData &&
        (currentFilterIndex == index || state is ShipmentsLoadingState)) return;
    currentFilterIndex = index;
    await getShipments(shipmentsCompleted: shipmentsCompleted);
    emit(ShipmentsChangeFilterState(index));
  }

  int currentPage = 1;
  bool hasMoreData = true;
  List<ShipmentModel>? shipments;
  ShipmentsResponseBody? shipmentsResponseBody;
  Future<void> getShipments(
      {bool isPaging = false, bool shipmentsCompleted = false}) async {
    if (state is ShipmentsLoadingState ||
        state is ShipmentsPagingLoadingState) {
      return;
    }
    if (isPaging) {
      if (!hasMoreData) return;
      emit(ShipmentsPagingLoadingState());
    } else {
      currentPage = 1;
      shipments = null;
      hasMoreData = true;
      emit(ShipmentsLoadingState());
    }
    final result = await _shipmentsRepo.getShipments(
      shipmentsCompleted
          ? BaseShipmentStatus
              .closedShipmentStatusList[currentFilterIndex].status
          : BaseShipmentStatus.shipmentStatusList[currentFilterIndex].status,
      currentPage,
    );
    if (result.success) {
      shipmentsResponseBody = result.data;
      hasMoreData =
          result.data!.shipments.length == shipmentsResponseBody?.perPage;
      shipments ??= [];
      shipments!.addAll(result.data!.shipments);
      if ((isPaging && hasMoreData) || currentPage == 1) currentPage++;
      emit(ShipmentsSuccessState(result.data!.shipments));
    } else {
      emit(ShipmentsErrorState(result.error));
    }
  }
}
