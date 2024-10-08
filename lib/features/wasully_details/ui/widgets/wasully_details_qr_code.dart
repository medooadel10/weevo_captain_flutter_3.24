import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Dialogs/loading.dart';
import '../../../../Dialogs/qr_dialog_code.dart';
import '../../../../Models/refresh_qr_code.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Utilits/constants.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/dio_factory.dart';
import '../../../wasully_handle_shipment/ui/widgets/wasully_courier_to_customer_qrcode_dialog.dart';
import '../../../wasully_handle_shipment/ui/widgets/wasully_merchant_to_courier_qr_code_dialog.dart';
import '../../logic/cubit/wasully_details_cubit.dart';

class WasullyDetailsQrCode extends StatelessWidget {
  final String? status;
  final String? merchantNationalId;
  final String? courierNationalId;
  final String? locationId;
  const WasullyDetailsQrCode({
    super.key,
    this.status,
    this.merchantNationalId,
    this.courierNationalId,
    this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    if (status == 'receivingShipment' ||
        status == 'handingOverShipmentToCustomer' ||
        status == 'handingOverReturnedShipmentToMerchant') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            if (status == 'receivingShipment') {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => WasullyMerchantToCourierQrCodeScanner(
                        parentContext: context,
                        model: ShipmentTrackingModel(
                          wasullyId: cubit.wasullyModel!.slug.split('-')[1],
                          merchantNationalId: merchantNationalId,
                          courierNationalId: authProvider.phone,
                          shipmentId: cubit.wasullyModel!.id,
                          deliveringState:
                              cubit.wasullyModel!.deliveringStateCode,
                          status: cubit.wasullyModel!.status,
                          hasChildren: 0,
                          deliveringCity:
                              cubit.wasullyModel!.deliveringCityCode,
                          receivingState:
                              cubit.wasullyModel!.receivingStateCode,
                          receivingStreet: cubit.wasullyModel!.receivingStreet,
                          receivingApartment: '',
                          receivingBuildingNumber: '',
                          receivingFloor: '',
                          receivingLandmark: '',
                          receivingLat:
                              cubit.wasullyModel!.receivingLat.toString(),
                          receivingLng:
                              cubit.wasullyModel!.receivingLng.toString(),
                          clientPhone: cubit.wasullyModel!.clientPhone,
                          receivingCity: cubit.wasullyModel!.receivingCityCode,
                          paymentMethod: cubit.wasullyModel!.paymentMethod,
                          deliveringLat:
                              cubit.wasullyModel!.deliveringLat.toString(),
                          deliveringLng:
                              cubit.wasullyModel!.deliveringLng.toString(),
                          fromLat: authProvider.locationData!.latitude,
                          fromLng: authProvider.locationData!.longitude,
                          merchantId: cubit.wasullyModel!.merchant.id,
                          courierId: cubit.wasullyModel!.courier.id,
                          merchantImage: cubit.wasullyModel!.merchant.photo,
                          merchantName: cubit.wasullyModel!.merchant.name,
                          merchantPhone: cubit.wasullyModel!.merchant.phone,
                          courierName: authProvider.name,
                          courierImage: authProvider.photo,
                          courierPhone: authProvider.phone,
                          wasullyModel: cubit.wasullyModel,
                          deliveringStreet:
                              cubit.wasullyModel!.deliveringStreet,
                        ),
                        locationId: locationId!,
                      ));
            } else if (status == 'handingOverShipmentToCustomer') {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => WasullyCourierToCustomerQrCodeScanner(
                      parentContext: context,
                      model: ShipmentTrackingModel(
                        wasullyId: cubit.wasullyModel!.slug.split('-')[1],
                        merchantNationalId: merchantNationalId,
                        courierNationalId: authProvider.phone,
                        shipmentId: cubit.wasullyModel!.id,
                        deliveringState:
                            cubit.wasullyModel!.deliveringStateCode,
                        status: cubit.wasullyModel!.status,
                        hasChildren: 0,
                        deliveringCity: cubit.wasullyModel!.deliveringCityCode,
                        receivingState: cubit.wasullyModel!.receivingStateCode,
                        receivingStreet: cubit.wasullyModel!.receivingStreet,
                        receivingApartment: '',
                        receivingBuildingNumber: '',
                        receivingFloor: '',
                        receivingLandmark: '',
                        receivingLat:
                            cubit.wasullyModel!.receivingLat.toString(),
                        receivingLng:
                            cubit.wasullyModel!.receivingLng.toString(),
                        clientPhone: cubit.wasullyModel!.clientPhone,
                        receivingCity: cubit.wasullyModel!.receivingCityCode,
                        paymentMethod: cubit.wasullyModel!.paymentMethod,
                        deliveringLat:
                            cubit.wasullyModel!.deliveringLat.toString(),
                        deliveringLng:
                            cubit.wasullyModel!.deliveringLng.toString(),
                        fromLat: authProvider.locationData!.latitude,
                        fromLng: authProvider.locationData!.longitude,
                        merchantId: cubit.wasullyModel!.merchant.id,
                        courierId: cubit.wasullyModel!.courier.id,
                        merchantImage: cubit.wasullyModel!.merchant.photo,
                        merchantName: cubit.wasullyModel!.merchant.name,
                        merchantPhone: cubit.wasullyModel!.merchant.phone,
                        courierName: Preferences.instance.getUserName,
                        courierImage: authProvider.photo,
                        courierPhone: authProvider.phone,
                        wasullyModel: cubit.wasullyModel,
                        deliveringStreet: cubit.wasullyModel!.deliveringStreet,
                      ),
                      locationId: locationId!));
            } else if (status == 'handingOverReturnedShipmentToMerchant') {
              if (cubit.wasullyModel?.handoverCodeCourierToMerchant == null &&
                  cubit.wasullyModel?.handoverQrcodeCourierToMerchant == null) {
                showDialog(
                    context: context, builder: (context) => const Loading());
                await refreshHandoverQrcodeCourierToMerchant(
                    cubit.wasullyModel!.id);
                check(
                    auth: authProvider,
                    state: NetworkState.success,
                    ctx: navigator.currentContext!);
              } else {
                showDialog(
                  context: context,
                  builder: (context) => QrCodeDialog(
                    data: RefreshQrcode(
                        filename: cubit
                            .wasullyModel?.handoverQrcodeCourierToMerchant
                            ?.split('/')
                            .last,
                        path:
                            cubit.wasullyModel?.handoverQrcodeCourierToMerchant,
                        code: int.parse(
                            cubit.wasullyModel!.handoverCodeCourierToMerchant ??
                                '')),
                  ),
                );
              }
            }
          },
          backgroundColor: weevoPrimaryOrangeColor,
          child: const Icon(
            Icons.qr_code,
            color: Colors.white,
          ),
        ),
      );
    }
    return Container();
  }

  Future<RefreshQrcode> refreshHandoverQrcodeCourierToMerchant(
      int shipmentId) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliys/$shipmentId/refresh-handover-qrcode-ctm',
        data: {},
        token: token,
      );
      return RefreshQrcode.fromJson(response.data);
    } on DioException {
      return RefreshQrcode.fromJson({});
    }
  }
}
