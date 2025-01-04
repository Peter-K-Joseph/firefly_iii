import 'package:firefly_iii/model/transaction_accounts_model.dart';
import 'package:sqflite/sqflite.dart';

class AccountsTable {
  static final _accountsTable = 'transaction_accounts';
  late final Database _db;

  AccountsTable(this._db);

  static String get create => '''
    CREATE TABLE $_accountsTable (
      id TEXT PRIMARY KEY,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      active INTEGER NOT NULL,
      position INTEGER,
      name TEXT NOT NULL,
      type TEXT NOT NULL,
      account_role TEXT,
      currency_id TEXT,
      currency_code TEXT,
      currency_symbol TEXT,
      currency_decimal_places INTEGER,
      current_balance REAL,
      current_balance_date TEXT,
      notes TEXT,
      monthly_payment_date TEXT,
      credit_card_type TEXT,
      account_number TEXT,
      iban TEXT,
      bic TEXT,
      virtual_balance REAL,
      opening_balance REAL,
      opening_balance_date TEXT,
      liability_type TEXT,
      liability_direction TEXT,
      interest REAL,
      interest_period TEXT,
      current_debt REAL,
      include_net_worth INTEGER NOT NULL,
      longitude REAL,
      latitude REAL,
      zoom_level INTEGER,
      self_link TEXT,
      uri TEXT
  );''';

  Future insert(TransactionAccountsModel account) async => await _db.insert(
        _accountsTable,
        account.toDatabaseSchema(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future insertAll(List<TransactionAccountsModel> accounts) async {
    final batch = _db.batch();
    for (final account in accounts) {
      batch.insert(
        _accountsTable,
        account.toDatabaseSchema(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<TransactionAccountsModel> selectById(int id) async {
    final List<Map<String, dynamic>> accounts = await _db.query(
      _accountsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return TransactionAccountsModel.fromDatabaseSchema(accounts.first);
  }

  Future<List<TransactionAccountsModel>> selectTableBy(
      TransactionAccountsModel searchparam, bool matchAny,
      {bool ignoreCase = true}) async {
    final whereClauses = <String>[];
    final whereArgs = <dynamic>[];

    final fields = searchparam.toDatabaseSchema();

    fields.forEach((key, value) {
      if (value != null) {
        if (value is String && value.isNotEmpty) {
          whereClauses.add('$key LIKE ? ${ignoreCase ? 'COLLATE NOCASE' : ''}');
          whereArgs.add(value);
        } else if (value is int || value is double) {
          whereClauses.add('$key = ?');
          whereArgs.add(value);
        } else if (value is DateTime) {
          whereClauses.add('$key = ?');
          whereArgs.add(value.toIso8601String());
        }
      }
    });

    final whereString = whereClauses.isNotEmpty
        ? whereClauses.join(matchAny ? ' OR ' : ' AND ')
        : null;

    final List<Map<String, dynamic>> query = await _db.query(
      _accountsTable,
      where: whereString,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    print('Query: $query: whereString: $whereString, whereArgs: $whereArgs');

    return query
        .map((map) => TransactionAccountsModel.fromDatabaseSchema(map))
        .toList();
  }

  Future<List<TransactionAccountsModel>> selectAll() async {
    final List<Map<String, dynamic>> accounts = await _db.query(_accountsTable);
    return accounts
        .map((e) => TransactionAccountsModel.fromDatabaseSchema(e))
        .toList();
  }
}
