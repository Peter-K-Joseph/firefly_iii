import 'package:firefly_iii/model/apis/api_endpoints/autocomplete_endpoint.dart';
import 'package:firefly_iii/model/apis/api_endpoints/available_budgets.dart';
import 'package:firefly_iii/model/enums.dart';

import 'api_endpoints/accounts_endpoint.dart';
import 'api_schema.dart';

class ApiEndpoint {
  ApiEndpointSchema about =
      ApiEndpointSchema(method: APIMethod.get, path: '/api/v1/about');
  ApiEndpointSchema user =
      ApiEndpointSchema(method: APIMethod.get, path: '/api/v1/about/user');
  ApiEndpointSchema summary =
      ApiEndpointSchema(method: APIMethod.get, path: '/api/v1/summary/basic');

  AccountsEndpoint accounts = AccountsEndpoint();
  AutocompleteEndpoint autocomplete = AutocompleteEndpoint();
  AvailableBudgets availableBudgets = AvailableBudgets();
}
