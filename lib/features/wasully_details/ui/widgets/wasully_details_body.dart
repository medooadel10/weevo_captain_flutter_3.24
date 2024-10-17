import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/data/models/shipment_status/base_shipment_status.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../data/models/wasully_model.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import 'wasully_details_buttons.dart';
import 'wasully_details_image.dart';
import 'wasully_details_info.dart';
import 'wasully_details_locations.dart';

class WasullyDetailsBody extends StatelessWidget {
  const WasullyDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WasullyDetailsCubit, WasullyDetailsState>(
      builder: (context, state) {
        final cubit = context.read<WasullyDetailsCubit>();
        if (cubit.wasullyModel != null) {
          WasullyModel wasullyModel = cubit.wasullyModel!;
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<WasullyDetailsCubit>()
                          .getWassullyDetails(
                            wasullyModel.id,
                          );
                      return Future.value();
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: BaseShipmentStatus
                              .shipmentStatusMap[wasullyModel.status]!
                              .buildWasullyMerchantHeader(context),
                        ),
                        SliverAppBar(
                          pinned: false,
                          floating: true,
                          snap: true,
                          leading: null,
                          automaticallyImplyLeading: false,
                          expandedHeight: 200.h,
                          backgroundColor: Colors.transparent,
                          flexibleSpace: FlexibleSpaceBar(
                            background: WasullyDetailsImage(
                              image: wasullyModel.image,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              verticalSpace(10),
                              WasullyDetailsInfo(
                                wasullyModel: wasullyModel,
                              ),
                              verticalSpace(16),
                              WasullyDetailsLocations(
                                wasullyModel: wasullyModel,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(10),
                WasullyDetailsButtons(
                  status: wasullyModel.status,
                ),
              ],
            ).paddingSymmetric(
              horizontal: 16.w,
              vertical: 5.h,
            ),
          );
        }
        return const Center(
          child: CustomLoadingIndicator(),
        );
      },
    );
  }
}
