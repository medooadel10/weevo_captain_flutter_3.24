import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Utilits/colors.dart';
import '../Widgets/edit_text.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});
  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late TextEditingController _fromController, _toController;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _fromController = TextEditingController();
    _toController = TextEditingController();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WalletProvider walletProvider = Provider.of<WalletProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: EditText(
                      readOnly: true,
                      controller: _fromController,
                      isPassword: false,
                      isPhoneNumber: false,
                      hintText: 'الفترة من',
                      upperTitle: false,
                      onTap: () async {
                        DateTime? dt = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          builder: (BuildContext ctx, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                dialogTheme: DialogTheme(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                  ),
                                ),
                                colorScheme: const ColorScheme.light(
                                  primary: weevoPrimaryOrangeColor,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: weevoPrimaryOrangeColor,
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child ?? Container(),
                            );
                          },
                        );
                        if (dt == null) {
                          return;
                        }
                        final dateTime = DateTime(
                          dt.year,
                          dt.month,
                          dt.day,
                        );
                        _fromController.text =
                            intl.DateFormat('yyyy-MM-dd').format(dateTime);
                      },
                      isFocus: false,
                      shouldDisappear: false,
                    ),
                  ),
                  SizedBox(width: 6.h),
                  Expanded(
                    child: EditText(
                      readOnly: true,
                      controller: _toController,
                      isPassword: false,
                      isPhoneNumber: false,
                      hintText: 'الفترة الي',
                      upperTitle: false,
                      onTap: () async {
                        DateTime? dt = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          builder: (BuildContext ctx, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                dialogTheme: DialogTheme(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      25.0,
                                    ),
                                  ),
                                ),
                                colorScheme: const ColorScheme.light(
                                  primary: weevoPrimaryOrangeColor,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: weevoPrimaryOrangeColor,
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child ?? Container(),
                            );
                          },
                        );
                        if (dt == null) {
                          return;
                        }
                        final dateTime = DateTime(
                          dt.year,
                          dt.month,
                          dt.day,
                        );
                        _toController.text =
                            intl.DateFormat('yyyy-MM-dd').format(dateTime);
                      },
                      isFocus: false,
                      shouldDisappear: false,
                    ),
                  ),
                ],
              ),
              isError
                  ? SizedBox(
                      height: 8.h,
                    )
                  : Container(),
              isError
                  ? Text(
                      'يجب ان يكون تاريخ من الفترة قبل الي الفترة',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 16.0,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20.h,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (DateTime.parse(_fromController.text)
                      .isAfter(DateTime.parse(_toController.text))) {
                    setState(() {
                      isError = true;
                    });
                  } else {
                    if (walletProvider.mainIndex == 3) {
                      switch (walletProvider.creditMainIndex) {
                        case 0:
                          Navigator.pop(context);
                          walletProvider.creditDateFrom = _fromController.text;
                          walletProvider.creditDateTo = _toController.text;
                          await walletProvider.creditListOfTransaction(
                              authorization: authProvider.appAuthorization!,
                              paging: false,
                              refreshing: false,
                              isFilter: true);
                          break;
                        case 1:
                          Navigator.pop(context);
                          walletProvider.creditDeductionDateFrom =
                              _fromController.text;
                          walletProvider.creditDeductionDateTo =
                              _toController.text;
                          await walletProvider.creditDeductionListOfTransaction(
                              paging: false, refreshing: false, isFilter: true);
                      }
                    } else if (walletProvider.mainIndex == 4) {
                      switch (walletProvider.withdrawMainIndex) {
                        case 0:
                          Navigator.pop(context);
                          walletProvider.pendingWithdrawDateFrom =
                              _fromController.text;
                          walletProvider.pendingWithdrawDateTo =
                              _toController.text;
                          await walletProvider.pendingWithdrawTransactions(
                              authorization: authProvider.appAuthorization!,
                              paging: false,
                              refreshing: false,
                              isFilter: true);
                          break;
                        case 1:
                          Navigator.pop(context);
                          walletProvider.approvedWithdrawDateFrom =
                              _fromController.text;
                          walletProvider.approvedWithdrawDateTo =
                              _toController.text;
                          await walletProvider.approvedWithdrawTransactions(
                              authorization: authProvider.appAuthorization!,
                              paging: false,
                              refreshing: false,
                              isFilter: true);
                          break;
                        case 2:
                          Navigator.pop(context);
                          walletProvider.transferredWithdrawDateFrom =
                              _fromController.text;
                          walletProvider.transferredWithdrawDateTo =
                              _toController.text;
                          await walletProvider.transferredWithdrawTransactions(
                              authorization: authProvider.appAuthorization!,
                              paging: false,
                              refreshing: false,
                              isFilter: true);
                          break;
                        case 3:
                          Navigator.pop(context);
                          walletProvider.declinedWithdrawDateFrom =
                              _fromController.text;
                          walletProvider.declinedWithdrawDateTo =
                              _toController.text;
                          await walletProvider.declinedWithdrawTransactions(
                            authorization: authProvider.appAuthorization!,
                            paging: false,
                            refreshing: false,
                            isFilter: true,
                          );
                      }
                    }
                  }
                },
                style: ButtonStyle(
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 6.0,
                    )),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    )),
                child: Text(
                  'تصنيف',
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
