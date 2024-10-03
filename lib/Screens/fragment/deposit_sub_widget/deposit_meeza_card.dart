import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../../../Dialogs/action_dialog.dart';
import '../../../Dialogs/content_dialog.dart';
import '../../../Dialogs/date_time_bottom_sheet.dart';
import '../../../Dialogs/loading.dart';
import '../../../Dialogs/wallet_dialog.dart';
import '../../../Models/transaction_webview_model.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/credit_card_formatter.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';
import '../../transaction_webview.dart';

class DepositMeezaCard extends StatefulWidget {
  const DepositMeezaCard({super.key});

  @override
  State<DepositMeezaCard> createState() => _DepositMeezaCardState();
}

class _DepositMeezaCardState extends State<DepositMeezaCard> {
  late TextEditingController _cardNumberController,
      _cardExpiryDateMonthController,
      _cardExpiryDateYearController,
      _cardCVVController;
  late FocusNode _cardNumberNode,
      _cardExpiryDateMonthNode,
      _cardExpiryDateYearNode,
      _cardCVVNode;
  bool _cardNumberFocused = false,
      _cardExpiryDateMonthFocused = false,
      _cardExpiryDateYearFocused = false,
      _cardCVVFocused = false,
      _cardNumberEmpty = true,
      _cardExpiryDateMonthEmpty = true,
      _cardExpiryDateYearEmpty = true,
      _cardCVVEmpty = true;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? _expirationMonthDate, _expirationYearDate, _cardNumber, _cvv;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardExpiryDateMonthController = TextEditingController();
    _cardExpiryDateYearController = TextEditingController();
    _cardCVVController = TextEditingController();
    _cardNumberNode = FocusNode();
    _cardExpiryDateMonthNode = FocusNode();
    _cardExpiryDateYearNode = FocusNode();
    _cardCVVNode = FocusNode();
    _cardNumberNode.addListener(() {
      setState(() {
        _cardNumberFocused = _cardNumberNode.hasFocus;
      });
    });
    _cardCVVNode.addListener(() {
      setState(() {
        _cardCVVFocused = _cardCVVNode.hasFocus;
      });
    });
    _cardExpiryDateMonthNode.addListener(() {
      setState(() {
        _cardExpiryDateMonthFocused = _cardExpiryDateMonthNode.hasFocus;
      });
    });
    _cardExpiryDateYearNode.addListener(() {
      setState(() {
        _cardExpiryDateYearFocused = _cardExpiryDateYearNode.hasFocus;
      });
    });
    _cardNumberController.addListener(() {
      setState(() {
        _cardNumberEmpty = _cardNumberController.text.isEmpty;
      });
    });
    _cardExpiryDateMonthController.addListener(() {
      setState(() {
        _cardExpiryDateMonthEmpty = _cardExpiryDateMonthController.text.isEmpty;
      });
    });
    _cardExpiryDateYearController.addListener(() {
      setState(() {
        _cardExpiryDateYearEmpty = _cardExpiryDateYearController.text.isEmpty;
      });
    });
    _cardCVVController.addListener(() {
      setState(() {
        _cardCVVEmpty = _cardCVVController.text.isEmpty;
      });
    });
    _cardNumberEmpty = _cardNumberController.text.isEmpty;
    _cardExpiryDateYearEmpty = _cardExpiryDateYearController.text.isEmpty;
    _cardCVVEmpty = _cardCVVController.text.isEmpty;
  }

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
        child: Form(
          key: _formState,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: weevoTransGrey,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text(
                    'أدخل بيانات بطاقة ميزة',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: weevoMizaColor,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10.0.h,
                ),
                EditText(
                  suffix: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Image.asset(
                        'assets/images/miza_card.jpeg',
                        height: 60.0.h,
                        width: 60.0.w,
                      )),
                  readOnly: false,
                  type: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CreditCardInputFormatter(),
                  ],
                  controller: _cardNumberController,
                  focusNode: _cardNumberNode,
                  onFieldSubmit: (_) {
                    _cardNumberNode.unfocus();
                  },
                  isFocus: _cardNumberFocused,
                  onSave: (String? v) {
                    _cardNumber = v;
                  },
                  onChange: (String? value) {
                    isButtonPressed = false;
                    if (isError) {
                      _formState.currentState!.validate();
                    }
                  },
                  labelText: 'رقم بطاقة ميزة',
                  hintColor: Colors.grey[400],
                  hintText: 'XXXX-XXXX-XXXX-XXXX',
                  isPassword: false,
                  isPhoneNumber: false,
                  upperTitle: true,
                  validator: (String? v) {
                    if (!isButtonPressed) {
                      return null;
                    }
                    isError = true;
                    if (v!.isEmpty || v.length < 19) {
                      return 'أدخل رقم بطاقة ميزة بطريقة صحيحة';
                    }
                    isError = false;
                    return null;
                  },
                  shouldDisappear: !_cardNumberEmpty && !_cardNumberFocused,
                ),
                SizedBox(
                  height: 10.h,
                ),
                const Text(
                  'تاريخ الأنتهاء',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: EditText(
                        readOnly: true,
                        controller: _cardExpiryDateMonthController,
                        focusNode: _cardExpiryDateMonthNode,
                        onFieldSubmit: (_) {
                          _cardExpiryDateMonthNode.unfocus();
                        },
                        isFocus: _cardExpiryDateMonthFocused,
                        onSave: (String? v) {
                          _expirationMonthDate = v;
                        },
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.0),
                                topLeft: Radius.circular(25.0),
                              )),
                              builder: (ctx) => DateTimeBottomSheet(
                                  onItemClick: (String item, int i) {
                                    log('$item $i');
                                    _cardExpiryDateMonthController.text = item;
                                    _cardExpiryDateMonthNode.unfocus();
                                    Navigator.pop(context);
                                  },
                                  data: months));
                        },
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                        },
                        labelText: 'شهر',
                        hintColor: Colors.grey[400],
                        hintText: 'شهر',
                        isPassword: false,
                        isPhoneNumber: false,
                        upperTitle: true,
                        validator: (String? v) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (v!.isEmpty) {
                            return 'أدخل الشهر';
                          }
                          isError = false;
                          return null;
                        },
                        shouldDisappear: !_cardExpiryDateMonthEmpty &&
                            !_cardExpiryDateMonthFocused,
                      ),
                    ),
                    SizedBox(
                      width: 6.0.w,
                    ),
                    Expanded(
                      child: EditText(
                        readOnly: true,
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.0),
                                topLeft: Radius.circular(25.0),
                              )),
                              builder: (ctx) => DateTimeBottomSheet(
                                  onItemClick: (String item, int i) {
                                    log('$item $i');
                                    _cardExpiryDateYearController.text = item;
                                    _cardExpiryDateYearNode.unfocus();
                                    Navigator.pop(context);
                                  },
                                  data: years));
                        },
                        controller: _cardExpiryDateYearController,
                        focusNode: _cardExpiryDateYearNode,
                        onFieldSubmit: (_) {
                          _cardExpiryDateYearNode.unfocus();
                        },
                        isFocus: _cardExpiryDateYearFocused,
                        onSave: (String? v) {
                          _expirationYearDate = v;
                        },
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                        },
                        labelText: 'سنة',
                        hintColor: Colors.grey[400],
                        hintText: 'سنة',
                        isPassword: false,
                        isPhoneNumber: false,
                        upperTitle: true,
                        validator: (String? v) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (v!.isEmpty) {
                            return 'أدخل السنة';
                          }
                          isError = false;
                          return null;
                        },
                        shouldDisappear: !_cardExpiryDateYearEmpty &&
                            !_cardExpiryDateYearFocused,
                      ),
                    ),
                  ],
                ),
                EditText(
                  readOnly: false,
                  type: TextInputType.number,
                  controller: _cardCVVController,
                  focusNode: _cardCVVNode,
                  isFocus: _cardCVVFocused,
                  onFieldSubmit: (_) {
                    _cardCVVNode.unfocus();
                  },
                  onChange: (String? value) {
                    isButtonPressed = false;
                    if (isError) {
                      _formState.currentState!.validate();
                    }
                  },
                  onSave: (String? v) {
                    _cvv = v;
                  },
                  labelText: 'الرمز السري cvv',
                  isPassword: true,
                  maxLength: 3,
                  isPhoneNumber: false,
                  upperTitle: true,
                  validator: (String? v) {
                    if (v!.isEmpty || v.length < 3) {
                      return 'أدخل الرمز السري';
                    }
                    return null;
                  },
                  shouldDisappear: !_cardCVVEmpty && !_cardCVVFocused,
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
                      log('$_expirationYearDate$_expirationMonthDate');
                      log(_cvv.toString());
                      log(_cardNumber.toString());
                      showDialog(
                          context: context,
                          builder: (ctxx) => ActionDialog(
                                content:
                                    'سيتم خصم رسوم تحصيل الكتروني\n${walletProvider.getTotalCommision().toStringAsFixed(2)} جنية من مبلغ الايداع',
                                approveAction: 'حسناً',
                                onApproveClick: () async {
                                  Navigator.pop(ctxx);
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Loading());
                                  await walletProvider.addCreditWithMeeza(
                                    amount: walletProvider.fromOfferPage
                                        ? walletProvider
                                            .getTotalResultFromOfferPage()
                                        : walletProvider.depositAmount!
                                            .toDouble(),
                                    method: walletProvider.item!.paymentMethod,
                                    pan: _cardNumber!.split('-').join(),
                                    expirationDate:
                                        '$_expirationYearDate$_expirationMonthDate',
                                    cvv: _cvv!,
                                  );
                                  if (walletProvider.state ==
                                      NetworkState.success) {
                                    if (walletProvider.meezaCard!.upgResponse !=
                                        null) {
                                      Navigator.pop(navigator.currentContext!);
                                      dynamic value = await Navigator.pushNamed(
                                          navigator.currentContext!,
                                          TransactionWebView.id,
                                          arguments: TransactionWebViewModel(
                                              url: walletProvider.meezaCard!
                                                  .upgResponse!.threeDSUrl!,
                                              selectedValue: walletProvider
                                                          .item!
                                                          .paymentMethod ==
                                                      'credit-card'
                                                  ? 0
                                                  : walletProvider.item!
                                                              .paymentMethod ==
                                                          'meeza-card'
                                                      ? 1
                                                      : 2));
                                      if (value != null) {
                                        if (value == 'no funds') {
                                          showDialog(
                                              context:
                                                  navigator.currentContext!,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  ActionDialog(
                                                      content:
                                                          'لا يوجد لديك رصيد كافي\nيرجي شحن البطاقة وأعادة المحاولة',
                                                      approveAction: 'حسناً',
                                                      onApproveClick: () {
                                                        Navigator.pop(context);
                                                      }));
                                        } else {
                                          showDialog(
                                              context:
                                                  navigator.currentContext!,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  const Loading());
                                          await getMezaStatus(
                                              walletProvider: walletProvider,
                                              authProvider: authProvider,
                                              value: value);
                                        }
                                      }
                                    } else {
                                      if (walletProvider.meezaCard!.status ==
                                          'completed') {
                                        log('status compeleted');
                                        log('${walletProvider.meezaCard!.status}');
                                        await walletProvider.getCurrentBalance(
                                            authorization:
                                                authProvider.appAuthorization!,
                                            fromRefresh: false);
                                        Navigator.pop(
                                            navigator.currentContext!);
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
                                                      // walletProvider
                                                      //         .fromOfferPage =
                                                      //     false;

                                                      MagicRouter.navigateTo(
                                                          const AvailableShipmentsScreen());
                                                    } else {
                                                      Navigator.pop(context);
                                                      walletProvider
                                                          .setDepositIndex(5);
                                                      walletProvider
                                                          .setAccountTypeIndex(
                                                              null);
                                                    }
                                                  },
                                                ));
                                      }
                                    }
                                  } else if (walletProvider.state ==
                                      NetworkState.error) {
                                    Navigator.pop(navigator.currentContext!);
                                    showDialog(
                                      context: navigator.currentContext!,
                                      builder: (context) => WalletDialog(
                                        msg: 'برجاء محاولة الأيداع مرة اخري',
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
                              ));
                    }
                    FocusScope.of(context).unfocus();
                  },
                  title: 'طلب أيداع',
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

  Future<void> getMezaStatus(
      {required WalletProvider walletProvider,
      required AuthProvider authProvider,
      required String value}) async {
    log(value);
    log('${walletProvider.meezaCard!.transaction!.id}');
    Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      log('t');
      await walletProvider.checkPaymentStatus(
          systemReferenceNumber: value,
          transactionId: walletProvider.meezaCard!.transaction!.id!);
      if (walletProvider.state == NetworkState.success) {
        log('success');
        if (walletProvider.creditStatus!.status == 'completed') {
          log('status compeleted');
          if (t.isActive) {
            t.cancel();
            log('timer cancelled');
          }
          log('${walletProvider.creditStatus!.status}');
          await walletProvider.getCurrentBalance(
              authorization: authProvider.appAuthorization!,
              fromRefresh: false);
          Navigator.pop(navigator.currentContext!);
          showDialog(
              context: navigator.currentContext!,
              barrierDismissible: false,
              builder: (context) => ContentDialog(
                    content: 'تم إيداع المبلغ بنجاح',
                    callback: () {
                      Navigator.pop(context);
                      walletProvider.setDepositIndex(5);
                      walletProvider.setAccountTypeIndex(null);
                    },
                  ));
        } else {
          log('not compeleted');
        }
      } else {
        log('else');
        if (t.isActive) {
          t.cancel();
          log('timer cancelled');
        }
        Navigator.pop(navigator.currentContext!);
        showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (context) => ContentDialog(
            content: 'برجاء التأكد من وجود رصيد كافي',
            callback: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    });
  }
}
