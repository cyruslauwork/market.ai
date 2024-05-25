import 'dart:async';
import 'dart:convert';

import 'package:interactive_chart/interactive_chart.dart';

import 'package:market_ai/services/services.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'candle_adapter.dart';

// import 'package:market_ai/utils/utils.dart';

class Candle {
  // Singleton implementation
  static final Candle _instance = Candle._();
  factory Candle() => _instance;
  Candle._();

  Future<List<CandleData>> init({String? stockSymbol}) {
    stockSymbol ??= MainPresenter.to.financialInstrumentSymbol.value;
    // print(stockSymbol);
    return CandleAdapter().listListTolistCandledata(
        Candle().checkAPIProvider(init: true, stockSymbol: stockSymbol));
  }

  Future<String> getCsv({required String stockSymbol}) async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    final response =
        await HTTPService().fetchCandleCsv(stockSymbol: stockSymbol);

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.candledownloadTime.value = downloadTime;

    try {
      if (response.statusCode == 200) {
        // print(response.body.runtimeType);
        return response.body;
      } else {
        MainPresenter.to.marketDataProviderMsg.value =
            '${response.statusCode} error from';
        MainPresenter.to.isMarketDataProviderErr.value = true;
        return 'Date,Open,High,Low,Close,Adj Close,Volume\n1993-01-29,43.968750,43.968750,43.750000,43.937500,24.763748,1003200\n1993-02-01,43.968750,44.250000,43.968750,44.250000,24.939869,480500\n1993-02-02,44.218750,44.375000,44.125000,44.343750,24.992701,201300';
      }
    } on Exception catch (e) {
      MainPresenter.to.marketDataProviderMsg.value =
          '$e: Failed to connect to market data provider';
      MainPresenter.to.isMarketDataProviderErr.value = true;
      return 'Date,Open,High,Low,Close,Adj Close,Volume\n1993-01-29,43.968750,43.968750,43.750000,43.937500,24.763748,1003200\n1993-02-01,43.968750,44.250000,43.968750,44.250000,24.939869,480500\n1993-02-02,44.218750,44.375000,44.125000,44.343750,24.992701,201300';
    }
  }

  Future<List<Map<String, dynamic>>> getJSON() async {
    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    List<Map<String, dynamic>> json = [];

    int apiCallsPerRequest = 5;

    json = MainPresenter.to.json;

    for (int i = 0; i < apiCallsPerRequest; i++) {
      try {
        final response = await HTTPService().fetchCandleJSON();
        if (response.statusCode == 200) {
          // init is false if and only if added new JSON data
          for (var map in jsonDecode(response.body)['results']) {
            if (map is Map<String, dynamic>) {
              json.add(map);
            }
          }
        } else {
          MainPresenter.to.marketDataProviderMsg.value =
              '${response.statusCode} error from';
          MainPresenter.to.isMarketDataProviderErr.value = true;
        }
      } on Exception catch (e) {
        MainPresenter.to.marketDataProviderMsg.value =
            '$e: Failed to connect to market data provider';
        MainPresenter.to.isMarketDataProviderErr.value = true;
      }
    }

    DateTime downloadEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
    int downloadTime = downloadDuration.inMilliseconds;
    MainPresenter.to.candledownloadTime.value = downloadTime;

    MainPresenter.to.json = json; // Record the current JSON

    return json;
  }

  Future<List<List<dynamic>>> checkAPIProvider(
      {required bool init, required String stockSymbol}) {
    if (FlavorService.to.srcFileType == SrcFileType.csv) {
      return CandleAdapter().csvToListList(getCsv(stockSymbol: stockSymbol));
    } else if (FlavorService.to.srcFileType == SrcFileType.json) {
      return CandleAdapter().jsonToListList(getJSON());
    } else {
      throw ArgumentError('Failed to check API provider.');
    }
  }

  computeTrendLines() {
    final ma5 = CandleData.computeMA(MainPresenter.to.listCandledata, 5);
    // final ma10 = CandleData.computeMA(MainPresenter.to.listCandledata, 10);
    final ma20 = CandleData.computeMA(MainPresenter.to.listCandledata, 20);
    final ma60 = CandleData.computeMA(MainPresenter.to.listCandledata, 60);
    final ma120 = CandleData.computeMA(MainPresenter.to.listCandledata, 120);
    final ma240 = CandleData.computeMA(MainPresenter.to.listCandledata, 240);

    for (int i = 0; i < MainPresenter.to.listCandledata.length; i++) {
      MainPresenter.to.listCandledata[i].trends = [
        ma5[i],
        // ma10[i],
        ma20[i],
        ma60[i],
        ma120[i],
        ma240[i],
      ];
    }
  }

  removeTrendLines() {
    for (final data in MainPresenter.to.listCandledata) {
      data.trends = [];
    }
  }
}
