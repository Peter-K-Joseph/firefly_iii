import 'package:dio/dio.dart';
import 'package:firefly_iii/services/database.dart';

abstract class BaseNetwork {
  Future<Map<String, dynamic>?> getAuthorisationHeader();
  static Dio dio = Dio();
  static DatabaseService database = DatabaseService();
}
