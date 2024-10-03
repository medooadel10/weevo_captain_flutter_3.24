import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Models/transaction_data.dart';
import '../../../../Utilits/colors.dart';

class CreditTrailingWidget extends StatelessWidget {
  final TransactionData data;
  final int index;

  const CreditTrailingWidget({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '${data.netAmount}',
              style: TextStyle(
                fontSize: 12.0.sp,
                color: weevoLightBlackGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              'جنيه',
              style: TextStyle(
                fontSize: 11.0.sp,
                color: weevoLightBlackGrey,
              ),
            ),
          ],
        ),
        index == 1 || index == 2
            ? const SizedBox(
                width: 80.0,
                height: 30.0,
              )
            : data.details!.method == 'bm-upg-e-wallet'
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
                : data.details!.method == 'bm-upg-meeza-card'
                    ? Container(
                        width: 80.0,
                        height: 30.0,
                        padding: const EdgeInsets.all(
                          6.0,
                        ),
                        decoration: BoxDecoration(
                          color: weevoMizaColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Text(
                            'بطاقة ميزة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 80.0,
                        height: 30.0,
                        padding: const EdgeInsets.all(
                          6.0,
                        ),
                        decoration: BoxDecoration(
                          color: weevoPrimaryOrangeColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: Text(
                            'كاش',
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
