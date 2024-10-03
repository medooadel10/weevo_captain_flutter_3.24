import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/cash_out.dart';
import '../Providers/wallet_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';

class CashOutWidget extends StatefulWidget {
  const CashOutWidget({super.key});

  @override
  State<CashOutWidget> createState() => _CashOutWidgetState();
}

class _CashOutWidgetState extends State<CashOutWidget> {
  int? _selectedItem;
  late WalletProvider _walletProvider;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _selectedItem = _walletProvider.accountWithdrawalTypeIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cashOutList
          .map(
            (CashOut item) => GestureDetector(
              onTap: () {
                _walletProvider
                    .setWithdrawalAccountTypeIndex(cashOutList.indexOf(item));
                setState(() {
                  _selectedItem = cashOutList.indexOf(item);
                });
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: item.color,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: cashOutList.indexOf(item) == _selectedItem
                        ? Container(
                            decoration: const BoxDecoration(
                              color: weevoRustYellow,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2.0),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
