import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Dialogs/filter_dialog.dart';
import '../Providers/auth_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/wallet_tab.dart';

class Wallet extends StatefulWidget {
  static String id = 'Wallet';

  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late AuthProvider _authProvider;
  late WalletProvider _walletProvider;
  bool _firstTime = true;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    getBalance();
  }

  void getBalance() async {
    await _walletProvider.getCurrentBalance(
      authorization: _authProvider.appAuthorization,
      fromRefresh: false,
    );
    check(
        auth: _authProvider,
        ctx: navigator.currentContext!,
        state: _walletProvider.state!);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () {
          if (_firstTime) {
            getBalance();
            _firstTime = false;
          }
        },
        child: PopScope(
          onPopInvokedWithResult: (value, result) async {
            switch (walletProvider.mainIndex) {
              case 0:
                Navigator.pop(context);
                walletProvider.setMainIndex(0);
                break;
              case 1:
                switch (walletProvider.depositIndex) {
                  case 0:
                    Navigator.pop(context);
                    walletProvider.setMainIndex(0);
                    break;
                  case 1:
                    walletProvider.setDepositIndex(0);
                    break;
                  case 2:
                    walletProvider.setDepositIndex(1);
                    break;
                  // case 3:
                  //   walletProvider.setDepositIndex(1);
                  //   break;
                  // case 4:
                  //   walletProvider.setDepositIndex(1);
                  //   break;
                  case 3:
                    walletProvider.setDepositAmount(null);
                    walletProvider.setDepositIndex(0);
                    break;
                }
                break;
              case 2:
                switch (walletProvider.withdrawalIndex) {
                  case 0:
                    Navigator.pop(context);
                    walletProvider.setMainIndex(0);
                    break;
                  case 1:
                    walletProvider.setWithdrawalIndex(0);
                    break;
                  case 2:
                    walletProvider.setWithdrawalIndex(1);
                    break;
                  case 3:
                    walletProvider.setWithdrawalIndex(1);
                    break;
                  case 4:
                    walletProvider.setWithdrawalIndex(1);
                    break;
                  case 5:
                    walletProvider.setWithdrawalAmount(null);
                    walletProvider.setWithdrawalIndex(0);
                    break;
                }
                break;
              case 3:
                Navigator.pop(context);
                walletProvider.setMainIndex(0);
                break;
              case 4:
                Navigator.pop(context);
                walletProvider.setMainIndex(0);
                break;
            }
          },
          canPop: true,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                walletProvider.mainIndex == 3 || walletProvider.mainIndex == 4
                    ? walletProvider.creditPaging ||
                            walletProvider.paymentPaging ||
                            walletProvider.approvedWithdrawPaging ||
                            walletProvider.pendingWithdrawPaging ||
                            walletProvider.declinedWithdrawPaging ||
                            walletProvider.transferredWithdrawPaging
                        ? Container()
                        : FloatingActionButton.extended(
                            onPressed: () {
                              log(walletProvider.agreedAmount.toString());
                              showDialog(
                                context: context,
                                builder: (context) => const FilterDialog(),
                              );
                            },
                            label: const Text(
                              'تصنيف',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            icon: const Icon(Icons.filter_list_alt),
                            backgroundColor: walletProvider.mainIndex == 4
                                ? weevoLightBlue
                                : weevoLightPurple,
                          )
                    : Container(),
            backgroundColor: weevoWhiteSilver,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  switch (walletProvider.mainIndex) {
                    case 0:
                      Navigator.pop(context);
                      walletProvider.setMainIndex(0);
                      break;
                    case 1:
                      switch (walletProvider.depositIndex) {
                        case 0:
                          Navigator.pop(context);
                          walletProvider.setMainIndex(0);
                          break;
                        case 1:
                          walletProvider.setDepositIndex(0);
                          break;
                        case 2:
                          walletProvider.setDepositIndex(1);
                          break;
                        // case 3:
                        //   walletProvider.setDepositIndex(1);
                        //   break;
                        // case 4:
                        //   walletProvider.setDepositIndex(1);
                        //   break;
                        case 3:
                          walletProvider.setDepositAmount(null);
                          walletProvider.setDepositIndex(0);
                          break;
                      }
                      break;
                    case 2:
                      switch (walletProvider.withdrawalIndex) {
                        case 0:
                          Navigator.pop(context);
                          walletProvider.setMainIndex(0);
                          break;
                        case 1:
                          walletProvider.setWithdrawalIndex(0);
                          break;
                        case 2:
                          walletProvider.setWithdrawalIndex(1);
                          break;
                        case 3:
                          walletProvider.setWithdrawalIndex(1);
                          break;
                        case 4:
                          walletProvider.setWithdrawalIndex(1);
                          break;
                        case 5:
                          walletProvider.setWithdrawalAmount(null);
                          walletProvider.setWithdrawalIndex(0);
                          break;
                      }
                      break;
                    case 3:
                      Navigator.pop(context);
                      walletProvider.setMainIndex(0);
                      break;
                    case 4:
                      Navigator.pop(context);
                      walletProvider.setMainIndex(0);
                      break;
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                ),
              ),
              title: const Text(
                'المحفظة',
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                    ),
                    color: weevoWhiteSilver,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'رصيدك الحـالي',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: weevoLightGrey,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * .01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'EGP',
                              style: TextStyle(
                                fontSize: 30.0,
                                color: weevoDarkBlue,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              walletProvider.currentBalance ?? '0.0',
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: weevoDarkBlue,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            walletProvider.state == NetworkState.waiting
                                ? IconButton(
                                    onPressed: () {},
                                    icon: SizedBox(
                                      height: 15.h,
                                      width: 15.w,
                                      child: const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          weevoPrimaryBlueColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.refresh),
                                    onPressed: () async {
                                      await walletProvider.getCurrentBalance(
                                          authorization:
                                              _authProvider.appAuthorization,
                                          fromRefresh: true);
                                    },
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: mediaQuery.size.height * .03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WalletTab(
                              tabTitle: 'الرئيسية\n',
                              onTap: () => walletProvider.setMainIndex(0),
                              imageIcon: 'assets/images/home.png',
                              color: weevoGreenLighter,
                              selectedIndex: walletProvider.mainIndex,
                              itemIndex: 0,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            WalletTab(
                              tabTitle: 'ايداع\n',
                              onTap: () {
                                walletProvider.setMainIndex(1);
                                walletProvider.setDepositIndex(0);
                                walletProvider.setDepositAmount(null);
                              },
                              imageIcon: 'assets/images/deposit.png',
                              color: weevoPrimaryOrangeColor,
                              selectedIndex: walletProvider.mainIndex,
                              itemIndex: 1,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            WalletTab(
                              tabTitle: 'سحب\n',
                              onTap: () {
                                walletProvider.setMainIndex(2);
                                walletProvider.setWithdrawalIndex(0);
                                walletProvider.setWithdrawalAmount(null);
                              },
                              imageIcon: 'assets/images/on_hold.png',
                              color: weevoPrimaryBlueColor,
                              selectedIndex: walletProvider.mainIndex,
                              itemIndex: 2,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            WalletTab(
                              tabTitle: 'سجل\nالرصيد',
                              onTap: () {
                                walletProvider.setMainIndex(3);
                                walletProvider.setCreditMainIndex(0);
                                walletProvider.resetCreditFilter();
                                walletProvider.resetPaymentFilter();
                              },
                              imageIcon: 'assets/images/record.png',
                              color: weevoLightPurple,
                              selectedIndex: walletProvider.mainIndex,
                              itemIndex: 3,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            WalletTab(
                              tabTitle: 'سجل\nالسحب',
                              onTap: () {
                                walletProvider.setMainIndex(4);
                                walletProvider.setWithdrawMainIndex(0);
                                walletProvider.resetApprovedWithdrawFilter();
                                walletProvider.resetPendingWithdrawFilter();
                                walletProvider.resetTransferredWithdrawFilter();
                                walletProvider.resetDeclinedWithdrawFilter();
                              },
                              imageIcon: 'assets/images/record.png',
                              color: weevoLightBlue,
                              selectedIndex: walletProvider.mainIndex,
                              itemIndex: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                            35,
                          ),
                          topLeft: Radius.circular(
                            35,
                          ),
                        ),
                      ),
                      child: walletProvider.mainWidget,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
