import '../enums.dart';

class ApiEndpointSchema {
  final APIMethod method;
  final String _path;
  final Map<String, dynamic>? parameters;
  bool Function(Map<String, dynamic> parameters)? validator;

  ApiEndpointSchema({
    required this.method,
    required String path,
    this.parameters,
    this.validator,
  }) : _path = path;

  String get path {
    if (parameters != null) {
      var resolvedPath = _path;
      parameters!.forEach((key, value) {
        resolvedPath = resolvedPath.replaceAll('{$key}', value.toString());
      });
      return resolvedPath;
    }
    return _path;
  }
}
