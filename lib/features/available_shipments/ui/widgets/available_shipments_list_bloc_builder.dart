import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../shipments/ui/widgets/shipments_loading.dart';
import '../../data/models/available_shipment_model.dart';
import '../../logic/cubit/available_shipments_cubit.dart';
import '../../logic/cubit/available_shipments_states.dart';
import 'available_shipment_tile.dart';

class AvailableShipmentsListBlocBuilder extends StatefulWidget {
  const AvailableShipmentsListBlocBuilder({super.key});

  @override
  State<AvailableShipmentsListBlocBuilder> createState() =>
      _AvailableShipmentsListBlocBuilderState();
}

class _AvailableShipmentsListBlocBuilderState
    extends State<AvailableShipmentsListBlocBuilder> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(addListener);
  }

  void addListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context
          .read<AvailableShipmentsCubit>()
          .getAvailableShipments(isPaging: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(addListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AvailableShipmentsCubit, AvailableShipmentsStates>(
      buildWhen: (previous, current) =>
          current is AvailableShipmentsLoadedState ||
          current is AvailableShipmentsErrorState ||
          current is AvailableShipmentsLoadingState ||
          current is AvailableShipmentsPagingLoadingState,
      builder: (context, state) {
        final cubit = context.read<AvailableShipmentsCubit>();
        if (state is AvailableShipmentsLoadedState &&
            cubit.availableShipments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/shipment_details_icon.png',
                  width: 80.0.w,
                  height: 80.0.h,
                ),
                verticalSpace(10),
                Text(
                  'لا يوجد لديك طلبات متاحة للتوصيل',
                  strutStyle: const StrutStyle(
                    forceStrutHeight: true,
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0.sp,
                  ),
                ),
              ],
            ),
          );
        }
        final shipments = context
            .select<AvailableShipmentsCubit, List<AvailableShipmentModel>>(
          (cubit) => cubit.availableShipments,
        );
        if (state is AvailableShipmentsLoadingState ||
            state is AvailableShipmentsErrorState) {
          return const ShipmentsLoading();
        }
        return RefreshIndicator(
          onRefresh: () async {
            await cubit.getAvailableShipments();
          },
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      int reverseIndex = shipments.length - index - 1;
                      if (reverseIndex < shipments.length) {
                        return AvailableShipmentTile(
                          availableShipment: shipments[reverseIndex],
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => verticalSpace(10),
                    itemCount: shipments.length +
                        (state is AvailableShipmentsPagingLoadingState ? 1 : 0),
                  ),
                  Visibility(
                    visible: state is AvailableShipmentsPagingLoadingState,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => const ShipmentsLoading(),
                      separatorBuilder: (context, index) => verticalSpace(10),
                      itemCount: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
