import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Utilits/colors.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/shipment_details_cubit.dart';
import 'shipment_details_app_bar_title.dart';

class ShipmentDetailsAppBar extends StatelessWidget {
  final int? id;
  const ShipmentDetailsAppBar({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ShipmentDetailsCubit>();
    return BlocBuilder<ShipmentDetailsCubit, ShipmentDetailsState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: weevoPrimaryOrangeColor,
                onPressed: () {
                  MagicRouter.pop(data: cubit.shipmentDetails);
                },
              ),
              Expanded(
                child: ShipmentDetailsAppBarTitle(
                  id: id,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
