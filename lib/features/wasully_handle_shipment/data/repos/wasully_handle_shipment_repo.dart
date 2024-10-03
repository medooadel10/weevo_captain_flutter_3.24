import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../Models/refresh_qr_code.dart';
import '../../../../Storage/shared_preference.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/data_result.dart';
import '../../../../core/networking/dio_factory.dart';

class WasullyHandleShipmentRepo {
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
      await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliy/$shipmentId/handle-receive-shipment-by-validating-handover-code-mtc',
        data: {'code': qrCode},
        token: token,
      );

      return DataResult.success(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        if (e.response!.data['message'] == 'invalid code!') {
          return DataResult.failure(
              'الكود الذي أدخلته غير صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري');
        }
      }

      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }

  Future<DataResult<void>>
      markShipmentAsDeliveredByValidatingCourierToCustomerHandoverCode(
          int shipmentId, int qrCode) async {
    final token = Preferences.instance.getAccessToken;
    try {
      await DioFactory.postData(
        url:
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliy/$shipmentId/mark-shipment-as-delivered-by-validating-handover-code-ctc',
        data: {'code': qrCode},
        token: token,
      );

      return DataResult.success(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
      } else {
        if (e.response!.data['message'] == 'invalid code!') {
          return DataResult.failure(
              'الكود الذي أدخلته غير صحيح\nيرجي التأكد من الكود\nوأعادة المحاولة مرة آخري');
        }
      }
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
            '${ApiConstants.baseUrl}/api/v1/captain/wasuliy/review-merchant-shipment',
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
    } on DioException catch (e) {
      log('message: ${e.response?.data}');
      return DataResult.failure('حدث خطأ ما, الرجاء المحاولة مرة اخرى');
    }
  }
}
