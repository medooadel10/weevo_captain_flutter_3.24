import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/network_error_widget.dart';
import 'widget/credit_deduct_item.dart';

class DeductionRequest extends StatefulWidget {
  const DeductionRequest({super.key});

  @override
  State<DeductionRequest> createState() => _DeductionRequestState();
}

class _DeductionRequestState extends State<DeductionRequest> {
  late WalletProvider _walletProvider;
  late AuthProvider _authProvider;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_walletProvider.creditDeductionPaging) {
          _walletProvider.nextCreditDeductionPage();
        }
      }
    });
  }

  void getData() async {
    await _walletProvider.creditDeductionListOfTransaction(
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
      auth: _authProvider,
      state: _walletProvider.creditDeductionState!,
      ctx: navigator.currentContext!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, data, child) => data.creditDeductionState ==
              NetworkState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
              ),
            )
          : data.creditDeductionState == NetworkState.success
              ? data.creditDeductionListEmpty
                  ? Center(
                      child: Text(
                        'لا توجد مدفوعات',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0.sp,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => data.clearCreditDeductionList(),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView.builder(
                            controller: _controller,
                            itemBuilder: (BuildContext context, int i) =>
                                CreditDeductItem(
                              data: data.creditDeductionList[i],
                            ),
                            itemCount: data.creditDeductionList.length,
                          ),
                          AnimatedContainer(
                            color: Colors.white.withOpacity(0.8),
                            height: data.creditDeductionPaging ? 40.0.h : 0.0.h,
                            duration: const Duration(milliseconds: 300),
                            child: const Center(
                              child: SpinKitThreeBounce(
                                color: weevoPrimaryOrangeColor,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
              : NetworkErrorWidget(
                  onRetryCallback: () async {
                    await _walletProvider.creditDeductionListOfTransaction(
                      paging: false,
                      refreshing: false,
                      isFilter: true,
                    );
                  },
                ),
    );
  }
}
