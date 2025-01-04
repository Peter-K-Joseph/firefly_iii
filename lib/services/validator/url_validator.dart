import 'package:firefly_iii/services/network_requests.dart';

class UrlValidator {
  static bool isValid(String url) {
    if (url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    if (!['http', 'https'].contains(uri.scheme)) return false;
    if (uri.host.isEmpty) return false;

    final urlPattern =
        RegExp(r'^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(:\d+)?(\/.*)?$');
    if (!urlPattern.hasMatch(url)) return false;

    return true;
  }

  static Future<bool> domainExists(String url) async {
    final preCheck = isValid(url);
    if (!preCheck) return preCheck;

    try {
      final response = await NetworkRequests.get(url);
      return response.statusCode == 200 ? true : false;
    } catch (e) {
      return false;
    }
  }
}
