import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../Storage/shared_preference.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/data_result.dart';
import '../../../../core/networking/dio_factory.dart';
import '../models/shipment_details_model.dart';

class ShipmentDetailsRepo {
  Future<DataResult<ShipmentDetailsModel>> getShipmentDetails(
      int shipmentId) async {
    try {
      final response = await DioFactory.getData(
        url: '${ApiConstants.myShipmentsDetailsUrl}/$shipmentId',
        token: Preferences.instance.getAccessToken,
      );
      return DataResult.success(
        ShipmentDetailsModel.fromJson(response.data),
      );
    } on DioException catch (e) {
      return DataResult.failure(
        e.response?.data['message'] ??
            e.message ??
            e.error?.toString() ??
            'حدث خطأ ما, الرجاء المحاولة مرة اخرى',
      );
    }
  }

  Future<DataResult<void>> cancelShipment(int shipmentId) async {
    try {
      await DioFactory.postData(
        url:
            '${ApiConstants.myShipmentsDetailsUrl}/$shipmentId/cancel-this-shipment',
        token: Preferences.instance.getAccessToken,
        data: {},
      );
      return DataResult.success(null);
    } on DioException catch (e) {
      log('cancel shipment error ${e.response?.data['message']}');
      return DataResult.failure(
        e.response?.data['message'] ??
            e.message ??
            e.error?.toString() ??
            'حدث خطأ ما, الرجاء المحاولة مرة اخرى',
      );
    }
  }
}
