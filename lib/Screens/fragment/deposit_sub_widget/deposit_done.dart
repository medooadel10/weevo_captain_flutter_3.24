import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';

class DepositDone extends StatelessWidget {
  const DepositDone({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(
        16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pay_wallet.png',
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تم ايداع مبلغ ',
                style: TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 25.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                walletProvider.depositAmount.toString(),
                style: TextStyle(
                  color: weevoLightOrange,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' جنية',
                style: TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 25.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            'يمكنك معرفة تفاصيل الايداع من سجل الرصيد',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: weevoDarkBlue,
              fontSize: 14.0.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
