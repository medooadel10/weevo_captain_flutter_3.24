import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../Dialogs/loading.dart';
import '../Models/directions.dart';
import '../Models/refresh_qr_code.dart';
import '../Utilits/constants.dart';
import '../core/httpHelper/http_helper.dart';

class ShipmentTrackingProvider with ChangeNotifier {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  Directions? _directions;
  NetworkState? _state;
  LatLng _newLocation = const LatLng(0.0, 0.0);
  RefreshQrcode? _refreshQrCode;
  bool _mtcQrCodeError = false;
  bool _ctcQrCodeError = false;

  LatLng get newLocation => _newLocation;
  Future<void> getDirections({
    required BuildContext context,
    required GoogleMapController controller,
    required LatLng directionFrom,
    required LatLng directionTo,
  }) async {
    _state = NetworkState.waiting;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Loading());
    ByteData originByteData =
        await DefaultAssetBundle.of(context).load("assets/images/origin.png");
    ByteData destinationByteData =
        await DefaultAssetBundle.of(navigator.currentContext!)
            .load("assets/images/destination.png");
    var originIcon = originByteData.buffer.asUint8List();
    var destinationIcon = destinationByteData.buffer.asUint8List();
    Response r = await HttpHelper.instance.httpGet(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${directionFrom.latitude},${directionFrom.longitude}&destination=${directionTo.latitude},${directionTo.longitude}&language=ar&key=AIzaSyB_4B59IxChSRS5-VHdYmSs6DWIVWkIro4',
        false,
        hasBase: false);
    if (r.statusCode >= 200 && r.statusCode < 300) {
      _directions = Directions.fromMap(jsonDecode(r.body));
      _markers.clear();
      _polyLines.clear();
      _markers.add(Marker(
        markerId: const MarkerId('Origin'),
        infoWindow: const InfoWindow(title: 'مكان التسليم'),
        icon: BitmapDescriptor.bytes(originIcon),
        position: directionFrom,
      ));
      _markers.add(Marker(
        markerId: const MarkerId('Destination'),
        infoWindow: const InfoWindow(title: 'مكان الاستلام'),
        icon: BitmapDescriptor.bytes(destinationIcon),
        position: directionTo,
      ));
      _polyLines.add(Polyline(
          polylineId: const PolylineId('polyline overview'),
          color: Colors.grey[600]!,
          width: 6,
          jointType: JointType.round,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          points: _directions!.polylinePoints
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList()));
      Navigator.pop(navigator.currentContext!);
      _state = NetworkState.success;
      controller.animateCamera(
          CameraUpdate.newLatLngBounds(_directions!.bounds, 100.0));
    } else {
      Navigator.pop(navigator.currentContext!);
      _state = NetworkState.success;
    }
    notifyListeners();
  }

  Future<void> markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
      int shipmentId, int qrCode) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/mark-shipment-as-delivered-by-validating-handover-code-ctc',
        true,
        body: {
          'code': qrCode,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        if (json.decode(r.body)['message'] == 'invalid code!') {
          _ctcQrCodeError = true;
        } else {
          _ctcQrCodeError = false;
        }
        _state = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> handleReceivingShipmentByValidatingMerchantToCourierHandoverCode(
      int shipmentId, int qrCode) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/handle-receive-shipment-by-validating-handover-code-mtc',
        true,
        body: {
          'code': qrCode,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        if (json.decode(r.body)['message'] == 'invalid code!') {
          _mtcQrCodeError = true;
        } else {
          _mtcQrCodeError = false;
        }
        _state = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool get mtcQrCodeError => _mtcQrCodeError;

  Future<void> reviewMerchant(
      {int? shipmentId,
      int? rating,
      String? title,
      String? body,
      String? recommend}) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'review-merchant-shipment',
        true,
        body: {
          'shipment_id': shipmentId,
          'rating': rating,
          'title': title,
          'body': body,
          'recommend': recommend,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> markShipmentAsDeliveredToEndCustomerWithoutValidating(
      int shipmentId) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/mark-shipment-as-delivered-without-handover-validation',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> refreshHandoverQrcodeCourierToMerchant(int shipmentId) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/refresh-handover-qrcode-ctm',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _refreshQrCode = RefreshQrcode.fromJson(json.decode(r.body));
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> onMyWayToGetShipment(int shipmentId) async {
    try {
      _state = NetworkState.waiting;
      Response r = await HttpHelper.instance.httpPost(
        'shipments/$shipmentId/on-the-way-to-get-shipment-from-merchant',
        true,
      );
      log('onMyWayToGetShipment -> ${r.body}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        log('onMyWayToGetShipment success -> ${r.body}');
        _state = NetworkState.success;
      } else {
        _state = NetworkState.error;
      }
    } catch (e) {
      log('onMyWayToGetShipment error -> ${e.toString()}');
    }
    notifyListeners();
  }

  RefreshQrcode? get refreshQrCode => _refreshQrCode;

  Future<void> trackUser({
    required BuildContext context,
    required GoogleMapController controller,
    required LatLng newLocation,
  }) async {
    ByteData trackingByteData = await DefaultAssetBundle.of(context)
        .load("assets/images/tracking_car_super_small.png");
    var trackingIcon = trackingByteData.buffer.asUint8List();
    _markers.removeWhere((Marker m) => m.markerId.value == 'tracking');
    _markers.add(Marker(
      markerId: const MarkerId('tracking'),
      icon: BitmapDescriptor.bytes(trackingIcon),
      position: newLocation,
    ));
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: newLocation,
      zoom: 17.0,
    )));
    _newLocation = newLocation;
    notifyListeners();
  }

  Set<Marker> get markers => _markers;

  NetworkState? get state => _state;

  Directions? get directions => _directions;

  Set<Polyline> get polyLines => _polyLines;

  bool get ctcQrCodeError => _ctcQrCodeError;
}
