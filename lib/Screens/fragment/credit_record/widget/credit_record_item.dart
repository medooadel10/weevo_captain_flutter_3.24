import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../Models/transaction_data.dart';
import 'credit_leading_icon.dart';
import 'credit_trailling_widget.dart';

class CreditRecordItem extends StatelessWidget {
  final TransactionData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            index == 0
                ? 'إيداع رقم ${data.details!.id}'
                : 'عملية رقم ${data.details!.id}',
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (index == 0)
            Text(
              'تم أيداع ${data.amount} وتم خصم ${data.bankCharge}',
              style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold),
            ),
        ],
      ),
      subtitle: data.dateTime != null
          ? Text(
              DateFormat('dd/MM/yyyy hh:mm a', 'ar_EG')
                  .format(DateTime.parse(data.dateTime!)),
              style: TextStyle(
                fontSize: 14.0.sp,
                color: Colors.black,
              ),
            )
          : Container(),
      leading: const CreditLeadingIcon(),
      trailing: CreditTrailingWidget(
        index: index,
        data: data,
      ),
    );
  }

  const CreditRecordItem({
    super.key,
    required this.data,
    required this.index,
  });
}
