import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/wallet_provider.dart';

class WalletWithdrawal extends StatelessWidget {
  const WalletWithdrawal({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return walletProvider.withdrawalWidget;
  }
}
