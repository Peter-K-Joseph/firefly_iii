import 'package:firefly_iii/model/user_model.dart';
import 'package:firefly_iii/model/variables.dart';
import 'package:firefly_iii/services/database/user_accounts_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'database/accounts_table.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;
  late SystemUserAccountsTable systemAccounts;
  late AccountsTable accountsTable;
  UserModel? activeUser;

  Future<bool> waitUntilInitialised() async {
    if (_db != null) {
      return true;
    }
    return await init().then((value) {
      return value != null;
    });
  }

  Future<UserModel> getActiveSession() async {
    if (activeUser != null) {
      return activeUser!;
    }

    final user = UserModel(isDefault: true);
    final account =
        (await systemAccounts.selectTableBy(user, true)).firstOrNull;
    if (account != null) {
      activeUser = account;
      return account;
    }

    throw Exception('No active session found');
  }

  Future<Database?> init() async {
    if (_db != null) {
      return _db;
    }

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'firefly_iii.db');
    _db = await openDatabase(
      path,
      version: Versioning.database,
      onCreate: (db, version) async {
        await db.execute(SystemUserAccountsTable.create);
        await db.execute(AccountsTable.create);
      },
    ).then((value) {
      systemAccounts = SystemUserAccountsTable(value);
      accountsTable = AccountsTable(value);
      return value;
    });

    return _db;
  }
}
