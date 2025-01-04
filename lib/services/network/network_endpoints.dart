import 'package:dio/dio.dart';
import 'package:firefly_iii/model/enums.dart';
import 'package:firefly_iii/services/network/base_network.dart';

import '../../model/apis/api_endpoint.dart';
import '../../model/apis/api_response/about_model.dart';
import '../../model/apis/api_response/about_user_model.dart';

mixin NetworkEndpoints on BaseNetwork {
  static final ApiEndpoint networkEndpoints = ApiEndpoint();

  Future isTokenValid(
    String url,
    String token,
  ) async {
    try {
      final response = await BaseNetwork.dio.get(
        '$url${networkEndpoints.about.path}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return AboutModel.fromJson(response.data);
        } else {
          throw WhatWentWrongAtLogin.unexpectedResponse;
        }
      } else {
        throw WhatWentWrongAtLogin.loginFailed;
      }
    } catch (e) {
      throw WhatWentWrongAtLogin.loginFailed;
    }
  }

  Future getUserDetails(
    String url,
    String token,
  ) async {
    try {
      final response = await BaseNetwork.dio.get(
        '$url${networkEndpoints.user.path}',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return AboutUserModel.fromJson(response.data);
        } else {
          throw WhatWentWrongAtLogin.unexpectedResponse;
        }
      } else {
        throw WhatWentWrongAtLogin.loginFailed;
      }
    } catch (e) {
      throw WhatWentWrongAtLogin.loginFailed;
    }
  }
}
