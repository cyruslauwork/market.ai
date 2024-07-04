import 'dart:convert';
import 'dart:math';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/services/services.dart';
// import 'package:market_ai/utils/utils.dart';

class SubsequentAnalytics {
  // Singleton implementation
  static final SubsequentAnalytics _instance = SubsequentAnalytics._();
  factory SubsequentAnalytics() => _instance;
  SubsequentAnalytics._();

  void init() async {
    MainPresenter.to.subsequentAnalyticsNotifier.value = false;
    MainPresenter.to.saCount++;
    int saCount = MainPresenter.to.saCount.value;

    List<List<double>> lastClosePriceAndSubsequentTrends = [];

    DateTime exeStartTime = DateTime.now(); // Record the download start time

    int matchLen;
    List<List<dynamic>> candleListList;
    int candleListListLength;
    List<int> matchRows;
    double minValueOfAllTrends = double.infinity;
    double maxValueOfAllTrends = double.negativeInfinity;

    int count = 0;
    if (MainPresenter.to.alwaysUseCrossData.value ||
        MainPresenter.to.isLockTrend.value) {
      List<String> minuteDataList =
          List<String>.from(MainPresenter.to.minuteDataList);
      String fiSymbol = MainPresenter.to.financialInstrumentSymbol.value;
      for (String symbol in minuteDataList) {
        if (symbol == 'SPY' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.spyCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.spyMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'QQQ' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.qqqCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.qqqMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'USO' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.usoCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.usoMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'GLD' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.gldCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.gldMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'SLV' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.slvCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.slvMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'IWM' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.iwmCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.iwmMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'XLK' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.xlkCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.xlkMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'AAPL' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.aaplCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.aaplMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'BA' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.baCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.baMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'BAC' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.bacCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.bacMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'MCD' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.mcdCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.mcdMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'NVDA' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.nvdaCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.nvdaMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'MSFT' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.msftCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.msftMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'GSK' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.gskCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.gskMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'TSLA' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.tslaCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.tslaMatchRows;
          matchLen = matchRows.length;
        } else if (symbol == 'AMZN' && symbol != fiSymbol) {
          candleListList = MainPresenter.to.amznCandleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.amznMatchRows;
          matchLen = matchRows.length;
        } else {
          candleListList = MainPresenter.to.candleListList;
          candleListListLength = candleListList.length;
          matchRows = MainPresenter.to.matchRows;
          matchLen = matchRows.length;
        }
        if (matchRows.isEmpty || candleListList.isEmpty) {
          continue;
        } else if (matchRows.isNotEmpty) {
          if (matchRows[0] == 0) {
            continue;
          }
        }
        bool outerBreak = false;
        for (int i = 0; i < matchLen; i++) {
          // Takes 500 only to avoid a Cloud Functions crash
          if (count >= 500) {
            outerBreak = true;
            break;
          }
          lastClosePriceAndSubsequentTrends.add(
              getMatchedTrendLastClosePriceAndSubsequentTrend(i,
                  otherCandleListList: candleListList, matchRows: matchRows));
          count++;
        }
        if (outerBreak) {
          break;
        }
        int selectedLength =
            MainPresenter.to.selectedPeriodPercentDifferencesList.length;
        // Selected trend
        for (int i = 0; i < selectedLength; i++) {
          double value =
              candleListList[candleListListLength - selectedLength + i][4];
          minValueOfAllTrends = min(minValueOfAllTrends, value);
          maxValueOfAllTrends = max(maxValueOfAllTrends, value);
        }
        double lastSelectedClosePrice = MainPresenter.to.candleListList.last[4];
        int subLen = MainPresenter.to.subLength.value;
        // Adjusted trends
        for (int index in matchRows) {
          double lastActualDifference = lastSelectedClosePrice /
              candleListList[index + selectedLength][4];
          for (int i = 0; i < selectedLength + subLen + 1; i++) {
            double adjustedMatchedTrendClosePrice;
            if (i == selectedLength) {
              adjustedMatchedTrendClosePrice = lastSelectedClosePrice;
            } else {
              adjustedMatchedTrendClosePrice =
                  candleListList[index + i][4] // Close price of matched trend
                      *
                      lastActualDifference;
            }
            minValueOfAllTrends =
                min(minValueOfAllTrends, adjustedMatchedTrendClosePrice);
            maxValueOfAllTrends =
                max(maxValueOfAllTrends, adjustedMatchedTrendClosePrice);
          }
        }
      }
    } else {
      matchLen = MainPresenter.to.matchRows.length;
      candleListList = MainPresenter.to.candleListList;
      candleListListLength = MainPresenter.to.candleListList.length;
      matchRows = MainPresenter.to.matchRows;

      for (int i = 0; i < (matchLen > 499 ? 499 : matchLen); i++) {
        // Takes 500 only to avoid a Cloud Functions crash
        lastClosePriceAndSubsequentTrends
            .add(getMatchedTrendLastClosePriceAndSubsequentTrend(i));
      }
      int selectedLength =
          MainPresenter.to.selectedPeriodPercentDifferencesList.length;
      // Selected trend
      for (int i = 0; i < selectedLength; i++) {
        double value =
            candleListList[candleListListLength - selectedLength + i][4];
        minValueOfAllTrends = min(minValueOfAllTrends, value);
        maxValueOfAllTrends = max(maxValueOfAllTrends, value);
      }
      double lastSelectedClosePrice = candleListList.last[4];
      int subLen = MainPresenter.to.subLength.value;
      // Adjusted trends
      for (int index in matchRows) {
        double lastActualDifference =
            lastSelectedClosePrice / candleListList[index + selectedLength][4];
        for (int i = 0; i < selectedLength + subLen + 1; i++) {
          double adjustedMatchedTrendClosePrice;
          if (i == selectedLength) {
            adjustedMatchedTrendClosePrice = lastSelectedClosePrice;
          } else {
            adjustedMatchedTrendClosePrice =
                candleListList[index + i][4] // Close price of matched trend
                    *
                    lastActualDifference;
          }
          minValueOfAllTrends =
              min(minValueOfAllTrends, adjustedMatchedTrendClosePrice);
          maxValueOfAllTrends =
              max(maxValueOfAllTrends, adjustedMatchedTrendClosePrice);
        }
      }
    }
    // print(minValueOfAllTrends);
    // print(maxValueOfAllTrends);

    DateTime exeEndTime = DateTime.now(); // Record the download end time
    // Calculate the time difference
    Duration exeDuration = exeEndTime.difference(exeStartTime);
    int exeTime = exeDuration.inMilliseconds;
    MainPresenter.to.lastClosePriceAndSubsequentTrendsExeTime.value = exeTime;

    if (lastClosePriceAndSubsequentTrends.length >= 4) {
      exeStartTime = DateTime.now(); // Record the download start time
      // log(lastClosePriceAndSubsequentTrends.toString());
      await CloudService()
          .fetchCsvAndPng(
        lastClosePriceAndSubsequentTrends: lastClosePriceAndSubsequentTrends,
        minValueOfAllTrends: minValueOfAllTrends,
        maxValueOfAllTrends: maxValueOfAllTrends,
        apiKey: MainPresenter.to.apiKey.value,
      )
          .then((parsedResponse) {
        // log(parsedResponse.toString());
        // Check if multiple SAs are queued
        if (MainPresenter.to.saCount.value == saCount) {
          exeEndTime = DateTime.now(); // Record the download end time
          // Calculate the time difference
          exeDuration = exeEndTime.difference(exeStartTime);
          exeTime = exeDuration.inMilliseconds;
          MainPresenter.to.cloudSubsequentAnalyticsTime.value = exeTime;
          try {
            Map<String, dynamic> csvPngFiles = parsedResponse['csv_png_files'];
            // logger.d(csvPngFiles);
            MainPresenter.to.subsequentAnalyticsErr.value = '';
            parseJson(csvPngFiles);
            MainPresenter.to.apiKeyErr.value = '';
            PrefsService.to.prefs
                .setString(SharedPreferencesConstant.apiKeyErr, '');
          } catch (e) {
            String err = parsedResponse['error'];
            if (err == Err.apiKey.name) {
              MainPresenter.to.subsequentAnalyticsErr.value = err;
              MainPresenter.to.apiKeyErr.value = err;
              PrefsService.to.prefs
                  .setString(SharedPreferencesConstant.apiKeyErr, err);
            } else if (err == Err.invalidJson.name) {
              MainPresenter.to.subsequentAnalyticsErr.value =
                  '$err: The error may be caused by the time range being less than 3.';
            } else {
              MainPresenter.to.apiKeyErr.value = err;
            }
          }
        } else {
          return;
        }
      }).catchError((error) {
        // Handle any errors during the asynchronous operation
        MainPresenter.to.subsequentAnalyticsErr.value =
            'An unexpected error occurred in getCsvAndPng(): $error';
      });
    } else {
      MainPresenter.to.subsequentAnalyticsErr.value =
          'The number of subsequent trends must be equal to or greater than 4.';
    }
    if (MainPresenter.to.subsequentAnalyticsNotifier.value) {
      MainPresenter.to.subsequentAnalyticsNotifier.value = false;
      MainPresenter.to.subsequentAnalyticsNotifier.value = true;
    } else {
      MainPresenter.to.subsequentAnalyticsNotifier.value = true;
    }
  }

  List<double> getMatchedTrendLastClosePriceAndSubsequentTrend(int index,
      {List<List<dynamic>>? otherCandleListList, List<int>? matchRows}) {
    List<double> lastClosePriceAndSubsequentTrend = [];
    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

    otherCandleListList ??= MainPresenter.to.candleListList;
    matchRows ??= MainPresenter.to.matchRows;

    double lastActualDifference = MainPresenter.to.candleListList.last[4] /
        otherCandleListList[matchRows[index] + selectedLength.toInt()][4];

    lastClosePriceAndSubsequentTrend.add(MainPresenter
        .to.selectedPeriodActualPricesList[selectedLength.toInt()]);

    int length = MainPresenter.to.length.value;
    int subLen = MainPresenter.to.subLength.value;

    for (int i = length; i < length + subLen; i++) {
      double adjustedMatchedTrendClosePrice =
          otherCandleListList[matchRows[index] + i]
                  [4] // Close price of matched trend
              *
              lastActualDifference;

      lastClosePriceAndSubsequentTrend.add(adjustedMatchedTrendClosePrice);
    }

    // print(lastClosePriceAndSubsequentTrend);
    return lastClosePriceAndSubsequentTrend;
  }

  void parseJson(Map<String, dynamic> csvPngFiles) {
    // Get the data from the parsed JSON data
    String img1 = csvPngFiles['img1'];
    String img2 = csvPngFiles['img2'];
    String img3 = csvPngFiles['img3'];
    String img4 = csvPngFiles['img4'];
    String img5 = csvPngFiles['img5'];
    String img6 = csvPngFiles['img6'];
    String img7 = csvPngFiles['img7'];
    String img8 = csvPngFiles['img8'];
    String img9 = csvPngFiles['img9'];
    String img10 = csvPngFiles['img10'];

    // Convert the base64-encoded image data to bytes
    MainPresenter.to.img1Bytes.value = base64Decode(img1);
    MainPresenter.to.img2Bytes.value = base64Decode(img2);
    MainPresenter.to.img3Bytes.value = base64Decode(img3);
    MainPresenter.to.img4Bytes.value = base64Decode(img4);
    MainPresenter.to.img5Bytes.value = base64Decode(img5);
    MainPresenter.to.img6Bytes.value = base64Decode(img6);
    MainPresenter.to.img7Bytes.value = base64Decode(img7);
    MainPresenter.to.img8Bytes.value = base64Decode(img8);
    MainPresenter.to.img9Bytes.value = base64Decode(img9);
    MainPresenter.to.img10Bytes.value = base64Decode(img10);

    PrefsService.to.prefs.setString(SharedPreferencesConstant.img1, img1);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img2, img2);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img3, img3);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img4, img4);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img5, img5);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img6, img6);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img7, img7);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img8, img8);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img9, img9);
    PrefsService.to.prefs.setString(SharedPreferencesConstant.img10, img10);

    MainPresenter.to.numOfClusters.value = csvPngFiles['num_of_clusters'];

    List clusters = csvPngFiles['clusters.csv'];
    List<String> clusterJsonList =
        clusters.map((map) => jsonEncode(map)).toList();
    // print(clusterJsonList);
    PrefsService.to.prefs
        .setStringList(SharedPreferencesConstant.cluster, clusterJsonList);
    MainPresenter.to.clusters.value = clusters;
    // logger.d(MainPresenter.to.cluster);

    MainPresenter.to.maxSilhouetteScore.value =
        double.parse(csvPngFiles['max_silhouette_score']).toStringAsFixed(3);
  }
}
