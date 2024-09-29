import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
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
    List<CandleData> listCandledata;
    int listCandledataLength;
    List<int> matchRows;
    double minValueOfAllTrends = double.infinity;
    double maxValueOfAllTrends = double.negativeInfinity;

    int count = 0;
    if (MainPresenter.to.alwaysUseCrossData.value ||
        MainPresenter.to.isLockTrend.value) {
      List<String> minuteDataList = List<String>.from(
          MainPresenter.to.universalHasMinuteData.keys.toList());
      String fiSymbol = MainPresenter.to.financialInstrumentSymbol.value;
      Map<String, List<CandleData>> universalListCandledata =
          MainPresenter.to.universalListCandledata;
      for (String symbol in minuteDataList) {
        if (symbol != fiSymbol) {
          listCandledata = universalListCandledata[symbol]!;
          listCandledataLength = listCandledata.length;
          matchRows = MainPresenter.to.universalMatchRows[symbol]!;
          matchLen = matchRows.length;
        } else {
          listCandledata = MainPresenter.to.listCandledata;
          listCandledataLength = listCandledata.length;
          matchRows = MainPresenter.to.matchRows;
          matchLen = matchRows.length;
        }
        if (matchRows.isEmpty || listCandledata.isEmpty) {
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
                  otherListCandledata: listCandledata, matchRows: matchRows));
          count++;
        }
        if (outerBreak) {
          break;
        }
        int selectedLength = (MainPresenter.to.length.value - 1);
        // Selected trend
        for (int i = 0; i < selectedLength; i++) {
          double value =
              listCandledata[listCandledataLength - selectedLength + i].close!;
          minValueOfAllTrends = min(minValueOfAllTrends, value);
          maxValueOfAllTrends = max(maxValueOfAllTrends, value);
        }
        double lastSelectedClosePrice =
            MainPresenter.to.listCandledata.last.close!;
        int subLen = MainPresenter.to.subLength.value;
        // Adjusted trends
        for (int index in matchRows) {
          double lastActualDifference = lastSelectedClosePrice /
              listCandledata[index + selectedLength].close!;
          for (int i = 0; i < selectedLength + subLen + 1; i++) {
            double adjustedMatchedTrendClosePrice;
            if (i == selectedLength) {
              adjustedMatchedTrendClosePrice = lastSelectedClosePrice;
            } else {
              adjustedMatchedTrendClosePrice = listCandledata[index + i]
                      .close! // Close price of matched trend
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
      listCandledata = MainPresenter.to.listCandledata;
      listCandledataLength = MainPresenter.to.listCandledata.length;
      matchRows = MainPresenter.to.matchRows;
      for (int i = 0; i < (matchLen > 499 ? 500 : matchLen); i++) {
        // Takes 500 only to avoid a Cloud Functions crash
        lastClosePriceAndSubsequentTrends
            .add(getMatchedTrendLastClosePriceAndSubsequentTrend(i));
      }
      int selectedLength = (MainPresenter.to.length.value - 1);
      // Selected trend
      for (int i = 0; i < selectedLength; i++) {
        double value =
            listCandledata[listCandledataLength - selectedLength + i].close!;
        minValueOfAllTrends = min(minValueOfAllTrends, value);
        maxValueOfAllTrends = max(maxValueOfAllTrends, value);
      }
      double lastSelectedClosePrice = listCandledata.last.close!;
      int subLen = MainPresenter.to.subLength.value;
      // Adjusted trends
      for (int index in matchRows) {
        double lastActualDifference = lastSelectedClosePrice /
            listCandledata[index + selectedLength].close!;
        for (int i = 0; i < selectedLength + subLen + 1; i++) {
          double adjustedMatchedTrendClosePrice;
          if (i == selectedLength) {
            adjustedMatchedTrendClosePrice = lastSelectedClosePrice;
          } else {
            adjustedMatchedTrendClosePrice =
                listCandledata[index + i].close! // Close price of matched trend
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
        // ignore: unnecessary_type_check
        if (parsedResponse is! Map<String, dynamic>) {
          throw Exception('Parsed response is not a Map<String, dynamic>');
        }
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

            lastClosePriceAndSubsequentTrends.clear();
            parsedResponse.clear();
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

            lastClosePriceAndSubsequentTrends.clear();
            parsedResponse.clear();
          }
        } else {
          lastClosePriceAndSubsequentTrends.clear();
          parsedResponse.clear();
          return;
        }
      }).catchError((error) {
        // Handle any errors during the asynchronous operation
        MainPresenter.to.subsequentAnalyticsErr.value =
            'An unexpected error occurred in getCsvAndPng(): $error. This could be due to an invalid API key or too many trend matches.';
        lastClosePriceAndSubsequentTrends.clear();
      });
    } else {
      MainPresenter.to.subsequentAnalyticsErr.value = 'trends_not_enough'.tr;
    }
    if (MainPresenter.to.subsequentAnalyticsNotifier.value) {
      MainPresenter.to.subsequentAnalyticsNotifier.value = false;
      MainPresenter.to.subsequentAnalyticsNotifier.value = true;
    } else {
      MainPresenter.to.subsequentAnalyticsNotifier.value = true;
    }
  }

  List<double> getMatchedTrendLastClosePriceAndSubsequentTrend(int index,
      {List<CandleData>? otherListCandledata, List<int>? matchRows}) {
    List<double> lastClosePriceAndSubsequentTrend = [];
    double selectedLength = (MainPresenter.to.length.value - 1).toDouble();

    otherListCandledata ??= MainPresenter.to.listCandledata;
    matchRows ??= MainPresenter.to.matchRows;

    double lastActualDifference = MainPresenter.to.listCandledata.last.close! /
        otherListCandledata[matchRows[index] + selectedLength.toInt()].close!;

    lastClosePriceAndSubsequentTrend
        .add(MainPresenter.to.listCandledata.last.close!);

    int length = MainPresenter.to.length.value;
    int subLen = MainPresenter.to.subLength.value;

    for (int i = length; i < length + subLen; i++) {
      double adjustedMatchedTrendClosePrice =
          otherListCandledata[matchRows[index] + i]
                  .close! // Close price of matched trend
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
