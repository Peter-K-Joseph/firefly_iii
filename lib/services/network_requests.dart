import 'package:firefly_iii/model/enums.dart';
import 'package:firefly_iii/services/network/base_network.dart';

import '../model/user_model.dart';
import 'network/accounts_endpoints.dart';
import 'network/network_endpoints.dart';
import 'network/summary_endpoints.dart';

class NetworkRequests extends BaseNetwork
    with NetworkEndpoints, SummaryEndpoints, AccountsEndpoints {
  @override
  Future<Map<String, dynamic>?> getAuthorisationHeader() async {
    final UserModel account = await BaseNetwork.database.getActiveSession();
    if (account.tokenType == TokenType.personalAccessToken) {
      return {
        'Authorization': 'Bearer ${account.accessToken}',
      };
    }
    return null;
  }

  static Future get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    final response = await BaseNetwork.dio.get(
      url,
      queryParameters: queryParameters,
      data: data,
    );
    return response;
  }
}
