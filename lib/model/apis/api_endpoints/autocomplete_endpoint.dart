import '../../enums.dart';
import '../api_schema.dart';

class AutocompleteEndpoint {
  ApiEndpointSchema accounts = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/accounts');
  ApiEndpointSchema bills = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/bills');
  ApiEndpointSchema budgets = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/budgets');
  ApiEndpointSchema categories = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/categories');
  ApiEndpointSchema currencies = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/currencies');
  ApiEndpointSchema tags = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/tags');
  ApiEndpointSchema transactions = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/transactions');
  ApiEndpointSchema transactionTypes = ApiEndpointSchema(
      method: APIMethod.get, path: '/api/v1/autocomplete/transaction-types');
}
