import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/feedback_data_arg.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/merchant_feedback_item.dart';

class MerchantFeedback extends StatefulWidget {
  static const String id = 'Merchant_Feedback';
  final FeedbackDataArg arg;

  const MerchantFeedback({
    super.key,
    required this.arg,
  });

  @override
  State<MerchantFeedback> createState() => _MerchantFeedbackState();
}

class _MerchantFeedbackState extends State<MerchantFeedback> {
  late ShipmentProvider _shipmentProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
  }

  void getData() async {
    await _shipmentProvider.listOfMerchantReviews(
        merchantId: widget.arg.userId);
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _shipmentProvider.merchantReviewState!);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () {},
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
              ),
            ),
            title: Text(
              'تقييمات ${widget.arg.username}',
            ),
          ),
          body: Consumer<ShipmentProvider>(
            builder: (ctx, data, ch) => data.merchantReviewState ==
                    NetworkState.waiting
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            weevoPrimaryOrangeColor)),
                  )
                : data.merchantReviewsEmpty
                    ? Center(
                        child: Text('لا توجد تقييمات ل ${widget.arg.username}'),
                      )
                    : ListView.builder(
                        itemBuilder: (BuildContext context, int i) =>
                            MerchantFeedbackItem(
                                model: data.merchantReviews[i]),
                        itemCount: data.merchantReviews.length,
                      ),
          ),
        ),
      ),
    );
  }
}
