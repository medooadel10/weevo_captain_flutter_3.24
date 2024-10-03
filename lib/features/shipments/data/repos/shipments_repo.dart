import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../Storage/shared_preference.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/data_result.dart';
import '../../../../core/networking/dio_factory.dart';
import '../models/shipments_response_body.dart';

class ShipmentsRepo {
  Future<DataResult<ShipmentsResponseBody>> getShipments(
      String status, int page) async {
    final String token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
        url: ApiConstants.myShipmentsUrl,
        token: token,
        query: {
          'status': status,
          'page': page,
        },
      );
      log(response.data.toString());
      return DataResult.success(ShipmentsResponseBody.fromJson(response.data));
    } on DioException {
      return DataResult.failure('فشل في الاتصال بالسيرفر');
    } catch (e) {
      log('Error is $e');
      return DataResult.failure('فشل في الاتصال بالسيرفر');
    }
  }
}
