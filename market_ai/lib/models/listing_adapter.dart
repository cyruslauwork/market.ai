import 'package:flutter/material.dart';
import 'package:market_ai/presenters/presenters.dart';

// import 'package:market_ai/utils/utils.dart';

class ListingAdapter {
  // Singleton implementation
  static final ListingAdapter _instance = ListingAdapter._();
  factory ListingAdapter() => _instance;
  ListingAdapter._();

  List<Map<String, dynamic>> jsonsToJson(
      List<Map<String, dynamic>> parsedResponses) {
    List<Map<String, dynamic>> json = [];

    try {
      for (var parsedResponse in parsedResponses) {
        var rows = parsedResponse['data']['table']['rows'];
        if (rows is List) {
          for (var row in rows) {
            if (row is Map<String, dynamic>) {
              json.add(row);
            }
          }
        }
      }
    } catch (e) {
      MainPresenter.to.listingErr.value =
          'Unable to fetch listings from api.nasdaq.com due to maintenance: $e';
    }
    // log(json.toString());
    return json;
  }

  Future<List<SymbolAndName>> jsonToSymbolAndName(
      Future<List<Map<String, dynamic>>> futureJson) async {
    List<Map<String, dynamic>> json = await futureJson;
    List<SymbolAndName> listSymbolAndName;

    listSymbolAndName = json
        .map((row) => SymbolAndName(
              symbol: row['symbol'].toString(),
              name: row['name'].toString(),
            ))
        .where((symbolAndName) =>
            !symbolAndName.symbol.contains('/') &&
            !symbolAndName.symbol.contains('^'))
        .toList();

    // Check if target financial instruments are not in the list and insert it if necessary
    bool containsUSO =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'USO');
    if (!containsUSO) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'USO',
              name: 'UNITED STATES OIL FUND LP UNITS(POST REV SPLIT)'));
    }
    bool containsQQQ =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'QQQ');
    if (!containsQQQ) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'QQQ', name: 'INVESCO QQQ TRUST UNIT SER 1'));
    }
    bool containsIWM =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'IWM');
    if (!containsIWM) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'IWM', name: 'ISHARES TRUST RUSSELL 2000 ETF'));
    }
    bool containsSLV =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'SLV');
    if (!containsSLV) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'SLV', name: 'ISHARES SILVER TRUST ISHARES'));
    }
    bool containsGLD =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'GLD');
    if (!containsGLD) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'GLD', name: 'SPDR GOLD TRUST GOLD SHARES NPV'));
    }
    bool containsAAPL = listSymbolAndName
        .any((symbolAndName) => symbolAndName.symbol == 'AAPL');
    if (!containsAAPL) {
      listSymbolAndName.insert(0,
          const SymbolAndName(symbol: 'AAPL', name: 'Apple Inc. Common Stock'));
    }
    bool containsXLK =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'XLK');
    if (!containsXLK) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'XLK',
              name:
                  'SELECT SECTOR SPDR TRUST TECHNOLOGY SELECT SECTOR USD DIS'));
    }
    bool containsGSK =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'GSK');
    if (!containsGSK) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'GSK',
              name:
                  'GSK plc American Depositary Shares (Each representing two Ordinary Shares)'));
    }
    bool containsMCD =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'MCD');
    if (!containsMCD) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'MCD', name: "McDonald's Corporation Common Stock"));
    }
    bool containsBA =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'BA');
    if (!containsBA) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'BA', name: 'Boeing Company (The) Common Stock'));
    }
    bool containsBAC =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'BAC');
    if (!containsBAC) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'BAC', name: 'Bank of America Corporation Common Stock'));
    }
    bool containsNVDA = listSymbolAndName
        .any((symbolAndName) => symbolAndName.symbol == 'NVDA');
    if (!containsNVDA) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'NVDA', name: 'NVIDIA Corporation Common Stock'));
    }
    bool containsMSFT = listSymbolAndName
        .any((symbolAndName) => symbolAndName.symbol == 'MSFT');
    if (!containsMSFT) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'MSFT', name: 'Microsoft Corporation Common Stock'));
    }
    bool containsTSLA = listSymbolAndName
        .any((symbolAndName) => symbolAndName.symbol == 'TSLA');
    if (!containsTSLA) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'TSLA', name: 'Tesla, Inc. Common Stock'));
    }
    bool containsAMZN = listSymbolAndName
        .any((symbolAndName) => symbolAndName.symbol == 'AMZN');
    if (!containsAMZN) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'AMZN', name: 'Amazon.com, Inc. Common Stock'));
    }
    bool containsSPY =
        listSymbolAndName.any((symbolAndName) => symbolAndName.symbol == 'SPY');
    if (!containsSPY) {
      listSymbolAndName.insert(
          0,
          const SymbolAndName(
              symbol: 'SPY',
              name: 'SPDR S&P500 ETF TRUST TRUST UNIT DEPOSITARY RECEIPT'));
    }

    // print(listSymbolAndName);
    return listSymbolAndName;
  }
}

@immutable
class SymbolAndName {
  final String symbol, name;

  const SymbolAndName({required this.symbol, required this.name});

  @override
  String toString() {
    return '$symbol, $name';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SymbolAndName &&
        other.symbol == symbol &&
        other.name == name;
  }

  @override
  int get hashCode => Object.hash(name, symbol);
}
