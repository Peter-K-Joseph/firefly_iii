import 'dart:developer';
import 'package:firefly_iii/services/database.dart';
import 'package:flutter/material.dart';
import '../../model/transaction_accounts_model.dart';
import '../../services/network_requests.dart';

class AccountController extends ChangeNotifier {
  final NetworkRequests _networkRequests = NetworkRequests();
  final DatabaseService _databaseService = DatabaseService();
  final ValueNotifier<int> signalUpdate = ValueNotifier(0);
  final ValueNotifier<String> searchQuery = ValueNotifier('');
  final ValueNotifier<bool> isFetchingData = ValueNotifier(false);
  final ValueNotifier<bool> isLoadingMore = ValueNotifier(false);
  final ValueNotifier<List<MapEntry<String, List<TransactionAccountsModel>>>>
      paginatedData = ValueNotifier([]);

  Map<String, List<TransactionAccountsModel>> _allAccounts = {};
  int _page = 0;
  final int _pageSize = 10;

  void updateIsFetchingData(bool value) {
    isFetchingData.value = value;
    notifyListeners();
  }

  Future<void> fetchAllAccounts() async {
    resetPagination();
    updateIsFetchingData(true);
    try {
      final accounts = await _networkRequests.getAllAccounts();
      await _databaseService.accountsTable.insertAll(accounts);
      final accountsMap = _groupAccountsByName(accounts);
      _allAccounts = accountsMap;
      loadMore();
    } catch (e) {
      log('Error fetching accounts: $e');
    } finally {
      updateIsFetchingData(false);
    }
  }

  Map<String, List<TransactionAccountsModel>> _groupAccountsByName(
      List<TransactionAccountsModel> accounts) {
    final Map<String, List<TransactionAccountsModel>> accountsMap = {};
    for (var account in accounts) {
      if (accountsMap.containsKey(account.name)) {
        accountsMap[account.name]!.add(account);
      } else {
        accountsMap[account.name!] = [account];
      }
    }
    return accountsMap;
  }

  // Function to load more data with pagination
  void loadMore() {
    if (_allAccounts.isEmpty) return;
    if (isLoadingMore.value) return;

    updateIsFetchingData(true);
    final startIndex = _page * _pageSize;
    final endIndex = startIndex + _pageSize > _allAccounts.length
        ? _allAccounts.length
        : startIndex + _pageSize;

    final entries = _allAccounts.entries
        .skip(startIndex)
        .take(endIndex - startIndex < 0 ? 0 : endIndex - startIndex)
        .toList();
    paginatedData.value.addAll(entries);
    paginatedData.notifyListeners();

    _page++;
    updateIsFetchingData(false);
  }

  // Reset pagination and reload the data
  void resetPagination() {
    _page = 0;
    paginatedData.value.clear();
    paginatedData.notifyListeners();
    loadMore();
  }

  void applySearchFilter() async {
    final query = searchQuery.value.toLowerCase();
    if (query.isEmpty) {
      resetPagination();
    } else {
      final filteredAccounts = await _databaseService.accountsTable
          .selectTableBy(TransactionAccountsModel(name: '%$query%'), true);

      paginatedData.value.clear();
      paginatedData.value
          .addAll(_groupAccountsByName(filteredAccounts).entries);
      paginatedData.notifyListeners();
    }
  }
}
