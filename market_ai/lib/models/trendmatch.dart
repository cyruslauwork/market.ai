import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:interactive_chart/interactive_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:isar/isar.dart';
import 'collections.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/screen_utils.dart';
import 'isac.dart';
import 'candle_adapter.dart';
import 'candle.dart';
import 'package:market_ai/services/flavor_service.dart';

// import 'package:market_ai/utils/utils.dart';

class TrendMatch {
  // Singleton implementation
  static final TrendMatch _instance = TrendMatch._();
  factory TrendMatch() => _instance;
  TrendMatch._();

  init() async {
    List<CandleData> listCandledata = MainPresenter.to.listCandledata;
    int dataLength = listCandledata.length;
    int totalDataLength = dataLength;

    List<double> selectedPeriodPercentDifferencesList = [];
    List<double> selectedPeriodActualDifferencesList = [];
    List<double> selectedPeriodActualPricesList = [];

    List<double> comparePeriodPercentDifferencesList = [];
    List<double> comparePeriodActualDifferencesList = [];
    List<double> comparePeriodActualPricesList = [];

    List<List<double>> comparePeriodPercentDifferencesListList = [];
    List<List<double>> comparePeriodActualDifferencesListList = [];
    List<List<double>> comparePeriodActualPricesListList = [];

    // List<double> matchPercentDifferencesList = [];
    List<double> matchActualDifferencesList = [];
    List<double> matchActualPricesList = [];

    List<List<double>> matchPercentDifferencesListList = [];
    List<List<double>> matchActualDifferencesListList = [];
    List<List<double>> matchActualPricesListList = [];

    MainPresenter.to.adjustedTrendsAndSelectedTrendList.value = [];

    int trueCount = 0;
    int falseCount = 0;
    int len = MainPresenter.to.length.value;

    if (len <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    MainPresenter.to.matchRows.value = [];
    MainPresenter.to.spyMatchRows.value = [];
    MainPresenter.to.qqqMatchRows.value = [];
    MainPresenter.to.usoMatchRows.value = [];
    MainPresenter.to.gldMatchRows.value = [];
    MainPresenter.to.matchPercentDifferencesListList.value = [];
    MainPresenter.to.matchActualDifferencesListList.value = [];
    MainPresenter.to.matchActualPricesListList.value = [];

    int tolerance = MainPresenter.to.tolerance.value;

    bool hasMa = listCandledata.last.trends.isNotEmpty;
    bool isMaMatch = MainPresenter.to.maMatchCriteria.value;
    List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
    List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
    int maLength = listCandledata.last.trends.length;

    if (isMaMatch) {
      if (!hasMa) {
        Candle().computeTrendLines();
        maLength = listCandledata.last.trends.length;
      }
      double selectedFirstPrice = listCandledata[dataLength - len].close!;
      // Loop selected data
      for (int i = len; i > 1; i--) {
        double newVal = listCandledata[dataLength - (i - 1)].close!;
        double oriVal = listCandledata[dataLength - i].close!;
        double percentDiff = (newVal - oriVal) / oriVal;

        selectedPeriodPercentDifferencesList.add(percentDiff);
        selectedPeriodActualDifferencesList.add(newVal - oriVal);

        List<double> selectedPeriodMaPercentDifferencesList = [];
        for (int l = 0; l < maLength; l++) {
          double newVal = listCandledata[dataLength - (i - 1)].trends[l]!;
          double oriVal = listCandledata[dataLength - i].trends[l]!;
          double maPercentDiff = (newVal - oriVal) / oriVal;
          selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
        }
        selectedPeriodMaPercentDifferencesListList
            .add(selectedPeriodMaPercentDifferencesList);
      }
      for (int l = 0; l < maLength; l++) {
        selectedPeriodFirstMaAndPricePercentDifferencesList.add(
            (listCandledata[dataLength - len].trends[l]! - selectedFirstPrice) /
                selectedFirstPrice);
      }
    } else {
      // Loop selected data
      for (int i = len; i > 1; i--) {
        double newVal = listCandledata[dataLength - (i - 1)].close!;
        double oriVal = listCandledata[dataLength - i].close!;
        double percentDiff = (newVal - oriVal) / oriVal;

        selectedPeriodPercentDifferencesList.add(percentDiff);
        selectedPeriodActualDifferencesList.add(newVal - oriVal);
      }
    }

    for (int i = len; i > 0; i--) {
      selectedPeriodActualPricesList.add(listCandledata[dataLength - i].close!);
    }
    MainPresenter.to.selectedPeriodPercentDifferencesList.value =
        selectedPeriodPercentDifferencesList;
    MainPresenter.to.selectedPeriodActualDifferencesList.value =
        selectedPeriodActualDifferencesList;
    MainPresenter.to.selectedPeriodActualPricesList.value =
        selectedPeriodActualPricesList;

    int maxMa() {
      if (MainPresenter.to.hasMinuteData.value &&
          MainPresenter.to.alwaysShowMinuteData.value) {
        MainPresenter.to.maxMa.value = 20;
        return 20;
      } else {
        MainPresenter.to.maxMa.value = 240;
        return 240;
      }
    }

    final isar = await IsarService().getIsarInstance();
    int thisLen;
    bool alwaysUseCrossData = MainPresenter.to.alwaysUseCrossData.value;
    String symbol = MainPresenter.to.financialInstrumentSymbol.value;
    if (alwaysUseCrossData) {
      thisLen = MainPresenter.to.schemasLen.value + 1;
    } else {
      thisLen = 1;
    }
    for (int i = 0; i < thisLen; i++) {
      String thisTurnSymbol = '';
      final dynamic dataList;
      if (i != 0) {
        if (i == 1 && symbol != 'SPY') {
          dataList = await isar.spyDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'SPY';
        } else if (i == 2 && symbol != 'QQQ') {
          dataList = await isar.qqqDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'QQQ';
        } else if (i == 3 && symbol != 'USO') {
          dataList = await isar.usoDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'USO';
        } else if (i == 4 && symbol != 'GLD') {
          dataList = await isar.gldDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'GLD';
        } else {
          if (i == 4) {
            break;
          }
          int l = i + 1;
          if (l == 1 && symbol != 'SPY') {
            dataList = await isar.spyDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'SPY';
          } else if (l == 2 && symbol != 'QQQ') {
            dataList = await isar.qqqDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'QQQ';
          } else if (l == 3 && symbol != 'USO') {
            dataList = await isar.usoDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'USO';
          } else if (l == 4 && symbol != 'GLD') {
            dataList = await isar.gldDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'GLD';
          } else {
            throw Exception('There is no minute interval data for $i');
          }
          i++;
        }
        if (dataList.length < 40) {
          continue;
        }
        List<Map<String, dynamic>> docList = List<SpyData>.from(dataList)
            .map<Map<String, dynamic>>((data) => data.toJson())
            .toList();
        listCandledata =
            await CandleAdapter().crossDataListListTolistCandledata((
          CandleAdapter().jsonToListList(Future.value(docList)),
          SrcFileType.json,
          thisTurnSymbol
        ));
        dataLength = listCandledata.length;
        totalDataLength += dataLength;
      }

      void addMatchRow(int rowId) {
        if (thisTurnSymbol == 'SPY') {
          MainPresenter.to.spyMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'QQQ') {
          MainPresenter.to.spyMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'USO') {
          MainPresenter.to.spyMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'GLD') {
          MainPresenter.to.spyMatchRows.add(rowId);
        } else if (thisTurnSymbol == '') {
          MainPresenter.to.matchRows.add(rowId);
        } else {
          throw Exception('There is no matchRows for $thisTurnSymbol');
        }
      }

      for (int l = (isMaMatch ? maxMa() : 0); l < dataLength - len; l++) {
        for (int i = 0; i < len - 1; i++) {
          double percentDiff = (listCandledata[l + i + 1].close! -
                  listCandledata[l + i].close!) /
              (listCandledata[l + i].close!);
          comparePeriodPercentDifferencesList.add(percentDiff);
          comparePeriodActualDifferencesList.add(
              listCandledata[l + i + 1].close! - listCandledata[l + i].close!);
        }
        for (int i = 0; i < len; i++) {
          comparePeriodActualPricesList.add(listCandledata[l + i].close!);
        }
        // print(selectedPeriodPercentDifferencesList.length);
        // print(comparePeriodPercentDifferencesList.length);
        (
          bool,
          List<double>
        ) comparisonResult = areDifferencesLessThanOrEqualToCertainPercent(
            selectedPeriodPercentDifferencesList,
            comparePeriodPercentDifferencesList,
            tolerance); // Record data type in Dart is equivalent to Tuple in Java and Python

        if (comparisonResult.$1) {
          if (isMaMatch) {
            List<double> comparePeriodFirstMaAndPricePercentDifferencesList =
                [];
            List<List<double>> comparePeriodMaPercentDifferencesListList = [];
            double compareFirstPrice = listCandledata[l].close!;

            for (int m = 0; m < len - 1; m++) {
              List<double> comparePeriodMaPercentDifferencesList = [];
              for (int i = 0; i < maLength; i++) {
                double newVal = listCandledata[l + m + 1].trends[i]!;
                double oriVal = listCandledata[l + m].trends[i]!;
                double maPercentDiff = (newVal - oriVal) / oriVal;
                comparePeriodMaPercentDifferencesList.add(maPercentDiff);
              }
              comparePeriodMaPercentDifferencesListList
                  .add(comparePeriodMaPercentDifferencesList);
            }
            for (int i = 0; i < maLength; i++) {
              comparePeriodFirstMaAndPricePercentDifferencesList.add(
                  (listCandledata[l].trends[i]! - compareFirstPrice) /
                      compareFirstPrice);
            }

            bool isMaMatched = false;
            for (int i = 0;
                i < comparePeriodMaPercentDifferencesListList.length;
                i++) {
              isMaMatched = maDifferencesLessThanOrEqualToCertainPercent(
                  selectedPeriodFirstMaAndPricePercentDifferencesList,
                  selectedPeriodMaPercentDifferencesListList,
                  comparePeriodFirstMaAndPricePercentDifferencesList,
                  comparePeriodMaPercentDifferencesListList,
                  tolerance);
              if (!isMaMatched) {
                break; // Exit the loop
              }
            }
            if (isMaMatched) {
              trueCount += 1;
              if (alwaysUseCrossData) {
                addMatchRow(l);
              } else {
                MainPresenter.to.matchRows.add(l);
              }
              matchPercentDifferencesListList.add(comparisonResult.$2);
              for (int i = 0; i < comparisonResult.$2.length; i++) {
                double actual = listCandledata[l + i + 1].close! -
                    listCandledata[l + i].close!;
                matchActualDifferencesList.add(actual);
              }
              for (int i = 0; i < comparisonResult.$2.length + 1; i++) {
                matchActualPricesList.add(listCandledata[l + i].close!);
              }
              matchActualDifferencesListList.add(matchActualDifferencesList);
              matchActualPricesListList.add(matchActualPricesList);
            } else {
              falseCount += 1;
            }
          } else {
            trueCount += 1;
            if (alwaysUseCrossData) {
              addMatchRow(l);
            } else {
              MainPresenter.to.matchRows.add(l);
            }
            matchPercentDifferencesListList.add(comparisonResult.$2);
            for (int i = 0; i < comparisonResult.$2.length; i++) {
              double actual = listCandledata[l + i + 1].close! -
                  listCandledata[l + i].close!;
              matchActualDifferencesList.add(actual);
            }
            for (int i = 0; i < comparisonResult.$2.length + 1; i++) {
              matchActualPricesList.add(listCandledata[l + i].close!);
            }
            matchActualDifferencesListList.add(matchActualDifferencesList);
            matchActualPricesListList.add(matchActualPricesList);
          }
        } else {
          falseCount += 1;
        }

        comparePeriodPercentDifferencesListList
            .add(comparePeriodPercentDifferencesList);
        comparePeriodActualDifferencesListList
            .add(comparePeriodActualDifferencesList);
        comparePeriodActualPricesListList.add(comparePeriodActualPricesList);
        comparePeriodPercentDifferencesList = [];
        comparePeriodActualDifferencesList = [];
        comparePeriodActualPricesList = [];

        matchActualDifferencesList = [];
        matchActualPricesList = [];
      }
    }

    MainPresenter.to.comparePeriodPercentDifferencesListList.value =
        comparePeriodPercentDifferencesListList;
    MainPresenter.to.comparePeriodActualDifferencesListList.value =
        comparePeriodActualDifferencesListList;
    MainPresenter.to.comparePeriodActualPricesListList.value =
        comparePeriodActualPricesListList;

    MainPresenter.to.matchPercentDifferencesListList.value =
        matchPercentDifferencesListList;
    MainPresenter.to.matchActualDifferencesListList.value =
        matchActualDifferencesListList;
    MainPresenter.to.matchActualPricesListList.value =
        matchActualPricesListList;

    DateTime endTime = DateTime.now(); // Record the end time
    // Calculate the time difference
    Duration executionDuration = endTime.difference(startTime);
    int executionTime = executionDuration.inMilliseconds;

    MainPresenter.to.trendMatchOutput.value = [
      trueCount,
      falseCount,
      executionTime,
      totalDataLength,
      len,
    ];

    MainPresenter.to.sidePlot.value = const SizedBox.shrink();
    MainPresenter.to.trendMatched.value = true;
  }

  (bool, List<double>) areDifferencesLessThanOrEqualToCertainPercent(
      List<double> selList, List<double> comList, int tolerance) {
    if (selList.length != comList.length) {
      // logger.d('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    if (MainPresenter.to.strictMatchCriteria.value) {
      int positiveTolerance = tolerance;
      int negativeTolerance = -tolerance;
      for (int i = 0; i < selList.length; i++) {
        double difference = comList[i] - selList[i];
        double percentDiff;

        // Handle zero in selList to avoid division by zero
        if (selList[i] == 0.0) {
          if (comList[i] != 0.0) {
            return (
              false,
              []
            ); // Any non-zero value compared to zero is a large difference
          } else {
            percentDiff = 0.0; // Both are zero, no difference
          }
        } else {
          percentDiff = (difference / selList[i]) * 100;
        }

        if (percentDiff >= 0) {
          // Positive percentDiff
          if (percentDiff > positiveTolerance) {
            return (false, []); // Difference is larger than certain %
          }
          if (positiveTolerance == tolerance) {
            positiveTolerance -= percentDiff.toInt();
          } else {
            positiveTolerance = tolerance;
          }
        } else {
          // Negative percentDiff
          if (percentDiff < negativeTolerance) {
            return (false, []); // Difference is less than certain -%
          }
          if (negativeTolerance == -tolerance) {
            negativeTolerance -= percentDiff.toInt();
          } else {
            negativeTolerance = -tolerance;
          }
        }
      }
    } else {
      for (int i = 0; i < selList.length; i++) {
        double difference = comList[i] - selList[i];
        double percentDiff;

        // Handle zero in selList to avoid division by zero
        if (selList[i] == 0.0) {
          if (comList[i] != 0.0) {
            return (
              false,
              []
            ); // Any non-zero value compared to zero is a large difference
          } else {
            percentDiff = 0.0; // Both are zero, no difference
          }
        } else {
          percentDiff = (difference / selList[i]) * 100;
        }

        if (percentDiff.abs() > tolerance) {
          return (false, []); // Difference is larger than certain %
        }
      }
    }

    return (true, comList); // All differences are less than certain %
  }

  bool maDifferencesLessThanOrEqualToCertainPercent(
      List<double> selFirstList,
      List<List<double>> selList,
      List<double> comFirstList,
      List<List<double>> comList,
      int tolerance) {
    if (selList.length != comList.length) {
      // logger.d('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    int length = selFirstList.length;
    int maLength = MainPresenter.to.listCandledata.last.trends.length;

    if (MainPresenter.to.strictMatchCriteria.value) {
      int positiveTolerance = tolerance;
      int negativeTolerance = -tolerance;

      for (int i = 0; i < length; i++) {
        double difference = comFirstList[i] - selFirstList[i];
        double percentDiff;

        // Handle zero in selList to avoid division by zero
        if (selFirstList[i] == 0.0) {
          if (comFirstList[i] != 0.0) {
            return false; // Any non-zero value compared to zero is a large difference
          } else {
            percentDiff = 0.0; // Both are zero, no difference
          }
        } else {
          percentDiff = (difference / selFirstList[i]) * 100;
        }

        if (percentDiff >= 0) {
          // Positive percentDiff
          if (percentDiff > positiveTolerance) {
            return false; // Difference is larger than certain %
          }
          if (positiveTolerance == tolerance) {
            positiveTolerance -= percentDiff.toInt();
          } else {
            positiveTolerance = tolerance;
          }
        } else {
          // Negative percentDiff
          if (percentDiff < negativeTolerance) {
            return false; // Difference is less than certain -%
          }
          if (negativeTolerance == -tolerance) {
            negativeTolerance -= percentDiff.toInt();
          } else {
            negativeTolerance = -tolerance;
          }
        }
      }

      positiveTolerance = tolerance;
      negativeTolerance = -tolerance;
      for (int i = 0; i < comList.length; i++) {
        for (int l = 0; l < maLength; l++) {
          double difference = comList[i][l] - selList[i][l];
          double percentDiff;

          // Handle zero in selList to avoid division by zero
          if (selList[i][l] == 0.0) {
            if (comList[i][l] != 0.0) {
              return false; // Any non-zero value compared to zero is a large difference
            } else {
              percentDiff = 0.0; // Both are zero, no difference
            }
          } else {
            percentDiff = (difference / selList[i][l]) * 100;
          }

          if (percentDiff >= 0) {
            // Positive percentDiff
            if (percentDiff > positiveTolerance) {
              return false; // Difference is larger than certain %
            }
            if (positiveTolerance == tolerance) {
              positiveTolerance -= percentDiff.toInt();
            } else {
              positiveTolerance = tolerance;
            }
          } else {
            // Negative percentDiff
            if (percentDiff < negativeTolerance) {
              return false; // Difference is less than certain -%
            }
            if (negativeTolerance == -tolerance) {
              negativeTolerance -= percentDiff.toInt();
            } else {
              negativeTolerance = -tolerance;
            }
          }
        }
      }
    } else {
      for (int i = 0; i < length; i++) {
        double difference = comFirstList[i] - selFirstList[i];
        double percentDiff;

        // Handle zero in selList to avoid division by zero
        if (selFirstList[i] == 0.0) {
          if (comFirstList[i] != 0.0) {
            return false; // Any non-zero value compared to zero is a large difference
          } else {
            percentDiff = 0.0; // Both are zero, no difference
          }
        } else {
          percentDiff = (difference / selFirstList[i]) * 100;
        }

        if (percentDiff.abs() > tolerance) {
          return false; // Difference is larger than certain %
        }
      }

      for (int i = 0; i < comList.length; i++) {
        for (int l = 0; l < maLength; l++) {
          double difference = comList[i][l] - selList[i][l];
          double percentDiff;

          // Handle zero in selList to avoid division by zero
          if (selList[i][l] == 0.0) {
            if (comList[i][l] != 0.0) {
              return false; // Any non-zero value compared to zero is a large difference
            } else {
              percentDiff = 0.0; // Both are zero, no difference
            }
          } else {
            percentDiff = (difference / selList[i][l]) * 100;
          }

          if (percentDiff.abs() > tolerance) {
            return false; // Difference is larger than certain %
          }
        }
      }
    }

    return true; // All differences are less than certain %
  }

  List<FlSpot> getSimplelineBarsData(int index, bool normalized) {
    List<FlSpot> flsportList = [];

    // Whether to normalize
    if (normalized) {
      if (MainPresenter.to.alwaysUseCrossData.value) {
        List<String> minuteDataList =
            List<String>.from(MainPresenter.to.minuteDataList) + ['NULL'];
        for (String symbol in minuteDataList) {
          List<int> matchRows;
          List<List<dynamic>> candleListList;
          if (symbol == 'SPY') {
            matchRows = MainPresenter.to.spyMatchRows;
            candleListList = MainPresenter.to.spyCandleListList;
          } else if (symbol == 'QQQ') {
            matchRows = MainPresenter.to.qqqMatchRows;
            candleListList = MainPresenter.to.qqqCandleListList;
          } else if (symbol == 'USO') {
            matchRows = MainPresenter.to.usoMatchRows;
            candleListList = MainPresenter.to.usoCandleListList;
          } else if (symbol == 'GLD') {
            matchRows = MainPresenter.to.gldMatchRows;
            candleListList = MainPresenter.to.gldCandleListList;
          } else {
            matchRows = MainPresenter.to.matchRows;
            candleListList = MainPresenter.to.candleListList;
          }
          if (matchRows.isEmpty) {
            continue;
          }

          List<double> closePrices = [];

          for (int l = 0; l < matchRows.length; l++) {
            for (int i = 0;
                i <
                    MainPresenter
                        .to.selectedPeriodPercentDifferencesList.length;
                i++) {
              closePrices.add(candleListList[
                  // The CSV/JSON data
                  matchRows[l] +
                      i // Loop all closing prices in the matched trend
                  ][4]); // The 4th row of the list is the closing price
            }
          }

          final lower = closePrices.reduce(min);
          final upper = closePrices.reduce(max);

          for (double i = 0;
              i <
                  MainPresenter.to.selectedPeriodPercentDifferencesList.length +
                      1;
              i++) {
            double closePrice = candleListList[
                    // The CSV/JSON data
                    matchRows[
                            index] // Get the matched trend row from this index
                        +
                        i.toInt()] // Loop all closing prices in the matched trend
                [4]; // The 4th row of the list is the closing price
            if (closePrice < 0) {
              closePrice = -(closePrice / lower);
            } else {
              closePrice = closePrice / upper;
            }

            flsportList.add(FlSpot(
                i, // Equal to selectedPeriodCount, starting from 0
                closePrice));
          }
        }
      } else {
        List<double> closePrices = [];

        for (int l = 0; l < MainPresenter.to.matchRows.length; l++) {
          for (int i = 0;
              i < MainPresenter.to.selectedPeriodPercentDifferencesList.length;
              i++) {
            closePrices.add(MainPresenter.to.candleListList[// The CSV/JSON data
                MainPresenter.to.matchRows[l] +
                    i // Loop all closing prices in the matched trend
                ][4]); // The 4th row of the list is the closing price
          }
        }

        final lower = closePrices.reduce(min);
        final upper = closePrices.reduce(max);

        for (double i = 0;
            i <
                MainPresenter.to.selectedPeriodPercentDifferencesList.length +
                    1;
            i++) {
          double closePrice = MainPresenter.to.candleListList[
                  // The CSV/JSON data
                  MainPresenter.to.matchRows[
                          index] // Get the matched trend row from this index
                      +
                      i.toInt()] // Loop all closing prices in the matched trend
              [4]; // The 4th row of the list is the closing price
          if (closePrice < 0) {
            closePrice = -(closePrice / lower);
          } else {
            closePrice = closePrice / upper;
          }

          flsportList.add(FlSpot(
              i, // Equal to selectedPeriodCount, starting from 0
              closePrice));
        }
      }
    } else {
      if (MainPresenter.to.alwaysUseCrossData.value) {
        List<String> minuteDataList =
            List<String>.from(MainPresenter.to.minuteDataList) + ['NULL'];
        for (String symbol in minuteDataList) {
          List<int> matchRows;
          List<List<dynamic>> candleListList;
          if (symbol == 'SPY') {
            matchRows = MainPresenter.to.spyMatchRows;
            candleListList = MainPresenter.to.spyCandleListList;
          } else if (symbol == 'QQQ') {
            matchRows = MainPresenter.to.qqqMatchRows;
            candleListList = MainPresenter.to.qqqCandleListList;
          } else if (symbol == 'USO') {
            matchRows = MainPresenter.to.usoMatchRows;
            candleListList = MainPresenter.to.usoCandleListList;
          } else if (symbol == 'GLD') {
            matchRows = MainPresenter.to.gldMatchRows;
            candleListList = MainPresenter.to.gldCandleListList;
          } else {
            matchRows = MainPresenter.to.matchRows;
            candleListList = MainPresenter.to.candleListList;
          }
          if (matchRows.isEmpty) {
            continue;
          }

          for (double i = 0;
              i <
                  MainPresenter.to.selectedPeriodPercentDifferencesList.length +
                      1;
              i++) {
            flsportList.add(FlSpot(
                i, // Equal to selectedPeriodCount, starting from 0
                candleListList[// The CSV/JSON data
                        matchRows[
                                index] // Get the matched trend row from this index
                            +
                            i.toInt()] // Loop all closing prices in the matched trend
                    [4] // The 4th row of the list is the closing price
                ));
          }
        }
      } else {
        for (double i = 0;
            i <
                MainPresenter.to.selectedPeriodPercentDifferencesList.length +
                    1;
            i++) {
          flsportList.add(FlSpot(
              i, // Equal to selectedPeriodCount, starting from 0
              MainPresenter.to.candleListList[// The CSV/JSON data
                      MainPresenter.to.matchRows[
                              index] // Get the matched trend row from this index
                          +
                          i.toInt()] // Loop all closing prices in the matched trend
                  [4] // The 4th row of the list is the closing price
              ));
        }
      }
    }

    return flsportList;
  }

  LineChartData getDefaultSimpleLineChartData(bool normalized) {
    List<LineChartBarData> lineBarsData = [];
    if (MainPresenter.to.alwaysUseCrossData.value) {
      List<String> minuteDataList =
          List<String>.from(MainPresenter.to.minuteDataList) + ['NULL'];
      for (String symbol in minuteDataList) {
        List<int> matchRows;
        if (symbol == 'SPY') {
          matchRows = MainPresenter.to.spyMatchRows;
        } else if (symbol == 'QQQ') {
          matchRows = MainPresenter.to.qqqMatchRows;
        } else if (symbol == 'USO') {
          matchRows = MainPresenter.to.usoMatchRows;
        } else if (symbol == 'GLD') {
          matchRows = MainPresenter.to.gldMatchRows;
        } else {
          matchRows = MainPresenter.to.matchRows;
        }
        if (matchRows.isEmpty) {
          continue;
        }
        if (lineBarsData.length >= 500) {
          break;
        }
        List<LineChartBarData> newLineBarsData = matchRows
            .mapIndexed((index, row) => LineChartBarData(
                spots: getSimplelineBarsData(index, normalized),
                isCurved: true,
                barWidth: 1,
                color: AppColor.greyColor))
            .take(500 -
                lineBarsData
                    .length) // Add this line to limit the items to the first 500
            .toList();
        lineBarsData.addAll(newLineBarsData);
      }
    } else {
      lineBarsData = MainPresenter.to.matchRows
          .mapIndexed((index, row) => LineChartBarData(
              spots: getSimplelineBarsData(index, normalized),
              isCurved: true,
              barWidth: 1,
              color: AppColor.greyColor))
          .take(500) // Add this line to limit the items to the first 500
          .toList();
    }
    return LineChartData(
      borderData: FlBorderData(show: false),
      lineBarsData: lineBarsData,
      // [
      //   // The red line
      //   LineChartBarData(
      //     spots:
      //         // const [
      //         //   FlSpot(1, 3.8),
      //         //   FlSpot(3, 1.9),
      //         //   FlSpot(6, 5),
      //         //   FlSpot(10, 3.3),
      //         //   FlSpot(13, 4.5),
      //         // ]
      //         getlineBarsData,
      //     isCurved: true,
      //     barWidth: 3,
      //     color: Colors.red,
      //   ),
      //   // The orange line
      //   LineChartBarData(
      //     spots:
      //         // const [
      //         //   FlSpot(1, 1),
      //         //   FlSpot(3, 2.8),
      //         //   FlSpot(7, 1.2),
      //         //   FlSpot(10, 2.8),
      //         //   FlSpot(12, 2.6),
      //         //   FlSpot(13, 3.9),
      //         // ]
      //         getlineBarsData,
      //     isCurved: true,
      //     barWidth: 3,
      //     color: Colors.orange,
      //   ),
      //   // The blue line
      //   LineChartBarData(
      //     spots:
      //         // const [
      //         //   FlSpot(1, 1),
      //         //   FlSpot(3, 4),
      //         //   FlSpot(5, 1.8),
      //         //   FlSpot(7, 5),
      //         //   FlSpot(10, 2),
      //         //   FlSpot(12, 2.2),
      //         //   FlSpot(13, 1.8),
      //         // ]
      //         getlineBarsData,
      //     isCurved: false,
      //     barWidth: 3,
      //     color: Colors.blue,
      //   ),
      // ],
    );
  }

  List<FlSpot> getAdjustedlineBarsData(int index) {
    List<FlSpot> flspotList = [];

    if (MainPresenter.to.alwaysUseCrossData.value) {
      List<String> minuteDataList =
          List<String>.from(MainPresenter.to.minuteDataList) + ['NULL'];
      for (String symbol in minuteDataList) {
        List<int> matchRows;
        List<List<dynamic>> candleListList;
        if (symbol == 'SPY') {
          matchRows = MainPresenter.to.spyMatchRows;
          candleListList = MainPresenter.to.spyCandleListList;
        } else if (symbol == 'QQQ') {
          matchRows = MainPresenter.to.qqqMatchRows;
          candleListList = MainPresenter.to.qqqCandleListList;
        } else if (symbol == 'USO') {
          matchRows = MainPresenter.to.usoMatchRows;
          candleListList = MainPresenter.to.usoCandleListList;
        } else if (symbol == 'GLD') {
          matchRows = MainPresenter.to.gldMatchRows;
          candleListList = MainPresenter.to.gldCandleListList;
        } else {
          matchRows = MainPresenter.to.matchRows;
          candleListList = MainPresenter.to.candleListList;
        }
        if (matchRows.isEmpty) {
          continue;
        }

        double selectedLength = MainPresenter
            .to.selectedPeriodPercentDifferencesList.length
            .toDouble();

        double lastSelectedClosePrice = candleListList.last[4];

        double lastActualDifference = lastSelectedClosePrice /
            candleListList[matchRows[index] + selectedLength.toInt()][4];

        double subLen = MainPresenter.to.subLength.value.toDouble();

        for (double i = 0; i < selectedLength + subLen + 1; i++) {
          if (i == selectedLength) {
            flspotList.add(FlSpot(i, lastSelectedClosePrice));
          } else {
            double adjustedMatchedTrendClosePrice =
                candleListList[matchRows[index] + i.toInt()]
                        [4] // Close price of matched trend
                    *
                    lastActualDifference;

            flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
          }
        }
      }
    } else {
      List<int> matchRows = MainPresenter.to.matchRows;
      List<List<dynamic>> candleListList = MainPresenter.to.candleListList;

      double selectedLength = MainPresenter
          .to.selectedPeriodPercentDifferencesList.length
          .toDouble();

      double lastSelectedClosePrice = candleListList.last[4];

      double lastActualDifference = lastSelectedClosePrice /
          candleListList[matchRows[index] + selectedLength.toInt()][4];

      double subLen = MainPresenter.to.subLength.value.toDouble();

      for (double i = 0; i < selectedLength + subLen + 1; i++) {
        if (i == selectedLength) {
          flspotList.add(FlSpot(i, lastSelectedClosePrice));
        } else {
          double adjustedMatchedTrendClosePrice =
              candleListList[matchRows[index] + i.toInt()]
                      [4] // Close price of matched trend
                  *
                  lastActualDifference;

          flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
        }
      }
    }

    return flspotList;
  }

  List<FlSpot> getSelectedPeriodClosePrices() {
    List<FlSpot> flspotList = [];

    List<List<dynamic>> candleListList = MainPresenter.to.candleListList;

    for (int i = 0;
        i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
        i++) {
      flspotList.add(FlSpot(
          i.toDouble(),
          candleListList[MainPresenter.to.candleListList.length -
              MainPresenter.to.selectedPeriodPercentDifferencesList.length +
              i -
              1][4]));
    }

    return flspotList;
  }

  LineChartData getDefaultAdjustedLineChartData() {
    List<LineChartBarData> lineBarsData = [];
    if (MainPresenter.to.alwaysUseCrossData.value) {
      List<String> minuteDataList =
          List<String>.from(MainPresenter.to.minuteDataList) + ['NULL'];
      for (String symbol in minuteDataList) {
        List<int> matchRows;
        if (symbol == 'SPY') {
          matchRows = MainPresenter.to.spyMatchRows;
        } else if (symbol == 'QQQ') {
          matchRows = MainPresenter.to.qqqMatchRows;
        } else if (symbol == 'USO') {
          matchRows = MainPresenter.to.usoMatchRows;
        } else if (symbol == 'GLD') {
          matchRows = MainPresenter.to.gldMatchRows;
        } else {
          matchRows = MainPresenter.to.matchRows;
        }
        if (matchRows.isEmpty) {
          continue;
        }
        if (lineBarsData.length >= 500) {
          break;
        }
        List<LineChartBarData> newLineBarsData = matchRows
            .mapIndexed((index, row) => LineChartBarData(
                spots: getAdjustedlineBarsData(index),
                isCurved: true,
                barWidth: 1,
                color: ThemeColor.secondary.value))
            .take(500 -
                lineBarsData
                    .length) // Add this line to limit the items to the first 500
            .toList()
          ..add(
            LineChartBarData(
              spots: getSelectedPeriodClosePrices(),
              isCurved: true,
              barWidth: 3,
              color: ThemeColor.primary.value,
            ),
          );
        lineBarsData.addAll(newLineBarsData);
      }
    } else {
      lineBarsData = MainPresenter.to.matchRows
          .mapIndexed((index, row) => LineChartBarData(
              spots: getAdjustedlineBarsData(index),
              isCurved: true,
              barWidth: 1,
              color: ThemeColor.secondary.value))
          .take(500) // Add this line to limit the items to the first 500
          .toList()
        ..add(
          LineChartBarData(
            spots: getSelectedPeriodClosePrices(),
            isCurved: true,
            barWidth: 3,
            color: ThemeColor.primary.value,
          ),
        );
    }
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      borderData: FlBorderData(show: false),
      lineBarsData: lineBarsData,
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(reservedSize: 16.w, showTitles: true)),
      ),
    );
  }
}
