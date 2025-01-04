import 'dart:async';

import 'package:firefly_iii/model/apis/api_response/about_model.dart';
import 'package:firefly_iii/model/apis/api_response/about_user_model.dart';
import 'package:firefly_iii/model/enums.dart';
import 'package:firefly_iii/model/user_model.dart';
import 'package:firefly_iii/services/database.dart';
import 'package:firefly_iii/services/network_requests.dart';
import 'package:firefly_iii/services/validator/url_validator.dart';
import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final ValueNotifier<bool?> validURL = ValueNotifier(null);
  final ValueNotifier<bool?> validToken = ValueNotifier(null);
  final ValueNotifier<int> step = ValueNotifier(1);
  TokenType? tokenType;
  Timer? _debounce;
  AboutModel? aboutModel;
  AboutUserModel? aboutUserModel;
  WhatWentWrongAtLogin? error;

  LoginController() {
    urlController.value =
        TextEditingValue(text: "https://backend.nuvie.in/public");
    tokenType = TokenType.personalAccessToken;
    step.value = 1;
    tokenController.value = TextEditingValue(
        text:
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZWY0YWRiOWMwMzAxMzZhMDZhN2MxN2JjNjI0NjFhMjI4OGUxNTg5NDY2ZDQxNGU0MzFlZDliNDZlZmFlNmU2MDkzNGNhZjczZjNlMzNkNTAiLCJpYXQiOjE3MzMwOTc4ODQuMjg3NTA2LCJuYmYiOjE3MzMwOTc4ODQuMjg3NTEsImV4cCI6MTc2NDYzMzg4NC4wODgwNDQsInN1YiI6IjEiLCJzY29wZXMiOltdfQ.mljd1_StNnWmLg7PRqGfhKQwAMFOGV6SjFyN3-WmgpNACcBfUduSOtaK46w7DVAQdIre9P3DLW0ce6N3EQHEaHCuOU7YZ5f_cYLG75x968bjkKd72ZdgyAy59ASWz6cLT_ASCvx0Zpn2lGIKveDfT3J1nnV7Atp1zhnBzOaW3XWMv-jQysyrtPD_Ar9MSFQ15TevyIVGM56GdgHyvINaf8WpGve5IUb3IN2y8bdRa60dqMcr6_bgm6OgZMcbaHQIlAokZC1FxkOkPN3BsKlQKxVNADMhG1tQ1Zykt9x4vFQRe67ZWQtV8m4V92mI7Jt81UcNudECnnbdmlGSpJcNNX-1xKpGWFSB8aYJoijNY8YI-2tNFAB1iaTDkADXBjQdV9swmUhSAbspBDzp9exuZ62GNDvUbznzcGuu3639AixeEyQVv2ZmVWDR6l63Gll3B2f1fg4VTOVxAi96gcb3jSFey3L3IYyOjEFfTpwKkQIVOlaB8qNagLfJyblw8kL2lS_JANKgBYgJA3sQb-yVcuyZDpFmsok17qa3iD8Y5uEDEX86UNCak9nWxbcB8-J0VRMYL5ZRgqHNNSMtvlXtDoE3Vjwff6YqzL-Hpmh8jzFPpxY7o6JcI6-0mRYk6te6f4sSa0kfSIl8S3zW0nJx5bfD1Bk7C4D-FJZT8rxK6tE");
  }

  void validateUrl(String value) {
    _debounce?.cancel();
    validURL.value = null;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      validURL.value = UrlValidator.isValid(value);
      notifyListeners();
    });
  }

  void validateURLField() async {
    step.value = 0;
    notifyListeners();

    final url = urlController.text;
    final isValid = UrlValidator.isValid(url);

    if (!isValid) {
      validURL.value = false;
      step.value = 1;
    } else {
      final domainExists = await UrlValidator.domainExists(url);
      validURL.value = domainExists;
      step.value = domainExists ? 2 : 1;
    }
    notifyListeners();
  }

  void setTokenType(TokenType type) {
    tokenType = type;
    step.value = 3;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    urlController.dispose();
    tokenController.dispose();
    super.dispose();
  }

  Future<void> validateAndLogin() async {
    step.value = 0;
    notifyListeners();

    if (tokenType == TokenType.personalAccessToken) {
      if (tokenController.text.isEmpty) {
        validToken.value = false;
        return;
      }

      try {
        final response = await NetworkRequests().isTokenValid(
          urlController.text,
          tokenController.text,
        );
        final userDetails = await NetworkRequests().getUserDetails(
          urlController.text,
          tokenController.text,
        );

        if (response is AboutModel && userDetails is AboutUserModel) {
          validToken.value = true;
          step.value = 5;
          aboutModel = response;
          aboutUserModel = userDetails;
        } else {
          validToken.value = false;
          error = response;
          step.value = 4;
        }
      } catch (e) {
        step.value = 4;
        validToken.value = false;
        error = WhatWentWrongAtLogin.loginFailed;
      }
    }
    notifyListeners();
  }

  void goToStep(int value) {
    step.value = value;
    notifyListeners();
  }

  Future<bool> addAccountToDatabase() async {
    try {
      UserModel model = UserModel(
        link: urlController.text,
        accessToken: tokenController.text,
        name: nameController.text,
        email: aboutUserModel!.email,
        tokenType: tokenType,
        isDefault: true,
      );
      await DatabaseService().systemAccounts.insertTable(model);
      return true;
    } catch (e) {
      return false;
    }
  }
}
