import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/merchant_feedback_item.dart';
import '../Widgets/network_error_widget.dart';

class MyReviews extends StatefulWidget {
  static const String id = 'My_Feedback';

  const MyReviews({super.key});

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  late ShipmentProvider _displayShipmentProvider;
  late AuthProvider _authProvider;

  void getData() async {
    await _displayShipmentProvider.listOfMyReviews(false);
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _displayShipmentProvider.myReviewsState!);
  }

  @override
  void initState() {
    super.initState();
    _displayShipmentProvider =
        Provider.of<ShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: getData,
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
            title: const Text(
              'ملاحظات المستخدمين',
            ),
          ),
          body: Consumer<ShipmentProvider>(
            builder: (ctx, data, ch) => data.myReviewsState ==
                    NetworkState.waiting
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            weevoPrimaryOrangeColor)),
                  )
                : data.myReviewsState == NetworkState.success
                    ? data.myReviewsEmpty
                        ? const Center(
                            child: Text('لا توجد تقييمات'),
                          )
                        : ListView.builder(
                            itemBuilder: (BuildContext context, int i) =>
                                MerchantFeedbackItem(model: data.myReviews[i]),
                            itemCount: data.myReviews.length,
                          )
                    : NetworkErrorWidget(
                        onRetryCallback: getData,
                      ),
          ),
        ),
      ),
    );
  }
}
