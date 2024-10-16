import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../Storage/shared_preference.dart';
import '../../../../../Utilits/colors.dart';
import '../../../../../Widgets/weevo_button.dart';
import '../../../logic/cubit/shipment_details_cubit.dart';
import '../shipment_cancel_dialog.dart';

class ShipmentCancelBtn extends StatelessWidget {
  final Color? color;
  const ShipmentCancelBtn({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();

    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        onTap: () {
          showDialog(
            context: navigator.currentContext!,
            builder: (_) {
              return BlocProvider.value(
                value: cubit,
                child: const ShipmentCancelDialog(),
              );
            },
          );
        },
        title: 'إلغاء الطلب',
        color: color ?? weevoPrimaryBlueColor,
        isStable: true,
      ),
    );
  }
}
