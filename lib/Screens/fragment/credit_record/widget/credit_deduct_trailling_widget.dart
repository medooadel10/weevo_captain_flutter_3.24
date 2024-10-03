import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../Models/dedaction_model.dart';
import '../../../../Utilits/colors.dart';

class CreditDeductTrailingWidget extends StatelessWidget {
  final Data data;

  const CreditDeductTrailingWidget({
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
              '${data.amount}',
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
        SizedBox(
          width: 100.0,
          height: 30.0,
          child: Center(
            child: Text(
              DateFormat('dd/MM/yyyy hh:mm a', 'ar-EG')
                  .format(DateTime.parse(data.dateTime!)),
              style: TextStyle(
                fontSize: 12.0.sp,
                color: Colors.black,
              ),
            ),
          ),
        )
      ],
    );
  }
}
