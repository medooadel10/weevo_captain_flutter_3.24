import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Dialogs/wallet_dialog.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/credit_card_formatter.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';

class WithdrawalMezaCard extends StatefulWidget {
  const WithdrawalMezaCard({super.key});

  @override
  State<WithdrawalMezaCard> createState() => _WithdrawalMezaCardState();
}

class _WithdrawalMezaCardState extends State<WithdrawalMezaCard> {
  late TextEditingController _cardNumberController, _cardOwnerController;
  late FocusNode _cardNumberNode, _cardOwnerNode;
  String? _cardOwner, _cardNumber;
  bool? _cardNumberFocused = false,
      _cardOwnerFocused = false,
      _cardNumberEmpty = true,
      _cardOwnerEmpty;
  bool isError = false;
  bool isButtonPressed = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cardNumberController = TextEditingController();
    _cardOwnerController = TextEditingController();
    _cardNumberNode = FocusNode();
    _cardOwnerNode = FocusNode();
    _cardNumberNode.addListener(() {
      setState(() {
        _cardNumberFocused = _cardNumberNode.hasFocus;
      });
    });
    _cardOwnerNode.addListener(() {
      setState(() {
        _cardOwnerFocused = _cardOwnerNode.hasFocus;
      });
    });
    _cardNumberController.addListener(() {
      setState(() {
        _cardNumberEmpty = _cardNumberController.text.isEmpty;
      });
    });
    _cardOwnerController.addListener(() {
      setState(() {
        _cardOwnerEmpty = _cardOwnerController.text.isEmpty;
      });
    });
    _cardNumberEmpty = _cardNumberController.text.isEmpty;
    _cardOwnerEmpty = _cardOwnerController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return LoadingWidget(
      isLoading: walletProvider.loading,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Form(
          key: _formState,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 30.h,
                ),
                const Text(
                  'كارت ميزة',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: weevoTransGrey,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                EditText(
                  readOnly: false,
                  controller: _cardOwnerController,
                  focusNode: _cardOwnerNode,
                  isFocus: _cardOwnerFocused,
                  type: TextInputType.text,
                  labelText: 'الاسم المكتوب علي البطاقة',
                  isPassword: false,
                  isPhoneNumber: false,
                  validator: (String? v) {
                    if (!isButtonPressed) {
                      return null;
                    }
                    isError = true;
                    if (v!.isEmpty) {
                      return 'ادخل الاسم المكتوب علي البطاقة';
                    }
                    isError = false;
                    return null;
                  },
                  onSave: (String? v) {
                    _cardOwner = v;
                  },
                  upperTitle: true,
                  shouldDisappear: !_cardOwnerEmpty! && !_cardOwnerFocused!,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                EditText(
                  readOnly: false,
                  controller: _cardNumberController,
                  focusNode: _cardNumberNode,
                  isFocus: _cardNumberFocused,
                  type: TextInputType.number,
                  labelText: 'الرقم المكتوب علي البطاقة',
                  isPassword: false,
                  isPhoneNumber: false,
                  maxLength: 19,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CreditCardInputFormatter(),
                  ],
                  validator: (String? v) {
                    if (!isButtonPressed) {
                      return null;
                    }
                    isError = true;
                    if (v!.isEmpty) {
                      return 'الرقم المكتوب علي البطاقة';
                    }
                    isError = false;
                    return null;
                  },
                  onSave: (String? v) {
                    _cardNumber = v;
                  },
                  upperTitle: true,
                  shouldDisappear: !_cardNumberEmpty! && !_cardNumberFocused!,
                ),
                SizedBox(
                  height: 20.h,
                ),
                WeevoButton(
                  isStable: true,
                  color: weevoPrimaryOrangeColor,
                  weight: FontWeight.w700,
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    isButtonPressed = true;
                    if (_formState.currentState!.validate()) {
                      _formState.currentState!.save();
                      log(_cardOwner!);
                      log(_cardNumber!);
                      log(_cardNumber!.split('-').join());
                      walletProvider.setLoading(true);
                      await walletProvider.mezaWithdrawal(
                          amount: walletProvider.withdrawalAmount!.toDouble(),
                          cardNumber: _cardNumber!.split('-').join(),
                          cardOwner: _cardOwner!);
                      if (walletProvider.state == NetworkState.success) {
                        await walletProvider.getCurrentBalance(
                            fromRefresh: false);
                        walletProvider.setLoading(false);
                        walletProvider.setWithdrawalIndex(5);
                      } else if (walletProvider.state == NetworkState.logout) {
                        check(
                            auth: authProvider,
                            state: walletProvider.state!,
                            ctx: navigator.currentContext!);
                      } else if (walletProvider.state == NetworkState.error) {
                        walletProvider.setLoading(false);
                        showDialog(
                          context: navigator.currentContext!,
                          builder: (context) => WalletDialog(
                            msg: walletProvider.errorMessage!,
                            onPress: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      }
                    }
                    walletProvider.setAccountTypeIndex(null);
                  },
                  title: 'طلب سحب',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
