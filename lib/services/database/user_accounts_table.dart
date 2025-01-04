import 'package:firefly_iii/model/enums.dart';
import 'package:firefly_iii/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

class SystemUserAccountsTable {
  static final _accountsTable = 'user_accounts';
  late final Database _db;

  SystemUserAccountsTable(this._db);

  static String get create => '''
    CREATE TABLE $_accountsTable (
      name TEXT PRIMARY KEY,
      email TEXT NOT NULL,
      link TEXT NOT NULL,
      tokenType TEXT CHECK(tokenType IN ('${TokenType.oAuthToken.name}', '${TokenType.personalAccessToken.name}')) NOT NULL,
      accessToken TEXT NOT NULL,
      accessTokenExpiresAt DATETIME,
      refreshToken TEXT,
      oauthClientID TEXT,
      oauthClientSecret TEXT,
      createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
      isDefault INTEGER DEFAULT FALSE
    );
  ''';

  Future insertTable(UserModel user) async => await _db.insert(
        _accountsTable,
        user.toDatabaseFormat(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future updateTable(UserModel user) async => await _db.update(
        _accountsTable,
        user.toDatabaseFormat(),
        where: 'name = ?',
        whereArgs: [user.name],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

  Future deleteTable(UserModel user) async => await _db.delete(
        _accountsTable,
        where: 'name = ?',
        whereArgs: [user.name],
      ).onError((error, stackTrace) async {
        return 0;
      });

  Future<List<UserModel>> selectTable() async {
    final List<Map<String, dynamic>> query = await _db.query(_accountsTable);
    return _fromTable(query);
  }

  Future<bool> doesTableExist() async {
    final List<Map<String, dynamic>> query = await _db.query(
      'sqlite_master',
      where: 'type = ? AND name = ?',
      whereArgs: ['table', _accountsTable],
    );
    return query.isNotEmpty;
  }

  Future<List<UserModel>> selectTableBy(UserModel user, bool matchAny) async {
    final whereClauses = [];
    final whereArgs = [];

    final fields = {
      'name': user.name,
      'email': user.email,
      'link': user.link,
      'tokenType': user.tokenType?.toString(),
      'accessToken': user.accessToken,
      'accessTokenExpiresAt': user.accessTokenExpiresAt?.toIso8601String(),
      'refreshToken': user.refreshToken,
      'oauthClientID': user.oauthClientID,
      'oauthClientSecret': user.oauthClientSecret,
      'isDefault': user.isDefault ? 1 : 0,
    };

    fields.forEach((key, value) {
      if (value != null && (value is String && value.isNotEmpty)) {
        whereClauses.add('$key = ?');
        whereArgs.add(value);
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
    return _fromTable(query);
  }

  List<UserModel> _fromTable(List<Map<String, dynamic>> query) {
    TokenType parseTokenTypeFromString(String tokenType) {
      switch (tokenType) {
        case 'oAuthToken':
          return TokenType.oAuthToken;
        case 'personalAccessToken':
          return TokenType.personalAccessToken;
        default:
          throw Exception('Unknown token type: $tokenType');
      }
    }

    return query.map((e) {
      TokenType type = parseTokenTypeFromString(e['tokenType']);
      assert((type == TokenType.oAuthToken &&
              e['refreshToken'] != null &&
              e['accessTokenExpiresAt'] != null &&
              e['oauthClientID'] != null &&
              e['oauthClientSecret'] != null) ||
          (type == TokenType.personalAccessToken && e['accessToken'] != null));

      return UserModel(
        name: e['name'],
        email: e['email'],
        link: e['link'],
        tokenType: type,
        accessToken: e['accessToken'],
        accessTokenExpiresAt: e['accessTokenExpiresAt'] != null
            ? DateTime.parse(e['accessTokenExpiresAt'])
            : null,
        refreshToken: e['refreshToken'],
        oauthClientID: e['oauthClientID'],
        oauthClientSecret: e['oauthClientSecret'],
        isDefault: e['isDefault'] == 1,
      );
    }).toList();
  }

  Future<bool> createTable() async {
    if (await doesTableExist()) return true;
    try {
      await _db.execute(create);
      return true;
    } catch (e) {
      return false;
    }
  }
}
