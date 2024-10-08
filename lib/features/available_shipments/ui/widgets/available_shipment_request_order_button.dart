import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../Dialogs/apply_confirmation_dialog.dart';
import '../../../../Dialogs/deliver_shipment_dialog.dart';
import '../../../../Dialogs/loading.dart';
import '../../../../Dialogs/no_credit_dialog.dart';
import '../../../../Dialogs/offer_confirmation_dialog.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Providers/shipment_provider.dart';
import '../../../../Providers/wallet_provider.dart';
import '../../../../Screens/child_shipment_details.dart';
import '../../../../Screens/shipment_details_display.dart';
import '../../../../Screens/wallet.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Widgets/edit_text.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/router/router.dart';
import '../../../wasully_details/logic/cubit/wasully_details_cubit.dart';
import '../../../wasully_details/logic/cubit/wasully_details_state.dart';
import '../../../wasully_details/ui/wasully_details_screen.dart';
import '../../data/models/available_shipment_model.dart';

class AvailableShipmentRequestOrderButton extends StatelessWidget {
  final AvailableShipmentModel model;
  const AvailableShipmentRequestOrderButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final WasullyDetailsCubit cubit = context.read();
    final shipmentProvider = Provider.of<ShipmentProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context);
    return WeevoButton(
      onTap: () {
        if (model.slug != null) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: PopScope(
                canPop: true,
                child: BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
                  listener: (context, state) {
                    if (state is WasullyDetailsSendOfferSuccessState ||
                        state is WasullyDetailsApplyShipmentSuccessState) {
                      MagicRouter.pop();
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (_) => OfferConfirmationDialog(
                          onOkPressed: () {
                            MagicRouter.pop();
                            MagicRouter.navigateAndPop(WasullyDetailsScreen(
                              id: model.id,
                            ));
                          },
                          isDone: true,
                          isOffer: state is WasullyDetailsSendOfferSuccessState,
                        ),
                      ).then((value) {
                        MagicRouter.navigateAndPop(WasullyDetailsScreen(
                          id: model.id,
                        ));
                      });
                    }
                    if (state is WasullyDetailsSendOfferErrorState) {
                      MagicRouter.pop();
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (_) => OfferConfirmationDialog(
                          onOkPressed: () => MagicRouter.pop(),
                          isDone: false,
                          isOffer: true,
                          message: state.error,
                        ),
                      );
                    }
                    if (state is WasullyDetailsApplyShipmentErrorState) {
                      MagicRouter.pop();
                      showDialog(
                          context: navigator.currentContext!,
                          builder: (c) => NoCreditDialog(
                                onOkCancelCallback: () {
                                  Navigator.pop(c);
                                },
                                onChargeWalletCallback: () {
                                  MagicRouter.pop();
                                  walletProvider.setMainIndex(1);
                                  walletProvider.setDepositAmount(
                                      num.parse(model.amount!).toInt());
                                  walletProvider.setDepositIndex(1);
                                  walletProvider.fromOfferPage = true;
                                  Navigator.pushReplacementNamed(c, Wallet.id);
                                },
                              ));
                    }
                  },
                  builder: (context, state) {
                    if (state is WasullyDetailsSendOfferLoadingState ||
                        state is WasullyDetailsApplyShipmentLoadingState) {
                      return const Loading();
                    }
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    radius: 40.0,
                                    child: const Icon(
                                      Icons.person,
                                      color: weevoGreyWhite,
                                      size: 50.0,
                                    ),
                                  ),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.merchant?.name ?? '',
                                          style: TextStyle(
                                            fontSize: 16.0.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_border,
                                              color: weevoPrimaryOrangeColor,
                                              size: 25.0,
                                            ),
                                            horizontalSpace(5),
                                            Text(
                                              model.merchant
                                                          ?.cachedAverageRating !=
                                                      null
                                                  ? double.parse(model.merchant!
                                                          .cachedAverageRating!)
                                                      .toStringAsFixed(1)
                                                  : '4.5',
                                              style: TextStyle(
                                                fontSize: 16.0.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(10),
                              SizedBox(
                                width: double.infinity,
                                child: WeevoButton(
                                  onTap: () {
                                    cubit.applyShipment(model: model);
                                  },
                                  color: weevoPrimaryOrangeColor,
                                  isStable: true,
                                  title:
                                      'قبول التوصيل ب ${model.price?.toStringAsFixed0()} جنيه',
                                ),
                              ),
                              verticalSpace(10),
                              EditText(
                                controller: cubit.offerController,
                                onFieldSubmit: (_) {
                                  cubit.sendOffer(model.id);
                                },
                                hintText: 'او قدم عرض التوصيل الخاص بك',
                              ),
                              verticalSpace(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: WeevoButton(
                                      onTap: () {
                                        cubit.sendOffer(model.id);
                                      },
                                      color: weevoPrimaryBlueColor,
                                      isStable: true,
                                      title: 'إرسال عرض',
                                    ),
                                  ),
                                  horizontalSpace(10),
                                  Expanded(
                                    child: WeevoButton(
                                      onTap: () {
                                        MagicRouter.pop();
                                      },
                                      color: weevoRedColor,
                                      isStable: false,
                                      title: 'إلغاء',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ).paddingSymmetric(
                        horizontal: 10.0.w,
                        vertical: 10.0.h,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => DeliverShipmentDialog(
              onOkPressed: (String v) {
                if (v == 'DONE') {
                  showDialog(
                      context: navigator.currentContext!,
                      builder: (c) => ApplyConfirmationDialog(
                            isWassully: false,
                            onOkPressed: () async {
                              MagicRouter.pop();
                              if (model.children!.isEmpty) {
                                MagicRouter.navigateAndPop(
                                    ShipmentDetailsDisplay(
                                  shipmentId: model.id,
                                ));
                              } else {
                                MagicRouter.navigateAndPop(ChildShipmentDetails(
                                  shipmentId: model.id,
                                ));
                              }

                              DocumentSnapshot userToken =
                                  await FirebaseFirestore.instance
                                      .collection('merchant_users')
                                      .doc(model.id.toString())
                                      .get();
                              String token = userToken['fcmToken'];
                              FirebaseFirestore.instance
                                  .collection('merchant_notifications')
                                  .doc(model.id.toString())
                                  .collection(model.id.toString())
                                  .add({
                                'read': false,
                                'date_time': DateTime.now().toIso8601String(),
                                'type': 'cancel_shipment',
                                'title': 'ويفو وفرلك كابتن',
                                'body': model.slug != null || model.slug != ''
                                    ? 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدم الطلب'
                                    : 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدم الشحنة',
                                'user_icon': authProvider.photo!.isNotEmpty
                                    ? authProvider.photo!
                                            .contains(ApiConstants.baseUrl)
                                        ? authProvider.photo
                                        : '${ApiConstants.baseUrl}${authProvider.photo}'
                                    : '',
                                'screen_to': 'shipment_screen',
                                'data': ShipmentTrackingModel(
                                        shipmentId: model.id, hasChildren: 1)
                                    .toJson(),
                              });
                              authProvider.sendNotification(
                                  title: 'ويفو وفرلك كابتن',
                                  body: model.slug != null || model.slug != ''
                                      ? 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدم الطلب'
                                      : 'الكابتن ${authProvider.name} قبل طلب الشحن وتم خصم مقدم الشحنة',
                                  toToken: token,
                                  image: authProvider.photo!.isNotEmpty
                                      ? authProvider.photo!
                                              .contains(ApiConstants.baseUrl)
                                          ? authProvider.photo
                                          : '${ApiConstants.baseUrl}${authProvider.photo}'
                                      : '',
                                  data: ShipmentTrackingModel(
                                          shipmentId: model.id, hasChildren: 1)
                                      .toJson(),
                                  screenTo: 'shipment_screen',
                                  type: 'cancel_shipment');
                            },
                            isDone: true,
                          ));
                } else {
                  if (shipmentProvider.noCredit!) {
                    showDialog(
                        context: navigator.currentContext!,
                        builder: (c) => NoCreditDialog(
                              onOkCancelCallback: () {
                                MagicRouter.pop();
                              },
                              onChargeWalletCallback: () {
                                MagicRouter.pop();
                                walletProvider.setMainIndex(1);
                                walletProvider.setDepositAmount(
                                    num.parse(model.amount!).toInt());
                                walletProvider.setDepositIndex(1);
                                walletProvider.fromOfferPage = true;
                                Navigator.pushReplacementNamed(c, Wallet.id);
                              },
                            ));
                  } else {
                    showDialog(
                        context: context,
                        builder: (c) => ApplyConfirmationDialog(
                              isWassully:
                                  model.slug != null || model.slug != '',
                              onOkPressed: () async {
                                MagicRouter.pop();
                              },
                              isDone: false,
                            ));
                  }
                }
              },
              shipmentId: model.id,
              amount: model.amount.toString(),
              shippingCost:
                  model.agreedShippingCost ?? model.expectedShippingCost ?? '0',
            ),
          );
        }
      },
      color: weevoPrimaryOrangeColor,
      isStable: true,
      childWidget: const Text(
        'وصل الاوردر',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
