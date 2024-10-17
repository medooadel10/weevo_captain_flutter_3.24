import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core/helpers/spacing.dart';
import '../../data/models/shipment_model.dart';
import '../../logic/cubit/shipments_cubit.dart';
import '../../logic/cubit/shipments_state.dart';
import 'shipment_tile.dart';
import 'shipments_loading.dart';

class ShipmentsListBlocBuilder extends StatelessWidget {
  final bool shipmentsCompleted;

  const ShipmentsListBlocBuilder({
    super.key,
    required this.shipmentsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    List<BaseShipmentStatus> shipmentStatusList = shipmentsCompleted
        ? BaseShipmentStatus.closedShipmentStatusList
        : BaseShipmentStatus.shipmentStatusList;
    return BlocBuilder<ShipmentsCubit, ShipmentsStates>(
      buildWhen: (previous, current) =>
          current is ShipmentsLoadingState ||
          current is ShipmentsSuccessState ||
          current is ShipmentsErrorState ||
          current is ShipmentsPagingLoadingState,
      builder: (context, state) {
        final cubit = context.read<ShipmentsCubit>();
        if (state is ShipmentsLoadingState ||
            state is ShipmentsErrorState ||
            cubit.shipments == null) {
          return const ShipmentsLoading();
        } else if (cubit.shipments!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/shipment_details_icon.png',
                  width: 40.0.w,
                  height: 40.0.h,
                ),
                verticalSpace(10),
                Text(
                  'لا يوجد لديك طلبات ${shipmentStatusList[cubit.currentFilterIndex].statusAr}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ShipmentModel shipment = cubit.shipments![index];
                  return ShipmentTile(
                    shipment: shipment,
                  );
                },
                separatorBuilder: (context, index) => verticalSpace(14),
                itemCount: cubit.shipments!.length,
              ),
              if (state is ShipmentsPagingLoadingState) ...[
                verticalSpace(14),
                const ShipmentsLoading(
                  itemCount: 3,
                ),
              ],
              verticalSpace(14),
            ],
          ),
        );
      },
    );
  }
}
