import 'package:dio/dio.dart';

import '../../../../Storage/shared_preference.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/data_result.dart';
import '../../../../core/networking/dio_factory.dart';
import '../models/available_shipments_response_body.dart';

class AvailableShipmentsRepo {
  Future<DataResult<AvailableShipmentsResponseBody>> getAvailableShipments(
      int page) async {
    final token = Preferences.instance.getAccessToken;
    try {
      final response = await DioFactory.getData(
        url: ApiConstants.availableShipmentsUrl,
        token: token,
        query: {'page': page},
      );
      return DataResult.success(
        AvailableShipmentsResponseBody.fromJson(response.data),
      );
    } on DioException {
      return DataResult.failure('فشل في الاتصال بالسيرفر');
    }
  }
}
