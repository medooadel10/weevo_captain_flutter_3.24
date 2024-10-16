import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Storage/shared_preference.dart';
import '../logic/cubit/shipment_details_cubit.dart';
import 'widgets/shipment_details_body.dart';

class ShipmentDetailsScreen extends StatefulWidget {
  final int id;
  const ShipmentDetailsScreen({super.key, required this.id});

  @override
  State<ShipmentDetailsScreen> createState() => _ShipmentDetailsScreenState();
}

class _ShipmentDetailsScreenState extends State<ShipmentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    await cubit.getShipmentDetails(widget.id);
    cubit.streamShipmentStatus(navigator.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        log('Status : ${context.read<ShipmentDetailsCubit>().shipmentDetails?.status}');

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ShipmentDetailsBody(
              id: widget.id,
            ),
          ),
        );
      },
    );
  }
}
