import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_captain_app/features/shipment_details/logic/cubit/shipment_details_cubit.dart';

import '../Dialogs/Loading.dart' as loading;
import '../Dialogs/action_dialog.dart';
import '../Dialogs/cancel_shipment_dialog.dart';
import '../Dialogs/courier_to_customer_qr_code_dialog.dart';
import '../Dialogs/done_dialog.dart';
import '../Dialogs/merchant_to_courier_qr_code_dialog.dart';
import '../Dialogs/qr_dialog_code.dart';
import '../Dialogs/rating_dialog.dart';
import '../Dialogs/tracking_dialog.dart';
import '../Dialogs/wallet_dialog.dart';
import '../Models/chat_data.dart';
import '../Models/refresh_qr_code.dart';
import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/connectivity_widget.dart';
import '../core/helpers/spacing.dart';
import '../core/helpers/toasts.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../main.dart';
import 'home.dart';

class HandleShipment extends StatefulWidget {
  static const String id = 'Handle_shipment';
  final ShipmentTrackingModel model;

  const HandleShipment({
    super.key,
    required this.model,
  });

  @override
  State<HandleShipment> createState() => _HandleShipmentState();
}

class _HandleShipmentState extends State<HandleShipment> {
  final pref = Preferences.instance;
  double _currentLat = 0.0, _currentLong = 0.0;
  StreamSubscription<LocationData>? _streamSubscription;
  late AuthProvider _authProvider;
  String? _locationId;
  String? _currentStatus;
  bool isFirstTime = true;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    if (widget.model.merchantNationalId.hashCode >=
        widget.model.courierNationalId.hashCode) {
      _locationId =
          '${widget.model.merchantNationalId}-${widget.model.courierNationalId}-${widget.model.shipmentId}';
    } else {
      _locationId =
          '${widget.model.courierNationalId}-${widget.model.merchantNationalId}-${widget.model.shipmentId}';
    }

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _currentLat = _authProvider.locationData?.latitude ?? 0.0;
    _currentLong = _authProvider.locationData?.longitude ?? 0.0;
    getInit();
  }

  void getInit() async {
    log('locationId -> $_locationId');
    log('status -> ${{widget.model.status}}');
    switch (widget.model.status) {
      case 'courier-applied-to-shipment':
      case 'merchant-accepted-shipping-offer':
        _currentStatus = '';
      case 'on-the-way-to-get-shipment-from-merchant':
        _currentStatus = 'inMyWay';
      case 'on-delivery':
        _currentStatus = 'receivedShipment';
      default:
        _currentStatus = 'closed';
    }
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('locations')
        .doc(_locationId)
        .set({
      'status': _currentStatus,
    });
    setState(() {
      isLoading = false;
    });
    log('currentStatus11 -> $_currentStatus');
    FirebaseFirestore.instance
        .collection('locations')
        .doc(_locationId)
        .snapshots()
        .listen((event) {
      log('event -> ${event.data()}');
      if (event.exists) {
        if (mounted) {
          if (isFirstTime) {
            isFirstTime = false;
          } else {
            setState(() {
              _currentStatus = event['status'];
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _currentStatus = '';
          });
        }
      }
    }).onError((error) {
      if (mounted) {
        setState(() {
          _currentStatus = '';
        });
      }
    });
    if (_currentStatus == 'inMyWay') {
      _streamSubscription = _authProvider.location!.onLocationChanged
          .listen((LocationData data) async {
        if (mounted) {
          setState(() {
            _currentLat = data.latitude!;
            _currentLong = data.longitude!;
          });
        }
      });
      send100MilesNotification();
    }
  }

  void send100MilesNotification() async {
    if (Geolocator.distanceBetween(
            _currentLat,
            _currentLong,
            double.parse(widget.model.deliveringLat!),
            double.parse(widget.model.deliveringLng!)) <=
        100.0) {
      DocumentSnapshot userToken = await FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(widget.model.merchantId.toString())
          .get();
      String token = userToken['fcmToken'];
      FirebaseFirestore.instance
          .collection('merchant_notifications')
          .doc(widget.model.merchantId.toString())
          .collection(widget.model.merchantId.toString())
          .add({
        'read': false,
        'date_time': DateTime.now().toIso8601String(),
        'type': 'tracking',
        'title': 'الطلب في الطريق اليك',
        'body':
            'الكابتن ${_authProvider.name} في الطريق اليك يرجي التواجد بالمكان',
        'user_icon': _authProvider.photo!.isNotEmpty
            ? _authProvider.photo!.contains(ApiConstants.baseUrl)
                ? _authProvider.photo
                : '${ApiConstants.baseUrl}${_authProvider.photo}'
            : '',
        'screen_to': 'handle_shipment_screen',
        'data': ShipmentTrackingModel(
                shipmentId: widget.model.shipmentId,
                deliveringState: widget.model.deliveringState,
                deliveringCity: widget.model.deliveringCity,
                receivingState: widget.model.receivingState,
                receivingCity: widget.model.receivingCity,
                deliveringLat: widget.model.deliveringLat,
                deliveringLng: widget.model.deliveringLng,
                receivingLat: widget.model.receivingLat,
                receivingLng: widget.model.receivingLng,
                fromLat: 31.000000,
                fromLng: 31.000000,
                hasChildren: widget.model.hasChildren,
                merchantId: widget.model.merchantId,
                courierId: widget.model.courierId,
                paymentMethod: widget.model.paymentMethod,
                merchantImage: widget.model.merchantImage,
                courierImage: widget.model.courierImage,
                merchantName: widget.model.merchantName,
                courierName: widget.model.courierName,
                merchantPhone: widget.model.merchantPhone,
                clientPhone: widget.model.courierPhone,
                status: widget.model.status,
                courierNationalId: widget.model.courierNationalId,
                merchantNationalId: widget.model.merchantNationalId,
                courierPhone: widget.model.courierPhone,
                locationIdStatus: _currentStatus)
            .toJson(),
      });
      _authProvider.sendNotification(
          title: 'الطلب في الطريق اليك',
          body:
              'الكابتن ${_authProvider.name} في الطريق اليك يرجي التواجد بالمكان',
          toToken: token,
          image: _authProvider.photo!.isNotEmpty
              ? _authProvider.photo!.contains(ApiConstants.baseUrl)
                  ? _authProvider.photo
                  : '${ApiConstants.baseUrl}${_authProvider.photo}'
              : '',
          type: 'tracking',
          screenTo: 'handle_shipment_screen',
          data: ShipmentTrackingModel(
                  shipmentId: widget.model.shipmentId,
                  deliveringState: widget.model.deliveringState,
                  deliveringCity: widget.model.deliveringCity,
                  receivingState: widget.model.receivingState,
                  receivingCity: widget.model.receivingCity,
                  deliveringLat: widget.model.deliveringLat,
                  deliveringLng: widget.model.deliveringLng,
                  receivingLng: widget.model.receivingLng,
                  receivingLat: widget.model.receivingLat,
                  fromLat: 31.000000,
                  fromLng: 31.000000,
                  courierNationalId: widget.model.courierNationalId,
                  merchantNationalId: widget.model.merchantNationalId,
                  hasChildren: widget.model.hasChildren,
                  merchantId: widget.model.merchantId,
                  courierId: widget.model.courierId,
                  paymentMethod: widget.model.paymentMethod,
                  merchantImage: widget.model.merchantImage,
                  courierImage: widget.model.courierImage,
                  merchantName: widget.model.merchantName,
                  courierName: widget.model.courierName,
                  merchantPhone: widget.model.merchantPhone,
                  clientPhone: widget.model.courierPhone,
                  status: widget.model.status,
                  courierPhone: widget.model.courierPhone,
                  locationIdStatus: _currentStatus)
              .toJson());
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('currentStatus12 -> $_currentStatus');
    log('locationId -> $_locationId');

    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final ShipmentTrackingProvider trackingProvider =
        Provider.of<ShipmentTrackingProvider>(context);
    final ShipmentDetailsCubit cubit = context.read<ShipmentDetailsCubit>();
    ShipmentProvider shipmentProvider = Provider.of<ShipmentProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        if (authProvider.fromOutsideNotification) {
          authProvider.setFromOutsideNotification(false);
          Navigator.pushReplacementNamed(
            context,
            Home.id,
          );
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: ConnectivityWidget(
        callback: () {},
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              title: Text(
                'طلب رقم ${widget.model.shipmentId}',
              ),
            ),
            body: Column(

              children: [
                _currentStatus == 'receivingShipment'
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text(
                              'برجاء الضغط على الزر الأزرق لإدخال الكود\n وبعد التحقق سيتم إستلام الطلب من المرسل',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            verticalSpace(10),
                            FloatingActionButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (ctx) =>
                                        MerchantToCourierQrCodeScanner(
                                            parentContext: context,
                                            model: widget.model,
                                            locationId: _locationId!));
                              },
                              backgroundColor: weevoPrimaryBlueColor,
                              child: const Icon(
                                Icons.qr_code,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _currentStatus == 'handingOverShipmentToCustomer' &&
                            widget.model.paymentMethod == 'online'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text(
                                                'برجاء الضغط علي الزر الأزرق لارسال رمز\nال qrcode للمرسل لتأكيد تسليم الطلب للمرسل',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0,
                                                    color: Colors.black),
                                                textAlign: TextAlign.center,
                                              ),
                                              verticalSpace(10),
                                FloatingActionButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: navigator.currentContext!,
                                        barrierDismissible: false,
                                        builder: (ctx) =>
                                            CourierToCustomerQrCodeScanner(
                                                parentContext: context,
                                                model: widget.model,
                                                locationId: _locationId!));
                                  },
                                  backgroundColor: weevoPrimaryBlueColor,
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _currentStatus ==
                                'handingOverReturnedShipmentToMerchant'
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    if (cubit.shipmentDetails!
                                                .handoverCodeCourierToMerchant ==
                                            null &&
                                        cubit.shipmentDetails!
                                                .handoverQrcodeCourierToMerchant ==
                                            null) {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const loading.Loading());
                                      await trackingProvider
                                          .refreshHandoverQrcodeCourierToMerchant(
                                              widget.model.shipmentId!);
                                      check(
                                          auth: authProvider,
                                          state: trackingProvider.state!,
                                          ctx: navigator.currentContext!);
                                      if (trackingProvider.state ==
                                          NetworkState.success) {
                                        Navigator.pop(
                                            navigator.currentContext!);
                                        showDialog(
                                          context: navigator.currentContext!,
                                          builder: (context) => QrCodeDialog(
                                              data: trackingProvider
                                                  .refreshQrCode!),
                                        );
                                      } else {
                                        Navigator.pop(
                                            navigator.currentContext!);
                                        showDialog(
                                          context: navigator.currentContext!,
                                          builder: (context) => WalletDialog(
                                            msg:
                                                'حدث خطأ برجاء المحاولة مرة اخري',
                                            onPress: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => QrCodeDialog(
                                            data: RefreshQrcode(
                                                filename: cubit.shipmentDetails!
                                                    .handoverQrcodeCourierToMerchant!
                                                    .split('/')
                                                    .last,
                                                path: cubit.shipmentDetails!
                                                    .handoverQrcodeCourierToMerchant!,
                                                code: int.parse(cubit
                                                    .shipmentDetails!
                                                    .handoverCodeCourierToMerchant!))),
                                      );
                                    }
                                  },
                                  backgroundColor: weevoPrimaryBlueColor,
                                  child: const Icon(
                                    Icons.qr_code,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : Container(),
                const SizedBox(
                  height: 4.0,
                ),
                TrackingDialog(
                  isLoading: isLoading,
                  status: _currentStatus,
                  onCLientPhoneCallback: () async {
                    await launchUrlString('tel:${widget.model.clientPhone}');
                  },
                  onCancelShipmentCallback: () async {
                    if (await authProvider.checkConnection()) {
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (ctx) => ActionDialog(
                          content: 'هل تود إلغاء الشحن',
                          cancelAction: 'لا',
                          approveAction: 'نعم',
                          onApproveClick: () async {
                            Navigator.pop(context);
                            await cancelShippingCallback(
                                widget.model, shipmentProvider, authProvider);
                          },
                          onCancelClick: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    } else {
                      showDialog(
                        context: navigator.currentContext!,
                        builder: (ctx) => ActionDialog(
                          content: 'تأكد من الاتصال بشبكة الانترنت',
                          cancelAction: 'حسناً',
                          approveAction: 'حاول مرة اخري',
                          onApproveClick: () async {
                            Navigator.pop(context);
                            await cancelShippingCallback(
                                widget.model, shipmentProvider, authProvider);
                          },
                          onCancelClick: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  },
                  onMyWayCallback: () async {
                    onMyWayCheckConnection(authProvider, trackingProvider);
                    if (Geolocator.distanceBetween(
                            _currentLat,
                            _currentLong,
                            double.parse(widget.model.receivingLat!),
                            double.parse(widget.model.receivingLng!)) <=
                        100.0) {
                      DocumentSnapshot userToken = await FirebaseFirestore
                          .instance
                          .collection('merchant_users')
                          .doc(widget.model.merchantId.toString())
                          .get();
                      String token = userToken['fcmToken'];
                      FirebaseFirestore.instance
                          .collection('merchant_notifications')
                          .doc(widget.model.merchantId.toString())
                          .collection(widget.model.merchantId.toString())
                          .add({
                        'read': false,
                        'date_time': DateTime.now().toIso8601String(),
                        'type': 'tracking',
                        'title': 'الكابتن في الطريق',
                        'body':
                            'جهز طلبك الكابتن ${authProvider.name} في الطريق اليك',
                        'user_icon': _authProvider.photo!.isNotEmpty
                            ? _authProvider.photo!
                                    .contains(ApiConstants.baseUrl)
                                ? _authProvider.photo
                                : '${ApiConstants.baseUrl}${_authProvider.photo}'
                            : '',
                        'screen_to': 'handle_shipment_screen',
                        'data': ShipmentTrackingModel(
                                shipmentId: widget.model.shipmentId,
                                deliveringState: widget.model.deliveringState,
                                deliveringCity: widget.model.deliveringCity,
                                receivingState: widget.model.receivingState,
                                receivingCity: widget.model.receivingCity,
                                deliveringLat: widget.model.deliveringLat,
                                deliveringLng: widget.model.deliveringLng,
                                receivingLat: widget.model.receivingLat,
                                receivingLng: widget.model.receivingLng,
                                fromLat: 31.000000,
                                fromLng: 31.000000,
                                hasChildren: widget.model.hasChildren,
                                merchantId: widget.model.merchantId,
                                courierId: widget.model.courierId,
                                paymentMethod: widget.model.paymentMethod,
                                merchantImage: widget.model.merchantImage,
                                courierImage: widget.model.courierImage,
                                merchantName: widget.model.merchantName,
                                courierName: widget.model.courierName,
                                merchantPhone: widget.model.merchantPhone,
                                clientPhone: widget.model.courierPhone,
                                courierNationalId:
                                    widget.model.courierNationalId,
                                merchantNationalId:
                                    widget.model.merchantNationalId,
                                status: widget.model.status,
                                courierPhone: widget.model.courierPhone,
                                locationIdStatus: _currentStatus)
                            .toJson(),
                      });
                      _authProvider.sendNotification(
                          title: 'الكابتن في الطريق',
                          body:
                              'جهز طلبك الكابتن ${authProvider.name} في الطريق اليك',
                          toToken: token,
                          image: _authProvider.photo!.isNotEmpty
                              ? _authProvider.photo!
                                      .contains(ApiConstants.baseUrl)
                                  ? _authProvider.photo
                                  : '${ApiConstants.baseUrl}${_authProvider.photo}'
                              : '',
                          type: 'tracking',
                          screenTo: 'handle_shipment_screen',
                          data: ShipmentTrackingModel(
                                  shipmentId: widget.model.shipmentId,
                                  deliveringState: widget.model.deliveringState,
                                  deliveringCity: widget.model.deliveringCity,
                                  receivingState: widget.model.receivingState,
                                  receivingCity: widget.model.receivingCity,
                                  deliveringLat: widget.model.deliveringLat,
                                  deliveringLng: widget.model.deliveringLng,
                                  receivingLat: widget.model.receivingLat,
                                  receivingLng: widget.model.receivingLng,
                                  courierNationalId:
                                      widget.model.courierNationalId,
                                  merchantNationalId:
                                      widget.model.merchantNationalId,
                                  fromLat: 31.000000,
                                  fromLng: 31.000000,
                                  hasChildren: widget.model.hasChildren,
                                  merchantId: widget.model.merchantId,
                                  courierId: widget.model.courierId,
                                  paymentMethod: widget.model.paymentMethod,
                                  merchantImage: widget.model.merchantImage,
                                  courierImage: widget.model.courierImage,
                                  merchantName: widget.model.merchantName,
                                  courierName: widget.model.courierName,
                                  merchantPhone: widget.model.merchantPhone,
                                  clientPhone: widget.model.courierPhone,
                                  status: widget.model.status,
                                  courierPhone: widget.model.courierPhone,
                                  locationIdStatus: _currentStatus)
                              .toJson());
                    }
                  },
                  onArrivedCallback: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DoneDialog(
                          callback: () async {
                            MagicRouter.pop();
                          },
                          content: 'قم بإستلام الطلب',
                        );
                      },
                    );
                    setState(() {
                      isLoading = true;
                    });
                    DocumentSnapshot userToken = await FirebaseFirestore
                        .instance
                        .collection('merchant_users')
                        .doc(widget.model.merchantId.toString())
                        .get();
                    String token = userToken['fcmToken'];
                    FirebaseFirestore.instance
                        .collection('merchant_notifications')
                        .doc(widget.model.merchantId.toString())
                        .collection(widget.model.merchantId.toString())
                        .add({
                      'read': false,
                      'date_time': DateTime.now().toIso8601String(),
                      'type': 'tracking',
                      'title': 'الكابتن وصل',
                      'body':
                          'الكابتن ${_authProvider.name} وصل يرجي التواجد بالمكان لتسليم الطلب',
                      'user_icon': _authProvider.photo!.isNotEmpty
                          ? _authProvider.photo!.contains(ApiConstants.baseUrl)
                              ? _authProvider.photo
                              : '${ApiConstants.baseUrl}${_authProvider.photo}'
                          : '',
                      'screen_to': 'handle_shipment_screen',
                      'data': ShipmentTrackingModel(
                              shipmentId: widget.model.shipmentId,
                              deliveringState: widget.model.deliveringState,
                              deliveringCity: widget.model.deliveringCity,
                              receivingState: widget.model.receivingState,
                              receivingCity: widget.model.receivingCity,
                              deliveringLat: widget.model.deliveringLat,
                              deliveringLng: widget.model.deliveringLng,
                              receivingLat: widget.model.receivingLat,
                              receivingLng: widget.model.receivingLng,
                              fromLat: 31.000000,
                              fromLng: 31.000000,
                              hasChildren: widget.model.hasChildren,
                              merchantId: widget.model.merchantId,
                              courierId: widget.model.courierId,
                              paymentMethod: widget.model.paymentMethod,
                              merchantImage: widget.model.merchantImage,
                              courierImage: widget.model.courierImage,
                              merchantName: widget.model.merchantName,
                              courierName: widget.model.courierName,
                              merchantPhone: widget.model.merchantPhone,
                              clientPhone: widget.model.courierPhone,
                              courierNationalId: widget.model.courierNationalId,
                              merchantNationalId:
                                  widget.model.merchantNationalId,
                              status: widget.model.status,
                              courierPhone: widget.model.courierPhone,
                              locationIdStatus: _currentStatus)
                          .toJson(),
                    });
                    _authProvider.sendNotification(
                        title: 'الكابتن وصل',
                        body:
                            'الكابتن ${_authProvider.name} وصل يرجي التواجد بالمكان لتسليم الطلب',
                        toToken: token,
                        image: _authProvider.photo!.isNotEmpty
                            ? _authProvider.photo!
                                    .contains(ApiConstants.baseUrl)
                                ? _authProvider.photo
                                : '${ApiConstants.baseUrl}${_authProvider.photo}'
                            : '',
                        screenTo: 'handle_shipment_screen',
                        type: 'tracking',
                        data: ShipmentTrackingModel(
                                shipmentId: widget.model.shipmentId,
                                deliveringState: widget.model.deliveringState,
                                deliveringCity: widget.model.deliveringCity,
                                receivingState: widget.model.receivingState,
                                receivingCity: widget.model.receivingCity,
                                deliveringLat: widget.model.deliveringLat,
                                deliveringLng: widget.model.deliveringLng,
                                receivingLat: widget.model.receivingLat,
                                receivingLng: widget.model.receivingLng,
                                fromLat: 31.000000,
                                fromLng: 31.000000,
                                hasChildren: widget.model.hasChildren,
                                merchantId: widget.model.merchantId,
                                courierId: widget.model.courierId,
                                courierNationalId:
                                    widget.model.courierNationalId,
                                merchantNationalId:
                                    widget.model.merchantNationalId,
                                paymentMethod: widget.model.paymentMethod,
                                merchantImage: widget.model.merchantImage,
                                courierImage: widget.model.courierImage,
                                merchantName: widget.model.merchantName,
                                courierName: widget.model.courierName,
                                merchantPhone: widget.model.merchantPhone,
                                clientPhone: widget.model.courierPhone,
                                status: widget.model.status,
                                courierPhone: widget.model.courierPhone,
                                locationIdStatus: _currentStatus)
                            .toJson());
                    await FirebaseFirestore.instance
                        .collection('locations')
                        .doc(_locationId)
                        .set({
                      'status': 'arrived',
                      'shipmentId': widget.model.shipmentId,
                    });
                    setState(() {
                      isLoading = false;
                    });
                    _streamSubscription?.cancel();
                  },
                  onReturnShipmentCallback: () async {
                    showDialog(
                      context: navigator.currentContext!,
                      builder: (ctx) => ActionDialog(
                        content: 'هل تود إسترجاع الطلب',
                        cancelAction: 'لا',
                        approveAction: 'نعم',
                        onApproveClick: () async {
                          MagicRouter.pop();
                          setState(() {
                            isLoading = true;
                          });
                          sendCurrentLocation(
                              authProvider, widget.model, _locationId!);
                          DocumentSnapshot userToken = await FirebaseFirestore
                              .instance
                              .collection('merchant_users')
                              .doc(widget.model.merchantId.toString())
                              .get();
                          String token = userToken['fcmToken'];
                          FirebaseFirestore.instance
                              .collection('merchant_notifications')
                              .doc(widget.model.merchantId.toString())
                              .collection(widget.model.merchantId.toString())
                              .add({
                            'read': false,
                            'date_time': DateTime.now().toIso8601String(),
                            'type': 'tracking',
                            'title': 'الطلب مرتجع الكابتن في الطريق اليك',
                            'body':
                                'الكابتن ${_authProvider.name} في الطريق لاعادة الطلب اليك يرجي التواجد بالمكان',
                            'user_icon': _authProvider.photo!.isNotEmpty
                                ? _authProvider.photo!
                                        .contains(ApiConstants.baseUrl)
                                    ? _authProvider.photo
                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                : '',
                            'screen_to': 'handle_shipment_screen',
                            'data': ShipmentTrackingModel(
                                    shipmentId: widget.model.shipmentId,
                                    deliveringState:
                                        widget.model.deliveringState,
                                    deliveringCity: widget.model.deliveringCity,
                                    receivingState: widget.model.receivingState,
                                    receivingCity: widget.model.receivingCity,
                                    deliveringLat: widget.model.deliveringLat,
                                    deliveringLng: widget.model.deliveringLng,
                                    fromLat: 31.000000,
                                    fromLng: 31.000000,
                                    hasChildren: widget.model.hasChildren,
                                    merchantId: widget.model.merchantId,
                                    courierId: widget.model.courierId,
                                    paymentMethod: widget.model.paymentMethod,
                                    merchantImage: widget.model.merchantImage,
                                    courierImage: widget.model.courierImage,
                                    merchantName: widget.model.merchantName,
                                    courierName: widget.model.courierName,
                                    merchantPhone: widget.model.merchantPhone,
                                    clientPhone: widget.model.courierPhone,
                                    courierNationalId:
                                        widget.model.courierNationalId,
                                    merchantNationalId:
                                        widget.model.merchantNationalId,
                                    status: widget.model.status,
                                    courierPhone: widget.model.courierPhone,
                                    locationIdStatus: _currentStatus)
                                .toJson(),
                          });
                          _authProvider.sendNotification(
                              title: 'الطلب مرتجع الكابتن في الطريق اليك',
                              body:
                                  'الكابتن ${_authProvider.name} في الطريق لاعادة الطلب اليك يرجي التواجد بالمكان',
                              toToken: token,
                              image: _authProvider.photo!.isNotEmpty
                                  ? _authProvider.photo!
                                          .contains(ApiConstants.baseUrl)
                                      ? _authProvider.photo
                                      : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                  : '',
                              screenTo: 'handle_shipment_screen',
                              type: 'tracking',
                              data: ShipmentTrackingModel(
                                      shipmentId: widget.model.shipmentId,
                                      deliveringState:
                                          widget.model.deliveringState,
                                      deliveringCity:
                                          widget.model.deliveringCity,
                                      receivingState:
                                          widget.model.receivingState,
                                      receivingCity: widget.model.receivingCity,
                                      deliveringLat: widget.model.deliveringLat,
                                      deliveringLng: widget.model.deliveringLng,
                                      fromLat: 31.000000,
                                      fromLng: 31.000000,
                                      hasChildren: widget.model.hasChildren,
                                      merchantId: widget.model.merchantId,
                                      courierId: widget.model.courierId,
                                      paymentMethod: widget.model.paymentMethod,
                                      merchantImage: widget.model.merchantImage,
                                      courierNationalId:
                                          widget.model.courierNationalId,
                                      merchantNationalId:
                                          widget.model.merchantNationalId,
                                      courierImage: widget.model.courierImage,
                                      merchantName: widget.model.merchantName,
                                      courierName: widget.model.courierName,
                                      merchantPhone: widget.model.merchantPhone,
                                      clientPhone: widget.model.courierPhone,
                                      status: widget.model.status,
                                      courierPhone: widget.model.courierPhone,
                                      locationIdStatus: _currentStatus)
                                  .toJson());
                          await FirebaseFirestore.instance
                              .collection('locations')
                              .doc(_locationId)
                              .set({
                            'status': 'returnShipment',
                            'shipmentId': widget.model.shipmentId,
                          });
                          setState(() {
                            isLoading = true;
                          });
                        },
                        onCancelClick: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  onReceivingShipmentCallback: _currentStatus == 'arrived' ||
                          _currentStatus == 'receivingShipment'
                      ? () async {
                          setState(() {
                            isLoading = true;
                          });
                          DocumentSnapshot userToken = await FirebaseFirestore
                              .instance
                              .collection('merchant_users')
                              .doc(widget.model.merchantId.toString())
                              .get();
                          String token = userToken['fcmToken'];
                          FirebaseFirestore.instance
                              .collection('merchant_notifications')
                              .doc(widget.model.merchantId.toString())
                              .collection(widget.model.merchantId.toString())
                              .add({
                            'read': false,
                            'date_time': DateTime.now().toIso8601String(),
                            'type': 'tracking',
                            'title': 'الكابتن يريد استلام الطلب',
                            'body':
                                'الكابتن ${_authProvider.name} يريد استلام الطلب',
                            'user_icon': _authProvider.photo!.isNotEmpty
                                ? _authProvider.photo!
                                        .contains(ApiConstants.baseUrl)
                                    ? _authProvider.photo
                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                : '',
                            'screen_to': 'handle_shipment_screen',
                            'data': ShipmentTrackingModel(
                                    shipmentId: widget.model.shipmentId,
                                    deliveringState:
                                        widget.model.deliveringState,
                                    deliveringCity: widget.model.deliveringCity,
                                    receivingState: widget.model.receivingState,
                                    receivingCity: widget.model.receivingCity,
                                    deliveringLat: widget.model.deliveringLat,
                                    deliveringLng: widget.model.deliveringLng,
                                    receivingLat: widget.model.receivingLat,
                                    receivingLng: widget.model.receivingLng,
                                    fromLat: 31.000000,
                                    fromLng: 31.000000,
                                    hasChildren: widget.model.hasChildren,
                                    merchantId: widget.model.merchantId,
                                    courierId: widget.model.courierId,
                                    paymentMethod: widget.model.paymentMethod,
                                    merchantImage: widget.model.merchantImage,
                                    courierImage: widget.model.courierImage,
                                    merchantName: widget.model.merchantName,
                                    courierName: widget.model.courierName,
                                    merchantPhone: widget.model.merchantPhone,
                                    clientPhone: widget.model.courierPhone,
                                    courierNationalId:
                                        widget.model.courierNationalId,
                                    merchantNationalId:
                                        widget.model.merchantNationalId,
                                    status: widget.model.status,
                                    courierPhone: widget.model.courierPhone,
                                    locationIdStatus: _currentStatus)
                                .toJson(),
                          });
                          _authProvider.sendNotification(
                              title: 'الكابتن يريد استلام الطلب',
                              body:
                                  'الكابتن ${_authProvider.name} يريد استلام الطلب',
                              toToken: token,
                              image: _authProvider.photo!.isNotEmpty
                                  ? _authProvider.photo!
                                          .contains(ApiConstants.baseUrl)
                                      ? _authProvider.photo
                                      : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                  : '',
                              screenTo: 'handle_shipment_screen',
                              type: 'tracking',
                              data: ShipmentTrackingModel(
                                      shipmentId: widget.model.shipmentId,
                                      deliveringState:
                                          widget.model.deliveringState,
                                      deliveringCity:
                                          widget.model.deliveringCity,
                                      receivingState:
                                          widget.model.receivingState,
                                      receivingCity: widget.model.receivingCity,
                                      deliveringLat: widget.model.deliveringLat,
                                      deliveringLng: widget.model.deliveringLng,
                                      receivingLat: widget.model.receivingLat,
                                      receivingLng: widget.model.receivingLng,
                                      fromLat: 31.0000,
                                      fromLng: 31.0000,
                                      hasChildren: widget.model.hasChildren,
                                      merchantId: widget.model.merchantId,
                                      courierId: widget.model.courierId,
                                      courierNationalId:
                                          widget.model.courierNationalId,
                                      merchantNationalId:
                                          widget.model.merchantNationalId,
                                      paymentMethod: widget.model.paymentMethod,
                                      merchantImage: widget.model.merchantImage,
                                      courierImage: widget.model.courierImage,
                                      merchantName: widget.model.merchantName,
                                      courierName: widget.model.courierName,
                                      merchantPhone: widget.model.merchantPhone,
                                      clientPhone: widget.model.courierPhone,
                                      status: widget.model.status,
                                      courierPhone: widget.model.courierPhone,
                                      locationIdStatus: _currentStatus)
                                  .toJson());
                          await FirebaseFirestore.instance
                              .collection('locations')
                              .doc(_locationId)
                              .set({
                            'status': 'receivingShipment',
                            'shipmentId': widget.model.shipmentId,
                          });
                          setState(() {
                            isLoading = false;
                          });
                          showDialog(
                              context: navigator.currentContext!,
                              builder: (ctx) => MerchantToCourierQrCodeScanner(
                                  parentContext: context,
                                  model: widget.model,
                                  locationId: _locationId!));
                        }
                      : () {
                          showToast(
                            'يجب عليك الضغط على الزر وصلت أولاً',
                          );
                        },
                  onMerchantLocation: () async {
                    log('Location callback -> ${widget.model.deliveringLat},${widget.model.deliveringLng}');
                    String url =
                        "google.navigation:q=${widget.model.receivingLat},${widget.model.receivingLng}";
                    await launchUrlString(url);
                  },
                  onClientLocationCallback: () async {
                    log('Location callback -> ${widget.model.deliveringLat},${widget.model.deliveringLng}');
                    String url =
                        "google.navigation:q=${widget.model.receivingLat},${widget.model.receivingLng}";
                    await launchUrlString(url);
                  },
                  onHandOverShipmentCallback: () async {
                    showDialog(
                        context: context,
                        builder: (ctx) => ActionDialog(
                              content: 'هل تود تسليم الطلب ؟',
                              onApproveClick: () async {
                                MagicRouter.pop();
                                setState(() {
                                  isLoading = true;
                                });
                                DocumentSnapshot userToken =
                                    await FirebaseFirestore.instance
                                        .collection('merchant_users')
                                        .doc(widget.model.merchantId.toString())
                                        .get();
                                String token = userToken['fcmToken'];
                                FirebaseFirestore.instance
                                    .collection('merchant_notifications')
                                    .doc(widget.model.merchantId.toString())
                                    .collection(
                                        widget.model.merchantId.toString())
                                    .add({
                                  'read': false,
                                  'date_time': DateTime.now().toIso8601String(),
                                  'type': 'tracking',
                                  'title': 'الكابتن وصل لمكان التسليم',
                                  'body':
                                      'الكابتن ${_authProvider.name} وصل لتسليم الطلب يرجي التأكد من ارسال صورة ال qrcode لأتمام عملية التسليم',
                                  'user_icon': _authProvider.photo!.isNotEmpty
                                      ? _authProvider.photo!
                                              .contains(ApiConstants.baseUrl)
                                          ? _authProvider.photo
                                          : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                      : '',
                                  'screen_to': 'handle_shipment_screen',
                                  'data': ShipmentTrackingModel(
                                          shipmentId: widget.model.shipmentId,
                                          deliveringState:
                                              widget.model.deliveringState,
                                          deliveringCity:
                                              widget.model.deliveringCity,
                                          receivingState:
                                              widget.model.receivingState,
                                          receivingCity:
                                              widget.model.receivingCity,
                                          deliveringLat:
                                              widget.model.deliveringLat,
                                          deliveringLng:
                                              widget.model.deliveringLng,
                                          receivingLat:
                                              widget.model.receivingLat,
                                          receivingLng:
                                              widget.model.receivingLng,
                                          fromLat: 31.0000,
                                          fromLng: 31.0000,
                                          hasChildren: widget.model.hasChildren,
                                          merchantId: widget.model.merchantId,
                                          courierId: widget.model.courierId,
                                          paymentMethod:
                                              widget.model.paymentMethod,
                                          merchantImage:
                                              widget.model.merchantImage,
                                          courierImage:
                                              widget.model.courierImage,
                                          merchantName:
                                              widget.model.merchantName,
                                          courierName: widget.model.courierName,
                                          merchantPhone:
                                              widget.model.merchantPhone,
                                          clientPhone:
                                              widget.model.courierPhone,
                                          courierNationalId:
                                              widget.model.courierNationalId,
                                          merchantNationalId:
                                              widget.model.merchantNationalId,
                                          status: widget.model.status,
                                          courierPhone:
                                              widget.model.courierPhone,
                                          locationIdStatus: _currentStatus)
                                      .toJson(),
                                });
                                _authProvider.sendNotification(
                                    title: 'الكابتن وصل لمكان التسليم',
                                    body:
                                        'الكابتن ${_authProvider.name} وصل لتسليم الطلب يرجي التأكد من ارسال صورة ال qrcode لأتمام عملية التسليم',
                                    toToken: token,
                                    image: _authProvider.photo!.isNotEmpty
                                        ? _authProvider.photo!
                                                .contains(ApiConstants.baseUrl)
                                            ? _authProvider.photo
                                            : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                        : '',
                                    screenTo: 'handle_shipment_screen',
                                    type: 'tracking',
                                    data: ShipmentTrackingModel(
                                            shipmentId: widget.model.shipmentId,
                                            deliveringState:
                                                widget.model.deliveringState,
                                            deliveringCity:
                                                widget.model.deliveringCity,
                                            receivingState:
                                                widget.model.receivingState,
                                            receivingCity:
                                                widget.model.receivingCity,
                                            deliveringLat:
                                                widget.model.deliveringLat,
                                            deliveringLng:
                                                widget.model.deliveringLng,
                                            receivingLat:
                                                widget.model.receivingLat,
                                            receivingLng:
                                                widget.model.receivingLng,
                                            courierNationalId:
                                                widget.model.courierNationalId,
                                            merchantNationalId:
                                                widget.model.merchantNationalId,
                                            fromLat: 31.0000,
                                            fromLng: 31.0000,
                                            hasChildren:
                                                widget.model.hasChildren,
                                            merchantId: widget.model.merchantId,
                                            courierId: widget.model.courierId,
                                            paymentMethod:
                                                widget.model.paymentMethod,
                                            merchantImage:
                                                widget.model.merchantImage,
                                            courierImage:
                                                widget.model.courierImage,
                                            merchantName:
                                                widget.model.merchantName,
                                            courierName:
                                                widget.model.courierName,
                                            merchantPhone:
                                                widget.model.merchantPhone,
                                            clientPhone:
                                                widget.model.courierPhone,
                                            status: widget.model.status,
                                            courierPhone:
                                                widget.model.courierPhone,
                                            locationIdStatus: _currentStatus)
                                        .toJson());
                                await FirebaseFirestore.instance
                                    .collection('locations')
                                    .doc(_locationId)
                                    .set({
                                  'status': 'handingOverShipmentToCustomer',
                                  'shipmentId': widget.model.shipmentId,
                                });
                                setState(() {
                                  isLoading = false;
                                });
                                if (_currentStatus ==
                                        'handingOverShipmentToCustomer' &&
                                    widget.model.paymentMethod == 'cod') {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      builder: (c) => const loading.Loading());
                                  await trackingProvider
                                      .markShipmentAsDeliveredToEndCustomerWithoutValidating(
                                          widget.model.shipmentId!);
                                  check(
                                      auth: authProvider,
                                      state: trackingProvider.state!,
                                      ctx: navigator.currentContext!);
                                  if (trackingProvider.state ==
                                      NetworkState.success) {
                                    WeevoCaptain.facebookAppEvents.logPurchase(
                                        amount: num.parse(widget
                                                    .model
                                                    .shipmentDetailsModel
                                                    ?.amount ??
                                                '0')
                                            .toDouble(),
                                        currency: 'EGP');
                                    FirebaseFirestore.instance
                                        .collection('locations')
                                        .doc(_locationId)
                                        .set(
                                      {'status': 'closed'},
                                    );
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('merchant_users')
                                            .doc(widget.model.merchantId
                                                .toString())
                                            .get();
                                    String token = userToken['fcmToken'];
                                    log('CourierName ${Preferences.instance.getUserName}');
                                    log('CourierName2 ${authProvider.name}');

                                    _authProvider.sendNotification(
                                        title: 'تهانينا طلبك اتسلمت',
                                        body:
                                            'تسليم الطلب رقم ${widget.model.shipmentId} اتأكد وتم تحويل الرصيد لحسابك',
                                        toToken: token,
                                        image: _authProvider.photo!.isNotEmpty
                                            ? _authProvider.photo!.contains(
                                                    ApiConstants.baseUrl)
                                                ? _authProvider.photo
                                                : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                            : '',
                                        type: 'rating',
                                        screenTo: '',
                                        data: ShipmentTrackingModel(
                                                shipmentId:
                                                    widget.model.shipmentId,
                                                deliveringState: widget
                                                    .model.deliveringState,
                                                deliveringCity:
                                                    widget.model.deliveringCity,
                                                receivingState:
                                                    widget.model.receivingState,
                                                receivingCity:
                                                    widget.model.receivingCity,
                                                deliveringLat:
                                                    widget.model.deliveringLat,
                                                deliveringLng:
                                                    widget.model.deliveringLng,
                                                receivingLat:
                                                    widget.model.receivingLat,
                                                receivingLng:
                                                    widget.model.receivingLng,
                                                courierNationalId: widget
                                                    .model.courierNationalId,
                                                merchantNationalId: widget
                                                    .model.merchantNationalId,
                                                fromLat: 31.0000,
                                                fromLng: 31.0000,
                                                hasChildren:
                                                    widget.model.hasChildren,
                                                merchantId:
                                                    widget.model.merchantId,
                                                courierId:
                                                    widget.model.courierId,
                                                paymentMethod:
                                                    widget.model.paymentMethod,
                                                merchantImage:
                                                    widget.model.merchantImage,
                                                courierImage:
                                                    widget.model.courierImage,
                                                merchantName:
                                                    widget.model.merchantName,
                                                courierName: Preferences
                                                    .instance.getUserName,
                                                merchantPhone:
                                                    widget.model.merchantPhone,
                                                clientPhone:
                                                    widget.model.courierPhone,
                                                status: widget.model.status,
                                                courierPhone:
                                                    widget.model.courierPhone,
                                                locationIdStatus: _currentStatus)
                                            .toJson());
                                    MagicRouter.pop();
                                    await showDialog(
                                        context: navigator.currentContext!,
                                        builder: (c) => DoneDialog(
                                              content: 'تم تسليم طلبك بنجاح',
                                              callback: () {
                                                MagicRouter.pop();
                                              },
                                            ));
                                    MagicRouter.navigateAndPopAll(
                                        RatingDialog(model: widget.model));
                                  } else if (trackingProvider.state ==
                                      NetworkState.error) {
                                    FirebaseFirestore.instance
                                        .collection('locations')
                                        .doc(_locationId)
                                        .set({
                                      'status': 'receivedShipment',
                                      'shipmentId': widget.model.shipmentId,
                                    });
                                    Navigator.pop(navigator.currentContext!);
                                    showDialog(
                                      context: navigator.currentContext!,
                                      builder: (context) => WalletDialog(
                                        msg: 'حدث خطأ برجاء المحاولة مرة اخري',
                                        onPress: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  }
                                } else {
                                  showDialog(
                                      context: navigator.currentContext!,
                                      barrierDismissible: false,
                                      builder: (ctx) =>
                                          CourierToCustomerQrCodeScanner(
                                              parentContext: context,
                                              model: widget.model,
                                              locationId: _locationId!));
                                }
                              },
                              approveAction: 'نعم',
                              onCancelClick: () {
                                Navigator.pop(ctx);
                              },
                              cancelAction: 'لا',
                            ));
                  },
                  onHandOverReturnedShipmentCallback: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseFirestore.instance
                        .collection('locations')
                        .doc(_locationId)
                        .set({
                      'status': 'handingOverReturnedShipmentToMerchant',
                    });
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onReceiveShipmentToClientCallback: () async {
                    showDialog(
                      context: context,
                      builder: (ctx) => ActionDialog(
                        content: 'هل تود توصيل الطلب للعميل ؟',
                        cancelAction: 'لا',
                        approveAction: 'نعم',
                        onApproveClick: () async {
                          MagicRouter.pop();
                          setState(() {
                            isLoading = true;
                          });
                          FirebaseFirestore.instance
                              .collection('locations')
                              .doc(_locationId)
                              .set({
                            'status': 'receivedShipment',
                            'shipmentId': widget.model.shipmentId,
                          });
                          setState(() {
                            isLoading = false;
                          });
                        },
                        onCancelClick: () {
                          MagicRouter.pop();
                        },
                      ),
                    );
                  },
                  model: widget.model,
                )
              ],
            )),
      ),
    );
  }

  Future<void> cancelShippingCallback(ShipmentTrackingModel model,
      ShipmentProvider data, AuthProvider authProvider) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => CancelShipmentDialog(onOkPressed: () async {
              Navigator.pop(ctx);
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const loading.Loading());
              await data.cancelShipping(model.shipmentId!);
              check(
                  ctx: navigator.currentContext!,
                  auth: authProvider,
                  state: data.cancelShippingState!);
              if (data.cancelShippingState == NetworkState.success) {
                Navigator.pop(navigator.currentContext!);
                await showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: data.cancelMessage,
                          onApproveClick: () {
                            Navigator.pop(context);
                          },
                          approveAction: 'حسناً',
                        ));
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => const loading.Loading());
                DocumentSnapshot userToken = await FirebaseFirestore.instance
                    .collection('merchant_users')
                    .doc(widget.model.merchantId.toString())
                    .get();
                String token = userToken['fcmToken'];
                FirebaseFirestore.instance
                    .collection('merchant_notifications')
                    .doc(widget.model.merchantId.toString())
                    .collection(widget.model.merchantId.toString())
                    .add({
                  'read': false,
                  'date_time': DateTime.now().toIso8601String(),
                  'type': 'cancel_shipment',
                  'title': 'تم إلغاء الشحن',
                  'body':
                      'قام الكابتن ${authProvider.name} بالغاء الطلب يمكنك الذهاب للطلب في الطلبات المتاحة',
                  'user_icon': _authProvider.photo!.isNotEmpty
                      ? _authProvider.photo!.contains(ApiConstants.baseUrl)
                          ? _authProvider.photo
                          : '${ApiConstants.baseUrl}${_authProvider.photo}'
                      : '',
                  'screen_to': 'shipment_screen',
                  'data': ShipmentTrackingModel(
                          shipmentId: widget.model.shipmentId,
                          deliveringState: widget.model.deliveringState,
                          deliveringCity: widget.model.deliveringCity,
                          receivingState: widget.model.receivingState,
                          receivingCity: widget.model.receivingCity,
                          deliveringLat: widget.model.deliveringLat,
                          deliveringLng: widget.model.deliveringLng,
                          fromLat: 31.0000,
                          fromLng: 31.0000,
                          hasChildren: widget.model.hasChildren,
                          merchantId: widget.model.merchantId,
                          courierId: widget.model.courierId,
                          paymentMethod: widget.model.paymentMethod,
                          merchantImage: widget.model.merchantImage,
                          courierImage: widget.model.courierImage,
                          merchantName: widget.model.merchantName,
                          courierName: widget.model.courierName,
                          merchantPhone: widget.model.merchantPhone,
                          clientPhone: widget.model.courierPhone,
                          status: widget.model.status,
                          courierPhone: widget.model.courierPhone,
                          locationIdStatus: _currentStatus)
                      .toJson(),
                });
                Provider.of<AuthProvider>(navigator.currentContext!,
                        listen: false)
                    .sendNotification(
                        title: 'تم إلغاء الشحن',
                        body:
                            'قام الكابتن ${authProvider.name} بالغاء الطلب يمكنك الذهاب للطلب في الطلبات المتاحة',
                        toToken: token,
                        image: _authProvider.photo!.isNotEmpty
                            ? _authProvider.photo!
                                    .contains(ApiConstants.baseUrl)
                                ? _authProvider.photo
                                : '${ApiConstants.baseUrl}${_authProvider.photo}'
                            : '',
                        data: ShipmentTrackingModel(
                                shipmentId: widget.model.shipmentId,
                                deliveringState: widget.model.deliveringState,
                                deliveringCity: widget.model.deliveringCity,
                                receivingState: widget.model.receivingState,
                                receivingCity: widget.model.receivingCity,
                                deliveringLat: widget.model.deliveringLat,
                                deliveringLng: widget.model.deliveringLng,
                                fromLat: 31.0000,
                                fromLng: 31.0000,
                                courierNationalId:
                                    widget.model.courierNationalId,
                                merchantNationalId:
                                    widget.model.merchantNationalId,
                                hasChildren: widget.model.hasChildren,
                                merchantId: widget.model.merchantId,
                                courierId: widget.model.courierId,
                                paymentMethod: widget.model.paymentMethod,
                                merchantImage: widget.model.merchantImage,
                                courierImage: widget.model.courierImage,
                                merchantName: widget.model.merchantName,
                                courierName: widget.model.courierName,
                                merchantPhone: widget.model.merchantPhone,
                                clientPhone: widget.model.courierPhone,
                                status: widget.model.status,
                                courierPhone: widget.model.courierPhone,
                                locationIdStatus: _currentStatus)
                            .toJson(),
                        screenTo: 'shipment_screen',
                        type: 'cancel_shipment');
                FirebaseFirestore.instance
                    .collection('locations')
                    .doc(_locationId)
                    .set(
                  {'status': 'closed'},
                );
                Navigator.pop(navigator.currentContext!);
                Navigator.pushNamedAndRemoveUntil(
                  navigator.currentContext!,
                  Home.id,
                  (route) => false,
                );
              } else if (data.cancelShippingState == NetworkState.error) {
                Navigator.pop(navigator.currentContext!);
                showDialog(
                    context: navigator.currentContext!,
                    barrierDismissible: false,
                    builder: (context) => ActionDialog(
                          content: 'حدث خطأ من فضلك حاول مرة اخري',
                          cancelAction: 'حسناً',
                          onCancelClick: () {
                            Navigator.pop(context);
                          },
                        ));
              }
            }, onCancelPressed: () {
              Navigator.pop(context);
            }));
  }

  void sendCurrentLocation(AuthProvider authProvider,
      ShipmentTrackingModel model, String locationId) async {
    await authProvider.getCurrentLocation();
    authProvider.sendMessage(
        '${authProvider.locationData!.latitude}-${authProvider.locationData!.longitude}',
        Type.location.index,
        ChatData(
            currentUserImageUrl: authProvider.photo,
            currentUserId: authProvider.id,
            currentUserName: authProvider.name,
            currentUserNationalId: authProvider.getNationalId,
            shipmentId: widget.model.shipmentId,
            peerId: widget.model.merchantId.toString(),
            peerUserName: widget.model.merchantName,
            peerNationalId: widget.model.courierPhone,
            peerImageUrl: widget.model.merchantImage),
        locationId);
  }

  void onMyWayCheckConnection(AuthProvider authProvider,
      ShipmentTrackingProvider trackingProvider) async {
    setState(() {
      isLoading = true;
    });
    if (await authProvider.checkConnection()) {
      setState(() {
        isLoading = true;
      });
      await trackingProvider.onMyWayToGetShipment(widget.model.shipmentId!);
      if (trackingProvider.state == NetworkState.success) {
        DocumentSnapshot userToken = await FirebaseFirestore.instance
            .collection('merchant_users')
            .doc(widget.model.merchantId.toString())
            .get();
        String token = userToken['fcmToken'];
        FirebaseFirestore.instance
            .collection('merchant_notifications')
            .doc(widget.model.merchantId.toString())
            .collection(widget.model.merchantId.toString())
            .add({
          'read': false,
          'date_time': DateTime.now().toIso8601String(),
          'type': 'tracking',
          'title': 'الكابتن في الطريق',
          'body': 'جهز طلبك الكابتن ${authProvider.name} في الطريق اليك',
          'user_icon': _authProvider.photo!.isNotEmpty
              ? _authProvider.photo!.contains(ApiConstants.baseUrl)
                  ? _authProvider.photo
                  : '${ApiConstants.baseUrl}${_authProvider.photo}'
              : '',
          'screen_to': 'handle_shipment_screen',
          'data': ShipmentTrackingModel(
                  shipmentId: widget.model.shipmentId,
                  deliveringState: widget.model.deliveringState,
                  deliveringCity: widget.model.deliveringCity,
                  receivingState: widget.model.receivingState,
                  receivingCity: widget.model.receivingCity,
                  deliveringLat: widget.model.deliveringLat,
                  deliveringLng: widget.model.deliveringLng,
                  fromLat: 31.0000,
                  fromLng: 31.0000,
                  hasChildren: widget.model.hasChildren,
                  merchantId: widget.model.merchantId,
                  courierId: widget.model.courierId,
                  courierNationalId: widget.model.courierNationalId,
                  merchantNationalId: widget.model.merchantNationalId,
                  paymentMethod: widget.model.paymentMethod,
                  merchantImage: widget.model.merchantImage,
                  courierImage: widget.model.courierImage,
                  merchantName: widget.model.merchantName,
                  courierName: widget.model.courierName,
                  merchantPhone: widget.model.merchantPhone,
                  clientPhone: widget.model.courierPhone,
                  status: widget.model.status,
                  courierPhone: widget.model.courierPhone,
                  locationIdStatus: _currentStatus)
              .toJson(),
        });
        _authProvider.sendNotification(
            title: 'الكابتن في الطريق',
            body: 'جهز طلبك الكابتن ${authProvider.name} في الطريق اليك',
            toToken: token,
            screenTo: 'handle_shipment_screen',
            image: _authProvider.photo!.isNotEmpty
                ? _authProvider.photo!.contains(ApiConstants.baseUrl)
                    ? _authProvider.photo
                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                : '',
            type: 'tracking',
            data: ShipmentTrackingModel(
                    shipmentId: widget.model.shipmentId,
                    deliveringState: widget.model.deliveringState,
                    deliveringCity: widget.model.deliveringCity,
                    receivingState: widget.model.receivingState,
                    receivingCity: widget.model.receivingCity,
                    deliveringLat: widget.model.deliveringLat,
                    deliveringLng: widget.model.deliveringLng,
                    courierNationalId: widget.model.courierNationalId,
                    merchantNationalId: widget.model.merchantNationalId,
                    fromLat: 31.0000,
                    fromLng: 31.0000,
                    hasChildren: widget.model.hasChildren,
                    merchantId: widget.model.merchantId,
                    courierId: widget.model.courierId,
                    paymentMethod: widget.model.paymentMethod,
                    merchantImage: widget.model.merchantImage,
                    courierImage: widget.model.courierImage,
                    merchantName: widget.model.merchantName,
                    courierName: widget.model.courierName,
                    merchantPhone: widget.model.merchantPhone,
                    clientPhone: widget.model.courierPhone,
                    status: widget.model.status,
                    courierPhone: widget.model.courierPhone,
                    locationIdStatus: _currentStatus)
                .toJson());
        await FirebaseFirestore.instance
            .collection('locations')
            .doc(_locationId)
            .set({
          'status': 'inMyWay',
          'shipmentId': widget.model.shipmentId,
        });
        setState(() {
          isLoading = false;
        });
        _streamSubscription = authProvider.location!.onLocationChanged
            .listen((LocationData data) async {
          setState(() {
            _currentLat = data.latitude!;
            _currentLong = data.longitude!;
          });
        });
      } else if (trackingProvider.state == NetworkState.error) {
        showDialog(
          context: navigator.currentContext!,
          builder: (context) => WalletDialog(
            msg: 'حدث خطأ برجاء المحاولة مرة اخري',
            onPress: () {
              Navigator.pop(context);
            },
          ),
        );
      }
    } else {
      showDialog(
          context: navigator.currentContext!,
          builder: (ctx) => ActionDialog(
                content: 'تأكد من الاتصال بشبكة الانترنت',
                cancelAction: 'حسناً',
                approveAction: 'حاول مرة اخري',
                onApproveClick: () async {
                  Navigator.pop(context);
                  onMyWayCheckConnection(authProvider, trackingProvider);
                },
                onCancelClick: () {
                  Navigator.pop(context);
                },
              ));
    }
  }
}
