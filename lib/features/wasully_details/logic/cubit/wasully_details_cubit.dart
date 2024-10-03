import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Providers/auth_provider.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../main.dart';
import '../../../available_shipments/data/models/available_shipment_model.dart';
import '../../data/models/wasully_apply_shipment_request.dart';
import '../../data/models/wasully_apply_shipment_response.dart';
import '../../data/models/wasully_model.dart';
import '../../data/models/wasully_offer_request_body.dart';
import '../../data/repos/wasully_details_repo.dart';
import 'wasully_details_state.dart';

class WasullyDetailsCubit extends Cubit<WasullyDetailsState> {
  final WasullyDetailsRepo _wasullyDetailsRepo;
  WasullyDetailsCubit(this._wasullyDetailsRepo)
      : super(WasullyDetailsInitialState());

  WasullyModel? wasullyModel;

  Future<void> getWassullyDetails(int id) async {
    emit(WasullyDetailsLoadingState());
    final result = await _wasullyDetailsRepo.getWasullyDetails(id);
    if (result.success!) {
      wasullyModel = result.data;
      emit(WasullyDetailsSuccessState(wasullyModel!));
    } else {
      emit(WasullyDetailsErrorState(result.error!));
    }
  }

  final offerController = TextEditingController();
  void sendOffer(int id) async {
    if (state is WasullyDetailsSendOfferLoadingState) return;
    emit(WasullyDetailsSendOfferLoadingState());
    final result = await _wasullyDetailsRepo.sendWasullyOffer(
      WasullyOfferRequestBody(
        id,
        offerController.text,
      ),
    );
    if (result.success!) {
      log(result.data!.data.id.toString());
      if (result.data != null) {
        final updateResult = await _wasullyDetailsRepo.updateWasullyOffer(
          result.data!.data.id,
          double.parse(offerController.text),
        );
        if (updateResult.success!) {
          emit(WasullyDetailsSendOfferSuccessState(result.data!));
        } else {
          emit(WasullyDetailsSendOfferErrorState(updateResult.error!));
        }
      } else {
        emit(WasullyDetailsSendOfferSuccessState(result.data!));
      }
    } else {
      emit(WasullyDetailsSendOfferErrorState(result.error!));
    }
  }

  void applyShipment({AvailableShipmentModel? model}) async {
    if (state is WasullyDetailsApplyShipmentLoadingState) return;
    emit(WasullyDetailsApplyShipmentLoadingState());
    final result = await _wasullyDetailsRepo.applyShipment(
      WasullyApplyShipmentRequestBody(
        model != null ? model.id : wasullyModel!.id,
      ),
    );
    if (result.success ?? false) {
      WeevoCaptain.facebookAppEvents.logInitiatedCheckout(
        totalPrice: model != null
            ? num.parse(model.amount!).toDouble()
            : num.parse(wasullyModel!.amount).toDouble(),
        currency: 'EGP',
      );
      sentNotifications(result.data!);
      emit(WasullyDetailsApplyShipmentSuccessState());
    } else {
      emit(WasullyDetailsApplyShipmentErrorState(result.error!));
    }
  }

  Future<void> sentNotifications(WasullyApplyShipmentResponse data) async {
    final result = await _wasullyDetailsRepo.sentNotificationData(data);
    if (result.success!) {
      await _wasullyDetailsRepo.sendNotification(
          title: 'ويفو وفرلك كابتن',
          body:
              'الكابتن ${data.captainModel.name} قبل طلب الشحن وتم خصم مقدم الطلب',
          toToken: result.data!,
          image: data.captainModel.photo != null
              ? data.captainModel.photo!.isNotEmpty
                  ? data.captainModel.photo!.contains(ApiConstants.baseUrl)
                      ? data.captainModel.photo ?? ''
                      : '${ApiConstants.baseUrl}/${data.captainModel.photo}'
                  : ''
              : '',
          data: ShipmentTrackingModel(
            shipmentId: data.id,
            hasChildren: 0,
          ).toJson(),
          screenTo: 'shipment_screen',
          type: '');
    } else {
      emit(WasullyDetailsApplyShipmentErrorState(result.error!));
    }
  }

  Future<void> cancelShipment() async {
    if (state is WasullyDetailsCancelShipmentLoadingState) return;
    emit(WasullyDetailsCancelShipmentLoadingState());
    final result = await _wasullyDetailsRepo.cancelShipment(
      wasullyModel!.id,
    );
    if (result.success!) {
      String courierPhoneNumber = Preferences.instance.getPhoneNumber;
      String merchantPhoneNumber = wasullyModel!.merchant.phone!;
      String locationId =
          '$courierPhoneNumber-$merchantPhoneNumber-${wasullyModel!.id}';
      await FirebaseFirestore.instance
          .collection('locations')
          .doc(locationId)
          .set(
        {
          'status': 'closed',
          'shipmentId': wasullyModel!.slug,
        },
      );
      emit(WasullyDetailsCancelShipmentSuccessState(result.data!));
    } else {
      emit(WasullyDetailsCancelShipmentErrorState(result.error!));
    }
  }

  Future<void> changeShipmentToOnMyWay() async {
    if (state is WasullyDetailsOnMyWayLoadingState) return;
    emit(WasullyDetailsOnMyWayLoadingState());
    final result = await _wasullyDetailsRepo.onMyWay(
      wasullyModel!.id,
    );
    if (result.success!) {
      emit(WasullyDetailsOnMyWaySuccessState());
    } else {
      emit(WasullyDetailsOnMyWayErrorState(result.error!));
    }
  }

  void handleShipment(AuthProvider authProvider) async {
    try {
      emit(WasullyDetailshandleShipmentLoadingState());
      DocumentSnapshot userToken = await FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(wasullyModel?.merchant.id.toString())
          .get();
      String merchantNationalId = userToken['national_id'];
      emit(WasullyDetailshandleShipmentSuccessState(merchantNationalId));
    } catch (e) {
      emit(WasullyDetailshandleShipmentErrorState(e.toString()));
    }
  }
}
