import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../../../Dialogs/content_dialog.dart';
import '../../../Dialogs/loading.dart';
import '../../../Dialogs/mobile_number_dialog.dart';
import '../../../Models/fawatrak_payment_methods.dart';
import '../../../Models/transaction_webview_model.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/network_error_widget.dart';
import '../../transaction_webview.dart';

class DepositChoosePayment extends StatefulWidget {
  const DepositChoosePayment({super.key});

  @override
  State<DepositChoosePayment> createState() => _DepositChoosePaymentState();
}

class _DepositChoosePaymentState extends State<DepositChoosePayment> {
  late WalletProvider _walletProvider;
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    checkNetworkState();
  }

  void checkNetworkState() async {
    await _walletProvider.getFawatrakAvailablePaymentGateways();
    check(
      ctx: navigator.currentContext!,
      auth: _authProvider,
      state: _walletProvider.listOfAvailablePaymentGatewaysState!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return walletProvider.listOfAvailablePaymentGatewaysState ==
                NetworkState.waiting ||
            walletProvider.fawatrakAvailablePaymentGateways == null
        ? const Center(child: CircularProgressIndicator())
        : walletProvider.listOfAvailablePaymentGatewaysState ==
                NetworkState.success
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'اختر طريقة الإيداع',
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: walletProvider.fawatrakAvailablePaymentGateways!
                          .map(
                            (FawatrakPaymentMethodsModel item) =>
                                GestureDetector(
                              onTap: () async {
                                walletProvider.setPaymentId(item.paymentId!);
                                FocusScope.of(context).unfocus();
                                // showDialog(
                                //     context: context,
                                //     builder: (ctxx) => ActionDialog(
                                //           content:
                                //               'سيتم خصم رسوم تحصيل الكتروني\n${item.paymentId == 2 ? ((walletProvider.depositAmount.toDouble() * 0.016) + 1.50) : ((walletProvider.depositAmount.toDouble() * 0.015) + 1.50)} جنية من مبلغ الايداع',
                                //           approveAction: 'حسناً',
                                //           onApproveClick: () async {
                                //             Navigator.pop(ctxx);
                                log('${item.paymentId}');
                                if (item.paymentId == 4) {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      barrierDismissible: false,
                                      builder: (context) => MobileNumberDialog(
                                            phoneClick: (String phone) async {
                                              log('phone -> $phone');
                                              showDialog(
                                                  context:
                                                      navigator.currentContext!,
                                                  barrierDismissible: false,
                                                  builder: (context) =>
                                                      const Loading());
                                              await walletProvider.initPayment(
                                                  amount: walletProvider
                                                          .fromOfferPage
                                                      ? walletProvider
                                                          .getTotalResultFromOfferPage()
                                                      : walletProvider
                                                          .depositAmount!
                                                          .toDouble(),
                                                  paymentId: item.paymentId,
                                                  phone: phone);
                                              if (walletProvider.state ==
                                                  NetworkState.success) {
                                                if (walletProvider
                                                        .initPaymentModel !=
                                                    null) {
                                                  Navigator.pop(
                                                    navigator.currentContext!,
                                                  );
                                                  walletProvider
                                                      .setDepositIndex(2);
                                                }
                                              } else if (walletProvider.state ==
                                                  NetworkState.logout) {
                                                Navigator.pop(
                                                    navigator.currentContext!);
                                                check(
                                                    ctx: navigator
                                                        .currentContext!,
                                                    auth: authProvider,
                                                    state:
                                                        walletProvider.state!);
                                              } else {
                                                Navigator.pop(
                                                    navigator.currentContext!);
                                              }
                                            },
                                          ));
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Loading());
                                  await walletProvider.initPayment(
                                    amount: walletProvider.fromOfferPage
                                        ? walletProvider
                                            .getTotalResultFromOfferPage()
                                        : walletProvider.depositAmount!
                                            .toDouble(),
                                    paymentId: item.paymentId,
                                  );
                                  if (walletProvider.state ==
                                      NetworkState.success) {
                                    if (walletProvider.initPaymentModel !=
                                        null) {
                                      Navigator.pop(navigator.currentContext!);
                                      if (item.paymentId == 2) {
                                        bool value = (await Navigator.pushNamed(
                                            navigator.currentContext!,
                                            TransactionWebView.id,
                                            arguments: TransactionWebViewModel(
                                                url: walletProvider
                                                        .initPaymentModel[
                                                    'redirectTo'],
                                                selectedValue: null)) as bool);
                                        if (value) {
                                          await walletProvider
                                              .getCurrentBalance(
                                                  authorization: authProvider
                                                      .appAuthorization!,
                                                  fromRefresh: false);
                                          showDialog(
                                              context:
                                                  navigator.currentContext!,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  ContentDialog(
                                                    content: walletProvider
                                                            .fromOfferPage
                                                        ? ' تم إيداع المبلغ بنجاح\n يمكنك الان التقديم علي الشحنه'
                                                        : 'تم إيداع المبلغ بنجاح',
                                                    callback: () {
                                                      if (walletProvider
                                                          .fromOfferPage) {
                                                        MagicRouter.navigateTo(
                                                            const AvailableShipmentsScreen());
                                                      } else {
                                                        Navigator.pop(context);
                                                        walletProvider
                                                            .setDepositIndex(3);
                                                        walletProvider
                                                            .setAccountTypeIndex(
                                                                null);
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
                                      } else {
                                        walletProvider.setDepositIndex(2);
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
                                }

                                // },
                                // cancelAction: 'لا',
                                // onCancelClick: () {
                                //   Navigator.pop(ctxx);
                                // },
                                // )
                                // );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: weevoOffWhiteOrange),
                                      borderRadius:
                                          BorderRadius.circular(20.r)),
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            item.nameAr!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
                                        child: CustomImage(
                                          image: item.logo ?? '',
                                          height: 40.h,
                                          width: 40.w,
                                          radius: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    )
                    // CashOutWidget(
                    //   onRetry: checkNetworkState,
                    //   onPaymentCallback: (ListOfAvailablePaymentGateways d) async {
                    //     if (walletProvider.item.paymentMethod == 'credit-card') {
                    //       walletProvider.setDepositIndex(2);
                    //     } else if (walletProvider.item.paymentMethod == 'meeza-card') {
                    //       walletProvider.setDepositIndex(3);
                    //     } else if (walletProvider.item.paymentMethod == 'e-wallet') {
                    //       walletProvider.setDepositIndex(4);
                    //     } else {
                    //       showDialog(
                    //           context: context,
                    //           builder: (ctxx) => ActionDialog(
                    //                 content:
                    //                     'سيتم خصم رسوم تحصيل الكتروني\n${walletProvider.getTotalCommision().toStringAsFixed(2)} جنية من مبلغ الايداع',
                    //                 approveAction: 'حسناً',
                    //                 onApproveClick: () async {
                    //                   showDialog(
                    //                       context: context,
                    //                       barrierDismissible: false,
                    //                       builder: (context) => Loading());
                    //                   await walletProvider.addCreditWithOpay(
                    //                     amount: walletProvider.fromOfferPage
                    //                         ? walletProvider.getTotalResultFromOfferPage()
                    //                         : walletProvider.depositAmount.toDouble(),
                    //                     method: walletProvider.item.paymentMethod,
                    //                     paymentGetWay:
                    //                         walletProvider.item.paymentGatewayHandler,
                    //                   );
                    //                   if (walletProvider.state == NetworkState.SUCCESS) {
                    //                     if (walletProvider.opayModel.callbackUrl !=
                    //                         null) {
                    //                       Navigator.pop(context);
                    //
                    //                       log(walletProvider
                    //                           .opayModel.transaction.details.method);
                    //                       Navigator.pop(context);
                    //                       EasyLoading.show(status: "loading");
                    //
                    //                       OPayTask.setSandBox(true);
                    //                       OPayTask().createOrder(
                    //                           context,
                    //                           PayParams(
                    //                             publicKey:
                    //                                 "OPAYPUB16526029843300.7158556826526631",
                    //                             merchantId: "281822051549449",
                    //                             merchantName: "1234567895222",
                    //                             reference:
                    //                                 walletProvider.opayModel.reference,
                    //                             countryCode: Country.egypt.countryCode,
                    //                             payAmount: walletProvider.fromOfferPage
                    //                                 ? ((double.parse(walletProvider
                    //                                                 .opayModel
                    //                                                 .transaction
                    //                                                 .amount))
                    //                                             .toDouble())
                    //                                         .toInt() *
                    //                                     100
                    //                                 : double.parse(walletProvider
                    //                                             .opayModel
                    //                                             .transaction
                    //                                             .amount)
                    //                                         .toInt() *
                    //                                     100,
                    //                             currency: Country.egypt.currency,
                    //                             productName: "weevo",
                    //                             productDescription: "weevo payment",
                    //                             callbackUrl:
                    //                                 walletProvider.opayModel.callbackUrl,
                    //                             paymentType: walletProvider
                    //                                 .opayModel.transaction.details.method,
                    //
                    //                             expireAt: 30,
                    //                             userClientIP: "1.11.111.111",
                    //                             //userInfo: UserInfo("1","11@bb.com","10101010","name"),
                    //                           ), httpFinishedMethod: () {
                    //                         EasyLoading.dismiss();
                    //                       }).then((response) async {
                    //                         // httpResponse （Just check the reason for the failure of the network request）
                    //                         _createOrderResult = response
                    //                             .payHttpResponse
                    //                             .toJson((value) {
                    //                           log('02 ${walletProvider.opayModel
                    //                               .callbackUrl}');
                    //
                    //                           if (value != null) {
                    //                             return value.toJson();
                    //                           }
                    //                           return null;
                    //                         }).toString();
                    //                         log("httpResult=$_createOrderResult");
                    //                         log('a0 ${walletProvider.opayModel.status}');
                    //
                    //                         // h5 Response （Payment result check ）
                    //                         if (response.webJsResponse != null) {
                    //                           var status =
                    //                               response.webJsResponse?.orderStatus;
                    //                           log('a0 ${walletProvider.opayModel
                    //                               .status}');
                    //
                    //                           log("webJsResponse.status=$status");
                    //                           if (status != null) {}
                    //                           switch (status) {
                    //                             case PayResultStatus.initial:
                    //                               break;
                    //                             case PayResultStatus.pending:
                    //                               break;
                    //                             case PayResultStatus.success:
                    //                               log('a0 ${walletProvider.opayModel
                    //                                   .status}');
                    //                               await walletProvider.getCurrentBalance(
                    //                                   authorization:
                    //                                   authProvider.appAuthorization,
                    //                                   fromRefresh: false);
                    //                               showDialog(
                    //                                   context: context,
                    //                                   barrierDismissible: false,
                    //                                   builder: (context) =>
                    //                                       ContentDialog(
                    //                                         content: walletProvider
                    //                                             .fromOfferPage
                    //                                             ? ' تم إيداع المبلغ بنجاح\n يمكنك الان التقديم علي الشحنه'
                    //                                             : '    تم إيداع المبلغ بنجاح',
                    //                                         callback: () {
                    //                                           if (walletProvider
                    //                                               .fromOfferPage) {
                    //                                             // walletProvider
                    //                                             //         .fromOfferPage =
                    //                                             //     false;
                    //                                             Navigator
                    //                                                 .pushReplacementNamed(
                    //                                               context,
                    //                                               AvailableShipmentContainer
                    //                                                   .id,
                    //                                             );
                    //                                           } else {
                    //                                             Navigator.pop(context);
                    //                                             walletProvider
                    //                                                 .setDepositIndex(5);
                    //                                             walletProvider
                    //                                                 .setAccountTypeIndex(
                    //                                                     null);
                    //                                           }
                    //                                         },
                    //                                       ));
                    //                               break;
                    //                             case PayResultStatus.fail:
                    //                               showDialog(
                    //                                 context: context,
                    //                                 barrierDismissible: false,
                    //                                 builder: (context) => ContentDialog(
                    //                                   content: 'حدث خطأ حاول مرة اخري',
                    //                                   callback: () {
                    //                                     Navigator.pop(context);
                    //                                   },
                    //                                 ),
                    //                               );
                    //                               break;
                    //                             case PayResultStatus.close:
                    //                               break;
                    //                           }
                    //                         }
                    //                       });
                    //                     }
                    //                   } else if (walletProvider.state ==
                    //                       NetworkState.LOGOUT) {
                    //                     Navigator.pop(context);
                    //                     check(
                    //                         ctx: context,
                    //                         auth: authProvider,
                    //                         state: walletProvider.state);
                    //                   } else {
                    //                     Navigator.pop(context);
                    //                   }
                    //                 },
                    //                 cancelAction: 'لا',
                    //                 onCancelClick: () {
                    //                   Navigator.pop(ctxx);
                    //                 },
                    //               ));
                    //     }
                    //   },
                    // ),
                  ],
                ),
              )
            : NetworkErrorWidget(
                onRetryCallback: checkNetworkState,
              );
  }
}
