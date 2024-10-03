import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../Models/connectivity_enum.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  ConnectivityStatus _getStatusFromResult(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.cellular;
    } else if (result.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.wifi;
    }
    return ConnectivityStatus.offline;
  }
}
