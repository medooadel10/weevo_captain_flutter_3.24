import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions.dart';
import '../../logic/cubit/shipments_cubit.dart';
import 'shipment_filter_list_bloc_builder.dart';
import 'shipments_list_bloc_builder.dart';

class ShipmentsBody extends StatefulWidget {
  final bool shipmentsCompleted;

  const ShipmentsBody({
    super.key,
    required this.shipmentsCompleted,
  });

  @override
  State<ShipmentsBody> createState() => _ShipmentsBodyState();
}

class _ShipmentsBodyState extends State<ShipmentsBody> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController.addListener(_addListener);
  }

  void _addListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.9) {
      context.read<ShipmentsCubit>().getShipments(isPaging: true);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_addListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          context
              .read<ShipmentsCubit>()
              .getShipments(shipmentsCompleted: widget.shipmentsCompleted);
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: widget.shipmentsCompleted ? 60.h : 120.h,
              excludeHeaderSemantics: true,
              leading: null,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: ShipmentFilterListBlocBuilder(
                  shipmentsCompleted: widget.shipmentsCompleted,
                ).paddingSymmetric(
                  horizontal: 10.w,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ShipmentsListBlocBuilder(
                shipmentsCompleted: widget.shipmentsCompleted,
              ).paddingSymmetric(
                horizontal: 10.w,
                vertical: 10.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
