import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Dialogs/action_dialog.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';
import '../../../Widgets/cash_out_widget.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';

class WithdrawPayment extends StatelessWidget {
  const WithdrawPayment({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return LoadingWidget(
      isLoading: walletProvider.loading,
      child: Padding(
        padding: const EdgeInsets.all(
          16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'اختر طريقة السحب',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.grey[500],
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Expanded(
              child: CashOutWidget(),
            ),
            SizedBox(
              height: size.height * .01,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeevoButton(
                isStable: true,
                color: weevoPrimaryOrangeColor,
                weight: FontWeight.w700,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  if (walletProvider.accountWithdrawalTypeIndex == 0) {
                    walletProvider.setWithdrawalIndex(2);
                  } else if (walletProvider.accountWithdrawalTypeIndex == 1) {
                    walletProvider.setWithdrawalIndex(3);
                  } else if (walletProvider.accountWithdrawalTypeIndex == 2) {
                    walletProvider.setWithdrawalIndex(4);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => ActionDialog(
                        content: 'عليك اختيار نوع الحساب',
                        onCancelClick: () {
                          Navigator.pop(context);
                        },
                        cancelAction: 'حسناً',
                      ),
                    );
                  }
                },
                title: 'طلب السحب',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
