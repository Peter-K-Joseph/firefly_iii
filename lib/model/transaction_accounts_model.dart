class TransactionAccountsModel {
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final bool? active;
  final dynamic position;
  final String? name;
  final String? type;
  final dynamic accountRole;
  final String? currencyId;
  final String? currencyCode;
  final String? currencySymbol;
  final int? currencyDecimalPlaces;
  final double? currentBalance;
  final DateTime? currentBalanceDate;
  final dynamic notes;
  final dynamic monthlyPaymentDate;
  final dynamic creditCardType;
  final String? accountNumber;
  final dynamic iban;
  final String? bic;
  final double? virtualBalance;
  final double? openingBalance;
  final DateTime? openingBalanceDate;
  final dynamic liabilityType;
  final dynamic liabilityDirection;
  final double? interest;
  final dynamic interestPeriod;
  final dynamic currentDebt;
  final bool? includeNetWorth;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic zoomLevel;
  final String? selfLink;
  final String? uri;

  TransactionAccountsModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.active,
    this.position,
    this.name,
    this.type,
    this.accountRole,
    this.currencyId,
    this.currencyCode,
    this.currencySymbol,
    this.currencyDecimalPlaces,
    this.currentBalance,
    this.currentBalanceDate,
    this.notes,
    this.monthlyPaymentDate,
    this.creditCardType,
    this.accountNumber,
    this.iban,
    this.bic,
    this.virtualBalance,
    this.openingBalance,
    this.openingBalanceDate,
    this.liabilityType,
    this.liabilityDirection,
    this.interest,
    this.interestPeriod,
    this.currentDebt,
    this.includeNetWorth,
    this.longitude,
    this.latitude,
    this.zoomLevel,
    this.selfLink,
    this.uri,
  });

  factory TransactionAccountsModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? date) =>
        date != null ? DateTime.parse(date) : null;

    double? tryParseDouble(String? value) =>
        value != null ? double.parse(value) : null;

    return TransactionAccountsModel(
      id: json['id'],
      createdAt: json['attributes']['created_at'],
      updatedAt: json['attributes']['updated_at'],
      active: json['attributes']['active'],
      position: json['attributes']['order'],
      name: json['attributes']['name'],
      type: json['attributes']['type'],
      accountRole: json['attributes']['account_role'],
      currencyId: json['attributes']['currency_id'],
      currencyCode: json['attributes']['currency_code'],
      currencySymbol: json['attributes']['currency_symbol'],
      currencyDecimalPlaces: json['attributes']['currency_decimal_places'],
      currentBalance: double.parse(json['attributes']['current_balance']),
      currentBalanceDate:
          parseDate(json['attributes']['current_balance_date']) ??
              DateTime.now(),
      notes: json['attributes']['notes'],
      monthlyPaymentDate: parseDate(json['attributes']['monthly_payment_date']),
      creditCardType: json['attributes']['credit_card_type'],
      accountNumber: json['attributes']['account_number'],
      iban: json['attributes']['iban'],
      bic: json['attributes']['bic'],
      virtualBalance: double.parse(json['attributes']['virtual_balance']),
      openingBalance: double.parse(json['attributes']['opening_balance']),
      openingBalanceDate: parseDate(json['attributes']['opening_balance_date']),
      liabilityType: json['attributes']['liability_type'],
      liabilityDirection: json['attributes']['liability_direction'],
      interest: tryParseDouble(json['attributes']['interest']),
      interestPeriod: json['attributes']['interest_period'],
      currentDebt: json['attributes']['current_debt'],
      includeNetWorth: json['attributes']['include_net_worth'],
      longitude: json['attributes']['longitude'],
      latitude: json['attributes']['latitude'],
      zoomLevel: json['attributes']['zoom_level'],
      selfLink: json['links']['self'],
      uri: json['links']['0']['uri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': {
        'created_at': createdAt,
        'updated_at': updatedAt,
        'active': active,
        'order': position,
        'name': name,
        'type': type,
        'account_role': accountRole,
        'currency_id': currencyId,
        'currency_code': currencyCode,
        'currency_symbol': currencySymbol,
        'currency_decimal_places': currencyDecimalPlaces,
        'current_balance': currentBalance,
        'current_balance_date': currentBalanceDate,
        'notes': notes,
        'monthly_payment_date': monthlyPaymentDate,
        'credit_card_type': creditCardType,
        'account_number': accountNumber,
        'iban': iban,
        'bic': bic,
        'virtual_balance': virtualBalance,
        'opening_balance': openingBalance,
        'opening_balance_date': openingBalanceDate,
        'liability_type': liabilityType,
        'liability_direction': liabilityDirection,
        'interest': interest,
        'interest_period': interestPeriod,
        'current_debt': currentDebt,
        'include_net_worth': includeNetWorth,
        'longitude': longitude,
        'latitude': latitude,
        'zoom_level': zoomLevel,
      },
      'links': {
        'self': selfLink,
        '0': {'uri': uri},
      },
    };
  }

  // Convert to database schema format
  Map<String, dynamic> toDatabaseSchema() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'active': active == null
          ? null
          : active == true
              ? 1
              : 0,
      'position': position,
      'name': name,
      'type': type,
      'account_role': accountRole,
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'currency_decimal_places': currencyDecimalPlaces,
      'current_balance': currentBalance,
      'current_balance_date': currentBalanceDate?.toIso8601String(),
      'notes': notes,
      'monthly_payment_date': monthlyPaymentDate,
      'credit_card_type': creditCardType,
      'account_number': accountNumber,
      'iban': iban,
      'bic': bic,
      'virtual_balance': virtualBalance,
      'opening_balance': openingBalance,
      'opening_balance_date': openingBalanceDate?.toIso8601String(),
      'liability_type': liabilityType,
      'liability_direction': liabilityDirection,
      'interest': interest,
      'interest_period': interestPeriod,
      'current_debt': currentDebt,
      'include_net_worth': includeNetWorth == null
          ? null
          : includeNetWorth == true
              ? 1
              : 0,
      'longitude': longitude,
      'latitude': latitude,
      'zoom_level': zoomLevel,
      'self_link': selfLink,
      'uri': uri,
    };
  }

  factory TransactionAccountsModel.fromDatabaseSchema(
      Map<String, dynamic> json) {
    DateTime? parseDate(String? date) =>
        date != null ? DateTime.parse(date) : null;

    return TransactionAccountsModel(
      id: json['id'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      active: json['active'] == 1,
      position: json['position'],
      name: json['name'],
      type: json['type'],
      accountRole: json['account_role'],
      currencyId: json['currency_id'].toString(),
      currencyCode: json['currency_code'],
      currencySymbol: json['currency_symbol'],
      currencyDecimalPlaces: json['currency_decimal_places'],
      currentBalance: json['current_balance'],
      currentBalanceDate: parseDate(json['current_balance_date']),
      notes: json['notes'],
      monthlyPaymentDate: json['monthly_payment_date'],
      creditCardType: json['credit_card_type'],
      accountNumber: json['account_number'],
      iban: json['iban'],
      bic: json['bic'],
      virtualBalance: json['virtual_balance'],
      openingBalance: json['opening_balance'],
      openingBalanceDate: parseDate(json['opening_balance_date']),
      liabilityType: json['liability_type'],
      liabilityDirection: json['liability_direction'],
      interest: json['interest'],
      interestPeriod: json['interest_period'],
      currentDebt: json['current_debt'],
      includeNetWorth: json['include_net_worth'] == 1,
      longitude: json['longitude'],
      latitude: json['latitude'],
      zoomLevel: json['zoom_level'],
      selfLink: json['self_link'],
      uri: json['uri'],
    );
  }
}
