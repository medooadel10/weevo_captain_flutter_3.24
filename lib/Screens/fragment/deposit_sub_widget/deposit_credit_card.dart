import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../../../Dialogs/action_dialog.dart';
import '../../../Dialogs/content_dialog.dart';
import '../../../Dialogs/loading.dart';
import '../../../Models/transaction_webview_model.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';
import '../../transaction_webview.dart';

class DepositCreditCard extends StatefulWidget {
  const DepositCreditCard({super.key});

  @override
  State<DepositCreditCard> createState() => _DepositCreditCardState();
}

class _DepositCreditCardState extends State<DepositCreditCard> {
  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return LoadingWidget(
      isLoading: walletProvider.loading,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Container()),
            WeevoButton(
              isStable: true,
              color: weevoPrimaryOrangeColor,
              weight: FontWeight.w700,
              onTap: () async {
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (ctxx) => ActionDialog(
                          content:
                              'سيتم خصم رسوم تحصيل الكتروني\n${walletProvider.getTotalCommision().toStringAsFixed(2)} جنية من مبلغ الايداع',
                          approveAction: 'حسناً',
                          onApproveClick: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Loading());
                            await walletProvider.addCreditWithCreditCard(
                              amount: walletProvider.fromOfferPage
                                  ? walletProvider.getTotalResultFromOfferPage()
                                  : walletProvider.depositAmount!.toDouble(),
                              method: walletProvider.item!.paymentMethod,
                            );
                            if (walletProvider.state == NetworkState.success) {
                              if (walletProvider.creditCard!.checkoutUrl !=
                                  null) {
                                Navigator.pop(navigator.currentContext!);
                                dynamic value = await Navigator.pushNamed(
                                    navigator.currentContext!,
                                    TransactionWebView.id,
                                    arguments: TransactionWebViewModel(
                                        url: walletProvider
                                            .creditCard!.checkoutUrl!,
                                        selectedValue: walletProvider
                                                    .item!.paymentMethod ==
                                                'credit-card'
                                            ? 0
                                            : walletProvider
                                                        .item!.paymentMethod ==
                                                    'meeza-card'
                                                ? 1
                                                : 2));
                                if (value != null && value == true) {
                                  await walletProvider.getCurrentBalance(
                                      authorization:
                                          authProvider.appAuthorization!,
                                      fromRefresh: false);
                                  showDialog(
                                      context: navigator.currentContext!,
                                      barrierDismissible: false,
                                      builder: (context) => ContentDialog(
                                            content: walletProvider
                                                    .fromOfferPage
                                                ? ' تم إيداع المبلغ بنجاح\n يمكنك الان التقديم علي الشحنه'
                                                : '    تم إيداع المبلغ بنجاح',
                                            callback: () {
                                              if (walletProvider
                                                  .fromOfferPage) {
                                                // walletProvider.fromOfferPage =
                                                // false;

                                                MagicRouter.navigateTo(
                                                  const AvailableShipmentsScreen(),
                                                );
                                              } else {
                                                Navigator.pop(context);
                                                walletProvider
                                                    .setDepositIndex(5);
                                                walletProvider
                                                    .setAccountTypeIndex(null);
                                              }
                                            },
                                          ));
                                } else {
                                  showDialog(
                                    context: navigator.currentContext!,
                                    barrierDismissible: false,
                                    builder: (context) => ContentDialog(
                                      content: 'حدث خطأ حاول مرة اخري',
                                      callback: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                }
                              }
                            } else if (walletProvider.state ==
                                NetworkState.logout) {
                              Navigator.pop(navigator.currentContext!);
                              check(
                                  ctx: navigator.currentContext!,
                                  auth: authProvider,
                                  state: walletProvider.state!);
                            } else {
                              Navigator.pop(navigator.currentContext!);
                            }
                          },
                          cancelAction: 'لا',
                          onCancelClick: () {
                            Navigator.pop(ctxx);
                          },
                        ));
              },
              title: 'طلب أيداع',
            ),
            SizedBox(
              height: 20.0.h,
            ),
            Column(
              children: [
                Text(
                  walletProvider.item!.depositionBankChargeMessage!,
                  style: TextStyle(
                      color: walletProvider.item!.paymentMethod == 'credit-card'
                          ? weevoLightGreen
                          : walletProvider.item!.paymentMethod == 'meeza-card'
                              ? weevoPrimaryBlueColor
                              : weevoDarkPurple,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  walletProvider.item!.depositionBankChargeSecondMessage!,
                  style: TextStyle(
                      color: walletProvider.item!.paymentMethod == 'credit-card'
                          ? weevoLightGreen
                          : walletProvider.item!.paymentMethod == 'meeza-card'
                              ? weevoPrimaryBlueColor
                              : weevoDarkPurple,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
