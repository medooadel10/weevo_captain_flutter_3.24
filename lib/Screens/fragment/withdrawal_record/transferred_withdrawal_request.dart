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

class TransferredWithdrawalRequests extends StatefulWidget {
  const TransferredWithdrawalRequests({super.key});

  @override
  State<TransferredWithdrawalRequests> createState() =>
      _TransferredWithdrawalRequestsState();
}

class _TransferredWithdrawalRequestsState
    extends State<TransferredWithdrawalRequests> {
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
        if (!_walletProvider.transferredWithdrawPaging) {
          _walletProvider.nextTransferredWithdrawPage(
            authorization: _authProvider.appAuthorization!,
          );
        }
      }
    });
  }

  void getData() async {
    await _walletProvider.transferredWithdrawTransactions(
      authorization: _authProvider.appAuthorization!,
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
        auth: _authProvider,
        state: _walletProvider.transferredWithdrawState!,
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
      builder: (context, data, child) =>
          data.transferredWithdrawState == NetworkState.waiting
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                  ),
                )
              : data.transferredWithdrawState == NetworkState.success
                  ? data.transferredWithdrawEmpty
                      ? Center(
                          child: Text(
                            'لا توجد مسحوبات محولة',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0.sp,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => data.clearTransferredWithdrawList(
                              _authProvider.appAuthorization!),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ListView.builder(
                                controller: _controller,
                                itemBuilder: (BuildContext context, int i) =>
                                    WithdrawalRecordItem(
                                  data: data.transferredWithdrawList[i],
                                ),
                                itemCount: data.transferredWithdrawList.length,
                              ),
                              AnimatedContainer(
                                color: Colors.white.withOpacity(0.8),
                                height: data.transferredWithdrawPaging
                                    ? 40.0.h
                                    : 0.0.h,
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
                        await _walletProvider.transferredWithdrawTransactions(
                          paging: false,
                          refreshing: false,
                          isFilter: true,
                        );
                      },
                    ),
    );
  }
}
