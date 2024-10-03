import 'dart:developer';

import 'package:bloc/bloc.dart';

import '../../../wasully_details/data/models/shipment_status/base_shipment_status.dart';
import '../../data/models/shipment_model.dart';
import '../../data/repos/shipments_repo.dart';
import 'shipments_state.dart';

class ShipmentsCubit extends Cubit<ShipmentsStates> {
  final ShipmentsRepo _shipmentsRepo;
  ShipmentsCubit(this._shipmentsRepo) : super(ShipmentsInitialState());

  int currentFilterIndex = 0;
  int lastRequestedFilterIndex = -1;

  void filterAndGetShipments(int index,
      {bool isForcedGetData = false, bool shipmentsCompleted = false}) async {
    if (!isForcedGetData &&
        (currentFilterIndex == index || state is ShipmentsLoadingState)) return;
    currentFilterIndex = index;
    lastRequestedFilterIndex = index;
    await getShipments(shipmentsCompleted: shipmentsCompleted);
    emit(ShipmentsChangeFilterState(index));
  }

  int currentPage = 1;
  bool hasMoreData = true;
  final int pageSize = 15;
  List<ShipmentModel>? shipments;
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
    if (result.success!) {
      hasMoreData = result.data!.shipments.length == pageSize;
      shipments ??= [];
      shipments!.addAll(result.data!.shipments);
      if ((isPaging && hasMoreData) || currentPage == 1) currentPage++;
      emit(ShipmentsSuccessState(result.data!.shipments));
    } else {
      log('Error: ${result.error}');
      emit(ShipmentsErrorState(result.error!));
    }
  }
}
