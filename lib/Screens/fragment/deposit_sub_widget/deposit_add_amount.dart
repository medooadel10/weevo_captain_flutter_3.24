import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/weevo_button.dart';

class DepositAddAmount extends StatefulWidget {
  const DepositAddAmount({super.key});

  @override
  State<DepositAddAmount> createState() => _DepositAddAmountState();
}

class _DepositAddAmountState extends State<DepositAddAmount> {
  late FocusNode _billingNode;
  late TextEditingController _billingController;
  bool _billingIsEmpty = true;
  bool _billingFocused = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? _depositAmount;
  late WalletProvider _walletProvider;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _billingNode = FocusNode();
    _billingController = TextEditingController();
    _billingNode.addListener(() {
      setState(() {
        _billingFocused = _billingNode.hasFocus;
      });
    });
    _billingController.addListener(() {
      setState(() {
        _billingIsEmpty = _billingController.text.isEmpty;
      });
    });
    _billingIsEmpty = _billingController.text.isEmpty;
    _billingController.text = _walletProvider.depositAmount != null
        ? _walletProvider.depositAmount.toString()
        : '';
  }

  @override
  void dispose() {
    _billingNode.dispose();
    _billingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/credit_card_pic.png',
            height: 200.0.h,
            width: 200.0.h,
          ),
          Form(
            key: _formState,
            child: EditText(
              readOnly: false,
              controller: _billingController,
              fontSize: 20.0.sp,
              fontWeight: FontWeight.w700,
              upperTitle: true,
              align: TextAlign.center,
              focusNode: _billingNode,
              action: TextInputAction.done,
              onFieldSubmit: (_) {
                _billingNode.unfocus();
              },
              onChange: (String? value) {
                isButtonPressed = false;
                if (isError) {
                  _formState.currentState!.validate();
                }
              },
              isFocus: _billingFocused,
              radius: 12.0.r,
              isPhoneNumber: false,
              shouldDisappear: !_billingFocused && !_billingIsEmpty,
              onSave: (String? value) {
                _depositAmount = value;
              },
              type: TextInputType.number,
              validator: (String? value) {
                if (!isButtonPressed) {
                  return null;
                }
                isError = true;
                if (value!.isEmpty || double.parse(value) <= 0.0) {
                  return priceForPay;
                } else if (double.parse(value) < 10.0) {
                  return 'يجب الا يقل المبلغ عن ١٠ جنية';
                }
                isError = false;
                return null;
              },
              labelText: 'أدخل المبلغ',
              suffix: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Text(
                      'جنية',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0.r,
                      ),
                    ),
                  ),
                ],
              ),
              isPassword: false,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          WeevoButton(
            isStable: true,
            color: weevoPrimaryOrangeColor,
            weight: FontWeight.w700,
            onTap: () {
              FocusScope.of(context).unfocus();
              isButtonPressed = true;
              if (_formState.currentState!.validate()) {
                _formState.currentState!.save();
                walletProvider
                    .setDepositAmount(int.parse(_depositAmount ?? '0'));
                walletProvider.setDepositIndex(1);
              }
            },
            title: 'تأكيد المبلغ',
          ),
        ],
      ),
    );
  }
}
