import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:interactive_chart/interactive_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:market_ai/models/candle.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/screen_utils.dart';

// import 'package:market_ai/utils/utils.dart';

class TrendMatch {
  // Singleton implementation
  static final TrendMatch _instance = TrendMatch._();
  factory TrendMatch() => _instance;
  TrendMatch._();

  init() {
    List<CandleData> listCandledata = MainPresenter.to.listCandledata;
    int dataLength = listCandledata.length;

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
    int subLen = MainPresenter.to.subLength.value;

    if (len <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    MainPresenter.to.matchRows.value = [];
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
        return 20;
      } else {
        return 240;
      }
    }

    for (int l = (isMaMatch ? maxMa() : 0);
        l < dataLength - (len + subLen);
        l++) {
      for (int i = 0; i < len - 1; i++) {
        double percentDiff =
            (listCandledata[l + i + 1].close! - listCandledata[l + i].close!) /
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
          List<double> comparePeriodFirstMaAndPricePercentDifferencesList = [];
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
            MainPresenter.to.matchRows.add(l);
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
          MainPresenter.to.matchRows.add(l);
          matchPercentDifferencesListList.add(comparisonResult.$2);
          for (int i = 0; i < comparisonResult.$2.length; i++) {
            double actual =
                listCandledata[l + i + 1].close! - listCandledata[l + i].close!;
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
      dataLength,
      len,
    ];

    MainPresenter.to.sidePlot.value = const SizedBox.shrink();
    MainPresenter.to.trendMatched.value = true;

    // logger.d('True${MainPresenter.to.trendMatchOutput[0]}');
    // logger.d('False${MainPresenter.to.trendMatchOutput[1]}');
    // logger.d('executionTime${MainPresenter.to.trendMatchOutput[2]}');
    // logger.d('dataLength${MainPresenter.to.trendMatchOutput[3]}');
    // logger.d('selectedCount${MainPresenter.to.trendMatchOutput[4]}');
    // logger.d('candleListList${MainPresenter.to.candleListList.length}');
    // logger.d('listCandledata${MainPresenter.to.dataLength}');
    // logger.d('selectedPeriodPercentDifferencesList${MainPresenter.to.selectedPeriodPercentDifferencesList.length}');
    // logger.d('selectedPeriodActualDifferencesList${MainPresenter.to.selectedPeriodActualDifferencesList.length}');
    // logger.d('selectedPeriodActualPricesList${MainPresenter.to.selectedPeriodActualPricesList.length}');
    // logger.d('comparePeriodPercentDifferencesListList${MainPresenter.to.comparePeriodPercentDifferencesListList.length}');
    // logger.d('comparePeriodActualDifferencesListList${MainPresenter.to.comparePeriodActualDifferencesListList.length}');
    // logger.d('comparePeriodActualPricesListList${MainPresenter.to.comparePeriodActualPricesListList.length}');
    // logger.d('matchPercentDifferencesListList${MainPresenter.to.matchPercentDifferencesListList.length}');
    // logger.d('matchActualDifferencesListList${MainPresenter.to.matchActualDifferencesListList.length}');
    // logger.d('matchActualPricesListList${MainPresenter.to.matchActualPricesListList.length}');
    // logger.d('matchRows${MainPresenter.to.matchRows.length}');
    // logger.d('lastCandleDataLength${MainPresenter.to.lastCandleDataLength}');
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
          i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
          i++) {
        double closePrice = MainPresenter.to.candleListList[// The CSV/JSON data
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
    } else {
      for (double i = 0;
          i < MainPresenter.to.selectedPeriodPercentDifferencesList.length + 1;
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

    return flsportList;
  }

  LineChartData getDefaultSimpleLineChartData(bool normalized) {
    return LineChartData(
      borderData: FlBorderData(show: false),
      lineBarsData: MainPresenter.to.matchRows
          .mapIndexed((index, row) => LineChartBarData(
              spots: getSimplelineBarsData(index, normalized),
              isCurved: true,
              barWidth: 1,
              color: AppColor.greyColor))
          // .take(5) // Add this line to limit the items to the first 5
          .toList(),
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
    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

    List<List<dynamic>> candleListList = MainPresenter.to.candleListList;
    List<int> matchRows = MainPresenter.to.matchRows;

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
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      borderData: FlBorderData(show: false),
      lineBarsData: MainPresenter.to.matchRows
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
        ),
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(reservedSize: 16.w, showTitles: true)),
      ),
    );
  }
}
