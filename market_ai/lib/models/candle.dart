import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';

import 'package:interactive_chart/interactive_chart.dart';
import 'package:isar/isar.dart';

import 'package:market_ai/services/services.dart';
import 'package:market_ai/presenters/presenters.dart';
import 'candle_adapter.dart';
import 'collections.dart';
import 'isac.dart';

// import 'package:market_ai/utils/utils.dart';

class Candle {
  // Singleton implementation
  static final Candle _instance = Candle._();
  factory Candle() => _instance;
  Candle._();

  Future<List<CandleData>> init({String? stockSymbol}) {
    stockSymbol ??= MainPresenter.to.financialInstrumentSymbol.value;
    MainPresenter.to.hasCandleData.value = false;
    MainPresenter.to.trendMatched.value = false;
    MainPresenter.to.hasSubsequentAnalytics.value = false;
    // print(stockSymbol);
    return CandleAdapter().listListTolistCandledata(
        Candle().checkAPIProvider(stockSymbol: stockSymbol));
  }

  Future<String> getCsv({required String stockSymbol}) async {
    String dummyData = '''
Date,Open,High,Low,Close,Adj Close,Volume
1993-01-29,43.968750,43.968750,43.750000,43.937500,24.763748,1003200
1993-02-01,43.968750,44.250000,43.968750,44.250000,24.939869,480500
1993-02-02,44.218750,44.375000,44.125000,44.343750,24.992701,201300
1993-02-03,44.343750,44.437500,43.875000,44.156250,24.888395,529400
1993-02-04,44.062500,44.093750,43.843750,44.000000,24.804644,531500
1993-02-05,44.000000,44.250000,43.968750,44.218750,24.928959,492100
1993-02-08,44.281250,44.375000,44.125000,44.312500,24.981792,596100
1993-02-09,44.375000,44.625000,44.343750,44.593750,25.133671,1221000
1993-02-10,44.593750,44.812500,44.531250,44.781250,25.238012,379600
1993-02-11,44.750000,44.843750,44.625000,44.812500,25.254572,439900
1993-02-12,44.750000,44.843750,44.625000,44.718750,25.201738,417500
1993-02-16,44.687500,44.843750,44.625000,44.687500,25.185177,480900
1993-02-17,44.687500,44.843750,44.625000,44.750000,25.218217,201400
1993-02-18,44.781250,45.000000,44.750000,44.968750,25.342535,469200
1993-02-19,45.000000,45.218750,44.906250,45.156250,25.446873,291000
1993-02-22,45.156250,45.156250,44.968750,45.031250,25.369432,671100
1993-02-23,45.031250,45.156250,44.968750,44.968750,25.336390,240900
1993-02-24,44.750000,44.875000,44.656250,44.718750,25.201738,405400
1993-02-25,44.718750,44.843750,44.625000,44.718750,25.201738,298300
1993-02-26,44.625000,44.750000,44.531250,44.625000,25.148905,323700
1993-03-01,44.625000,44.750000,44.531250,44.562500,25.115864,327900
1993-03-02,44.593750,44.687500,44.468750,44.656250,25.168697,279100
1993-03-03,44.625000,44.656250,44.375000,44.500000,25.084946,255800
1993-03-04,44.437500,44.531250,44.312500,44.375000,25.007506,329200
1993-03-05,44.281250,44.375000,44.125000,44.312500,24.974464,294000
1993-03-08,44.343750,44.468750,44.281250,44.312500,24.974464,260900
1993-03-09,44.375000,44.468750,44.156250,44.218750,24.921631,424500
1993-03-10,44.156250,44.468750,44.125000,44.375000,25.005381,366000
1993-03-11,44.375000,44.468750,44.281250,44.375000,25.005381,272700
1993-03-12,44.281250,44.375000,44.125000,44.218750,24.921631,259800
1993-03-15,44.187500,44.281250,44.062500,44.156250,24.888589,228900
1993-03-16,44.187500,44.312500,44.093750,44.125000,24.872028,198400
1993-03-17,44.156250,44.218750,43.906250,44.093750,24.855467,548800
1993-03-18,44.062500,44.218750,43.968750,44.000000,24.802634,358500
1993-03-19,43.968750,44.062500,43.906250,43.968750,24.786074,386400
1993-03-22,43.968750,44.062500,43.875000,43.906250,24.753032,201400
1993-03-23,43.906250,44.000000,43.781250,43.781250,24.675592,203500
1993-03-24,43.781250,43.781250,43.625000,43.625000,24.591841,257200
1993-03-25,43.625000,43.625000,43.375000,43.375000,24.457188,355600
1993-03-26,43.375000,43.375000,43.187500,43.250000,24.379747,493600
1993-03-29,43.250000,43.312500,43.062500,43.156250,24.326914,342200
1993-03-30,43.156250,43.218750,43.031250,43.093750,24.293872,330000
1993-03-31,43.125000,43.281250,43.062500,43.156250,24.326914,448400
1993-04-01,43.156250,43.250000,43.031250,43.156250,24.326914,416600
''';

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
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print(response.body.runtimeType);
        return response.body;
      } else {
        MainPresenter.to.marketDataProviderMsg.value =
            '${response.statusCode} error from';
        MainPresenter.to.isMarketDataProviderErr.value = true;
        return dummyData;
      }
    } on Exception catch (e) {
      MainPresenter.to.marketDataProviderMsg.value =
          '$e: Failed to connect to market data provider';
      MainPresenter.to.isMarketDataProviderErr.value = true;
      return dummyData;
    }
  }

  Future<List<Map<String, dynamic>>> getJSON(
      {required String stockSymbol}) async {
    List<Map<String, dynamic>> dummyData = [
      {
        "time_key": 1464168660,
        "open": 116.59,
        "high": 116.62,
        "low": 116.51,
        "close": 116.54,
        "volume": 184907
      },
      {
        "time_key": 1464168720,
        "open": 116.54,
        "high": 116.58,
        "low": 116.49,
        "close": 116.57,
        "volume": 108004
      },
      {
        "time_key": 1464168780,
        "open": 116.57,
        "high": 116.61,
        "low": 116.56,
        "close": 116.56,
        "volume": 48004
      },
      {
        "time_key": 1464168840,
        "open": 116.56,
        "high": 116.59,
        "low": 116.54,
        "close": 116.57,
        "volume": 72004
      },
      {
        "time_key": 1464168900,
        "open": 116.57,
        "high": 116.62,
        "low": 116.55,
        "close": 116.61,
        "volume": 89004
      },
      {
        "time_key": 1464168960,
        "open": 116.61,
        "high": 116.66,
        "low": 116.58,
        "close": 116.63,
        "volume": 128004
      },
      {
        "time_key": 1464169020,
        "open": 116.63,
        "high": 116.68,
        "low": 116.62,
        "close": 116.66,
        "volume": 150004
      },
      {
        "time_key": 1464169080,
        "open": 116.66,
        "high": 116.71,
        "low": 116.64,
        "close": 116.68,
        "volume": 196004
      },
      {
        "time_key": 1464169140,
        "open": 116.68,
        "high": 116.71,
        "low": 116.65,
        "close": 116.69,
        "volume": 210004
      },
      {
        "time_key": 1464169200,
        "open": 116.69,
        "high": 116.72,
        "low": 116.68,
        "close": 116.70,
        "volume": 245004
      },
      {
        "time_key": 1464169260,
        "open": 116.70,
        "high": 116.74,
        "low": 116.69,
        "close": 116.72,
        "volume": 280004
      },
      {
        "time_key": 1464169320,
        "open": 116.72,
        "high": 116.77,
        "low": 116.71,
        "close": 116.75,
        "volume": 316004
      },
      {
        "time_key": 1464169380,
        "open": 116.75,
        "high": 116.79,
        "low": 116.74,
        "close": 116.76,
        "volume": 352004
      },
      {
        "time_key": 1464169440,
        "open": 116.76,
        "high": 116.80,
        "low": 116.75,
        "close": 116.79,
        "volume": 384004
      },
      {
        "time_key": 1464169500,
        "open": 116.79,
        "high": 116.83,
        "low": 116.78,
        "close": 116.82,
        "volume": 412004
      },
      {
        "time_key": 1464169560,
        "open": 116.82,
        "high": 116.85,
        "low": 116.81,
        "close": 116.84,
        "volume": 448004
      },
      {
        "time_key": 1464169620,
        "open": 116.84,
        "high": 116.88,
        "low": 116.83,
        "close": 116.87,
        "volume": 482004
      },
      {
        "time_key": 1464169680,
        "open": 116.87,
        "high": 116.91,
        "low": 116.86,
        "close": 116.90,
        "volume": 516004
      },
      {
        "time_key": 1464169740,
        "open": 116.90,
        "high": 116.93,
        "low": 116.89,
        "close": 116.92,
        "volume": 550004
      },
      {
        "time_key": 1464169800,
        "open": 116.92,
        "high": 116.95,
        "low": 116.91,
        "close": 116.94,
        "volume": 584004
      },
      {
        "time_key": 1464169860,
        "open": 116.94,
        "high": 116.98,
        "low": 116.93,
        "close": 116.97,
        "volume": 618004
      },
      {
        "time_key": 1464169920,
        "open": 116.97,
        "high": 117.01,
        "low": 116.96,
        "close": 117.00,
        "volume": 652004
      },
      {
        "time_key": 1464169980,
        "open": 117.00,
        "high": 117.04,
        "low": 116.99,
        "close": 117.02,
        "volume": 686004
      },
      {
        "time_key": 1464170040,
        "open": 117.02,
        "high": 117.06,
        "low": 117.01,
        "close": 117.05,
        "volume": 720004
      },
      {
        "time_key": 1464170100,
        "open": 117.05,
        "high": 117.09,
        "low": 117.04,
        "close": 117.08,
        "volume": 754004
      },
      {
        "time_key": 1464170160,
        "open": 117.08,
        "high": 117.12,
        "low": 117.07,
        "close": 117.10,
        "volume": 788004
      },
      {
        "time_key": 1464170220,
        "open": 117.10,
        "high": 117.14,
        "low": 117.09,
        "close": 117.13,
        "volume": 822004
      },
      {
        "time_key": 1464170280,
        "open": 117.13,
        "high": 117.17,
        "low": 117.12,
        "close": 117.15,
        "volume": 856004
      },
      {
        "time_key": 1464170340,
        "open": 117.15,
        "high": 117.19,
        "low": 117.14,
        "close": 117.18,
        "volume": 890004
      },
      {
        "time_key": 1464170400,
        "open": 117.18,
        "high": 117.22,
        "low": 117.17,
        "close": 117.20,
        "volume": 924004
      },
      {
        "time_key": 1464170460,
        "open": 117.20,
        "high": 117.24,
        "low": 117.19,
        "close": 117.23,
        "volume": 958004
      },
      {
        "time_key": 1464170520,
        "open": 117.23,
        "high": 117.27,
        "low": 117.22,
        "close": 117.25,
        "volume": 992004
      },
      {
        "time_key": 1464170580,
        "open": 117.25,
        "high": 117.29,
        "low": 117.24,
        "close": 117.28,
        "volume": 1026004
      },
      {
        "time_key": 1464170640,
        "open": 117.28,
        "high": 117.32,
        "low": 117.27,
        "close": 117.30,
        "volume": 1060004
      },
      {
        "time_key": 1464170700,
        "open": 117.30,
        "high": 117.34,
        "low": 117.29,
        "close": 117.33,
        "volume": 1094004
      },
      {
        "time_key": 1464170760,
        "open": 117.33,
        "high": 117.37,
        "low": 117.32,
        "close": 117.35,
        "volume": 1128004
      },
      {
        "time_key": 1464170820,
        "open": 117.35,
        "high": 117.39,
        "low": 117.34,
        "close": 117.38,
        "volume": 1162004
      },
      {
        "time_key": 1464170880,
        "open": 117.38,
        "high": 117.42,
        "low": 117.37,
        "close": 117.40,
        "volume": 1196004
      },
      {
        "time_key": 1464170940,
        "open": 117.40,
        "high": 117.44,
        "low": 117.39,
        "close": 117.43,
        "volume": 1230004
      },
      {
        "time_key": 1464171000,
        "open": 117.43,
        "high": 117.47,
        "low": 117.42,
        "close": 117.45,
        "volume": 1264004
      }
    ];
    final isar = await IsarService().getIsarInstance();
    dynamic lastDoc;
    int timestamp;
    switch (stockSymbol) {
      case 'SPY':
        // final docs =
        //     await isar.spyDatas.where().filter().openEqualTo(463.39).findAll();
        // for (final doc in docs) {
        //   print(doc.timeKey);
        //   print('---');
        // }
        lastDoc = await isar.spyDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'QQQ':
        lastDoc = await isar.qqqDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'USO':
        lastDoc = await isar.usoDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'GLD':
        lastDoc = await isar.gldDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'SLV':
        lastDoc = await isar.slvDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'IWM':
        lastDoc = await isar.iwmDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'XLK':
        lastDoc = await isar.xlkDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'AAPL':
        lastDoc = await isar.aaplDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'BA':
        lastDoc = await isar.baDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'BAC':
        lastDoc = await isar.bacDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'MCD':
        lastDoc = await isar.mcdDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'NVDA':
        lastDoc = await isar.nvdaDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'MSFT':
        lastDoc = await isar.msftDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'GSK':
        lastDoc = await isar.gskDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'TSLA':
        lastDoc = await isar.tslaDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      case 'AMZN':
        lastDoc = await isar.amznDatas.where().sortByTimeKeyDesc().findFirst();
        break;
      default:
        throw Exception(
            'There is no minute interval data for financial instrument: $stockSymbol');
    }
    if (lastDoc != null) {
      timestamp = await lastDoc.timeKey;
    } else {
      timestamp = 0;
    }

    DateTime downloadStartTime =
        DateTime.now(); // Record the download start time

    try {
      final response =
          await HTTPService().fetchCandleJSON(stockSymbol, timestamp);

      DateTime downloadEndTime = DateTime.now(); // Record the download end time
      // Calculate the time difference
      Duration downloadDuration = downloadEndTime.difference(downloadStartTime);
      int downloadTime = downloadDuration.inMilliseconds;
      MainPresenter.to.candledownloadTime.value = downloadTime;

      // print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        // print(jsonData);
        List<dynamic> stockDataList;
        List<Map<String, dynamic>> docList;
        if (jsonData.containsKey('error')) {
          String err = jsonData['error'];
          if (err == Err.apiKey.name) {
            MainPresenter.to.apiKeyErr.value = err;
            PrefsService.to.prefs
                .setString(SharedPreferencesConstant.apiKeyErr, err);
          }
          if (err.length > 20) {
            MainPresenter.to.marketDataProviderMsg.value =
                '${'Error: $err'.substring(0, 20)}...';
          } else {
            MainPresenter.to.marketDataProviderMsg.value = 'Error: $err';
          }
          MainPresenter.to.isMarketDataProviderErr.value = true;
          return dummyData;
        }
        if (jsonData.containsKey('public_url')) {
          String publicUrl = jsonData['public_url'];
          final res = await HTTPService().getFetchJson(publicUrl);
          jsonData = res;
        }
        if (jsonData.containsKey('message')) {
          if (jsonData['message'] == 'No update required') {
            switch (stockSymbol) {
              case 'SPY':
                final dataList =
                    await isar.spyDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                // print(docList.first.values);
                // print(docList.last.values);
                // for (final doc in docList) {
                //   if (doc['open'] == 463.39) {
                //     print('time_key: ${doc['time_key']}');
                //     print('open: ${doc['open']}');
                //     print('===');
                //   }
                // }
                // print(docList.length);
                break;
              case 'QQQ':
                final dataList =
                    await isar.qqqDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'USO':
                final dataList =
                    await isar.usoDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'GLD':
                final dataList =
                    await isar.gldDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'SLV':
                final dataList =
                    await isar.slvDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'IWM':
                final dataList =
                    await isar.iwmDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'XLK':
                final dataList =
                    await isar.xlkDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'AAPL':
                final dataList =
                    await isar.aaplDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'BA':
                final dataList =
                    await isar.baDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'BAC':
                final dataList =
                    await isar.bacDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'MCD':
                final dataList =
                    await isar.mcdDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'NVDA':
                final dataList =
                    await isar.nvdaDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'MSFT':
                final dataList =
                    await isar.msftDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'GSK':
                final dataList =
                    await isar.gskDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'TSLA':
                final dataList =
                    await isar.tslaDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              case 'AMZN':
                final dataList =
                    await isar.amznDatas.where().sortByTimeKey().findAll();
                docList = dataList.map((data) => data.toJson()).toList();
                break;
              default:
                throw Exception(
                    'Unknown financial instrument symbol: $stockSymbol');
            }
            return docList;
          } else if (jsonData['message'] == 'User data outdated') {
            MainPresenter.to.marketDataProviderMsg.value =
                'User data outdated, please reinstall';
            MainPresenter.to.isMarketDataProviderErr.value = true;
            return dummyData;
          }
        }
        switch (stockSymbol) {
          case 'SPY':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => SpyData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.spyDatas.putAll(stockDataList.cast<SpyData>());
              });
            }
            final dataList =
                await isar.spyDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'QQQ':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => QqqData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.qqqDatas.putAll(stockDataList.cast<QqqData>());
              });
            }
            final dataList =
                await isar.qqqDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'USO':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => UsoData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.usoDatas.putAll(stockDataList.cast<UsoData>());
              });
            }
            final dataList =
                await isar.usoDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'GLD':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => GldData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.gldDatas.putAll(stockDataList.cast<GldData>());
              });
            }
            final dataList =
                await isar.gldDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'SLV':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => SlvData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.slvDatas.putAll(stockDataList.cast<SlvData>());
              });
            }
            final dataList =
                await isar.slvDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'IWM':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => IwmData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.iwmDatas.putAll(stockDataList.cast<IwmData>());
              });
            }
            final dataList =
                await isar.iwmDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'XLK':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => XlkData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.xlkDatas.putAll(stockDataList.cast<XlkData>());
              });
            }
            final dataList =
                await isar.xlkDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'AAPL':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => AaplData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.aaplDatas.putAll(stockDataList.cast<AaplData>());
              });
            }
            final dataList =
                await isar.aaplDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'BA':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => BaData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.baDatas.putAll(stockDataList.cast<BaData>());
              });
            }
            final dataList =
                await isar.baDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'BAC':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => BacData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.bacDatas.putAll(stockDataList.cast<BacData>());
              });
            }
            final dataList =
                await isar.bacDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'MCD':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => McdData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.mcdDatas.putAll(stockDataList.cast<McdData>());
              });
            }
            final dataList =
                await isar.mcdDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'NVDA':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => NvdaData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.nvdaDatas.putAll(stockDataList.cast<NvdaData>());
              });
            }
            final dataList =
                await isar.nvdaDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'MSFT':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => MsftData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.msftDatas.putAll(stockDataList.cast<MsftData>());
              });
            }
            final dataList =
                await isar.msftDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'GSK':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => GskData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.gskDatas.putAll(stockDataList.cast<GskData>());
              });
            }
            final dataList =
                await isar.gskDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'TSLA':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => TslaData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.tslaDatas.putAll(stockDataList.cast<TslaData>());
              });
            }
            final dataList =
                await isar.tslaDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          case 'AMZN':
            if (jsonData['content'] != null && !jsonData['content'].isEmpty) {
              stockDataList = jsonData['content']
                  .map((data) => AmznData.fromJson(data))
                  .toList();
              await isar.writeTxn(() async {
                await isar.amznDatas.putAll(stockDataList.cast<AmznData>());
              });
            }
            final dataList =
                await isar.amznDatas.where().sortByTimeKey().findAll();
            docList = dataList.map((data) => data.toJson()).toList();
            break;
          default:
            throw Exception(
                'Unknown financial instrument symbol: $stockSymbol');
        }
        return docList;
      } else {
        MainPresenter.to.marketDataProviderMsg.value =
            '${response.statusCode} error from server';
        MainPresenter.to.isMarketDataProviderErr.value = true;
        return dummyData;
      }
    } on Exception catch (e) {
      MainPresenter.to.marketDataProviderMsg.value =
          '$e: Failed to connect to market data provider';
      MainPresenter.to.isMarketDataProviderErr.value = true;
      return dummyData;
    }
  }

  (Future<List<List<dynamic>>>, SrcFileType) checkAPIProvider(
      {required String stockSymbol}) {
    bool hasMinuteData = MainPresenter.to.minuteDataList.contains(stockSymbol);
    MainPresenter.to.hasMinuteData.value = hasMinuteData;
    MainPresenter.to.marketDataProviderMsg.value = 'mkt_data'.tr;
    MainPresenter.to.isMarketDataProviderErr.value = false;
    if (MainPresenter.to.apiKey.value == '' ||
        MainPresenter.to.apiKeyErr.value != '' ||
        !MainPresenter.to.alwaysShowMinuteData.value ||
        !hasMinuteData) {
      return (
        CandleAdapter().csvToListList(getCsv(stockSymbol: stockSymbol)),
        SrcFileType.csv
      );
    } else {
      return (
        CandleAdapter().jsonToListList(getJSON(stockSymbol: stockSymbol)),
        SrcFileType.json
      );
    }
  }

  computeTrendLines({List<CandleData>? listCandledata}) {
    listCandledata ??= MainPresenter.to.listCandledata;

    if (MainPresenter.to.hasMinuteData.value &&
        MainPresenter.to.alwaysShowMinuteData.value) {
      final wma5 = computeEMA(listCandledata, 5);
      final wma10 = computeEMA(listCandledata, 10);
      final wma15 = computeEMA(listCandledata, 15);
      final wma20 = computeEMA(listCandledata, 20);

      for (int i = 0; i < listCandledata.length; i++) {
        listCandledata[i].trends = [
          wma5[i],
          wma10[i],
          wma15[i],
          wma20[i],
        ];
      }
    } else {
      final ma5 = computeSMA(listCandledata, 5);
      final ma20 = computeSMA(listCandledata, 20);
      final ma60 = computeSMA(listCandledata, 60);
      final ma120 = computeSMA(listCandledata, 120);
      final ma240 = computeSMA(listCandledata, 240);

      for (int i = 0; i < listCandledata.length; i++) {
        listCandledata[i].trends = [
          ma5[i],
          ma20[i],
          ma60[i],
          ma120[i],
          ma240[i],
        ];
      }
    }
  }

  removeTrendLines({List<CandleData>? listCandledata}) {
    listCandledata ??= MainPresenter.to.listCandledata;
    for (final data in listCandledata) {
      data.trends = [];
    }
  }

  /// Computes the Exponential Moving Average (EMA) for the given data.
  static List<double?> computeEMA(List<CandleData> data, [int period = 7]) {
    // If data length is less than the period, return nulls.
    if (data.length < period) return List.filled(data.length, null);

    final List<double?> result = [];
    final List<double?> emaValues = [];

    // Calculate the initial SMA for the first [period] data points.
    final firstPeriod =
        data.take(period).map((d) => d.close).whereType<double>();
    double sma = firstPeriod.reduce((a, b) => a + b) / firstPeriod.length;

    // Initialize EMA with the initial SMA value.
    emaValues.add(sma);
    result.addAll(List.filled(period - 1, null));
    result.add(sma);

    // Calculate the multiplier for weighting the EMA.
    final double multiplier = 2 / (period + 1);

    // Compute the EMA for the rest of the data points.
    for (int i = period; i < data.length; i++) {
      final curr = data[i].close;
      if (curr != null) {
        sma = (curr - sma) * multiplier + sma;
        emaValues.add(sma);
        result.add(sma);
      } else {
        emaValues.add(null);
        result.add(null);
      }
    }

    return result;
  }

  /// Efficient Updating Method not Sliding Window Method
  /// Computes the Simple Moving Average (SMA) for the given data.
  static List<double?> computeSMA(List<CandleData> data, [int period = 7]) {
    // If data length is less than the period, return nulls.
    if (data.length < period) return List.filled(data.length, null);

    final List<double?> result = [];

    // Calculate the initial SMA for the first [period] data points.
    final initialPeriod =
        data.take(period).map((d) => d.close).whereType<double>();
    double ma = initialPeriod.reduce((a, b) => a + b) / initialPeriod.length;
    result.addAll(List.filled(period - 1, null));
    result.add(ma);

    // Compute the moving average for the rest of the data points.
    for (int i = period; i < data.length; i++) {
      final curr = data[i].close;
      final prev = data[i - period].close;
      if (curr != null && prev != null) {
        ma = (ma * period + curr - prev) / period;
        result.add(ma);
      } else {
        result.add(null);
      }
    }
    return result;
  }
}
