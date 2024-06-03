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
      return listCandledata;
    } else if (param.$2 == SrcFileType.json) {
      listCandledata = listList
          .map((row) => CandleData(
                timestamp: row[0].toInt(),
                open: row[1].toDouble(),
                high: row[2].toDouble(),
                low: row[3].toDouble(),
                close: row[4].toDouble(),
                volume: row[5].toDouble(),
              ))
          .toList();
      MainPresenter.to.listCandledata.value = listCandledata;
      return listCandledata;
    } else {
      throw ArgumentError('Failed to convert list to candles.');
    }
  }
}
