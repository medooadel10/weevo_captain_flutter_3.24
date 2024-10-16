import 'package:get_it/get_it.dart';

import '../../Storage/shared_preference.dart';
import '../../features/available_shipments/data/repos/available_shipments_repo.dart';
import '../../features/shipment_details/data/repos/shipment_details_repo.dart';
import '../../features/shipments/data/repos/shipments_repo.dart';
import '../../features/wasully_details/data/repos/wasully_details_repo.dart';
import '../../features/wasully_handle_shipment/data/repos/wasully_handle_shipment_repo.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  getIt.registerSingleton(Preferences.instance);

  // Shipments
  getIt.registerLazySingleton(() => ShipmentsRepo());

  // Wasully Details
  getIt.registerLazySingleton(() => WasullyDetailsRepo());

  // Shipment Details
  getIt.registerLazySingleton(() => ShipmentDetailsRepo());

  // Available Shipments
  getIt.registerLazySingleton(() => AvailableShipmentsRepo());

  // Wasully Handle Shipment
  getIt.registerLazySingleton(() => WasullyHandleShipmentRepo());
}
