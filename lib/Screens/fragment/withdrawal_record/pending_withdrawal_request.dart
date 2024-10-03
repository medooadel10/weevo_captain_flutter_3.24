import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../Providers/auth_provider.dart';
import '../../../Providers/wallet_provider.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/network_error_widget.dart';
import 'widget/wallet_withdrawal_item.dart';

class PendingWithdrawalRequests extends StatefulWidget {
  const PendingWithdrawalRequests({super.key});

  @override
  State<PendingWithdrawalRequests> createState() =>
      _PendingWithdrawalRequestsState();
}

class _PendingWithdrawalRequestsState extends State<PendingWithdrawalRequests> {
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
        if (!_walletProvider.pendingWithdrawPaging) {
          _walletProvider.nextPendingWithdrawPage(
              authorization: _authProvider.appAuthorization!);
        }
      }
    });
  }

  void getData() async {
    await _walletProvider.pendingWithdrawTransactions(
      authorization: _authProvider.appAuthorization!,
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
        auth: _authProvider,
        state: _walletProvider.pendingWithdrawState!,
        ctx: navigator.currentContext!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, data, child) => data.pendingWithdrawState ==
              NetworkState.waiting
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
              ),
            )
          : data.pendingWithdrawState == NetworkState.success
              ? data.pendingWithdrawEmpty
                  ? Center(
                      child: Text(
                        'لا توجد مسحوبات منتظرة',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0.sp,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => data.clearPendingWithdrawList(
                          _authProvider.appAuthorization!),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView.builder(
                            controller: _controller,
                            itemBuilder: (BuildContext context, int i) =>
                                WithdrawalRecordItem(
                              data: data.pendingWithdrawList[i],
                            ),
                            itemCount: data.pendingWithdrawList.length,
                          ),
                          AnimatedContainer(
                            color: Colors.white.withOpacity(0.8),
                            height: data.pendingWithdrawPaging ? 40.0.h : 0.0.h,
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
                    await _walletProvider.pendingWithdrawTransactions(
                      paging: false,
                      refreshing: false,
                      isFilter: true,
                    );
                  },
                ),
    );
  }
}
