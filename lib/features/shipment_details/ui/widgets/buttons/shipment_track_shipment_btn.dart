import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Models/shipment_tracking_model.dart';
import '../../../../../Providers/auth_provider.dart';
import '../../../../../Screens/handle_shipment.dart';
import '../../../../../Storage/shared_preference.dart';
import '../../../../../Utilits/colors.dart';
import '../../../../../Widgets/weevo_button.dart';
import '../../../../../core/helpers/toasts.dart';
import '../../../../../core/router/router.dart';
import '../../../logic/cubit/shipment_details_cubit.dart';

class ShipmentTrackShipmentBtn extends StatelessWidget {
  const ShipmentTrackShipmentBtn({super.key});

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    final data = cubit.shipmentDetails!;
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        isStable: true,
        color: weevoPrimaryOrangeColor,
        onTap: () async {
          await context
              .read<ShipmentDetailsCubit>()
              .getShipmentDetails(data.id);
          if (data.status == 'cancelled' ||
              data.status == 'delivered' ||
              data.status == 'returned' ||
              data.status == 'available') {
            showToast('الطلب ليست موجودة بعد للتتبع');
            return;
          }
          DocumentSnapshot merchantToken = await FirebaseFirestore.instance
              .collection('merchant_users')
              .doc(data.merchantId.toString())
              .get();
          String merchantNationalId = merchantToken['national_id'];
          String courierNationalId = Preferences.instance.getPhoneNumber;
          MagicRouter.navigateTo(
            HandleShipment(
              model: ShipmentTrackingModel(
                shipmentDetailsModel: data,
                courierNationalId: courierNationalId,
                merchantNationalId: merchantNationalId,
                shipmentId: data.id,
                deliveringState: data.deliveringState.toString(),
                deliveringCity: data.deliveringCity.toString(),
                receivingState: data.receivingState.toString(),
                receivingCity: data.receivingCity.toString(),
                deliveringLat: data.deliveringLat,
                clientPhone: data.clientPhone,
                hasChildren: 0,
                status: data.status,
                deliveringLng: data.deliveringLng,
                receivingLng: data.receivingLng,
                receivingLat: data.receivingLat,
                merchantId: data.merchantId,
                merchantImage: data.merchant?.photo,
                merchantPhone: data.merchant?.phone,
                merchantName: data.merchant?.name,
                courierId: data.courierId,
                paymentMethod: data.paymentMethod,
                courierImage: authProvider.photo,
                courierName: authProvider.name,
                courierPhone: authProvider.phone,
                deliveringStreet: data.deliveringStreet,
                receivingStreet: data.receivingStreet,
              ),
            ),
          );
        },
        title: (data.status == 'on-the-way-to-get-shipment-from-merchant')
            ? 'توجه للإستلام'
            : (data.status == 'on-delivery')
                ? 'توجه للتسليم'
                : 'إبدأ التوصيل',
      ),
    );
  }
}
