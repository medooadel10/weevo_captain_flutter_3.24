import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../../../Dialogs/action_dialog.dart';
import '../../../Dialogs/msg_dialog.dart';
import '../../../Dialogs/wallet_dialog.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';

class DepositEWallet extends StatefulWidget {
  const DepositEWallet({super.key});

  @override
  State<DepositEWallet> createState() => _DepositEWalletState();
}

class _DepositEWalletState extends State<DepositEWallet> {
  late TextEditingController _numberController;
  late FocusNode _numberNode;
  bool _numberFocused = false, _numberEmpty = true;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? _mobileNumber;
  Timer? t;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController();
    _numberNode = FocusNode();
    _numberNode.addListener(() {
      setState(() {
        _numberFocused = _numberNode.hasFocus;
      });
    });
    _numberController.addListener(() {
      setState(() {
        _numberEmpty = _numberController.text.isEmpty;
      });
    });
    _numberEmpty = _numberController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    log(walletProvider.item!.paymentMethod!);
    return LoadingWidget(
      isLoading: walletProvider.loading,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Form(
          key: _formState,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 60.0.h,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: weevoMizaColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'محفظة الكترونية',
                            style: TextStyle(
                              color: weevoMizaColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0.sp,
                            ),
                          ),
                          Text(
                            'برجاء ادخال رقم المحفظة الالكترونية',
                            style: TextStyle(
                              color: weevoTransGrey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0.sp,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/images/mizapay.png',
                        width: 40.0,
                        height: 40.0,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                EditText(
                  readOnly: false,
                  controller: _numberController,
                  focusNode: _numberNode,
                  isFocus: _numberFocused,
                  type: TextInputType.number,
                  onSave: (String? v) {
                    _mobileNumber = v;
                  },
                  labelText: 'رقم المحفظة',
                  isPassword: false,
                  isPhoneNumber: true,
                  upperTitle: true,
                  onChange: (String? value) {
                    isButtonPressed = false;
                    if (isError) {
                      _formState.currentState!.validate();
                    }
                  },
                  validator: (String? v) {
                    if (!isButtonPressed) {
                      return null;
                    }
                    isError = true;
                    if (v!.isEmpty || v.length < 11) {
                      return 'من فضلك أدخل الرقم بطريقة صحيحة';
                    }
                    isError = false;
                    return null;
                  },
                  shouldDisappear: !_numberEmpty && !_numberFocused,
                ),
                SizedBox(
                  height: 60.0.h,
                ),
                WeevoButton(
                  isStable: true,
                  color: weevoPrimaryOrangeColor,
                  weight: FontWeight.w700,
                  onTap: () async {
                    isButtonPressed = true;
                    if (_formState.currentState!.validate()) {
                      _formState.currentState!.save();
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
                                builder: (context) => const MsgDialog(
                                      content:
                                          'سيصلك اشعار على رقم موبايلك المسجل على محفظتك الإلكترونية لأستكمال العملية',
                                    ));
                            await walletProvider.addCreditWithEWallet(
                              amount: walletProvider.fromOfferPage
                                  ? walletProvider.getTotalResultFromOfferPage()
                                  : walletProvider.depositAmount!.toDouble(),
                              method: walletProvider.item!.paymentMethod,
                              mobileNumber: _mobileNumber,
                            );
                            if (walletProvider.state == NetworkState.success) {
                              t = Timer.periodic(const Duration(seconds: 5),
                                  (timer) async {
                                await walletProvider.checkPaymentStatus(
                                    systemReferenceNumber: walletProvider
                                        .eWallet!
                                        .transaction!
                                        .details!
                                        .upgSystemRef!,
                                    transactionId: walletProvider.eWallet!
                                        .transaction!.details!.transactionId!);
                                if (walletProvider.state ==
                                    NetworkState.success) {
                                  if (walletProvider.creditStatus!.status ==
                                      'completed') {
                                    if (t!.isActive) {
                                      t!.cancel();
                                      t = null;
                                    }

                                    await walletProvider.getCurrentBalance(
                                        authorization:
                                            authProvider.appAuthorization!,
                                        fromRefresh: false);

                                    if (walletProvider.fromOfferPage) {
                                      // walletProvider.fromOfferPage = false;

                                      MagicRouter.navigateTo(
                                        const AvailableShipmentsScreen(),
                                      );
                                    } else {
                                      Navigator.pop(navigator.currentContext!);
                                      walletProvider.setDepositIndex(5);
                                      walletProvider.setAccountTypeIndex(null);
                                    }
                                  }
                                }
                              });
                            } else if (walletProvider.state ==
                                NetworkState.error) {
                              Navigator.pop(navigator.currentContext!);
                              showDialog(
                                context: navigator.currentContext!,
                                builder: (context) => WalletDialog(
                                  msg: 'حدث خطأ برحاء المحاولة مرة اخري',
                                  onPress: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            } else if (walletProvider.state ==
                                NetworkState.logout) {
                              Navigator.pop(navigator.currentContext!);
                              check(
                                  ctx: navigator.currentContext!,
                                  auth: authProvider,
                                  state: walletProvider.state!);
                            }
                          },
                          cancelAction: 'لا',
                          onCancelClick: () {
                            Navigator.pop(ctxx);
                          },
                        ),
                      );
                    }
                  },
                  title: 'طلب إيداع',
                ),
                SizedBox(
                  height: 20.0.h,
                ),
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
          ),
        ),
      ),
    );
  }
}
