import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Dialogs/banks_bottom_sheet.dart';
import '../../../Dialogs/wallet_dialog.dart';
import '../../../Models/bank_branch_model.dart';
import '../../../Models/bank_model.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/branches_bottom_sheet.dart';
import '../../../Widgets/edit_text.dart';
import '../../../Widgets/loading_widget.dart';
import '../../../Widgets/weevo_button.dart';

class WithdrawalBankAccount extends StatefulWidget {
  const WithdrawalBankAccount({super.key});

  @override
  State<WithdrawalBankAccount> createState() => _WithdrawalBankAccountState();
}

class _WithdrawalBankAccountState extends State<WithdrawalBankAccount> {
  late WalletProvider walletProvider;

  bool accountOwnerNameFocused = false,
      bankNameFocused = false,
      bankBranchFocused = false,
      bankIBANFocused = false,
      bankAccountFocused = false;

  bool accountOwnerNameEmpty = true,
      bankNameEmpty = true,
      bankBranchEmpty = true,
      bankIBANEmpty = true,
      bankAccountEmpty = true;

  late TextEditingController accountOwnerNameController,
      bankNameController,
      bankBranchController,
      bankIBANController,
      bankAccountController;
  late FocusNode accountOwnerNameNode,
      bankNameNode,
      bankBranchNode,
      bankIBANNode,
      bankAccountNode;
  int _selectedBankItem = 0, _selectedBranchItem = 0;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  String? accountOwnerName, bankBranch, bankName, bankIBAN, bankAccount;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.banksApi();
    accountOwnerNameController = TextEditingController();
    bankNameController = TextEditingController();
    bankBranchController = TextEditingController();
    bankIBANController = TextEditingController();
    bankAccountController = TextEditingController();
    accountOwnerNameNode = FocusNode();
    bankBranchNode = FocusNode();
    bankNameNode = FocusNode();
    bankIBANNode = FocusNode();
    bankAccountNode = FocusNode();
    accountOwnerNameController.addListener(() {
      setState(() {
        accountOwnerNameEmpty = accountOwnerNameController.text.isEmpty;
      });
    });
    bankBranchController.addListener(() {
      setState(() {
        bankBranchEmpty = bankBranchController.text.isEmpty;
      });
    });
    bankNameController.addListener(() {
      setState(() {
        bankNameEmpty = bankNameController.text.isEmpty;
      });
    });
    bankIBANController.addListener(() {
      setState(() {
        bankIBANEmpty = bankIBANController.text.isEmpty;
      });
    });
    bankAccountController.addListener(() {
      setState(() {
        bankAccountEmpty = bankAccountController.text.isEmpty;
      });
    });
    accountOwnerNameNode.addListener(() {
      setState(() {
        accountOwnerNameFocused = accountOwnerNameNode.hasFocus;
      });
    });
    bankBranchNode.addListener(() {
      setState(() {
        bankBranchFocused = bankBranchNode.hasFocus;
      });
    });
    bankNameNode.addListener(() {
      setState(() {
        bankNameFocused = bankNameNode.hasFocus;
      });
    });
    bankIBANNode.addListener(() {
      setState(() {
        bankIBANFocused = bankIBANNode.hasFocus;
      });
    });
    bankAccountNode.addListener(() {
      setState(() {
        bankAccountFocused = bankAccountNode.hasFocus;
      });
    });
    bankNameEmpty = bankNameController.text.isEmpty;
    accountOwnerNameEmpty = accountOwnerNameController.text.isEmpty;
    bankBranchEmpty = bankBranchController.text.isEmpty;
    bankIBANEmpty = bankIBANController.text.isEmpty;
    bankAccountEmpty = bankAccountController.text.isEmpty;
  }

  @override
  void dispose() {
    bankNameController.dispose();
    bankBranchController.dispose();
    accountOwnerNameController.dispose();
    bankIBANController.dispose();
    bankAccountController.dispose();
    accountOwnerNameNode.dispose();
    bankNameNode.dispose();
    bankBranchNode.dispose();
    bankIBANNode.dispose();
    bankAccountNode.dispose();
    super.dispose();
  }

  void clearControllers() {
    accountOwnerNameController.clear();
    bankNameController.clear();
    bankBranchController.clear();
    bankIBANController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Consumer<WalletProvider>(
      builder: (context, value, child) {
        return LoadingWidget(
          isLoading: walletProvider.loading,
          child: Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: Form(
              key: _formState,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EditText(
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty) {
                          return 'أدخل اسم صاحب الحساب';
                        }
                        isError = false;
                        return null;
                      },
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      readOnly: false,
                      controller: accountOwnerNameController,
                      type: TextInputType.text,
                      onSave: (String? v) {
                        accountOwnerName = v;
                      },
                      labelText: 'اسم صاحب الحساب',
                      isFocus: accountOwnerNameFocused,
                      focusNode: accountOwnerNameNode,
                      isPassword: false,
                      isPhoneNumber: false,
                      shouldDisappear:
                          !accountOwnerNameEmpty && !accountOwnerNameFocused,
                      upperTitle: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    EditText(
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty) {
                          return 'أدخل اسم البنك';
                        }
                        isError = false;
                        return null;
                      },
                      readOnly: true,
                      controller: bankNameController,
                      type: TextInputType.text,
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                          builder: (ctx) {
                            FocusScope.of(context).requestFocus(bankNameNode);
                            return BanksBottomSheet(
                              onItemClick: (BankModel bank, int i) {
                                setState(() {
                                  bankNameController.text = bank.nameAr!;
                                  bankName = bank.id.toString();
                                  _selectedBankItem = i;
                                });
                                walletProvider.branchesApi(bank.id!);
                                Navigator.pop(ctx);
                              },
                              selectedItem: _selectedBankItem,
                              models: walletProvider.banks!,
                            );
                          },
                        );
                        bankNameNode.unfocus();
                      },
                      labelText: 'اسم البنك',
                      isFocus: bankNameFocused,
                      focusNode: bankNameNode,
                      isPassword: false,
                      isPhoneNumber: false,
                      shouldDisappear: !bankNameEmpty && !bankNameFocused,
                      upperTitle: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    EditText(
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty) {
                          return 'أدخل اسم الفرع';
                        }
                        isError = false;
                        return null;
                      },
                      readOnly: true,
                      controller: bankBranchController,
                      type: TextInputType.text,
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                          builder: (ctx) {
                            FocusScope.of(context).requestFocus(bankBranchNode);
                            return BranchesBottomSheet(
                              onItemClick: (BankBranchModel branch, int i) {
                                setState(() {
                                  bankBranchController.text = branch.nameAr!;
                                  bankBranch = branch.id.toString();
                                  _selectedBranchItem = i;
                                });
                                Navigator.pop(ctx);
                              },
                              selectedItem: _selectedBranchItem,
                              models: walletProvider.branches ?? [],
                            );
                          },
                        );
                        bankBranchNode.unfocus();
                      },
                      labelText: 'اسم الفرع',
                      isFocus: bankBranchFocused,
                      focusNode: bankBranchNode,
                      isPassword: false,
                      isPhoneNumber: false,
                      shouldDisappear: !bankBranchEmpty && !bankBranchFocused,
                      upperTitle: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    EditText(
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty) {
                          return 'أدخل رقم الحساب';
                        }
                        isError = false;
                        return null;
                      },
                      readOnly: false,
                      controller: bankAccountController,
                      type: TextInputType.number,
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      onSave: (String? v) {
                        bankAccount = v;
                      },
                      labelText: 'رقم الحساب',
                      isFocus: bankAccountFocused,
                      focusNode: bankAccountNode,
                      isPassword: false,
                      isPhoneNumber: false,
                      shouldDisappear: !bankAccountEmpty && !bankAccountFocused,
                      upperTitle: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    EditText(
                      validator: (String? v) {
                        if (!isButtonPressed) {
                          return null;
                        }
                        isError = true;
                        if (v!.isEmpty) {
                          return 'أدخل رقم ال IBAN';
                        }
                        isError = false;
                        return null;
                      },
                      readOnly: false,
                      controller: bankIBANController,
                      type: TextInputType.text,
                      onChange: (String? v) {
                        isButtonPressed = false;
                        if (isError) {
                          _formState.currentState!.validate();
                        }
                      },
                      onSave: (String? v) {
                        bankIBAN = v;
                      },
                      labelText: 'رقم ال IBAN',
                      isFocus: bankIBANFocused,
                      focusNode: bankIBANNode,
                      isPassword: false,
                      isPhoneNumber: false,
                      shouldDisappear: !bankIBANEmpty && !bankIBANFocused,
                      upperTitle: true,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    WeevoButton(
                      isStable: true,
                      title: 'طلب سحب',
                      color: weevoPrimaryOrangeColor,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        isButtonPressed = true;
                        final formState = _formState.currentState;
                        if (formState!.validate()) {
                          formState.save();
                          log(bankAccount!);
                          log(bankIBAN!);
                          log(bankName!);
                          log(bankBranch!);
                          log(accountOwnerName!);
                          walletProvider.setLoading(true);
                          await walletProvider.bankAccountWithdrawal(
                            amount: walletProvider.withdrawalAmount!.toDouble(),
                            bankId: bankName!,
                            branchId: bankBranch!,
                            accountNumber: bankAccount!,
                            accountIban: bankIBAN!,
                            ownerName: accountOwnerName!,
                          );
                          if (walletProvider.state == NetworkState.success) {
                            await walletProvider.getCurrentBalance(
                                fromRefresh: false);
                            walletProvider.setLoading(false);
                            walletProvider.setWithdrawalIndex(5);
                          } else if (walletProvider.state == NetworkState.logout) {
                            check(
                                state: walletProvider.state!,
                                ctx: navigator.currentContext!,
                                auth: authProvider);
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
