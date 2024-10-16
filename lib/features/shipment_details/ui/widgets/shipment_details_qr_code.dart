import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Dialogs/courier_to_customer_qr_code_dialog.dart';
import '../../../../Dialogs/loading.dart' as loading;
import '../../../../Dialogs/merchant_to_courier_qr_code_dialog.dart';
import '../../../../Dialogs/qr_dialog_code.dart';
import '../../../../Models/refresh_qr_code.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Utilits/constants.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/dio_factory.dart';
import '../../logic/cubit/shipment_details_cubit.dart';

class ShipmentDetailsQrCode extends StatelessWidget {
  final String? status;
  final String? merchantNationalId;
  final String? courierNationalId;
  final String? locationId;
  const ShipmentDetailsQrCode({
    super.key,
    this.status,
    this.merchantNationalId,
    this.courierNationalId,
    this.locationId,
  });

  @override
  Widget build(BuildContext context) {
    ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
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
                  builder: (ctx) => MerchantToCourierQrCodeScanner(
                        parentContext: context,
                        model: ShipmentTrackingModel(
                          merchantNationalId: merchantNationalId,
                          courierNationalId: authProvider.phone,
                          shipmentId: cubit.shipmentDetails!.id,
                          deliveringState:
                              cubit.shipmentDetails!.deliveringState,
                          status: cubit.shipmentDetails!.status,
                          hasChildren: 0,
                          deliveringCity: cubit.shipmentDetails!.deliveringCity,
                          receivingState: cubit.shipmentDetails!.receivingState,
                          receivingStreet:
                              cubit.shipmentDetails!.receivingStreet,
                          receivingApartment: '',
                          receivingBuildingNumber: '',
                          receivingFloor: '',
                          receivingLandmark: '',
                          receivingLat:
                              cubit.shipmentDetails!.receivingLat.toString(),
                          receivingLng:
                              cubit.shipmentDetails!.receivingLng.toString(),
                          clientPhone: cubit.shipmentDetails!.clientPhone,
                          receivingCity: cubit.shipmentDetails!.receivingCity,
                          paymentMethod: cubit.shipmentDetails!.paymentMethod,
                          deliveringLat:
                              cubit.shipmentDetails!.deliveringLat.toString(),
                          deliveringLng:
                              cubit.shipmentDetails!.deliveringLng.toString(),
                          fromLat: authProvider.locationData?.latitude ?? 0.0,
                          fromLng: authProvider.locationData?.longitude ?? 0.0,
                          merchantId: cubit.shipmentDetails!.merchant?.id,
                          courierId: int.tryParse(authProvider.id!),
                          merchantImage: cubit.shipmentDetails!.merchant?.photo,
                          merchantName: cubit.shipmentDetails!.merchant?.name,
                          merchantPhone: cubit.shipmentDetails!.merchant?.phone,
                          courierName: authProvider.name,
                          courierImage: authProvider.photo,
                          courierPhone: authProvider.phone,
                          deliveringStreet:
                              cubit.shipmentDetails!.deliveringStreet,
                        ),
                        locationId: locationId!,
                      ));
            } else if (status == 'handingOverShipmentToCustomer') {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => CourierToCustomerQrCodeScanner(
                      parentContext: context,
                      model: ShipmentTrackingModel(
                        merchantNationalId: merchantNationalId,
                        courierNationalId: authProvider.phone,
                        shipmentId: cubit.shipmentDetails!.id,
                        deliveringState: cubit.shipmentDetails!.deliveringState,
                        status: cubit.shipmentDetails!.status,
                        hasChildren: 0,
                        deliveringCity: cubit.shipmentDetails!.deliveringCity,
                        receivingState: cubit.shipmentDetails!.receivingState,
                        receivingStreet: cubit.shipmentDetails!.receivingStreet,
                        receivingApartment: '',
                        receivingBuildingNumber: '',
                        receivingFloor: '',
                        receivingLandmark: '',
                        receivingLat:
                            cubit.shipmentDetails!.receivingLat.toString(),
                        receivingLng:
                            cubit.shipmentDetails!.receivingLng.toString(),
                        clientPhone: cubit.shipmentDetails!.clientPhone,
                        receivingCity: cubit.shipmentDetails!.receivingCity,
                        paymentMethod: cubit.shipmentDetails!.paymentMethod,
                        deliveringLat:
                            cubit.shipmentDetails!.deliveringLat.toString(),
                        deliveringLng:
                            cubit.shipmentDetails!.deliveringLng.toString(),
                        fromLat: authProvider.locationData?.latitude ?? 0.0,
                        fromLng: authProvider.locationData?.longitude ?? 0.0,
                        merchantId: cubit.shipmentDetails!.merchant?.id,
                        courierId: int.tryParse(authProvider.id!),
                        merchantImage: cubit.shipmentDetails!.merchant?.photo,
                        merchantName: cubit.shipmentDetails!.merchant?.name,
                        merchantPhone: cubit.shipmentDetails!.merchant?.phone,
                        courierName: Preferences.instance.getUserName,
                        courierImage: authProvider.photo,
                        courierPhone: authProvider.phone,
                        deliveringStreet:
                            cubit.shipmentDetails!.deliveringStreet,
                      ),
                      locationId: locationId!));
            } else if (status == 'handingOverReturnedShipmentToMerchant') {
              if (cubit.shipmentDetails?.handoverCodeCourierToMerchant ==
                      null &&
                  cubit.shipmentDetails?.handoverQrcodeCourierToMerchant ==
                      null) {
                showDialog(
                    context: context,
                    builder: (context) => const loading.Loading());
                await refreshHandoverQrcodeCourierToMerchant(
                    cubit.shipmentDetails!.id);
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
                            .shipmentDetails?.handoverQrcodeCourierToMerchant
                            ?.split('/')
                            .last,
                        path: cubit
                            .shipmentDetails?.handoverQrcodeCourierToMerchant,
                        code: int.parse(cubit.shipmentDetails!
                                .handoverCodeCourierToMerchant ??
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
            '${ApiConstants.baseUrl}/api/v1/captain/shipments/$shipmentId/refresh-handover-qrcode-ctm',
        data: {},
        token: token,
      );
      return RefreshQrcode.fromJson(response.data);
    } on DioException {
      return RefreshQrcode.fromJson({});
    }
  }
}
