import 'package:dio/dio.dart';
import 'package:firefly_iii/model/user_model.dart';

import '../../model/apis/api_endpoint.dart';
import 'base_network.dart';

mixin SummaryEndpoints on BaseNetwork {
  static final ApiEndpoint networkEndpoints = ApiEndpoint();

  Future<Map<String, dynamic>> getSummary({
    DateTime? start,
    DateTime? end,
  }) async {
    end = end ?? DateTime.now();
    start = start ?? DateTime(end.year, 1, 1);

    try {
      final UserModel account = await BaseNetwork.database.getActiveSession();
      final response = await BaseNetwork.dio.get(
        '${account.link!}${networkEndpoints.summary.path}',
        queryParameters: {
          'start': '${start.year}-${start.month}-${start.day}',
          'end': '${end.year}-${end.month}-${end.day}',
        },
        options: Options(
          headers: await getAuthorisationHeader(),
        ),
      );
      if (response.data.runtimeType.toString() != '_Map<String, dynamic>') {
        throw Exception('An exception was raised');
      }
      return response.data;
    } catch (e) {
      throw Exception('An exception was raised $e');
    }
  }
}
