import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_captain_app/core/helpers/spacing.dart';
import 'package:weevo_captain_app/core/helpers/toasts.dart';

import '../../../Dialogs/action_dialog.dart';
import '../../../Dialogs/cancel_shipment_dialog.dart';
import '../../../Dialogs/loading.dart';
import '../../../Dialogs/qr_dialog_code.dart';
import '../../../Dialogs/tracking_dialog.dart';
import '../../../Dialogs/wallet_dialog.dart';
import '../../../Models/chat_data.dart';
import '../../../Models/refresh_qr_code.dart';
import '../../../Models/shipment_tracking_model.dart';
import '../../../Providers/auth_provider.dart';
import '../../../Screens/home.dart';
import '../../../Storage/shared_preference.dart';
import '../../../Utilits/colors.dart';
import '../../../Utilits/constants.dart';
import '../../../Widgets/connectivity_widget.dart';
import '../../../core/networking/api_constants.dart';
import '../../../core/router/router.dart';
import '../../wasully_details/logic/cubit/wasully_details_cubit.dart';
import '../../wasully_details/logic/cubit/wasully_details_state.dart';
import '../logic/cubit/wasully_handle_shipment_cubit.dart';
import 'widgets/wasully_courier_to_customer_qrcode_dialog.dart';
import 'widgets/wasully_merchant_to_courier_qr_code_dialog.dart';

class WasullyHandleShipmentScreen extends StatefulWidget {
  final ShipmentTrackingModel model;

  const WasullyHandleShipmentScreen({
    super.key,
    required this.model,
  });

  @override
  State<WasullyHandleShipmentScreen> createState() =>
      _WasullyHandleShipmentScreenState();
}

class _WasullyHandleShipmentScreenState
    extends State<WasullyHandleShipmentScreen> {
  final pref = Preferences.instance;
  double _currentLat = 0.0, _currentLong = 0.0;
  StreamSubscription<LocationData>? _streamSubscription;
  late AuthProvider _authProvider;
  late String _locationId;
  String? _currentStatus;
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();
    log('Data : ${widget.model.merchantNationalId} ${widget.model.courierNationalId} ${widget.model.merchantId}');
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
    await FirebaseFirestore.instance
        .collection('locations')
        .doc(_locationId)
        .set({
      'status': _currentStatus,
    });
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
                  fromLat: 31.0000,
                  fromLng: 31.0000,
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
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final WasullyDetailsCubit wasullyDetailsCubit =
        context.read<WasullyDetailsCubit>();
    final WasullyHandleShipmentCubit wasullyHandleShipmentCubit =
        context.read<WasullyHandleShipmentCubit>();
    return BlocConsumer<WasullyHandleShipmentCubit, WasullyHandleShipmentState>(
      listener: (context, state) {
        if (state is WasullyHandleShipmentRefreshQrCodeError) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) => WalletDialog(
              msg: 'حدث خطأ برجاء المحاولة مرة اخري',
              onPress: () {
                Navigator.pop(context);
              },
            ),
          );
        }
        if (state is WasullyhandleShipmentRefreshQrCodeSuccess) {
          MagicRouter.pop();
          showDialog(
            context: context,
            builder: (context) => QrCodeDialog(
              data: state.refreshQrcode,
            ),
          );
        }
      },
      builder: (context, state) {
        log('CurrentStatus -> $_currentStatus');
        return ConnectivityWidget(
          callback: () {},
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: false,
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'طلب وصلي رقم ${widget.model.shipmentId}',
                      ),
                    ),
                  ],
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    MagicRouter.pop();
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
                      listener: (context, state) async {
                        if (state is WasullyDetailsOnMyWaySuccessState) {
                          onMyWaySuccess(authProvider);
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            _currentStatus == 'receivingShipment'
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10.0,
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'برجاء الضغط على الزر الأزرق لإدخال الكود\n وبعد التحقق سيتم إستلام الشحنة من المرسل',
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
                                                context:
                                                    navigator.currentContext!,
                                                builder: (ctx) =>
                                                    WasullyMerchantToCourierQrCodeScanner(
                                                        parentContext: navigator
                                                            .currentContext!,
                                                        model: widget.model,
                                                        locationId:
                                                            _locationId));
                                          },
                                          backgroundColor:
                                              weevoPrimaryBlueColor,
                                          child: const Icon(
                                            Icons.qr_code,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : _currentStatus ==
                                        'handingOverShipmentToCustomer'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 12.0),
                                        child: Column(
                                          children: [
                                            const Text(
                                              'برجاء الضغط على الزر الأزرق لإدخال الكود من المرسل إليه\n وبعد التحقق سيتم تسليم الشحنة إالى المرسل إليه',
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
                                                        WasullyCourierToCustomerQrCodeScanner(
                                                            parentContext:
                                                                context,
                                                            model: widget.model,
                                                            locationId:
                                                                _locationId));
                                              },
                                              backgroundColor:
                                                  weevoPrimaryBlueColor,
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
                                        ? Column(
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 12.0),
                                                child: FloatingActionButton(
                                                  onPressed: () async {
                                                    if (wasullyDetailsCubit
                                                                .wasullyModel!
                                                                .handoverCodeCourierToMerchant ==
                                                            null &&
                                                        wasullyDetailsCubit
                                                                .wasullyModel!
                                                                .handoverQrcodeCourierToMerchant ==
                                                            null) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              const Loading());
                                                      await wasullyHandleShipmentCubit
                                                          .refreshHandoverQrcodeCourierToMerchant(
                                                              widget.model
                                                                  .shipmentId!);
                                                      check(
                                                          auth: authProvider,
                                                          state: NetworkState
                                                              .success,
                                                          ctx: navigator
                                                              .currentContext!);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => QrCodeDialog(
                                                            data: RefreshQrcode(
                                                                filename: wasullyDetailsCubit
                                                                    .wasullyModel!
                                                                    .handoverQrcodeCourierToMerchant
                                                                    ?.split('/')
                                                                    .last,
                                                                path: wasullyDetailsCubit
                                                                    .wasullyModel!
                                                                    .handoverQrcodeCourierToMerchant,
                                                                code: int.parse(
                                                                    wasullyDetailsCubit
                                                                        .wasullyModel!
                                                                        .handoverCodeCourierToMerchant!))),
                                                      );
                                                    }
                                                  },
                                                  backgroundColor:
                                                      weevoPrimaryBlueColor,
                                                  child: const Icon(
                                                    Icons.qr_code,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                            TrackingDialog(
                              onCLientPhoneCallback: () async {
                                await launchUrl(Uri.parse(
                                    'tel:${widget.model.clientPhone}'));
                              },
                              status: _currentStatus ?? '',
                              onCancelShipmentCallback: () async {
                                if (await authProvider.checkConnection()) {
                                  showDialog(
                                    context: navigator.currentContext!,
                                    builder: (ctx) => ActionDialog(
                                      content: 'هل تود إلغاء الطلب',
                                      cancelAction: 'لا',
                                      approveAction: 'نعم',
                                      onApproveClick: () async {
                                        MagicRouter.pop();
                                        await cancelWasullyShipment(
                                            widget.model, context);
                                      },
                                      onCancelClick: () {
                                        MagicRouter.pop();
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
                                        MagicRouter.pop();
                                        await cancelWasullyShipment(
                                            widget.model, context);
                                      },
                                      onCancelClick: () {
                                        MagicRouter.pop();
                                      },
                                    ),
                                  );
                                }
                              },
                              onMyWayCallback: () async {
                                await wasullyOnMyWay(
                                    authProvider, context, state);
                                if (Geolocator.distanceBetween(
                                        _currentLat,
                                        _currentLong,
                                        double.parse(
                                            widget.model.receivingLat!),
                                        double.parse(
                                            widget.model.receivingLng!)) <=
                                    100.0) {
                                  DocumentSnapshot userToken =
                                      await FirebaseFirestore.instance
                                          .collection('merchant_users')
                                          .doc(widget.model.merchantId
                                              .toString())
                                          .get();
                                  String token = userToken['fcmToken'];
                                  FirebaseFirestore.instance
                                      .collection('merchant_notifications')
                                      .doc(widget.model.merchantId.toString())
                                      .collection(
                                          widget.model.merchantId.toString())
                                      .add({
                                    'read': false,
                                    'date_time':
                                        DateTime.now().toIso8601String(),
                                    'type': 'tracking',
                                    'title': 'الكابتن في الطريق',
                                    'body':
                                        'جهز شحنتك الكابتن ${authProvider.name} في الطريق اليك',
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
                                      title: 'الكابتن في الطريق',
                                      body:
                                          'جهز شحنتك الكابتن ${authProvider.name} في الطريق اليك',
                                      toToken: token,
                                      image: _authProvider.photo!.isNotEmpty
                                          ? _authProvider.photo!.contains(
                                                  ApiConstants.baseUrl)
                                              ? _authProvider.photo
                                              : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                          : '',
                                      type: 'tracking',
                                      screenTo: 'handle_shipment_screen',
                                      data: ShipmentTrackingModel(
                                              shipmentId:
                                                  widget.model.shipmentId,
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
                                }
                              },
                              onArrivedCallback: () async {
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
                                  'title': 'الكابتن وصل',
                                  'body':
                                      'الكابتن ${_authProvider.name} وصل يرجي التواجد بالمكان لتسليم الطلب',
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
                                            hasChildren:
                                                widget.model.hasChildren,
                                            merchantId: widget.model.merchantId,
                                            courierId: widget.model.courierId,
                                            courierNationalId:
                                                widget.model.courierNationalId,
                                            merchantNationalId:
                                                widget.model.merchantNationalId,
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
                                FirebaseFirestore.instance
                                    .collection('locations')
                                    .doc(_locationId)
                                    .set({
                                  'status': 'arrived',
                                  'shipmentId': widget.model.wasullyModel!.slug,
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
                                      sendCurrentLocation(authProvider,
                                          widget.model, _locationId);
                                      DocumentSnapshot userToken =
                                          await FirebaseFirestore.instance
                                              .collection('merchant_users')
                                              .doc(widget.model.merchantId
                                                  .toString())
                                              .get();
                                      String token = userToken['fcmToken'];
                                      FirebaseFirestore.instance
                                          .collection('merchant_notifications')
                                          .doc(widget.model.merchantId
                                              .toString())
                                          .collection(widget.model.merchantId
                                              .toString())
                                          .add({
                                        'read': false,
                                        'date_time':
                                            DateTime.now().toIso8601String(),
                                        'type': 'tracking',
                                        'title':
                                            'الطلب مرتجع الكابتن في الطريق اليك',
                                        'body':
                                            'الكابتن ${_authProvider.name} في الطريق لاعادة الطلب اليك يرجي التواجد بالمكان',
                                        'user_icon': _authProvider
                                                .photo!.isNotEmpty
                                            ? _authProvider.photo!.contains(
                                                    ApiConstants.baseUrl)
                                                ? _authProvider.photo
                                                : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                            : '',
                                        'screen_to': 'handle_shipment_screen',
                                        'data': ShipmentTrackingModel(
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
                                                courierName:
                                                    widget.model.courierName,
                                                merchantPhone:
                                                    widget.model.merchantPhone,
                                                clientPhone:
                                                    widget.model.courierPhone,
                                                courierNationalId: widget
                                                    .model.courierNationalId,
                                                merchantNationalId: widget
                                                    .model.merchantNationalId,
                                                status: widget.model.status,
                                                courierPhone:
                                                    widget.model.courierPhone,
                                                locationIdStatus:
                                                    _currentStatus)
                                            .toJson(),
                                      });
                                      _authProvider.sendNotification(
                                          title:
                                              'الطلب مرتجع الكابتن في الطريق اليك',
                                          body:
                                              'الكابتن ${_authProvider.name} في الطريق لاعادة الطلب اليك يرجي التواجد بالمكان',
                                          toToken: token,
                                          image: _authProvider.photo!.isNotEmpty
                                              ? _authProvider.photo!.contains(
                                                      ApiConstants.baseUrl)
                                                  ? _authProvider.photo
                                                  : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                              : '',
                                          screenTo: 'handle_shipment_screen',
                                          type: 'tracking',
                                          data: ShipmentTrackingModel(
                                                  shipmentId:
                                                      widget.model.shipmentId,
                                                  deliveringState: widget
                                                      .model.deliveringState,
                                                  deliveringCity: widget
                                                      .model.deliveringCity,
                                                  receivingState: widget
                                                      .model.receivingState,
                                                  receivingCity: widget
                                                      .model.receivingCity,
                                                  deliveringLat: widget
                                                      .model.deliveringLat,
                                                  deliveringLng: widget
                                                      .model.deliveringLng,
                                                  fromLat: 31.0000,
                                                  fromLng: 31.0000,
                                                  hasChildren:
                                                      widget.model.hasChildren,
                                                  merchantId:
                                                      widget.model.merchantId,
                                                  courierId:
                                                      widget.model.courierId,
                                                  paymentMethod: widget
                                                      .model.paymentMethod,
                                                  merchantImage: widget
                                                      .model.merchantImage,
                                                  courierNationalId: widget
                                                      .model.courierNationalId,
                                                  merchantNationalId: widget
                                                      .model.merchantNationalId,
                                                  courierImage:
                                                      widget.model.courierImage,
                                                  merchantName:
                                                      widget.model.merchantName,
                                                  courierName:
                                                      widget.model.courierName,
                                                  merchantPhone: widget.model.merchantPhone,
                                                  clientPhone: widget.model.courierPhone,
                                                  status: widget.model.status,
                                                  courierPhone: widget.model.courierPhone,
                                                  locationIdStatus: _currentStatus)
                                              .toJson());
                                      FirebaseFirestore.instance
                                          .collection('locations')
                                          .doc(_locationId)
                                          .set({
                                        'status': 'returnShipment',
                                        'shipmentId':
                                            widget.model.wasullyModel!.slug,
                                      });
                                    },
                                    onCancelClick: () {
                                      MagicRouter.pop();
                                    },
                                  ),
                                );
                              },
                              onReceiveShipmentToClientCallback: () async {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => ActionDialog(
                                    content: 'هل تود توصيل الطلب للمرسل اليه ؟',
                                    cancelAction: 'لا',
                                    approveAction: 'نعم',
                                    onApproveClick: () async {
                                      MagicRouter.pop();
                                      FirebaseFirestore.instance
                                          .collection('locations')
                                          .doc(_locationId)
                                          .set({
                                        'status': 'receivedShipment',
                                        'shipmentId':
                                            widget.model.wasullyModel!.slug,
                                      });
                                    },
                                    onCancelClick: () {
                                      MagicRouter.pop();
                                    },
                                  ),
                                );
                              },
                              onReceivingShipmentCallback:
                                  _currentStatus == 'arrived' ||
                                          _currentStatus == 'receivingShipment'
                                      ? () async {
                                          DocumentSnapshot userToken =
                                              await FirebaseFirestore.instance
                                                  .collection('merchant_users')
                                                  .doc(widget.model.merchantId
                                                      .toString())
                                                  .get();
                                          String token = userToken['fcmToken'];
                                          FirebaseFirestore.instance
                                              .collection(
                                                  'merchant_notifications')
                                              .doc(widget.model.merchantId
                                                  .toString())
                                              .collection(widget
                                                  .model.merchantId
                                                  .toString())
                                              .add({
                                            'read': false,
                                            'date_time': DateTime.now()
                                                .toIso8601String(),
                                            'type': 'tracking',
                                            'title':
                                                'الكابتن يريد استلام الطلب',
                                            'body':
                                                'الكابتن ${_authProvider.name} يريد استلام الطلب',
                                            'user_icon': _authProvider
                                                    .photo!.isNotEmpty
                                                ? _authProvider.photo!.contains(
                                                        ApiConstants.baseUrl)
                                                    ? _authProvider.photo
                                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                : '',
                                            'screen_to':
                                                'handle_shipment_screen',
                                            'data': ShipmentTrackingModel(
                                                    shipmentId:
                                                        widget.model.shipmentId,
                                                    deliveringState: widget
                                                        .model.deliveringState,
                                                    deliveringCity: widget
                                                        .model.deliveringCity,
                                                    receivingState: widget
                                                        .model.receivingState,
                                                    receivingCity: widget
                                                        .model.receivingCity,
                                                    deliveringLat: widget
                                                        .model.deliveringLat,
                                                    deliveringLng: widget
                                                        .model.deliveringLng,
                                                    receivingLat: widget
                                                        .model.receivingLat,
                                                    receivingLng: widget
                                                        .model.receivingLng,
                                                    fromLat: 31.0000,
                                                    fromLng: 31.0000,
                                                    hasChildren: widget
                                                        .model.hasChildren,
                                                    merchantId:
                                                        widget.model.merchantId,
                                                    courierId:
                                                        widget.model.courierId,
                                                    paymentMethod: widget
                                                        .model.paymentMethod,
                                                    merchantImage: widget
                                                        .model.merchantImage,
                                                    courierImage: widget
                                                        .model.courierImage,
                                                    merchantName: widget
                                                        .model.merchantName,
                                                    courierName: widget.model.courierName,
                                                    merchantPhone: widget.model.merchantPhone,
                                                    clientPhone: widget.model.courierPhone,
                                                    courierNationalId: widget.model.courierNationalId,
                                                    merchantNationalId: widget.model.merchantNationalId,
                                                    status: widget.model.status,
                                                    courierPhone: widget.model.courierPhone,
                                                    locationIdStatus: _currentStatus)
                                                .toJson(),
                                          });
                                          _authProvider.sendNotification(
                                              title:
                                                  'الكابتن يريد استلام الطلب',
                                              body:
                                                  'الكابتن ${_authProvider.name} يريد استلام الطلب',
                                              toToken: token,
                                              image: _authProvider
                                                      .photo!.isNotEmpty
                                                  ? _authProvider.photo!.contains(
                                                          ApiConstants.baseUrl)
                                                      ? _authProvider.photo
                                                      : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                  : '',
                                              screenTo:
                                                  'handle_shipment_screen',
                                              type: 'tracking',
                                              data: ShipmentTrackingModel(
                                                      shipmentId: widget
                                                          .model.shipmentId,
                                                      deliveringState: widget
                                                          .model
                                                          .deliveringState,
                                                      deliveringCity: widget
                                                          .model.deliveringCity,
                                                      receivingState: widget
                                                          .model.receivingState,
                                                      receivingCity: widget
                                                          .model.receivingCity,
                                                      deliveringLat: widget
                                                          .model.deliveringLat,
                                                      deliveringLng: widget
                                                          .model.deliveringLng,
                                                      receivingLat: widget
                                                          .model.receivingLat,
                                                      receivingLng: widget
                                                          .model.receivingLng,
                                                      fromLat: 31.0000,
                                                      fromLng: 31.0000,
                                                      hasChildren:
                                                          widget.model.hasChildren,
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
                                                  .toJson());
                                          FirebaseFirestore.instance
                                              .collection('locations')
                                              .doc(_locationId)
                                              .set({
                                            'status': 'receivingShipment',
                                            'shipmentId':
                                                widget.model.wasullyModel!.slug,
                                          });
                                          showDialog(
                                              context:
                                                  navigator.currentContext!,
                                              builder: (ctx) =>
                                                  WasullyMerchantToCourierQrCodeScanner(
                                                      parentContext: context,
                                                      model: widget.model,
                                                      locationId: _locationId));
                                        }
                                      : () {},
                              onMerchantLocation: () async {
                                openGoogleMap(widget.model.receivingLat!,
                                    widget.model.receivingLng!);
                              },
                              onClientLocationCallback: () async {
                                openGoogleMap(widget.model.deliveringLat!,
                                    widget.model.deliveringLng!);
                              },
                              onHandOverShipmentCallback: () async {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => ActionDialog(
                                          content: 'هل تود تسليم الطلب ؟',
                                          onApproveClick: () async {
                                            Navigator.pop(ctx);
                                            DocumentSnapshot userToken =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'merchant_users')
                                                    .doc(widget.model.merchantId
                                                        .toString())
                                                    .get();
                                            String token =
                                                userToken['fcmToken'];
                                            FirebaseFirestore.instance
                                                .collection(
                                                    'merchant_notifications')
                                                .doc(widget.model.merchantId
                                                    .toString())
                                                .collection(widget
                                                    .model.merchantId
                                                    .toString())
                                                .add({
                                              'read': false,
                                              'date_time': DateTime.now()
                                                  .toIso8601String(),
                                              'type': 'tracking',
                                              'title':
                                                  'الكابتن وصل لمكان التسليم',
                                              'body':
                                                  'الكابتن ${_authProvider.name} وصل لتسليم الطلب يرجي التأكد من ارسال صورة ال qrcode لأتمام عملية التسليم',
                                              'user_icon': _authProvider
                                                      .photo!.isNotEmpty
                                                  ? _authProvider.photo!
                                                          .contains(ApiConstants
                                                              .baseUrl)
                                                      ? _authProvider.photo
                                                      : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                  : '',
                                              'screen_to':
                                                  'handle_shipment_screen',
                                              'data': ShipmentTrackingModel(
                                                      shipmentId: widget
                                                          .model.shipmentId,
                                                      deliveringState: widget
                                                          .model
                                                          .deliveringState,
                                                      deliveringCity: widget
                                                          .model.deliveringCity,
                                                      receivingState: widget
                                                          .model.receivingState,
                                                      receivingCity: widget
                                                          .model.receivingCity,
                                                      deliveringLat: widget
                                                          .model.deliveringLat,
                                                      deliveringLng: widget
                                                          .model.deliveringLng,
                                                      receivingLat: widget
                                                          .model.receivingLat,
                                                      receivingLng: widget
                                                          .model.receivingLng,
                                                      fromLat:
                                                          widget.model.fromLat,
                                                      fromLng:
                                                          widget.model.fromLng,
                                                      hasChildren: widget
                                                          .model.hasChildren,
                                                      merchantId: widget
                                                          .model.merchantId,
                                                      courierId:
                                                          widget.model.courierId,
                                                      paymentMethod: widget.model.paymentMethod,
                                                      merchantImage: widget.model.merchantImage,
                                                      courierImage: widget.model.courierImage,
                                                      merchantName: widget.model.merchantName,
                                                      courierName: widget.model.courierName,
                                                      merchantPhone: widget.model.merchantPhone,
                                                      clientPhone: widget.model.courierPhone,
                                                      courierNationalId: widget.model.courierNationalId,
                                                      merchantNationalId: widget.model.merchantNationalId,
                                                      status: widget.model.status,
                                                      courierPhone: widget.model.courierPhone,
                                                      locationIdStatus: _currentStatus)
                                                  .toJson(),
                                            });
                                            _authProvider.sendNotification(
                                                title:
                                                    'الكابتن وصل لمكان التسليم',
                                                body:
                                                    'الكابتن ${_authProvider.name} وصل لتسليم الطلب يرجي التأكد من ارسال صورة ال qrcode لأتمام عملية التسليم',
                                                toToken: token,
                                                image: _authProvider
                                                        .photo!.isNotEmpty
                                                    ? _authProvider.photo!
                                                            .contains(ApiConstants
                                                                .baseUrl)
                                                        ? _authProvider.photo
                                                        : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                    : '',
                                                screenTo:
                                                    'handle_shipment_screen',
                                                type: 'tracking',
                                                data: ShipmentTrackingModel(
                                                        shipmentId: widget
                                                            .model.shipmentId,
                                                        deliveringState: widget
                                                            .model
                                                            .deliveringState,
                                                        deliveringCity: widget
                                                            .model
                                                            .deliveringCity,
                                                        receivingState: widget
                                                            .model
                                                            .receivingState,
                                                        receivingCity: widget
                                                            .model
                                                            .receivingCity,
                                                        deliveringLat: widget
                                                            .model
                                                            .deliveringLat,
                                                        deliveringLng: widget
                                                            .model
                                                            .deliveringLng,
                                                        receivingLat: widget
                                                            .model.receivingLat,
                                                        receivingLng: widget
                                                            .model.receivingLng,
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
                                              'status':
                                                  'handingOverShipmentToCustomer',
                                            });
                                          },
                                          approveAction: 'نعم',
                                          onCancelClick: () {
                                            Navigator.pop(ctx);
                                          },
                                          cancelAction: 'لا',
                                        ));
                              },
                              onHandOverReturnedShipmentCallback: () async {
                                FirebaseFirestore.instance
                                    .collection('locations')
                                    .doc(_locationId)
                                    .set({
                                  'status':
                                      'handingOverReturnedShipmentToMerchant',
                                });
                              },
                              model: widget.model,
                            ),
                          ],
                        );
                      },
                    )
                  ],
                ),
              )),
        );
      },
    );
  }

  void onMyWaySuccess(AuthProvider authProvider) async {
    DocumentSnapshot userToken = await FirebaseFirestore.instance
        .collection('merchant_users')
        .doc(widget.model.merchantId.toString())
        .get();
    String token = userToken['fcmToken'];
    log('token: $token');
    FirebaseFirestore.instance
        .collection('merchant_notifications')
        .doc(widget.model.merchantId.toString())
        .collection(widget.model.merchantId.toString())
        .add({
      'read': false,
      'date_time': DateTime.now().toIso8601String(),
      'type': 'tracking',
      'title': 'الكابتن في الطريق',
      'body': 'جهز شحنتك الكابتن ${authProvider.name} في الطريق اليك',
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
        body: 'جهز شحنتك الكابتن ${authProvider.name} في الطريق اليك',
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
      'shipmentId': widget.model.wasullyModel!.slug,
    });
    _streamSubscription = authProvider.location!.onLocationChanged
        .listen((LocationData data) async {
      setState(() {
        _currentLat = data.latitude!;
        _currentLong = data.longitude!;
      });
    });
  }

  void openGoogleMap(String latitude, String longitude) async {
    String googleUrl = 'google.navigation:q=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
    String googleMapsUrl = 'comgooglemaps://?q=$latitude,$longitude';

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // Attempt to open in Google Maps app first
      if (await launchUrlString(googleMapsUrl)) {
        await launchUrlString(googleMapsUrl);
      } else if (await launchUrlString(appleUrl)) {
        await launchUrlString(appleUrl);
      } else {
        showToast('من فضلك قم بتنزيل تطبيق جوجل ماب');
      }
    } else {
      // Android
      if (await launchUrlString(googleUrl)) {
        await launchUrlString(googleUrl);
      } else {
        showToast('من فضلك قم بتنزيل تطبيق جوجل ماب');
      }
    }
  }

  Future<void> cancelWasullyShipment(
      ShipmentTrackingModel model, BuildContext context) async {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => BlocProvider.value(
              value: cubit,
              child: BlocConsumer<WasullyDetailsCubit, WasullyDetailsState>(
                listener: (_, state) async {
                  if (state is WasullyDetailsCancelShipmentLoadingState) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => BlocProvider.value(
                              value: cubit,
                              child: BlocConsumer<WasullyDetailsCubit,
                                  WasullyDetailsState>(
                                listener: (_, state) async {
                                  if (state
                                      is WasullyDetailsCancelShipmentSuccessState) {
                                    MagicRouter.pop();
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) => ActionDialog(
                                        content: state.data.message,
                                        onApproveClick: () {
                                          MagicRouter.pop();
                                        },
                                        approveAction: 'حسناً',
                                      ),
                                    );
                                    log(state.data.message);
                                    showDialog(
                                        context: navigator.currentContext!,
                                        barrierDismissible: false,
                                        builder: (_) => const Loading());
                                    DocumentSnapshot userToken =
                                        await FirebaseFirestore.instance
                                            .collection('merchant_users')
                                            .doc(widget.model.merchantId
                                                .toString())
                                            .get();
                                    String token = userToken['fcmToken'];
                                    FirebaseFirestore.instance
                                        .collection('merchant_notifications')
                                        .doc(widget.model.merchantId.toString())
                                        .collection(
                                            widget.model.merchantId.toString())
                                        .add({
                                      'read': false,
                                      'date_time':
                                          DateTime.now().toIso8601String(),
                                      'type': 'cancel_shipment',
                                      'title': 'تم إلغاء الطلب',
                                      'body':
                                          'قام الكابتن ${authProvider.name} بالغاء الطلب يمكنك الذهاب للطب في الطلب المتاحة',
                                      'user_icon': _authProvider
                                              .photo!.isNotEmpty
                                          ? _authProvider.photo!.contains(
                                                  ApiConstants.baseUrl)
                                              ? _authProvider.photo
                                              : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                          : '',
                                      'screen_to': 'shipment_screen',
                                      'data': ShipmentTrackingModel(
                                              shipmentId:
                                                  widget.model.shipmentId,
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
                                              fromLat: 31.0000,
                                              fromLng: 31.0000,
                                              hasChildren:
                                                  widget.model.hasChildren,
                                              merchantId:
                                                  widget.model.merchantId,
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
                                          .toJson(),
                                    });
                                    Provider.of<AuthProvider>(navigator.currentContext!, listen: false)
                                        .sendNotification(
                                            title: 'تم إلغاء الطلب',
                                            body:
                                                'قام الكابتن ${authProvider.name} بالغاء الطلب يمكنك الذهاب للطب في الطلب المتاحة',
                                            toToken: token,
                                            image: _authProvider
                                                    .photo!.isNotEmpty
                                                ? _authProvider.photo!.contains(
                                                        ApiConstants.baseUrl)
                                                    ? _authProvider.photo
                                                    : '${ApiConstants.baseUrl}${_authProvider.photo}'
                                                : '',
                                            data: ShipmentTrackingModel(
                                                    shipmentId:
                                                        widget.model.shipmentId,
                                                    deliveringState: widget
                                                        .model.deliveringState,
                                                    deliveringCity: widget
                                                        .model.deliveringCity,
                                                    receivingState: widget
                                                        .model.receivingState,
                                                    receivingCity: widget
                                                        .model.receivingCity,
                                                    deliveringLat: widget
                                                        .model.deliveringLat,
                                                    deliveringLng: widget
                                                        .model.deliveringLng,
                                                    fromLat: 31.0000,
                                                    fromLng: 31.0000,
                                                    courierNationalId: widget
                                                        .model
                                                        .courierNationalId,
                                                    merchantNationalId: widget
                                                        .model
                                                        .merchantNationalId,
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

                                    MagicRouter.pop();
                                    Navigator.pushNamedAndRemoveUntil(
                                      navigator.currentContext!,
                                      Home.id,
                                      (route) => false,
                                    );
                                  }
                                  if (state
                                      is WasullyDetailsCancelShipmentErrorState) {
                                    Navigator.pop(navigator.currentContext!);
                                    showDialog(
                                      context: navigator.currentContext!,
                                      barrierDismissible: false,
                                      builder: (_) => ActionDialog(
                                        content:
                                            'حدث خطأ من فضلك حاول مرة اخري',
                                        cancelAction: 'حسناً',
                                        onCancelClick: () {
                                          MagicRouter.pop();
                                        },
                                      ),
                                    );
                                  }
                                },
                                builder: (_, state) {
                                  return const Loading();
                                },
                              ),
                            ));
                  }
                },
                builder: (_, state) {
                  return CancelShipmentDialog(onOkPressed: () async {
                    MagicRouter.pop();
                    await cubit.cancelShipment();
                  }, onCancelPressed: () {
                    MagicRouter.pop();
                  });
                },
              ),
            ));
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
            peerNationalId: widget.model.merchantNationalId,
            peerImageUrl: widget.model.merchantImage),
        locationId);
  }

  Future<void> wasullyOnMyWay(
    AuthProvider authProvider,
    BuildContext context,
    WasullyDetailsState state,
  ) async {
    WasullyDetailsCubit cubit = context.read<WasullyDetailsCubit>();
    if (await authProvider.checkConnection()) {
      await cubit.changeShipmentToOnMyWay();
      if (state is WasullyDetailsOnMyWaySuccessState) {
      } else if (state is WasullyDetailsOnMyWayErrorState) {
        showDialog(
          context: navigator.currentContext!,
          builder: (context) => WalletDialog(
            msg: 'حدث خطأ برجاء المحاولة مرة اخري',
            onPress: () {
              MagicRouter.pop();
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
                  MagicRouter.pop();
                  await wasullyOnMyWay(authProvider, context, state);
                },
                onCancelClick: () {
                  MagicRouter.pop();
                },
              ));
    }
  }
}
