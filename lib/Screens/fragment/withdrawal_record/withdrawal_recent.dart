import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';
import '../../../Widgets/wallet_tab_item.dart';

class WalletWithdrawalRecord extends StatefulWidget {
  const WalletWithdrawalRecord({super.key});

  @override
  State<WalletWithdrawalRecord> createState() => _WalletWithdrawalRecordState();
}

class _WalletWithdrawalRecordState extends State<WalletWithdrawalRecord> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar_EG');
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 25.0,
            left: 12.0,
            right: 12.0,
            bottom: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WalletTabItem(
                name: 'منتظرة',
                index: 0,
                selectedItem: walletProvider.withdrawMainIndex,
                onPress: () {
                  walletProvider.setWithdrawMainIndex(0);
                  walletProvider.resetPendingWithdrawFilter();
                },
                indicatorColor: weevoLightBlue,
              ),
              WalletTabItem(
                name: 'مقبولة',
                index: 1,
                selectedItem: walletProvider.withdrawMainIndex,
                onPress: () {
                  walletProvider.setWithdrawMainIndex(1);
                  walletProvider.resetApprovedWithdrawFilter();
                },
                indicatorColor: weevoLightBlue,
              ),
              WalletTabItem(
                name: 'محولة',
                index: 2,
                selectedItem: walletProvider.withdrawMainIndex,
                onPress: () {
                  walletProvider.setWithdrawMainIndex(2);
                  walletProvider.resetTransferredWithdrawFilter();
                },
                indicatorColor: weevoLightBlue,
              ),
              WalletTabItem(
                name: 'مرفوضة',
                index: 3,
                selectedItem: walletProvider.withdrawMainIndex,
                onPress: () {
                  walletProvider.setWithdrawMainIndex(3);
                  walletProvider.resetDeclinedWithdrawFilter();
                },
                indicatorColor: weevoLightBlue,
              ),
            ],
          ),
        ),
        Expanded(child: walletProvider.withdrawMainWidget),
      ],
    );
  }
}
