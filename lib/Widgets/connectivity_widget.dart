import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/connectivity_enum.dart';
import 'no_connection_widget.dart';

class ConnectivityWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback callback;

  const ConnectivityWidget({
    super.key,
    required this.child,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.wifi ||
        connectionStatus == ConnectivityStatus.cellular) {
      callback();
      return child;
    } else {
      return const Scaffold(body: NoConnectionWidget());
    }
  }
}
