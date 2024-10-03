import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/available_shipments_cubit.dart';
import '../widgets/available_shipments_body.dart';

class AvailableShipmentsScreen extends StatelessWidget {
  const AvailableShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AvailableShipmentsCubit(getIt())..streamAvailableShipments(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'الشحنات المتاحة',
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
            onPressed: () {
              MagicRouter.pop();
            },
          ),
        ),
        body: const AvailableShipmentsBody(),
      ),
    );
  }
}
