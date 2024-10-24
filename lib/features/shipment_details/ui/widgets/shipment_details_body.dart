import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../data/models/shipment_details_model.dart';
import '../../logic/cubit/shipment_details_cubit.dart';
import 'shipment_details_app_bar.dart';
import 'shipment_details_buttons.dart';
import 'shipment_details_header.dart';
import 'shipment_details_info.dart';
import 'shipment_details_locations.dart';

class ShipmentDetailsBody extends StatelessWidget {
  final int? id;
  const ShipmentDetailsBody({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
        ShipmentDetailsModel? shipmentDetails = cubit.shipmentDetails;

        return Column(
          children: [
            ShipmentDetailsAppBar(
              id: id,
            ),
            if (shipmentDetails == null)
              const Expanded(
                child: Center(
                  child: CustomLoadingIndicator(),
                ),
              ),
            if (shipmentDetails != null)
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 10.0.h,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await cubit.getShipmentDetails(shipmentDetails.id);
                            return Future.value();
                          },
                          child: CustomScrollView(
                            slivers: [
                              SliverToBoxAdapter(
                                child: BaseShipmentStatus
                                    .shipmentStatusMap[shipmentDetails.status]!
                                    .buildShipmentMerchantHeader(context),
                              ),
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    ShipmentDetailsHeader(),
                                    verticalSpace(10),
                                    ShipmentDetailsInfo(
                                      shipmentDetails: shipmentDetails,
                                    ),
                                    verticalSpace(16),
                                    ShipmentDetailsLocations(
                                      shipmentModel: shipmentDetails,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      verticalSpace(10),
                      const ShipmentDetailsButtons(),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
