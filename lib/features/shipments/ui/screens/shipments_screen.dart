import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/shipments_cubit.dart';
import '../widgets/shipments_body.dart';

class ShipmentsScreen extends StatelessWidget {
  final bool shipmentsCompleted;
  const ShipmentsScreen({
    super.key,
    required this.shipmentsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShipmentsCubit(getIt())
        ..filterAndGetShipments(
          0,
          isForcedGetData: true,
          shipmentsCompleted: shipmentsCompleted,
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            shipmentsCompleted
                ? 'حالة الطلبات المكتملة'
                : 'حالة الطلبات المعلقة',
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
        body: ShipmentsBody(
          shipmentsCompleted: shipmentsCompleted,
        ),
      ),
    );
  }
}
