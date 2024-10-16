import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';

import '../../../../Dialogs/rating_dialog.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../core/router/router.dart';
import '../../data/models/shipment_details_model.dart';
import '../../data/repos/shipment_details_repo.dart';

part 'shipment_details_cubit.freezed.dart';
part 'shipment_details_state.dart';

class ShipmentDetailsCubit extends Cubit<ShipmentDetailsState> {
  final ShipmentDetailsRepo _shipmentDetailsRepo;
  ShipmentDetailsCubit(this._shipmentDetailsRepo)
      : super(const ShipmentDetailsState.initial());

  ShipmentDetailsModel? shipmentDetails;

  Future<void> getShipmentDetails(int shipmentId,
      {bool clearShipment = true}) async {
    if (clearShipment) shipmentDetails = null;
    emit(const ShipmentDetailsState.loading());
    log('get shipment details');
    final result = await _shipmentDetailsRepo.getShipmentDetails(shipmentId);
    if (result.success) {
      log(result.data?.toJson().toString() ?? 'Null');
      shipmentDetails = result.data!;
      emit(ShipmentDetailsState.success(result.data!));
    } else {
      emit(ShipmentDetailsState.error(result.error));
    }
  }

  int currentProductIndex = 0;
  void changeProductIndex(int index) {
    currentProductIndex = index;
    emit(ShipmentDetailsState.changeProductIndex(index));
  }

  void cancelShipment() async {
    emit(const ShipmentDetailsState.cancelShipmentLoading());
    final result =
        await _shipmentDetailsRepo.cancelShipment(shipmentDetails!.id);
    if (result.success) {
      emit(const ShipmentDetailsState.cancelShipmentSuccess());
    } else {
      emit(ShipmentDetailsState.cancelShipmentError(result.error));
    }
  }

  String courierNationalId = '';
  String merchantNationalId = '';
  String locationId = '';
  String status = '';
  void streamShipmentStatus(BuildContext context) async {
    try {
      DocumentSnapshot courierToken = await FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(shipmentDetails?.merchant?.id.toString())
          .get();
      courierNationalId = Preferences.instance.getPhoneNumber;
      merchantNationalId = courierToken['national_id'];
      if (merchantNationalId.hashCode >= courierNationalId.hashCode) {
        locationId =
            '$merchantNationalId-$courierNationalId-${shipmentDetails?.id}';
      } else {
        locationId =
            '$courierNationalId-$merchantNationalId-${shipmentDetails?.id}';
      }
      FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .snapshots()
          .listen((event) {
        if (event.data() != null && event.data()!['status'] != null) {
          status = event.data()!['status'];
          log('status stream -> $status');
          if (status == 'delivered' && shipmentDetails!.status != 'delivered') {
            AuthProvider authProvider =
                Provider.of(navigator.currentContext!, listen: false);
            MagicRouter.navigateAndPopAll(
/*************  ✨ Codeium Command ⭐  *************/
              /// Streams the shipment status in real-time from the Firestore database for the given shipment.
              /// Listens for changes in the status field of the location document associated with the shipment.
              /// When the status updates to 'delivered', triggers navigation to the RatingDialog for the shipment.
              ///
              /// The location document's ID is determined by the hash codes of the courier and merchant national IDs,
              /// along with the shipment ID. The function also updates the shipment details upon status changes.
              ///
              /// If an error occurs, the locationId is reset to an empty string.
              ///
              /// Parameters:
              /// - `context`: The BuildContext used to retrieve the AuthProvider for navigation and updates.
/******  4211f2bf-ce56-4a24-a9c5-2500b5779564  *******/ RatingDialog(
                model: ShipmentTrackingModel(
                  courierNationalId: courierNationalId,
                  merchantNationalId: merchantNationalId,
                  shipmentId: shipmentDetails!.id,
                  deliveringState: shipmentDetails!.deliveringState.toString(),
                  deliveringCity: shipmentDetails!.deliveringCity.toString(),
                  receivingState: shipmentDetails!.receivingState.toString(),
                  receivingCity: shipmentDetails!.receivingCity.toString(),
                  deliveringLat: shipmentDetails!.deliveringLat,
                  clientPhone: shipmentDetails!.clientPhone,
                  hasChildren: 0,
                  status: shipmentDetails!.status,
                  deliveringLng: shipmentDetails!.deliveringLng,
                  receivingLng: shipmentDetails!.receivingLng,
                  receivingLat: shipmentDetails!.receivingLat,
                  merchantId: shipmentDetails!.merchantId,
                  merchantImage: authProvider.photo,
                  merchantPhone: authProvider.phone,
                  merchantName: authProvider.name,
                  courierId: shipmentDetails!.courierId,
                  paymentMethod: shipmentDetails!.paymentMethod,
                  courierImage: shipmentDetails!.merchant?.photo,
                  courierName: shipmentDetails!.merchant?.name,
                  courierPhone: shipmentDetails!.merchant?.phone,
                  deliveringStreet: shipmentDetails!.deliveringStreet,
                  receivingStreet: shipmentDetails!.receivingStreet,
                ),
              ),
            );
          }
          getShipmentDetails(shipmentDetails!.id, clearShipment: false);
        }
      });
    } catch (e) {
      locationId = '';
    }
  }
}
