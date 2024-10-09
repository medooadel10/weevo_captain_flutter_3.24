import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/features/available_shipments/ui/screens/available_shipments_screen.dart';

import '../Dialogs/coupon_info_dialog.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/network_error_widget.dart';
import 'home.dart';
import 'shipment_details_with_more_than_one_product.dart';
import 'shipment_details_with_one_product.dart';

class ShipmentDetailsDisplay extends StatefulWidget {
  static const String id = 'BeforeConfirmation';
  final int shipmentId;

  const ShipmentDetailsDisplay({super.key, required this.shipmentId});

  @override
  State<ShipmentDetailsDisplay> createState() => _ShipmentDetailsDisplayState();
}

class _ShipmentDetailsDisplayState extends State<ShipmentDetailsDisplay> {
  late ShipmentProvider _shipmentProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _shipmentProvider = Provider.of<ShipmentProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    getData();
    initializeDateFormatting('ar_EG');
  }

  @override
  void dispose() {
    initScreen();
    super.dispose();
  }

  void initScreen() {}

  void getData() async {
    await _shipmentProvider.getShipmentById(
        id: widget.shipmentId, isFirstTime: true);
    check(
        ctx: navigator.currentContext!,
        auth: _authProvider,
        state: _shipmentProvider.shipmentByIdState!);
    if (!((_shipmentProvider.shipmentById!.status == 'available' ||
            _shipmentProvider.shipmentById!.status == 'new') ||
        _shipmentProvider.shipmentById!.coupon == null)) {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => const CouponInfoDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    ShipmentProvider shipmentProvider = Provider.of<ShipmentProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (_shipmentProvider.fromNewShipment &&
            _shipmentProvider.shipmentById!.parentId == 0) {
          _shipmentProvider.setFromNewShipment(false);
          _shipmentProvider.setAvailableShipmentIndex(
              _shipmentProvider.availableShipmentIndex);
          MagicRouter.navigateAndPop(const AvailableShipmentsScreen());
        } else if (_authProvider.fromOutsideNotification) {
          _authProvider.setFromOutsideNotification(false);
          Navigator.pushReplacementNamed(context, Home.id);
        } else {
          if (shipmentProvider.shipmentById!.parentId! > 0) {
            shipmentProvider.getBulkShipmentById(
                id: shipmentProvider.shipmentById!.parentId!,
                isFirstTime: false);
          }
          MagicRouter.pop();
        }
        return false;
      },
      child: Scaffold(
        body: ConnectivityWidget(
          callback: () {},
          child: Consumer<ShipmentProvider>(
            builder: (context, data, child) =>
                data.shipmentByIdState == NetworkState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              weevoPrimaryOrangeColor),
                        ),
                      )
                    : data.shipmentByIdState == NetworkState.success
                        ? data.shipmentById!.products!.length > 1
                            ? ShipmentDetailsWithMoreThanOneProduct(
                                shipmentId: widget.shipmentId)
                            : ShipmentDetailsWithOneProduct(
                                shipmentId: widget.shipmentId)
                        : data.isAvailableShipment
                            ? NetworkErrorWidget(
                                onRetryCallback: () async {
                                  await _shipmentProvider.getShipmentById(
                                      id: widget.shipmentId,
                                      isFirstTime: false);
                                },
                              )
                            : NetworkErrorWidget(
                                onRetryCallback: () async {
                                  await _shipmentProvider.getShipmentById(
                                      id: widget.shipmentId,
                                      isFirstTime: false);
                                },
                              ),
          ),
        ),
      ),
    );
  }
}
