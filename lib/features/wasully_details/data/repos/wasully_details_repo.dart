import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import '../../../../Models/refresh_qr_code.dart';
import '../../../../Models/shipment_tracking_model.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/data_result.dart';
import '../../../../core/networking/dio_factory.dart';
import '../models/wasully_apply_shipment_request.dart';
import '../models/wasully_apply_shipment_response.dart';
import '../models/wasully_cancel_shipment_response.dart';
import '../models/wasully_model.dart';
import '../models/wasully_offer_request_body.dart';
import '../models/wasully_offer_response_body.dart';

class WasullyDetailsRepo {
  Future<DataResult<WasullyModel>> getWasullyDetails(int id) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
          url: '${ApiConstants.wasullyDetails}/$id', token: token);
      return DataResult.success(WasullyModel.fromJson(response.data));
    } on DioException catch (e) {
      log('Error is ${e.response?.data}');
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<WasullyOfferResponseBody>> sendWasullyOffer(
      WasullyOfferRequestBody body) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.wasullySendOfferUrl,
        data: body.toJson(),
        token: token,
      );
      return DataResult.success(
        WasullyOfferResponseBody.fromJson(response.data),
      );
    } on DioException {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>> updateWasullyOffer(
    int offerId,
    double offer,
  ) async {
    final token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.putData(
        url: '${ApiConstants.wasullyShippingOffers}/$offerId/update',
        data: {
          'offer': offer,
        },
        token: token,
      );
      return DataResult.success(null);
    } on DioException catch (e) {
      if (e.response?.data['message'] ==
          'You cannot send a better offer with a value greater than the previous offer!') {
        return DataResult.failure('لا يمكنك ارسال عرض اعلى من العرض السابق');
      }
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<WasullyApplyShipmentResponse>> applyShipment(
      WasullyApplyShipmentRequestBody body) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: ApiConstants.wasullyApplyShipmentUrl,
        data: body.toJson(),
        token: token,
      );
      log('apply shipment response -> ${response.data}');
      return DataResult.success(
        WasullyApplyShipmentResponse.fromJson(response.data),
      );
    } on DioException catch (e) {
      log('apply shipment Error is ${e.response?.data}');
      if (e.response?.data is Map<String, dynamic>) {
        if (e.response?.data['message'] ==
            'Your current balance does not allow for this action!') {
          return DataResult.failure('ليس لديك رصيد كافي للطلب');
        }
      }
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<String>> sentNotificationData(
      WasullyApplyShipmentResponse data) async {
    try {
      DocumentSnapshot userToken = await FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(data.merchantId.toString())
          .get();
      String token = userToken['fcmToken'];
      await FirebaseFirestore.instance
          .collection('merchant_notifications')
          .doc(data.merchantId.toString())
          .collection(data.merchantId.toString())
          .add({
        'read': false,
        'date_time': DateTime.now().toIso8601String(),
        'type': 'cancel_shipment',
        'title': 'ويفو وفرلك كابتن',
        'body':
            'الكابتن ${data.captainModel.name} قبل طلب الشحن وتم خصم مقدم الطلب',
        'user_icon': data.captainModel.photo != null
            ? data.captainModel.photo!.isNotEmpty
                ? data.captainModel.photo!.contains(ApiConstants.baseUrl)
                    ? data.captainModel.photo
                    : '${ApiConstants.baseUrl}/${data.captainModel.photo}'
                : ''
            : '',
        'screen_to': 'shipment_screen',
        'data': ShipmentTrackingModel(
          shipmentId: data.id,
          hasChildren: 0,
        ).toJson(),
      });
      return DataResult.success(token);
    } on FirebaseException {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<WasullyCancelShipmentResponse>> cancelShipment(
      int id) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url: '${ApiConstants.wasullyDetails}/$id/cancel-this-shipment',
        data: {},
        token: token,
      );

      return DataResult.success(
          WasullyCancelShipmentResponse.fromJson(response.data));
    } on DioException {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>> onMyWay(int id) async {
    final token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.postData(
        url:
            '${ApiConstants.wasullyDetails}/$id/on-the-way-to-get-shipment-from-merchant',
        data: {},
        token: token,
      );
      return DataResult.success(null);
    } on DioException {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<RefreshQrcode>> refreshHandoverQrcodeCourierToMerchant(
      int shipmentId) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliys/$shipmentId/refresh-handover-qrcode-ctm',
        data: {},
        token: token,
      );
      return DataResult.success(
        RefreshQrcode.fromJson(response.data),
      );
    } on DioException {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>>
      handleReceiveShipmentByValidatingHandoverCodeFromMerchantToCourier(
          int shipmentId, int qrCode) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliys/$shipmentId/handle-receive-shipment-by-validating-handover-code-mtc',
        data: {'code': qrCode},
        token: token,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataResult.success(null);
      } else if (response.statusCode == 401) {
        return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        if (response.data['message'] == 'invalid code!') {
          return DataResult.failure(
              'الكود الذي أدخلته غير صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري');
        }
      }

      return DataResult.success(null);
    } catch (e) {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>>
      markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
          int shipmentId, int qrCode) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliys/$shipmentId/mark-shipment-as-delivered-by-validating-handover-code-ctc',
        data: {'code': qrCode},
        token: token,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataResult.success(null);
      } else if (response.statusCode == 401) {
        return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        if (response.data['message'] == 'invalid code!') {
          return DataResult.failure(
              'الكود الذي أدخلته غير صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري');
        }
      }

      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    } catch (e) {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>> reviewMerchant({
    int? shipmentId,
    int? rating,
    String? title,
    String? body,
    String? recommend,
  }) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliys/review-merchant-shipment',
        data: {
          'shipment_id': shipmentId,
          'rating': rating,
          'title': title,
          'body': body,
          'recommend': recommend,
        },
        token: token,
      );
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return DataResult.success(null);
      } else if (response.statusCode == 401) {
        return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        return DataResult.failure('أدخل القيم بطريقة صحيحة');
      }
    } on DioException {
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
