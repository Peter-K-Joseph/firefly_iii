import 'package:firefly_iii/model/user_model.dart';
import 'package:firefly_iii/services/network_requests.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';

class PriceModel {
  String? decimal;
  int integer = 0;
  String currency = '₹';
  bool isPostDecimalPoint = false;

  double get value => double.parse('$integer.${decimal ?? '0'}');

  void addValue(int i) =>
      (isPostDecimalPoint) ? _addDecimal(i) : _addInteger(i);

  void _addDecimal(int i) {
    if (decimal != null && decimal!.length >= 2) return;
    decimal = '${decimal ?? ''}$i';
  }

  void _addInteger(int i) {
    int value = integer * 10 + i;

    if (value > 9999999) return;
    integer = integer * 10 + i;
  }

  void addDecimalPoint() => isPostDecimalPoint = true;

  void backSpace() {
    if (decimal != null && decimal!.isNotEmpty) {
      decimal = decimal!.substring(0, decimal!.length - 1);
    } else if ((decimal == null || decimal!.isEmpty) && isPostDecimalPoint) {
      isPostDecimalPoint = false;
    } else {
      decimal = null;
      isPostDecimalPoint = false;
      integer = integer ~/ 10;
    }
  }
}

class HomePageController extends ChangeNotifier {
  ValueNotifier<PriceModel> priceNotifier =
      ValueNotifier<PriceModel>(PriceModel());
  ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);
  ValueNotifier<Color> colorNotifier = ValueNotifier<Color>(Colors.grey);
  ValueNotifier<String?> fromAccountNotifier = ValueNotifier<String?>(null);
  ValueNotifier<String?> toAccountNotifier = ValueNotifier<String?>(null);
  ValueNotifier<List<String>> tagsNotifier = ValueNotifier<List<String>>([]);
  ValueNotifier<String?> descriptionNotifier = ValueNotifier<String?>(null);
  ValueNotifier<String?> categoryNotifier = ValueNotifier<String?>(null);

  final DatabaseService _database = DatabaseService();
  final NetworkRequests _networkRequests = NetworkRequests();
  final ValueNotifier<String> instanceNameNotifier = ValueNotifier<String>('');
  String currency = '-';
  final ValueNotifier<double?> totalAssetValueNotifier =
      ValueNotifier<double?>(null);

  void addDecimalPoint() {
    priceNotifier.value.addDecimalPoint();
    priceNotifier.notifyListeners();
  }

  void addDigit(int digit) {
    priceNotifier.value.addValue(digit);
    priceNotifier.notifyListeners();
  }

  void clearLastPosition() {
    priceNotifier.value.backSpace();
    priceNotifier.notifyListeners();
  }

  void clearAll() {
    priceNotifier.value = PriceModel();
    priceNotifier.notifyListeners();
  }

  Future<void> fetchInstanceName() async {
    final data = await _database.systemAccounts.selectTableBy(
      UserModel(isDefault: true),
      false,
    );
    if (data.isEmpty) {
      throw Exception('No instance found');
    } else {
      instanceNameNotifier.value =
          (data.first.name != null && data.first.name!.isNotEmpty)
              ? data.first.name!
              : 'Unnamed Instance';
    }
    instanceNameNotifier.notifyListeners();
  }

  Future<void> fetchTotalAssetValue() async {
    final summary = await _networkRequests.getSummary(
      start: DateTime.now().subtract(Duration(days: 365)),
      end: DateTime.now(),
    );
    bool found = false;
    for (final key in summary.keys) {
      if (key.contains('net-worth')) {
        found = true;
        currency = summary[key]['currency_symbol'];
        totalAssetValueNotifier.value =
            double.tryParse(summary[key]['monetary_value']);
        break;
      }
    }
    if (!found) {
      currency = '-';
      totalAssetValueNotifier.value = 0.00;
    }
    totalAssetValueNotifier.notifyListeners();
  }

  Future<List<String>> getVendors() async {
    return [
      'Amazon',
      'Flipkart',
      'Myntra',
      'Snapdeal',
      'Paytm',
      'PhonePe',
      'Google Pay',
      'Amazon Pay',
      'Freecharge',
      'Mobikwik',
      'Ola Money',
      'Uber Money',
      'Airtel Money',
      'Jio Money',
      'Paypal',
      'Stripe',
      'Razorpay',
      'PayU',
      'Instamojo',
      'Cashfree',
      'Paytm',
      'PhonePe',
      'Google Pay',
      'Amazon Pay',
      'Freecharge',
      'Mobikwik',
      'Ola Money',
      'Uber Money',
      'Airtel Money',
      'Jio Money',
      'Paypal',
      'Stripe',
      'Razorpay',
      'PayU',
      'Instamojo',
      'Cashfree',
    ];
  }

  HomePageController() {
    Future.delayed(Duration.zero, () async {
      await fetchInstanceName();
      await fetchTotalAssetValue();
    });
  }
}
