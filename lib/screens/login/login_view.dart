import 'package:firefly_iii/model/enums.dart';
import 'package:firefly_iii/screens/login/login_controller.dart';
import 'package:flutter/material.dart';

import '../../components/alert_notify.dart';
import '../../services/helpers/text_handler.dart';
import '../action_success/action_success_view.dart';

class LoginView extends StatelessWidget {
  final LoginController _controller = LoginController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginView({super.key});

  Widget _buildTextFormField({
    required String hintText,
    required String labelText,
    required TextEditingController controller,
    required ValueNotifier<bool?> errorNotifier,
    required String? Function(String?) validator,
    void Function(String)? onChanged,
    double fontSize = 16,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return ValueListenableBuilder<bool?>(
      valueListenable: errorNotifier,
      builder: (context, isValid, child) {
        return TextFormField(
          maxLines: maxLines,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIconColor: isValid == null
                ? Colors.grey.shade800
                : isValid
                    ? Colors.green
                    : Colors.red,
            labelStyle: TextStyle(
              color: isValid == null
                  ? Colors.grey.shade800
                  : isValid
                      ? Colors.green
                      : Colors.red,
            ),
            labelText: labelText,
            floatingLabelStyle: TextStyle(color: Colors.grey.shade800),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: isValid == null
                    ? Colors.grey.shade300
                    : isValid
                        ? Colors.green
                        : Colors.red,
                width: 1.5,
              ),
            ),
            prefixIcon: const Icon(Icons.link_outlined),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: isValid == null
                    ? Colors.grey.shade300
                    : isValid
                        ? Colors.green
                        : Colors.red,
              ),
            ),
            errorText:
                (isValid == null || isValid) ? null : 'Invalid $labelText',
            errorStyle: const TextStyle(color: Colors.red),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.red, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          keyboardType: keyboardType,
          autocorrect: false,
          controller: controller,
          validator: validator,
          onChanged: onChanged,
        );
      },
    );
  }

  Widget _buildElevatedButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFF265be9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 17, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildElevatedIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0XFF265be9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  List<Widget> getCurrentStageWidget(int stage, BuildContext context) {
    switch (stage) {
      case 0:
        return [
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: const Color(0XFF265be9),
                ),
                const SizedBox(height: 15),
                Text(
                  "Verifying Credentials...",
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                const SizedBox(height: 10),
              ],
            ),
          )
        ];
      case 1:
        return [
          _buildTextFormField(
            hintText: "https://demo.firefly-iii.org",
            labelText: "FireFly III URL",
            controller: _controller.urlController,
            errorNotifier: _controller.validURL,
            onChanged: (value) => _controller.validateUrl(value),
            validator: (value) => _controller.validURL.value == false
                ? 'Invalid or unreachable URL'
                : value == null || value.isEmpty
                    ? 'URL cannot be empty'
                    : null,
          ),
          const SizedBox(height: 10),
          _buildElevatedButton(
            text: "Proceed",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _controller.validateURLField();
              }
            },
          ),
        ];
      case 2:
        return [
          Text(
            'Choose method of authentication',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildElevatedIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _controller.goToStep(1);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 4,
                  child: _buildElevatedButton(
                    text: "OAuth",
                    onPressed: () =>
                        _controller.setTokenType(TokenType.oAuthToken),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _buildElevatedButton(
            text: "Personal Access Token",
            onPressed: () =>
                _controller.setTokenType(TokenType.personalAccessToken),
          ),
        ];
      case 3:
        return [
          ..._buildOAuthTokenField(),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildElevatedIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => _controller.goToStep(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: _buildElevatedButton(
                    text: "Login",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _controller.validateAndLogin();
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ];
      case 4:
        return [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            decoration: BoxDecoration(
              color: _controller.error == null
                  ? const Color.fromARGB(255, 0, 153, 5)
                  : const Color.fromARGB(255, 193, 13, 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Center(
                  child: Icon(
                    _controller.error == null
                        ? Icons.check_circle_outline
                        : Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    whatWentWrongText(_controller.error),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 4,
                  child: _buildElevatedButton(
                    text: "Go Back",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _controller.goToStep(3);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 1,
                  child: _buildElevatedIconButton(
                    icon: Icons.refresh,
                    onPressed: () => {
                      _controller.validateAndLogin(),
                    },
                  ),
                ),
              ],
            ),
          ),
        ];
      case 5:
        return [
          Text(
            "Yayy! You're now logged in as ${_controller.aboutUserModel!.email}",
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Let's start by naming this instance.",
          ),
          const SizedBox(height: 10),
          _buildTextFormField(
            hintText: "My FireFly III",
            labelText: "Instance Name",
            controller: _controller.nameController,
            errorNotifier: ValueNotifier(null),
            validator: (value) => value == null || value.isEmpty
                ? 'Instance name cannot be empty'
                : null,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildElevatedIconButton(
                    icon: Icons.cancel_outlined,
                    onPressed: () => {},
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  flex: 4,
                  child: _buildElevatedButton(
                    text: "Add Account",
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          await _controller.addAccountToDatabase()) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ActionSuccessView(
                              title: "Account Added",
                              message: "You can now start using FireFly III",
                              execute: () => {
                                Navigator.of(context).popUntil(
                                  (route) => route.isFirst,
                                ),
                              },
                            ),
                          ),
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Couldn't add account. Please try again.",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ];
      default:
        return [const Text('Unknown stage')];
    }
  }

  String whatWentWrongText(WhatWentWrongAtLogin? error) {
    if (error == null) {
      return "Login Successful";
    }
    switch (error) {
      case WhatWentWrongAtLogin.loginFailed:
        return "Login failed.\nPlease check your token and try again.";
      case WhatWentWrongAtLogin.unexpectedResponse:
        return "Couldn't verify token using the provided URL. Is the URL correct?";
    }
  }

  Widget getHelperWidget(int stage) {
    switch (stage) {
      case 2:
        return const AlertNotifier(
          type: "info",
          text: "You can find this in Options > Profile > OAuth",
        );
      case 5:
        return AlertNotifier(
          type: "success",
          text:
              "FireFly v${_controller.aboutModel!.version} | API v${_controller.aboutModel!.apiVersion}\nUser ID: ${_controller.aboutUserModel!.id} | Role: ${TextHandler.capitalize(_controller.aboutUserModel!.role)}",
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                  maxHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login to\nFireFly III",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ValueListenableBuilder<int>(
                          valueListenable: _controller.step,
                          builder: (context, step, child) {
                            return Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...getCurrentStageWidget(step, context),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      const Expanded(child: Divider()),
                                      const SizedBox(width: 10),
                                      Text(
                                        [0, 4, 5].contains(step)
                                            ? '💫'
                                            : "Step $step of 3",
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Expanded(child: Divider()),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  getHelperWidget(step),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildOAuthTokenField() {
    switch (_controller.tokenType) {
      case TokenType.oAuthToken:
        return [
          AlertNotifier(
            text: "OAuth Token isnt implemented",
            type: "danger",
          )
        ];
      case TokenType.personalAccessToken:
        return [
          _buildTextFormField(
            hintText: "***",
            labelText: "Personal Access Token",
            controller: _controller.tokenController,
            errorNotifier: _controller.validToken,
            onChanged: _controller.validToken.value = null,
            validator: (value) => _controller.validToken.value == false
                ? 'Invalid Token'
                : value == null || value.isEmpty
                    ? 'Token cannot be empty'
                    : null,
            maxLines: 5,
            fontSize: 12,
          )
        ];
      default:
        return [const Text('Unknown token type')];
    }
  }
}
