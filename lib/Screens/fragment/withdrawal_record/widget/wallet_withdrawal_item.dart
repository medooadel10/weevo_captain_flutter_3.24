import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../Models/transaction_data.dart';
import 'withdrawal_leading_icon.dart';
import 'withdrawal_trailling_widget.dart';

class WithdrawalRecordItem extends StatelessWidget {
  final TransactionData data;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'سحب رقم ${data.details!.id}',
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy hh:mm a', 'ar_EG')
            .format(DateTime.parse(data.dateTime!)),
        style: TextStyle(
          fontSize: 14.0.sp,
          color: Colors.grey,
        ),
      ),
      leading: const WithdrawalLeadingIcon(),
      trailing: WithdrawalTrailingWidget(
        data: data,
      ),
    );
  }

  const WithdrawalRecordItem({
    super.key,
    required this.data,
  });
}
