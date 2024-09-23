// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// import 'package:csv/csv.dart';
import 'package:interactive_chart/interactive_chart.dart';

import 'package:market_ai/services/services.dart';
import 'package:market_ai/presenters/presenters.dart';

class CandleAdapter {
  // Singleton implementation
  static final CandleAdapter _instance = CandleAdapter._();
  factory CandleAdapter() => _instance;
  CandleAdapter._();

  // Future<List<List<dynamic>>> csvToListList(Future<String> futureCsv) async {
  //   String csv = await futureCsv;

  //   MainPresenter.to.rowsAsListOfValues =
  //       const CsvToListConverter().convert(csv, eol: '\n');
  //   MainPresenter.to.rowsAsListOfValues.removeAt(0); // Remove CSV column titles
  //   csv.clear();
  //   return MainPresenter.to.rowsAsListOfValues;
  // }

  Future<List<List<dynamic>>> jsonToListList(
      Future<List<Map<String, dynamic>>> futureJson) async {
    List<Map<String, dynamic>> json = await futureJson;

    for (Map<String, dynamic> map in json) {
      List<dynamic> values = map.values.toList();
      MainPresenter.to.rowsAsListOfValues.add(values);
    }

    json.clear();
    return MainPresenter.to.rowsAsListOfValues;
  }

  Future<List<CandleData>> listListTolistCandledata(
      (Future<List<List<dynamic>>>, SrcFileType) param) async {
    List<List<dynamic>> listList = await param.$1;
    MainPresenter.to.docList.clear();
    late List<CandleData> listCandledata;

    if (!MainPresenter.to.isLockTrend.value) {
      PrefsService.to.prefs.setInt(
          SharedPreferencesConstant.lockTrendLastRow, listList.length - 1);
      if (param.$2 == SrcFileType.json) {
        PrefsService.to.prefs.setInt(
            SharedPreferencesConstant.lockTrendLastDatetime,
            listList.last[0].toInt());
        // } else if (param.$2 == SrcFileType.csv) {
        //   PrefsService.to.prefs.setInt(
        //       SharedPreferencesConstant.lockTrendLastDatetime,
        //       TimeService().convertToUnixTimestamp(
        //           listList.last[0]));
      } else {
        throw ArgumentError('Failed to convert list to candles.');
      }
    }

    MainPresenter.to.lastDatetime.value =
        MainPresenter.to.getLastDatetime(listList);
    if (param.$2 == SrcFileType.json) {
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
      MainPresenter.to.listCandledata = listCandledata;
      // final jsonList =
      //     listCandledata.map((candleData) => candleData.toMap()).toList();
      // final jsonString = json.encode(jsonList);

      // final documentsDirectory = await getApplicationDocumentsDirectory();
      // final filePath = '${documentsDirectory.path}/marketai_json/candle.json';
      // final file = File(filePath);
      // await file.create(recursive: true);
      // await file.writeAsString(jsonString);
      MainPresenter.to.rowsAsListOfValues.clear();
      listList.clear(); // This clears the list
      MainPresenter.to.hasCandleData.value = true;
      return listCandledata;
      // } else if (param.$2 == SrcFileType.csv) {
      //   listCandledata = listList
      //       .map((row) => CandleData(
      //             timestamp: TimeService().convertToUnixTimestamp(row[0]) * 1000,
      //             open: row[1].toDouble(),
      //             high: row[2].toDouble(),
      //             low: row[3].toDouble(),
      //             close: row[4].toDouble(),
      //             volume: row[6].toDouble(),
      //           ))
      //       .toList();
      //   MainPresenter.to.listCandledata.value = listCandledata;
      //   MainPresenter.to.rowsAsListOfValues.clear();
      //   listList.clear(); // This clears the list
      //   MainPresenter.to.hasCandleData.value = true;
      //   return listCandledata;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }

  Future<List<CandleData>> crossDataListListTolistCandledata(
      (Future<List<List<dynamic>>>, SrcFileType, String) param) async {
    List<List<dynamic>> listList = await param.$1;
    MainPresenter.to.docList.clear();
    late List<CandleData> listCandledata;

    // if (param.$2 == SrcFileType.csv) {
    //   listCandledata = listList
    //       .map((row) => CandleData(
    //             timestamp: TimeService().convertToUnixTimestamp(row[0]) * 1000,
    //             open: row[1].toDouble(),
    //             high: row[2].toDouble(),
    //             low: row[3].toDouble(),
    //             close: row[4].toDouble(),
    //             volume: row[6].toDouble(),
    //           ))
    //       .toList();
    //   if (MainPresenter.to.universalListCandledata.containsKey(param.$3)) {
    //     MainPresenter.to.universalListCandledata[param.$3] = listCandledata;
    //   } else {
    //     throw Exception('There is no listCandledata for ${param.$3}');
    //   }
    //   return listCandledata;
    // } else
    if (param.$2 == SrcFileType.json) {
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
      if (MainPresenter.to.universalListCandledata.containsKey(param.$3)) {
        MainPresenter.to.universalListCandledata[param.$3] = listCandledata;
      } else {
        throw Exception('There is no listCandledata for ${param.$3}');
      }
      MainPresenter.to.rowsAsListOfValues.clear();
      listList.clear(); // This clears the list
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
