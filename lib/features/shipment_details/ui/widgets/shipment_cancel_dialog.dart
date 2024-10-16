import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weevo_captain_app/Screens/home.dart';

import '../../../../Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/helpers/toasts.dart';
import '../../../../core/router/router.dart';
import '../../../../core/widgets/custom_loading_indicator.dart';
import '../../logic/cubit/shipment_details_cubit.dart';

class ShipmentCancelDialog extends StatelessWidget {
  const ShipmentCancelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ShipmentDetailsCubit cubit = context.read();
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: 20.0.w,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0.w,
            vertical: 20.0.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تأكيد الغاء الطلب ؟',
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              verticalSpace(12),
              BlocConsumer<ShipmentDetailsCubit, ShipmentDetailsState>(
                listener: (context, state) {
                  if (state is CancelShipmentSuccess) {
                    showToast('تم الغاء الطلب بنجاح');
                    // Cancel Dialog
                    MagicRouter.pop(); // Naviagte to shipments screen
                    MagicRouter.navigateAndPopAll(Home());
                  }
                  if (state is CancelShipmentError) {
                    MagicRouter.pop();
                    cubit.getShipmentDetails(cubit.shipmentDetails!.id);
                    showToast('لا يمكنك إلغاء هذا الطلب', isError: true);
                  }
                },
                builder: (context, state) {
                  if (state is CancelShipmentLoading) {
                    return const Center(
                      child: CustomLoadingIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      WeevoButton(
                        onTap: () {
                          cubit.cancelShipment();
                        },
                        title: 'الغاء الطلب',
                        color: weevoPrimaryOrangeColor,
                        isStable: true,
                      ),
                      verticalSpace(8),
                      WeevoButton(
                        onTap: () {
                          MagicRouter.pop();
                        },
                        title: 'الغاء',
                        color: weevoRedColor,
                        isStable: true,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
