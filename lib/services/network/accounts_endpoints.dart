import 'package:dio/dio.dart';

import '../../model/apis/api_endpoint.dart';
import '../../model/enums.dart';
import '../../model/transaction_accounts_model.dart';
import '../../model/user_model.dart';
import 'base_network.dart';

mixin AccountsEndpoints on BaseNetwork {
  static final ApiEndpoint networkEndpoints = ApiEndpoint();

  Future<List<TransactionAccountsModel>> getAccountsFromPage({
    int limit = 100,
    int page = 1,
    DateTime? balanceOnDate,
    AccountType? accountType,
    Options? options,
  }) async {
    final UserModel account = await BaseNetwork.database.getActiveSession();
    final result = await BaseNetwork.dio.get(
      '${account.link}${networkEndpoints.accounts.getAccounts.path}',
      queryParameters: {
        'limit': limit,
        'page': page,
        if (balanceOnDate != null) 'date': balanceOnDate.toIso8601String(),
        if (accountType != null) 'type': accountType.toString().split('.').last,
      },
      options: options ??
          Options(
            headers: await getAuthorisationHeader(),
          ),
    );
    if (result.statusCode == 200) {
      return result.data['data']
          .map<TransactionAccountsModel>(
            (e) => TransactionAccountsModel.fromJson(e),
          )
          .toList();
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }

  Future<List<TransactionAccountsModel>> getAllAccounts({
    DateTime? balanceOnDate,
    AccountType? accountType,
  }) async {
    final limit = 400;
    try {
      final Options options = Options(
        headers: await getAuthorisationHeader(),
      );
      final UserModel account = await BaseNetwork.database.getActiveSession();
      final result = await BaseNetwork.dio.get(
        '${account.link}${networkEndpoints.accounts.getAccounts.path}',
        queryParameters: {
          if (balanceOnDate != null) 'date': balanceOnDate.toIso8601String(),
          if (accountType != null)
            'type': accountType.toString().split('.').last,
        },
        options: options,
      );
      if (result.statusCode == 200) {
        final totalList = result.data['meta']['pagination']['total'];
        final List<TransactionAccountsModel> accounts = [];
        final totalPages = (totalList / limit).ceil();
        for (var i = 1; i <= totalPages; i++) {
          final List<TransactionAccountsModel> accountsPerPage =
              await getAccountsFromPage(
            limit: limit,
            page: i,
            balanceOnDate: balanceOnDate,
            accountType: accountType,
            options: options,
          );
          accounts.addAll(accountsPerPage);
        }
        return accounts;
      } else {
        throw Exception('Failed to fetch accounts');
      }
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }
}
