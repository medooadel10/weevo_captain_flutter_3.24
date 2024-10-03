import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Dialogs/action_dialog.dart';
import '../../../../Dialogs/cancel_shipment_dialog.dart';
import '../../../../Dialogs/loading.dart';
import '../../../../Utilits/colors.dart';
import '../../../../Widgets/weevo_button.dart';
import '../../../../core/helpers/toasts.dart';
import '../../../../core/router/router.dart';
import '../../logic/cubit/wasully_details_cubit.dart';
import '../../logic/cubit/wasully_details_state.dart';

class WasullyDetailsCancelShipmentBtn extends StatelessWidget {
  const WasullyDetailsCancelShipmentBtn({super.key});

  @override
  Widget build(BuildContext context) {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();

    return WeevoButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
              listener: (context, state) {
                if (state is WasullyDetailsCancelShipmentSuccessState) {
                  MagicRouter.pop();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                      content: state.data.message,
                      onApproveClick: () {
                        Navigator.pop(context);
                      },
                      approveAction: 'حسناً',
                    ),
                  );
                  cubit.getWassullyDetails(cubit.wasullyModel!.id);
                }
                if (state is WasullyDetailsCancelShipmentErrorState) {
                  showToast(state.error);
                }
              },
              builder: (context, state) {
                return state is WasullyDetailsCancelShipmentLoadingState
                    ? const Loading()
                    : CancelShipmentDialog(
                        onOkPressed: cubit.cancelShipment,
                        onCancelPressed: () => MagicRouter.pop(),
                      );
              },
            ),
          ),
        );
      },
      color: weevoDarkGrey,
      isStable: true,
      title: 'الغاء التوصيل',
    );
  }
}
