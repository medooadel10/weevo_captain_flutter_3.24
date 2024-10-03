import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Dialogs/wallet_dialog.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';

class WithdrawEWallet extends StatefulWidget {
  const WithdrawEWallet({super.key});

  @override
  State<WithdrawEWallet> createState() => _WithdrawEWalletState();
}

class _WithdrawEWalletState extends State<WithdrawEWallet> {
  late TextEditingController _walletNumberController, _walletOwnerController;
  late FocusNode _walletNumberNode, _walletOwnerNode;
  String? _walletOwner, _walletNumber;
  bool? _walletNumberFocused = false,
      _walletOwnerFocused = false,
      _walletNumberEmpty = true,
      _walletOwnerEmpty;
  bool isError = false;
  bool isButtonPressed = false;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _walletNumberController = TextEditingController();
    _walletOwnerController = TextEditingController();
    _walletNumberNode = FocusNode();
    _walletOwnerNode = FocusNode();
    _walletNumberNode.addListener(() {
      setState(() {
        _walletNumberFocused = _walletNumberNode.hasFocus;
      });
    });
    _walletOwnerNode.addListener(() {
      setState(() {
        _walletOwnerFocused = _walletOwnerNode.hasFocus;
      });
    });
    _walletNumberController.addListener(() {
      setState(() {
        _walletNumberEmpty = _walletNumberController.text.isEmpty;
      });
    });
    _walletOwnerController.addListener(() {
      setState(() {
        _walletOwnerEmpty = _walletOwnerController.text.isEmpty;
      });
    });
    _walletNumberEmpty = _walletNumberController.text.isEmpty;
    _walletOwnerEmpty = _walletOwnerController.text.isEmpty;
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
                  'رقم المحفظة',
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
                  controller: _walletOwnerController,
                  focusNode: _walletOwnerNode,
                  isFocus: _walletOwnerFocused,
                  type: TextInputType.text,
                  labelText: 'اسم صاحب المحفظة',
                  isPassword: false,
                  isPhoneNumber: false,
                  validator: (String? v) {
                    if (!isButtonPressed) {
                      return null;
                    }
                    isError = true;
                    if (v!.isEmpty) {
                      return 'ادخل اسم صاحب المحفظة';
                    }
                    isError = false;
                    return null;
                  },
                  onSave: (String? v) {
                    _walletOwner = v;
                  },
                  upperTitle: true,
                  shouldDisappear: !_walletOwnerEmpty! && !_walletOwnerFocused!,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                EditText(
                  readOnly: false,
                  controller: _walletNumberController,
                  focusNode: _walletNumberNode,
                  isFocus: _walletNumberFocused,
                  type: TextInputType.number,
                  labelText: 'رقم المحفظة',
                  isPassword: false,
                  isPhoneNumber: true,
                  validator: (String? v) {
                    if (!isButtonPressed) {
                      return null;
                    }
                    isError = true;
                    if (v!.isEmpty) {
                      return 'ادخل رقم المحفظة';
                    }
                    isError = false;
                    return null;
                  },
                  onSave: (String? v) {
                    _walletNumber = v;
                  },
                  upperTitle: true,
                  shouldDisappear:
                      !_walletNumberEmpty! && !_walletNumberFocused!,
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
                      walletProvider.setLoading(true);
                      await walletProvider.walletWithdrawal(
                          amount: walletProvider.withdrawalAmount!.toDouble(),
                          walletNumber: _walletNumber!,
                          walletOwner: _walletOwner!);
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
