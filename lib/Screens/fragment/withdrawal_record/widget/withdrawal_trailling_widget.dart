import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Models/transaction_data.dart';
import '../../../../Utilits/colors.dart';

class WithdrawalTrailingWidget extends StatelessWidget {
  final TransactionData data;
  const WithdrawalTrailingWidget({
    super.key,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              data.amount!,
              style: TextStyle(
                fontSize: 12.0.sp,
                color: weevoLightBlackGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'جنيه',
              style: TextStyle(
                fontSize: 10.0.sp,
                color: weevoLightBlackGrey,
              ),
            ),
          ],
        ),
        data.details!.method == 'e-wallet'
            ? Container(
                width: 80.0,
                height: 30.0,
                padding: const EdgeInsets.all(
                  6.0,
                ),
                decoration: BoxDecoration(
                  color: weevoBlackPurple,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Image.asset('assets/images/meza_word.png'),
              )
            : Container(
                width: 80.0,
                height: 30.0,
                padding: const EdgeInsets.all(
                  6.0,
                ),
                decoration: BoxDecoration(
                  color: weevoGreenLighter,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    'حساب بنكي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
