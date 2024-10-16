import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../logic/cubit/shipment_details_cubit.dart';

class ShipmentDetailsButtons extends StatelessWidget {
  const ShipmentDetailsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        final cubit = context.read<ShipmentDetailsCubit>();

        return state.maybeWhen(
            loading: () => const CustomLoadingIndicator(),
            orElse: () => BaseShipmentStatus
                .shipmentStatusMap[cubit.shipmentDetails!.status]!
                .buildShipmentDetailsButtons(context));
      },
    );
  }
}
