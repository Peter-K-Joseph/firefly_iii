/// A model representing the 'About' information of the API.
///
/// This model contains the data for /api/v1/about/
///
/// The [AboutModel] class has the following properties:
/// - [version]: The version of the application.
/// - [apiVersion]: The version of the API.
/// - [phpVersion]: The version of PHP being used.
/// - [os]: The operating system on which the application is running.
/// - [driver]: The driver being used.
///
/// The [AboutModel] class also includes a factory constructor
/// [AboutModel.fromJson] to create an instance from a JSON object.
/// 
class AboutModel {
  final String version;
  final String apiVersion;
  final String phpVersion;
  final String os;
  final String driver;

  AboutModel({
    required this.version,
    required this.apiVersion,
    required this.phpVersion,
    required this.os,
    required this.driver,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    json = json['data'];
    return AboutModel(
      version: json['version'],
      apiVersion: json['api_version'],
      phpVersion: json['php_version'],
      os: json['os'],
      driver: json['driver'],
    );
  }
}