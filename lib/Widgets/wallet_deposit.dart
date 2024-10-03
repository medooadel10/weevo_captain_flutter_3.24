import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/wallet_provider.dart';

class WalletDeposit extends StatefulWidget {
  const WalletDeposit({super.key});

  @override
  State<WalletDeposit> createState() => _WalletDepositState();
}

class _WalletDepositState extends State<WalletDeposit> {
  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    return walletProvider.depositWidget;
  }
}
