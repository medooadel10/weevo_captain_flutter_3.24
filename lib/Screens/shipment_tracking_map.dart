// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Storage/shared_preference.dart';

import '../Models/shipment_tracking_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';

class ShipmentTrackingMap extends StatefulWidget {
  static const String id = 'Shipment_Tracking';
  final ShipmentTrackingModel model;

  const ShipmentTrackingMap({
    super.key,
    required this.model,
  });

  @override
  State<ShipmentTrackingMap> createState() => _ShipmentTrackingMapState();
}

class _ShipmentTrackingMapState extends State<ShipmentTrackingMap> {
  GoogleMapController? _googleMapController;
  String? _mapStyle;
  StreamSubscription<LocationData>? _locationStream;
  String? _locationId;
  String shipmentStatus = 'none';

  @override
  void initState() {
    super.initState();

    _locationId = '${widget.model.courierId}-${widget.model.merchantId}';

    rootBundle.loadString('assets/images/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Consumer<ShipmentTrackingProvider>(
      builder: (ctx, data, ch) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // showModalBottomSheet(
            //     context: context,
            //     enableDrag: true,
            //     builder: (ctx) => TrackingDialog(
            //           model: widget.model,
            //           onMyWayCallback: () async {
            //             Navigator.pop(context);
            //             DocumentSnapshot userToken = await FirebaseFirestore
            //                 .instance
            //                 .collection('merchant_users')
            //                 .doc(widget.model.merchantId.toString())
            //                 .get();
            //             String token = userToken['fcmToken'];
            //             data.sendNotification(
            //                 'الطلب في الطريق اليك',
            //                 'الكابتن ${authProvider.name} في الطريق اليك يرجي التواجد بالمكان',
            //                 token);
            //             _locationStream = authProvider
            //                 .location.onLocationChanged
            //                 .listen((LocationData locationData) async {
            //               data.trackUser(
            //                 context: context,
            //                 controller: _googleMapController,
            //                 newLocation: LatLng(
            //                     locationData.latitude, locationData.longitude),
            //               );
            //               FirebaseFirestore.instance
            //                   .collection('locations')
            //                   .doc(_locationId)
            //                   .set({
            //                 'current_lat': '',
            //                 'current_lng': '',
            //                 'lat': locationData.latitude,
            //                 'lng': locationData.longitude,
            //                 'status': 'tracking',
            //               });
            //             });
            //           },
            //           arrivedCallback: Geolocator.distanceBetween(
            //                       data.newLocation?.latitude,
            //                       data.newLocation?.longitude,
            //                       double.parse(widget.model.deliveringLat),
            //                       double.parse(widget.model.deliveringLng)) <=
            //                   30.0
            //               ? () {
            //                   Navigator.pop(context);
            //                   data.polyLines.clear();
            //                   data.markers.clear();
            //                   setState(() {});
            //                   _locationStream.cancel();
            //                   FirebaseFirestore.instance
            //                       .collection('locations')
            //                       .doc(_locationId)
            //                       .set({
            //                     'current_lat': '',
            //                     'current_lng': '',
            //                     'lat': '',
            //                     'long': '',
            //                     'status': 'arrived',
            //              'shipmentId': model.shipmentId,
            //                   });
            //                 }
            //               : null,
            //         ),
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(20.0),
            //       topRight: Radius.circular(20.0),
            //     )));
          },
          backgroundColor: weevoPrimaryBlueColor,
          child: const Icon(
            Icons.arrow_upward_outlined,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              mapToolbarEnabled: false,
              markers: data.markers,
              compassEnabled: false,
              buildingsEnabled: false,
              initialCameraPosition: CameraPosition(
                  target: LatLng(authProvider.locationData!.latitude!,
                      authProvider.locationData!.latitude!),
                  zoom: 15.0),
              onMapCreated: (GoogleMapController controller) async {
                _googleMapController = controller;
                await _googleMapController?.setMapStyle(_mapStyle);
                // await data.getDirections(
                //   context: context,
                //   controller: controller,
                //   directionFrom: LatLng(widget.model.fromLat, widget.model.fromLng),
                //   directionTo: LatLng(double.parse(widget.model.deliveringLat),
                //       double.parse(widget.model.deliveringLng)),
                // );
                await data.getDirections(
                  context: navigator.currentContext!,
                  controller: controller,
                  directionFrom: LatLng(authProvider.locationData!.latitude!,
                      authProvider.locationData!.longitude!),
                  directionTo: const LatLng(30.5, 31.5),
                );
                FirebaseFirestore.instance
                    .collection('locations')
                    .doc(_locationId)
                    .set({
                  'current_lat': widget.model.fromLat,
                  'current_lng': widget.model.fromLng,
                  'lat': '',
                  'lng': '',
                  'status': 'none',
                });
                // showModalBottomSheet(
                //     context: context,
                //     enableDrag: true,
                //     builder: (ctx) => TrackingDialog(
                //           model: widget.model,
                //           onMyWayCallback: () async {
                //             Navigator.pop(context);
                //             DocumentSnapshot userToken = await FirebaseFirestore
                //                 .instance
                //                 .collection('merchant_users')
                //                 .doc(widget.model.merchantId.toString())
                //                 .get();
                //             String token = userToken['fcmToken'];
                //             await data.sendNotification(
                //                 'الطلب في الطريق اليك',
                //                 'الكابتن ${authProvider.name} في الطريق اليك يرجي التواجد بالمكان',
                //                 token);
                //             _locationStream = authProvider
                //                 .location.onLocationChanged
                //                 .listen((LocationData locationData) async {
                //               data.trackUser(
                //                 context: context,
                //                 controller: _googleMapController,
                //                 newLocation: LatLng(locationData.latitude,
                //                     locationData.longitude),
                //               );
                //               FirebaseFirestore.instance
                //                   .collection('locations')
                //                   .doc(_locationId)
                //                   .set({
                //                 'current_lat': '',
                //                 'current_lng': '',
                //                 'lat': locationData.latitude,
                //                 'lng': locationData.longitude,
                //                 'status': 'tracking',
                //               });
                //             });
                //           },
                //           arrivedCallback: Geolocator.distanceBetween(
                //                       data.newLocation?.latitude,
                //                       data.newLocation?.longitude,
                //                       double.parse(widget.model.deliveringLat),
                //                       double.parse(
                //                           widget.model.deliveringLng)) <=
                //                   30.0
                //               ? () {
                //                   Navigator.pop(context);
                //                   data.polyLines.clear();
                //                   data.markers.clear();
                //                   setState(() {});
                //                   _locationStream.cancel();
                //                   FirebaseFirestore.instance
                //                       .collection('locations')
                //                       .doc(_locationId)
                //                       .set({
                //                     'current_lat': '',
                //                     'current_lng': '',
                //                     'lat': '',
                //                     'long': '',
                //                     'status': 'arrived',
                //         'shipmentId': model.shipmentId,
                //                   });
                //                 }
                //               : null,
                //         ),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(20.0),
                //       topRight: Radius.circular(20.0),
                //     )));
              },
              polylines: data.polyLines,
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
            ),
            data.state == NetworkState.success
                ? SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: weevoPrimaryBlueColor,
                      ),
                      margin: const EdgeInsets.only(top: 10.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        '${data.directions!.totalDistance}  ${data.directions!.totalDuration}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
// ** user information dialog in tracking **
