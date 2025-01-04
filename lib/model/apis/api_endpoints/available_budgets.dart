import '../../enums.dart';
import '../api_schema.dart';

class AvailableBudgets {
  ApiEndpointSchema availableBudgets = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/available-budgets');
  ApiEndpointSchema availableBudgetsByID = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/available-budgets/{id}');
}
