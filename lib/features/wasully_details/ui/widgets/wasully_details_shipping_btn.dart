import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Dialogs/loading.dart';
import '../../../../Dialogs/offer_confirmation_dialog.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/router/router.dart';
import '../../data/models/wasully_model.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';
import 'wasully_offer_dialog.dart';

class WasullyDetailsShippingBtn extends StatelessWidget {
  const WasullyDetailsShippingBtn({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    WasullyModel wasullyModel = cubit.wasullyModel!;
    return SizedBox(
      width: double.infinity,
      child: WeevoButton(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => BlocProvider.value(
              value: cubit,
              child: WillPopScope(
                onWillPop: () async => false,
                child: BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
                  listener: (context, state) {
                    if (state is WasullyDetailsSendOfferSuccessState ||
                        state is WasullyDetailsApplyShipmentSuccessState) {
                      MagicRouter.pop();
                      cubit.getWassullyDetails(wasullyModel.id);
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (_) => OfferConfirmationDialog(
                          onOkPressed: () {
                            MagicRouter.pop();
                          },
                          isDone: true,
                          isOffer: state is WasullyDetailsSendOfferSuccessState,
                        ),
                      );
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
                        builder: (_) => OfferConfirmationDialog(
                          onOkPressed: () => MagicRouter.pop(),
                          isDone: false,
                          isOffer: false,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is WasullyDetailsSendOfferLoadingState ||
                        state is WasullyDetailsApplyShipmentLoadingState) {
                      return const Loading();
                    }
                    return WasullyOfferDialog(
                      merchantName: wasullyModel.merchant.name!,
                      merchantRating:
                          wasullyModel.merchant.cachedAverageRating.toString(),
                      price: wasullyModel.price,
                      wasullyId: wasullyModel.id,
                      merchantImage: wasullyModel.merchant.photo ?? '',
                    );
                  },
                ),
              ),
            ),
          );
        },
        color: weevoPrimaryOrangeColor,
        isStable: true,
        title: 'تقديم عرض',
      ),
    );
  }
}
