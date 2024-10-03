import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../wasully_details/data/models/shipment_status/base_shipment_status.dart';
import '../../logic/cubit/shipments_cubit.dart';
import '../../logic/cubit/shipments_state.dart';
import 'shipment_filter_item.dart';

class ShipmentFilterListBlocBuilder extends StatelessWidget {
  final bool shipmentsCompleted;
  const ShipmentFilterListBlocBuilder(
      {super.key, required this.shipmentsCompleted});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentsCubit, ShipmentsStates>(
      builder: (context, state) {
        ShipmentsCubit cubit = context.read<ShipmentsCubit>();
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 10.0.w,
            runSpacing: 10.0.h,
            children: List.generate(
              shipmentsCompleted
                  ? BaseShipmentStatus.closedShipmentStatusList.length
                  : BaseShipmentStatus.shipmentStatusList.length,
              (i) => GestureDetector(
                onTap: () => cubit.filterAndGetShipments(i,
                    shipmentsCompleted: shipmentsCompleted),
                child: ShipmentFilterItem(
                  data: shipmentsCompleted
                      ? BaseShipmentStatus.closedShipmentStatusList[i]
                      : BaseShipmentStatus.shipmentStatusList[i],
                  isSelected: cubit.currentFilterIndex == i,
                  isLoading: state is ShipmentsLoadingState,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
