import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../data/models/available_shipment_model.dart';
import '../../data/repos/available_shipments_repo.dart';
import 'available_shipments_states.dart';

class AvailableShipmentsCubit extends Cubit<AvailableShipmentsStates> {
  final AvailableShipmentsRepo _availableShipmentsRepo;
  AvailableShipmentsCubit(this._availableShipmentsRepo)
      : super(AvailableShipmentsInitialState());

  List<AvailableShipmentModel> availableShipments = [];
  int currentPage = 1;
  bool hasMoreData = true;
  Timer? _timer;
  bool isFirstTime = true;

  void streamAvailableShipments() async {
    await getAvailableShipments();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      getAvailableShipments(isPeriodicUpdate: true);
    });
  }

  Future<void> getAvailableShipments(
      {bool isPaging = false, bool isPeriodicUpdate = false}) async {
    if (isPaging) {
      if (!hasMoreData ||
          state is AvailableShipmentsPagingLoadingState ||
          state is AvailableShipmentsLoadingState) return;
      currentPage++;
      if (!isClosed) emit(AvailableShipmentsPagingLoadingState());
    } else if (!isPeriodicUpdate) {
      // Clear the list and reset the page only if it's not a periodic update
      currentPage = 1;
      hasMoreData = true;
      availableShipments.clear();
      emit(AvailableShipmentsLoadingState());
    }

    final result =
        await _availableShipmentsRepo.getAvailableShipments(currentPage);
    if (result.success!) {
      isFirstTime = false;
      hasMoreData = result.data!.availableShipments.length == 15;
      if (!isPaging && !isPeriodicUpdate) {
        availableShipments = result.data!.availableShipments;
      } else {
        final ids = availableShipments.map((e) => e.id).toSet();
        availableShipments.addAll(result.data!.availableShipments
            .where((item) => !ids.contains(item.id)));
      }
      emit(AvailableShipmentsLoadedState(availableShipments));
    } else {
      emit(AvailableShipmentsErrorState(result.error!));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
