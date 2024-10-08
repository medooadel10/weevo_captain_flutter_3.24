import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../Models/refresh_qr_code.dart';
import '../../data/repos/wasully_handle_shipment_repo.dart';

part 'wasully_handle_shipment_state.dart';

class WasullyHandleShipmentCubit extends Cubit<WasullyHandleShipmentState> {
  final WasullyHandleShipmentRepo _wasullyHandleShipmentRepo;
  WasullyHandleShipmentCubit(this._wasullyHandleShipmentRepo)
      : super(WasullyHandleShipmentInitial());

  String qrCodeErrorMsg = '';

  Future<void> refreshHandoverQrcodeCourierToMerchant(int shipmentId) async {
    emit(WasullyHandleShipmentRefreshQrCodeLoading());
    final result = await _wasullyHandleShipmentRepo
        .refreshHandoverQrcodeCourierToMerchant(shipmentId);
    if (result.success!) {
      qrCodeErrorMsg = '';
      emit(WasullyhandleShipmentRefreshQrCodeSuccess(result.data!));
    } else {
      qrCodeErrorMsg = result.error!;
      emit(WasullyHandleShipmentRefreshQrCodeError(result.error!));
    }
  }

  Future<void>
      handleReceiveShipmentByValidatingHandoverCodeFromMerchantToCourier(
          int shipmentId, int qrCode, String locationId, String slug) async {
    emit(WasullyHandleShipmentValidateQrCodeLoading());
    final result = await _wasullyHandleShipmentRepo
        .handleReceiveShipmentByValidatingHandoverCodeFromMerchantToCourier(
            shipmentId, qrCode);
    if (result.success!) {
      try {
        await FirebaseFirestore.instance
            .collection('locations')
            .doc(locationId)
            .set({
          'status': 'receivedShipment',
          'shipmentId': slug,
        });
        emit(WasullyHandleShipmentValidateQrCodeSuccess());
      } on FirebaseException {
        emit(WasullyHandleShipmentValidateQrCodeError(result.error!));
      }
    } else {
      emit(WasullyHandleShipmentValidateQrCodeError(result.error!));
    }
  }

  Future<void> markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
      int shipmentId, int qrCode, String locationId, String slug) async {
    emit(WasullyHandleShipmentValidateQrCodeLoading());
    final result = await _wasullyHandleShipmentRepo
        .markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
            shipmentId, qrCode);
    if (result.success!) {
      try {
        await FirebaseFirestore.instance
            .collection('locations')
            .doc(locationId)
            .set(
          {
            'status': 'closed',
            'shipmentId': slug,
          },
        );
        emit(WasullyHandleShipmentValidateQrCodeSuccess());
      } on FirebaseException {
        emit(WasullyHandleShipmentValidateQrCodeError(result.error!));
      }
    } else {
      log('message: ${result.error!}');
      emit(WasullyHandleShipmentValidateQrCodeError(result.error!));
    }
  }

  Future<void> reviewMerchant({
    int? shipmentId,
    int? rating,
    String? title,
    String? body,
    String? recommend,
  }) async {
    emit(WasullyHandleShipmentReviewMerchantLoading());
    final result = await _wasullyHandleShipmentRepo.reviewMerchant(
      shipmentId: shipmentId,
      rating: rating,
      title: title,
      body: body,
      recommend: recommend,
    );
    if (result.success!) {
      emit(WasullyHandleShipmentReviewMerchantSuccess());
    } else {
      emit(
        WasullyHandleShipmentReviewMerchantError(
          result.error!,
        ),
      );
    }
  }
}
