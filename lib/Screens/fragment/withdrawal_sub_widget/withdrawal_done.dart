import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';

class WithdrawalDone extends StatelessWidget {
  const WithdrawalDone({super.key});

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/pay_wallet.png',
          ),
          SizedBox(
            height: 10.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تم طلب سحب ',
                style: TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 25.0.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${walletProvider.withdrawalAmount}',
                style: TextStyle(
                  color: weevoDarkBlue,
                  fontSize: 25.0.sp,
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
            'سيتم تحويل مبلغ السحب خلال 24 ساعة',
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
