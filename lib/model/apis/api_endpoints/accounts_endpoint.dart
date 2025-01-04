import '../../enums.dart';
import '../api_schema.dart';

class AccountsEndpoint {
  ApiEndpointSchema getAccounts = ApiEndpointSchema(method: APIMethod.get, path: '/api/v1/accounts');
  ApiEndpointSchema createAccount = ApiEndpointSchema(method: APIMethod.post, path: '/api/v1/accounts');
  ApiEndpointSchema getSingleAccount = ApiEndpointSchema(method: APIMethod.get, path: '/api/v1/accounts/{id}');
  ApiEndpointSchema updateAccount = ApiEndpointSchema(method: APIMethod.put, path: '/api/v1/accounts/{id}');
  ApiEndpointSchema deleteAccount = ApiEndpointSchema(method: APIMethod.delete, path: '/api/v1/accounts/{id}');
  ApiEndpointSchema getAccountTransactions = ApiEndpointSchema(method: APIMethod.get, path: '/api/v1/accounts/{id}/transactions');
}