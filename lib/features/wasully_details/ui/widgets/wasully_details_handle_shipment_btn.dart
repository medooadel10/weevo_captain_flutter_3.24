import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../Dialogs/loading.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/toasts.dart';
import '../../../../core/router/router.dart';
import '../../../wasully_handle_shipment/ui/wasully_handle_shipment_screen.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';

class WasullyDetailsHandleShipmentBtn extends StatelessWidget {
  final Color color;
  const WasullyDetailsHandleShipmentBtn(
      {super.key, this.color = weevoPrimaryOrangeColor});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
      listener: (context, state) {
        if (state is WasullyDetailshandleShipmentLoadingState) {
          showDialog(
              context: navigator.currentContext!,
              barrierDismissible: false,
              builder: (context) =>
                  BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
                    listener: (context, state) {
                      if (state is WasullyDetailshandleShipmentSuccessState) {
                        log('Preferences.instance.getUserName: ${Preferences.instance.getUserName}');
                        MagicRouter.pop();
                        MagicRouter.navigateTo(
                          WasullyHandleShipmentScreen(
                            model: ShipmentTrackingModel(
                              merchantRating: cubit
                                  .wasullyModel!.merchant.cachedAverageRating,
                              wasullyId: cubit.wasullyModel!.slug.split('-')[1],
                              merchantNationalId: state.merchantNationalId,
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
                              receivingStreet:
                                  cubit.wasullyModel!.receivingStreet,
                              receivingApartment: '',
                              receivingBuildingNumber: '',
                              receivingFloor: '',
                              receivingLandmark: '',
                              receivingLat:
                                  cubit.wasullyModel!.receivingLat.toString(),
                              receivingLng:
                                  cubit.wasullyModel!.receivingLng.toString(),
                              clientPhone: cubit.wasullyModel!.clientPhone,
                              receivingCity:
                                  cubit.wasullyModel!.receivingCityCode,
                              paymentMethod: cubit.wasullyModel!.paymentMethod,
                              deliveringLat:
                                  cubit.wasullyModel!.deliveringLat.toString(),
                              deliveringLng:
                                  cubit.wasullyModel!.deliveringLng.toString(),
                              fromLat: authProvider.locationData?.latitude,
                              fromLng: authProvider.locationData?.longitude,
                              merchantId: cubit.wasullyModel!.merchant.id,
                              courierId:
                                  int.parse(Preferences.instance.getUserId),
                              merchantImage: cubit.wasullyModel!.merchant.photo,
                              merchantName: cubit.wasullyModel!.merchant.name,
                              merchantPhone: cubit.wasullyModel!.merchant.phone,
                              courierName: Preferences.instance.getUserName,
                              courierImage: authProvider.photo,
                              courierPhone: authProvider.phone,
                              wasullyModel: cubit.wasullyModel,
                              deliveringStreet:
                                  cubit.wasullyModel!.deliveringStreet,
                            ),
                          ),
                        ).then((value) {
                          cubit.getWassullyDetails(cubit.wasullyModel!.id);
                        });
                      } else if (state
                          is WasullyDetailshandleShipmentErrorState) {
                        MagicRouter.pop();
                        showToast(state.error, isError: true);
                      }
                    },
                    builder: (context, state) {
                      return const Loading();
                    },
                  ));
        }
      },
      builder: (context, state) {
        return WeevoButton(
          onTap: () async {
            // cubit.handleShipment(authProvider);
            MagicRouter.navigateTo(
              WasullyHandleShipmentScreen(
                model: ShipmentTrackingModel(
                  merchantRating:
                      cubit.wasullyModel!.merchant.cachedAverageRating,
                  wasullyId: cubit.wasullyModel!.slug.split('-')[1],
                  merchantNationalId: cubit.wasullyModel!.merchant.phone,
                  courierNationalId: authProvider.phone,
                  shipmentId: cubit.wasullyModel!.id,
                  deliveringState: cubit.wasullyModel!.deliveringStateCode,
                  status: cubit.wasullyModel!.status,
                  hasChildren: 0,
                  deliveringCity: cubit.wasullyModel!.deliveringCityCode,
                  receivingState: cubit.wasullyModel!.receivingStateCode,
                  receivingStreet: cubit.wasullyModel!.receivingStreet,
                  receivingApartment: '',
                  receivingBuildingNumber: '',
                  receivingFloor: '',
                  receivingLandmark: '',
                  receivingLat: cubit.wasullyModel!.receivingLat.toString(),
                  receivingLng: cubit.wasullyModel!.receivingLng.toString(),
                  clientPhone: cubit.wasullyModel!.clientPhone,
                  receivingCity: cubit.wasullyModel!.receivingCityCode,
                  paymentMethod: cubit.wasullyModel!.paymentMethod,
                  deliveringLat: cubit.wasullyModel!.deliveringLat.toString(),
                  deliveringLng: cubit.wasullyModel!.deliveringLng.toString(),
                  fromLat: authProvider.locationData?.latitude,
                  fromLng: authProvider.locationData?.longitude,
                  merchantId: cubit.wasullyModel!.merchant.id,
                  courierId: int.parse(Preferences.instance.getUserId),
                  merchantImage: cubit.wasullyModel!.merchant.photo,
                  merchantName: cubit.wasullyModel!.merchant.name,
                  merchantPhone: cubit.wasullyModel!.merchant.phone,
                  courierName: Preferences.instance.getUserName,
                  courierImage: authProvider.photo,
                  courierPhone: authProvider.phone,
                  wasullyModel: cubit.wasullyModel,
                  deliveringStreet: cubit.wasullyModel!.deliveringStreet,
                ),
              ),
            ).then((value) {
              cubit.getWassullyDetails(cubit.wasullyModel!.id);
            });
          },
          color: color,
          isStable: true,
          title: (cubit.wasullyModel!.status ==
                  'on-the-way-to-get-shipment-from-merchant')
              ? 'توجه للإستلام'
              : (cubit.wasullyModel!.status == 'on-delivery')
                  ? 'توجه للتسليم'
                  : 'إبدأ التوصيل',
        );
      },
    );
  }
}
