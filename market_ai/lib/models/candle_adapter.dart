// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

import 'package:csv/csv.dart';
import 'package:interactive_chart/interactive_chart.dart';

import 'package:market_ai/services/services.dart';
import 'package:market_ai/presenters/presenters.dart';

class CandleAdapter {
  // Singleton implementation
  static final CandleAdapter _instance = CandleAdapter._();
  factory CandleAdapter() => _instance;
  CandleAdapter._();

  Future<List<List<dynamic>>> csvToListList(Future<String> futureCsv) async {
    String csv = await futureCsv;

    List<List<dynamic>> rowsAsListOfValues =
        const CsvToListConverter().convert(csv, eol: '\n');
    rowsAsListOfValues.removeAt(0); // Remove CSV column titles
    return rowsAsListOfValues;
  }

  Future<List<List<dynamic>>> jsonToListList(
      Future<List<Map<String, dynamic>>> futureJson) async {
    List<Map<String, dynamic>> json = await futureJson;
    List<List<dynamic>> rowsAsListOfValues = [];

    for (Map<String, dynamic> map in json) {
      List<dynamic> values = map.values.toList();
      rowsAsListOfValues.add(values);
    }

    return rowsAsListOfValues;
  }

  Future<List<CandleData>> listListTolistCandledata(
      (Future<List<List<dynamic>>>, SrcFileType) param) async {
    List<List<dynamic>> listList = await param.$1;
    MainPresenter.to.candleListList.value = listList;
    late List<CandleData> listCandledata;

    if (!MainPresenter.to.isLockTrend.value) {
      PrefsService.to.prefs.setInt(
          SharedPreferencesConstant.lockTrendLastDatetime,
          MainPresenter.to.candleListList.last[0].toInt());
    }

    MainPresenter.to.lastDatetime.value = MainPresenter.to.getLastDatetime();
    if (param.$2 == SrcFileType.csv) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: TimeService().convertToUnixTimestamp(row[0]) * 1000,
                open: row[1].toDouble(),
                high: row[2].toDouble(),
                low: row[3].toDouble(),
                close: row[4].toDouble(),
                volume: row[6].toDouble(),
              ))
          .toList();
      MainPresenter.to.listCandledata.value = listCandledata;
      MainPresenter.to.hasCandleData.value = true;
      return listCandledata;
    } else if (param.$2 == SrcFileType.json) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: row[0].toInt() * 1000,
                open: row[1].toDouble(),
                high: row[2].toDouble(),
                low: row[3].toDouble(),
                close: row[4].toDouble(),
                volume: row[5].toDouble(),
              ))
          .toList();
      MainPresenter.to.listCandledata.value = listCandledata;
      // final jsonList =
      //     listCandledata.map((candleData) => candleData.toMap()).toList();
      // final jsonString = json.encode(jsonList);

      // final documentsDirectory = await getApplicationDocumentsDirectory();
      // final filePath = '${documentsDirectory.path}/marketai_json/spy_ios.json';
      // final file = File(filePath);
      // await file.create(recursive: true);
      // await file.writeAsString(jsonString);
      MainPresenter.to.hasCandleData.value = true;
      return listCandledata;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }

  Future<List<CandleData>> crossDataListListTolistCandledata(
      (Future<List<List<dynamic>>>, SrcFileType, String) param) async {
    List<List<dynamic>> listList = await param.$1;
    if (param.$3 == 'SPY') {
      MainPresenter.to.spyCandleListList.value = listList;
    } else if (param.$3 == 'QQQ') {
      MainPresenter.to.qqqCandleListList.value = listList;
    } else if (param.$3 == 'USO') {
      MainPresenter.to.usoCandleListList.value = listList;
    } else if (param.$3 == 'GLD') {
      MainPresenter.to.gldCandleListList.value = listList;
    } else if (param.$3 == 'SLV') {
      MainPresenter.to.slvCandleListList.value = listList;
    } else if (param.$3 == 'IWM') {
      MainPresenter.to.iwmCandleListList.value = listList;
    } else if (param.$3 == 'XLK') {
      MainPresenter.to.xlkCandleListList.value = listList;
    } else if (param.$3 == 'AAPL') {
      MainPresenter.to.aaplCandleListList.value = listList;
    } else if (param.$3 == 'BA') {
      MainPresenter.to.baCandleListList.value = listList;
    } else if (param.$3 == 'BAC') {
      MainPresenter.to.bacCandleListList.value = listList;
    } else if (param.$3 == 'MCD') {
      MainPresenter.to.mcdCandleListList.value = listList;
    } else if (param.$3 == 'NVDA') {
      MainPresenter.to.nvdaCandleListList.value = listList;
    } else if (param.$3 == 'MSFT') {
      MainPresenter.to.msftCandleListList.value = listList;
    } else if (param.$3 == 'GSK') {
      MainPresenter.to.gskCandleListList.value = listList;
    } else if (param.$3 == 'TSLA') {
      MainPresenter.to.tslaCandleListList.value = listList;
    } else if (param.$3 == 'AMZN') {
      MainPresenter.to.amznCandleListList.value = listList;
    } else {
      throw Exception('There is no candleListList for ${param.$3}');
    }
    late List<CandleData> listCandledata;

    if (param.$2 == SrcFileType.csv) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: TimeService().convertToUnixTimestamp(row[0]) * 1000,
                open: row[1].toDouble(),
                high: row[2].toDouble(),
                low: row[3].toDouble(),
                close: row[4].toDouble(),
                volume: row[6].toDouble(),
              ))
          .toList();
      if (param.$3 == 'SPY') {
        MainPresenter.to.spyListCandledata.value = listCandledata;
      } else if (param.$3 == 'QQQ') {
        MainPresenter.to.qqqListCandledata.value = listCandledata;
      } else if (param.$3 == 'USO') {
        MainPresenter.to.usoListCandledata.value = listCandledata;
      } else if (param.$3 == 'GLD') {
        MainPresenter.to.gldListCandledata.value = listCandledata;
      } else if (param.$3 == 'SLV') {
        MainPresenter.to.slvListCandledata.value = listCandledata;
      } else if (param.$3 == 'IWM') {
        MainPresenter.to.iwmListCandledata.value = listCandledata;
      } else if (param.$3 == 'XLK') {
        MainPresenter.to.xlkListCandledata.value = listCandledata;
      } else if (param.$3 == 'AAPL') {
        MainPresenter.to.aaplListCandledata.value = listCandledata;
      } else if (param.$3 == 'BA') {
        MainPresenter.to.baListCandledata.value = listCandledata;
      } else if (param.$3 == 'BAC') {
        MainPresenter.to.bacListCandledata.value = listCandledata;
      } else if (param.$3 == 'MCD') {
        MainPresenter.to.mcdListCandledata.value = listCandledata;
      } else if (param.$3 == 'NVDA') {
        MainPresenter.to.nvdaListCandledata.value = listCandledata;
      } else if (param.$3 == 'MSFT') {
        MainPresenter.to.msftListCandledata.value = listCandledata;
      } else if (param.$3 == 'GSK') {
        MainPresenter.to.gskListCandledata.value = listCandledata;
      } else if (param.$3 == 'TSLA') {
        MainPresenter.to.tslaListCandledata.value = listCandledata;
      } else if (param.$3 == 'AMZN') {
        MainPresenter.to.amznListCandledata.value = listCandledata;
      } else {
        throw Exception('There is no listCandledata for ${param.$3}');
      }
      return listCandledata;
    } else if (param.$2 == SrcFileType.json) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: row[0].toInt() * 1000,
                open: row[1].toDouble(),
                high: row[2].toDouble(),
                low: row[3].toDouble(),
                close: row[4].toDouble(),
                volume: row[5].toDouble(),
              ))
          .toList();
      if (param.$3 == 'SPY') {
        MainPresenter.to.spyListCandledata.value = listCandledata;
      } else if (param.$3 == 'QQQ') {
        MainPresenter.to.qqqListCandledata.value = listCandledata;
      } else if (param.$3 == 'USO') {
        MainPresenter.to.usoListCandledata.value = listCandledata;
      } else if (param.$3 == 'GLD') {
        MainPresenter.to.gldListCandledata.value = listCandledata;
      } else if (param.$3 == 'SLV') {
        MainPresenter.to.slvListCandledata.value = listCandledata;
      } else if (param.$3 == 'IWM') {
        MainPresenter.to.iwmListCandledata.value = listCandledata;
      } else if (param.$3 == 'XLK') {
        MainPresenter.to.xlkListCandledata.value = listCandledata;
      } else if (param.$3 == 'AAPL') {
        MainPresenter.to.aaplListCandledata.value = listCandledata;
      } else if (param.$3 == 'BA') {
        MainPresenter.to.baListCandledata.value = listCandledata;
      } else if (param.$3 == 'BAC') {
        MainPresenter.to.bacListCandledata.value = listCandledata;
      } else if (param.$3 == 'MCD') {
        MainPresenter.to.mcdListCandledata.value = listCandledata;
      } else if (param.$3 == 'NVDA') {
        MainPresenter.to.nvdaListCandledata.value = listCandledata;
      } else if (param.$3 == 'MSFT') {
        MainPresenter.to.msftListCandledata.value = listCandledata;
      } else if (param.$3 == 'GSK') {
        MainPresenter.to.gskListCandledata.value = listCandledata;
      } else if (param.$3 == 'TSLA') {
        MainPresenter.to.tslaListCandledata.value = listCandledata;
      } else if (param.$3 == 'AMZN') {
        MainPresenter.to.amznListCandledata.value = listCandledata;
      } else {
        throw Exception('There is no listCandledata for ${param.$3}');
      }
      return listCandledata;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }
}

extension MyCandleData on CandleData {
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }
}
