import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert'; // For jsonEncode

import 'package:interactive_chart/interactive_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:isar/isar.dart';
import 'package:market_ai/services/prefs/prefs.dart';
import 'collections.dart';

import 'package:market_ai/presenters/presenters.dart';
import 'package:market_ai/styles/styles.dart';
import 'isac.dart';
import 'candle_adapter.dart';
import 'candle.dart';
import 'package:market_ai/services/flavor_service.dart';
import 'package:market_ai/utils/utils.dart';

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

    int trueCount = 0;
    int falseCount = 0;
    int len = MainPresenter.to.length.value;
    int subLen = MainPresenter.to.subLength.value;

    if (len <= 1) {
      throw ArgumentError('Selected period must greater than 1 time unit.');
    }

    DateTime startTime = DateTime.now(); // Record the start time

    MainPresenter.to.matchRows.value = [];
    MainPresenter.to.spyMatchRows.value = [];
    MainPresenter.to.qqqMatchRows.value = [];
    MainPresenter.to.usoMatchRows.value = [];
    MainPresenter.to.gldMatchRows.value = [];
    MainPresenter.to.slvMatchRows.value = [];
    MainPresenter.to.iwmMatchRows.value = [];
    MainPresenter.to.xlkMatchRows.value = [];
    MainPresenter.to.aaplMatchRows.value = [];
    MainPresenter.to.baMatchRows.value = [];
    MainPresenter.to.bacMatchRows.value = [];
    MainPresenter.to.mcdMatchRows.value = [];
    MainPresenter.to.nvdaMatchRows.value = [];
    MainPresenter.to.msftMatchRows.value = [];
    MainPresenter.to.gskMatchRows.value = [];
    MainPresenter.to.tslaMatchRows.value = [];
    MainPresenter.to.amznMatchRows.value = [];
    MainPresenter.to.matchPercentDifferencesListList.value = [];
    MainPresenter.to.matchActualDifferencesListList.value = [];
    MainPresenter.to.matchActualPricesListList.value = [];

    int priceTolerance = MainPresenter.to.priceTolerance.value;
    int maTolerance = MainPresenter.to.maTolerance.value;

    bool hasMa = listCandledata.last.trends.isNotEmpty;
    bool isMaMatch = MainPresenter.to.maMatchCriteria.value;
    List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
    List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
    int maLength = listCandledata.last.trends.length;

    if (isMaMatch) {
      if (!hasMa) {
        await Candle().computeTrendLines();
        // listCandledata = MainPresenter.to.listCandledata;
        hasMa = listCandledata.last.trends.isNotEmpty;
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
    // int dummyCandleLen = MainPresenter.to.dummyCandle.length;
    if (alwaysUseCrossData) {
      thisLen = MainPresenter.to.minuteDataList.length + 1;
      // if (MainPresenter.to.spyListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.qqqListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.usoListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.gldListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.slvListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.iwmListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.xlkListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.aaplListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.baListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.bacListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.mcdListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.nvdaListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.msftListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.gskListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.tslaListCandledata.length != dummyCandleLen ||
      //     MainPresenter.to.amznListCandledata.length != dummyCandleLen) {
      //   MainPresenter.to.dispose();
      //   Get.put(MainPresenter());
      //   logger.d('Instance "MainPresenter" has been reloaded');
      // }
    } else {
      thisLen = 1;
    }
    for (int i = 0; i < thisLen; i++) {
      String thisTurnSymbol = '';
      dynamic dataList;
      // bool hasData = false;
      // List<CandleData> spyListCandledata = MainPresenter.to.spyListCandledata;
      // List<CandleData> qqqListCandledata = MainPresenter.to.qqqListCandledata;
      // List<CandleData> usoListCandledata = MainPresenter.to.usoListCandledata;
      // List<CandleData> gldListCandledata = MainPresenter.to.gldListCandledata;
      // List<CandleData> slvListCandledata = MainPresenter.to.slvListCandledata;
      // List<CandleData> iwmListCandledata = MainPresenter.to.iwmListCandledata;
      // List<CandleData> xlkListCandledata = MainPresenter.to.xlkListCandledata;
      // List<CandleData> aaplListCandledata = MainPresenter.to.aaplListCandledata;
      // List<CandleData> baListCandledata = MainPresenter.to.baListCandledata;
      // List<CandleData> bacListCandledata = MainPresenter.to.bacListCandledata;
      // List<CandleData> mcdListCandledata = MainPresenter.to.mcdListCandledata;
      // List<CandleData> nvdaListCandledata = MainPresenter.to.nvdaListCandledata;
      // List<CandleData> msftListCandledata = MainPresenter.to.msftListCandledata;
      // List<CandleData> gskListCandledata = MainPresenter.to.gskListCandledata;
      // List<CandleData> tslaListCandledata = MainPresenter.to.tslaListCandledata;
      // List<CandleData> amznListCandledata = MainPresenter.to.amznListCandledata;
      if (i != 0) {
        if (i == 1 && symbol != 'SPY') {
          // if (spyListCandledata.isEmpty ||
          //     spyListCandledata.length <= dummyCandleLen) {
          dataList = await isar.spyDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'SPY';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = spyListCandledata;
          // }
        } else if (i == 2 && symbol != 'QQQ') {
          // if (qqqListCandledata.isEmpty ||
          //     qqqListCandledata.length <= dummyCandleLen) {
          dataList = await isar.qqqDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'QQQ';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = qqqListCandledata;
          // }
        } else if (i == 3 && symbol != 'USO') {
          // if (usoListCandledata.isEmpty ||
          //     usoListCandledata.length <= dummyCandleLen) {
          dataList = await isar.usoDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'USO';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = usoListCandledata;
          // }
        } else if (i == 4 && symbol != 'GLD') {
          // if (gldListCandledata.isEmpty ||
          //     gldListCandledata.length <= dummyCandleLen) {
          dataList = await isar.gldDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'GLD';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = gldListCandledata;
          // }
        } else if (i == 5 && symbol != 'SLV') {
          // if (slvListCandledata.isEmpty ||
          //     slvListCandledata.length <= dummyCandleLen) {
          dataList = await isar.slvDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'SLV';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = slvListCandledata;
          // }
        } else if (i == 6 && symbol != 'IWM') {
          // if (iwmListCandledata.isEmpty ||
          //     iwmListCandledata.length <= dummyCandleLen) {
          dataList = await isar.iwmDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'IWM';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = iwmListCandledata;
          // }
        } else if (i == 7 && symbol != 'XLK') {
          // if (xlkListCandledata.isEmpty ||
          //     xlkListCandledata.length <= dummyCandleLen) {
          dataList = await isar.xlkDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'XLK';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = xlkListCandledata;
          // }
        } else if (i == 8 && symbol != 'AAPL') {
          // if (aaplListCandledata.isEmpty ||
          //     aaplListCandledata.length <= dummyCandleLen) {
          dataList = await isar.aaplDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'AAPL';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = aaplListCandledata;
          // }
        } else if (i == 9 && symbol != 'BA') {
          // if (baListCandledata.isEmpty ||
          //     baListCandledata.length <= dummyCandleLen) {
          dataList = await isar.baDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'BA';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = baListCandledata;
          // }
        } else if (i == 10 && symbol != 'BAC') {
          // if (bacListCandledata.isEmpty ||
          //     bacListCandledata.length <= dummyCandleLen) {
          dataList = await isar.bacDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'BAC';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = bacListCandledata;
          // }
        } else if (i == 11 && symbol != 'MCD') {
          // if (mcdListCandledata.isEmpty ||
          //     mcdListCandledata.length <= dummyCandleLen) {
          dataList = await isar.mcdDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'MCD';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = mcdListCandledata;
          // }
        } else if (i == 12 && symbol != 'NVDA') {
          // if (nvdaListCandledata.isEmpty ||
          //     nvdaListCandledata.length <= dummyCandleLen) {
          dataList = await isar.nvdaDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'NVDA';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = nvdaListCandledata;
          // }
        } else if (i == 13 && symbol != 'MSFT') {
          // if (msftListCandledata.isEmpty ||
          //     msftListCandledata.length <= dummyCandleLen) {
          dataList = await isar.msftDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'MSFT';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = msftListCandledata;
          // }
        } else if (i == 14 && symbol != 'GSK') {
          // if (gskListCandledata.isEmpty ||
          //     gskListCandledata.length <= dummyCandleLen) {
          dataList = await isar.gskDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'GSK';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = gskListCandledata;
          // }
        } else if (i == 15 && symbol != 'TSLA') {
          // if (tslaListCandledata.isEmpty ||
          //     tslaListCandledata.length <= dummyCandleLen) {
          dataList = await isar.tslaDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'TSLA';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = tslaListCandledata;
          // }
        } else if (i == 16 && symbol != 'AMZN') {
          // if (amznListCandledata.isEmpty ||
          //     amznListCandledata.length <= dummyCandleLen) {
          dataList = await isar.amznDatas.where().sortByTimeKey().findAll();
          thisTurnSymbol = 'AMZN';
          if (dataList.isEmpty) {
            continue;
          }
          // } else {
          //   hasData = true;
          //   listCandledata = amznListCandledata;
          // }
        } else {
          if (i == 16) {
            break;
          }
          int l = i + 1;
          if (l == 1 && symbol != 'SPY') {
            // if (spyListCandledata.isEmpty ||
            //     spyListCandledata.length <= dummyCandleLen) {
            dataList = await isar.spyDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'SPY';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = spyListCandledata;
            // }
          } else if (l == 2 && symbol != 'QQQ') {
            // if (qqqListCandledata.isEmpty ||
            //     qqqListCandledata.length <= dummyCandleLen) {
            dataList = await isar.qqqDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'QQQ';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = qqqListCandledata;
            // }
          } else if (l == 3 && symbol != 'USO') {
            // if (usoListCandledata.isEmpty ||
            //     usoListCandledata.length <= dummyCandleLen) {
            dataList = await isar.usoDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'USO';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = usoListCandledata;
            // }
          } else if (l == 4 && symbol != 'GLD') {
            // if (gldListCandledata.isEmpty ||
            //     gldListCandledata.length <= dummyCandleLen) {
            dataList = await isar.gldDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'GLD';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = gldListCandledata;
            // }
          } else if (l == 5 && symbol != 'SLV') {
            // if (slvListCandledata.isEmpty ||
            //     slvListCandledata.length <= dummyCandleLen) {
            dataList = await isar.slvDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'SLV';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = slvListCandledata;
            // }
          } else if (l == 6 && symbol != 'IWM') {
            // if (iwmListCandledata.isEmpty ||
            //     iwmListCandledata.length <= dummyCandleLen) {
            dataList = await isar.iwmDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'IWM';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = iwmListCandledata;
            // }
          } else if (l == 7 && symbol != 'XLK') {
            // if (xlkListCandledata.isEmpty ||
            //     xlkListCandledata.length <= dummyCandleLen) {
            dataList = await isar.xlkDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'XLK';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = xlkListCandledata;
            // }
          } else if (l == 8 && symbol != 'AAPL') {
            // if (aaplListCandledata.isEmpty ||
            //     aaplListCandledata.length <= dummyCandleLen) {
            dataList = await isar.aaplDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'AAPL';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = aaplListCandledata;
            // }
          } else if (l == 9 && symbol != 'BA') {
            // if (baListCandledata.isEmpty ||
            //     baListCandledata.length <= dummyCandleLen) {
            dataList = await isar.baDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'BA';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = baListCandledata;
            // }
          } else if (l == 10 && symbol != 'BAC') {
            // if (bacListCandledata.isEmpty ||
            //     bacListCandledata.length <= dummyCandleLen) {
            dataList = await isar.bacDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'BAC';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = bacListCandledata;
            // }
          } else if (l == 11 && symbol != 'MCD') {
            // if (mcdListCandledata.isEmpty ||
            //     mcdListCandledata.length <= dummyCandleLen) {
            dataList = await isar.mcdDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'MCD';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = mcdListCandledata;
            // }
          } else if (l == 12 && symbol != 'NVDA') {
            // if (nvdaListCandledata.isEmpty ||
            //     nvdaListCandledata.length <= dummyCandleLen) {
            dataList = await isar.nvdaDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'NVDA';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = nvdaListCandledata;
            // }
          } else if (l == 13 && symbol != 'MSFT') {
            // if (msftListCandledata.isEmpty ||
            //     msftListCandledata.length <= dummyCandleLen) {
            dataList = await isar.msftDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'MSFT';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = msftListCandledata;
            // }
          } else if (l == 14 && symbol != 'GSK') {
            // if (gskListCandledata.isEmpty ||
            //     gskListCandledata.length <= dummyCandleLen) {
            dataList = await isar.gskDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'GSK';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = gskListCandledata;
            // }
          } else if (l == 15 && symbol != 'TSLA') {
            // if (tslaListCandledata.isEmpty ||
            //     tslaListCandledata.length <= dummyCandleLen) {
            dataList = await isar.tslaDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'TSLA';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = tslaListCandledata;
            // }
          } else if (l == 16 && symbol != 'AMZN') {
            // if (amznListCandledata.isEmpty ||
            //     amznListCandledata.length <= dummyCandleLen) {
            dataList = await isar.amznDatas.where().sortByTimeKey().findAll();
            thisTurnSymbol = 'AMZN';
            if (dataList.isEmpty) {
              continue;
            }
            // } else {
            //   hasData = true;
            //   listCandledata = amznListCandledata;
            // }
          } else {
            throw Exception('There is no minute interval data for $i');
          }
          i++;
        }
        // if (hasData && listCandledata.isEmpty) {
        //   continue;
        // }
        List<Map<String, dynamic>> docList = [];
        // if (!hasData) {
        if (thisTurnSymbol == 'SPY') {
          docList = List<SpyData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'QQQ') {
          docList = List<QqqData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'USO') {
          docList = List<UsoData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'GLD') {
          docList = List<GldData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'SLV') {
          docList = List<SlvData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'IWM') {
          docList = List<IwmData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'XLK') {
          docList = List<XlkData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'AAPL') {
          docList = List<AaplData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'BA') {
          docList = List<BaData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'BAC') {
          docList = List<BacData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'MCD') {
          docList = List<McdData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'NVDA') {
          docList = List<NvdaData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'MSFT') {
          docList = List<MsftData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'GSK') {
          docList = List<GskData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'TSLA') {
          docList = List<TslaData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else if (thisTurnSymbol == 'AMZN') {
          docList = List<AmznData>.from(dataList)
              .map<Map<String, dynamic>>((data) => data.toJson())
              .toList();
        } else {
          throw Exception(
              'There is no Isac data structure for $thisTurnSymbol');
        }
        listCandledata =
            await CandleAdapter().crossDataListListTolistCandledata((
          CandleAdapter().jsonToListList(Future.value(docList)),
          SrcFileType.json,
          thisTurnSymbol
        ));
        // }
        dataLength = listCandledata.length;
        totalDataLength += dataLength;
        await Candle().computeTrendLines(listCandledata: listCandledata);
      }

      void addMatchRow(int rowId) {
        if (thisTurnSymbol == 'SPY') {
          MainPresenter.to.spyMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'QQQ') {
          MainPresenter.to.qqqMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'USO') {
          MainPresenter.to.usoMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'GLD') {
          MainPresenter.to.gldMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'SLV') {
          MainPresenter.to.slvMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'IWM') {
          MainPresenter.to.iwmMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'XLK') {
          MainPresenter.to.xlkMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'AAPL') {
          MainPresenter.to.aaplMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'BA') {
          MainPresenter.to.baMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'BAC') {
          MainPresenter.to.bacMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'MCD') {
          MainPresenter.to.mcdMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'NVDA') {
          MainPresenter.to.nvdaMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'MSFT') {
          MainPresenter.to.msftMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'GSK') {
          MainPresenter.to.gskMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'TSLA') {
          MainPresenter.to.tslaMatchRows.add(rowId);
        } else if (thisTurnSymbol == 'AMZN') {
          MainPresenter.to.amznMatchRows.add(rowId);
        } else if (thisTurnSymbol == '') {
          MainPresenter.to.matchRows.add(rowId);
        } else {
          throw Exception('There is no matchRows for $thisTurnSymbol');
        }
      }

      for (int l = (isMaMatch ? maxMa() : 0);
          l < dataLength - len - subLen;
          l++) {
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
            priceTolerance); // Record data type in Dart is equivalent to Tuple in Java and Python

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

            bool isMaMatched = maDifferencesLessThanOrEqualToCertainPercent(
                selectedPeriodFirstMaAndPricePercentDifferencesList,
                selectedPeriodMaPercentDifferencesListList,
                comparePeriodFirstMaAndPricePercentDifferencesList,
                comparePeriodMaPercentDifferencesListList,
                maTolerance);
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
      List<double> selList, List<double> comList, int priceTolerance) {
    if (selList.length != comList.length) {
      // logger.d('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    if (MainPresenter.to.strictMatchCriteria.value) {
      int positiveTolerance = priceTolerance;
      int negativeTolerance = -priceTolerance;
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
          if (positiveTolerance == priceTolerance) {
            positiveTolerance -= percentDiff.toInt();
          } else {
            positiveTolerance = priceTolerance;
          }
        } else {
          // Negative percentDiff
          if (percentDiff < negativeTolerance) {
            return (false, []); // Difference is less than certain -%
          }
          if (negativeTolerance == -priceTolerance) {
            negativeTolerance -= percentDiff.toInt();
          } else {
            negativeTolerance = -priceTolerance;
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

        if (percentDiff.abs() > priceTolerance) {
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
      int maTolerance) {
    if (selList.length != comList.length) {
      // logger.d('${selList.length} != ${comList.length}');
      throw ArgumentError('Both lists must have the same length.');
    }

    int length = selFirstList.length;
    int maLength = MainPresenter.to.listCandledata.last.trends.length;

    if (MainPresenter.to.strictMatchCriteria.value) {
      int positiveTolerance = maTolerance;
      int negativeTolerance = -maTolerance;

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
          if (positiveTolerance == maTolerance) {
            positiveTolerance -= percentDiff.toInt();
          } else {
            positiveTolerance = maTolerance;
          }
        } else {
          // Negative percentDiff
          if (percentDiff < negativeTolerance) {
            return false; // Difference is less than certain -%
          }
          if (negativeTolerance == -maTolerance) {
            negativeTolerance -= percentDiff.toInt();
          } else {
            negativeTolerance = -maTolerance;
          }
        }
      }

      positiveTolerance = maTolerance;
      negativeTolerance = -maTolerance;
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
            if (positiveTolerance == maTolerance) {
              positiveTolerance -= percentDiff.toInt();
            } else {
              positiveTolerance = maTolerance;
            }
          } else {
            // Negative percentDiff
            if (percentDiff < negativeTolerance) {
              return false; // Difference is less than certain -%
            }
            if (negativeTolerance == -maTolerance) {
              negativeTolerance -= percentDiff.toInt();
            } else {
              negativeTolerance = -maTolerance;
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

        if (percentDiff.abs() > maTolerance) {
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

          if (percentDiff.abs() > maTolerance) {
            return false; // Difference is larger than certain %
          }
        }
      }
    }

    return true; // All differences are less than certain %
  }

  List<FlSpot> getSimplelineBarsData(int index, bool normalized,
      {List<int>? matchRows, List<List<dynamic>>? candleListList}) {
    List<FlSpot> flsportList = [];

    // Whether to normalize
    if (normalized) {
      if (MainPresenter.to.alwaysUseCrossData.value ||
          MainPresenter.to.isLockTrend.value) {
        List<double> closePrices = [];

        for (int l = 0; l < matchRows!.length; l++) {
          for (int i = 0;
              i < MainPresenter.to.selectedPeriodPercentDifferencesList.length;
              i++) {
            closePrices.add(candleListList![
                // The CSV/JSON data
                matchRows[l] + i // Loop all closing prices in the matched trend
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
          double closePrice = candleListList![
                  // The CSV/JSON data
                  matchRows[index] // Get the matched trend row from this index
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
      if (MainPresenter.to.alwaysUseCrossData.value ||
          MainPresenter.to.isLockTrend.value) {
        for (double i = 0;
            i <
                MainPresenter.to.selectedPeriodPercentDifferencesList.length +
                    1;
            i++) {
          flsportList.add(FlSpot(
              i, // Equal to selectedPeriodCount, starting from 0
              candleListList![// The CSV/JSON data
                      matchRows![
                              index] // Get the matched trend row from this index
                          +
                          i.toInt()] // Loop all closing prices in the matched trend
                  [4] // The 4th row of the list is the closing price
              ));
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
    if (MainPresenter.to.alwaysUseCrossData.value ||
        MainPresenter.to.isLockTrend.value) {
      List<String> minuteDataList =
          List<String>.from(MainPresenter.to.minuteDataList);
      String fiSymbol = MainPresenter.to.financialInstrumentSymbol.value;
      for (String symbol in minuteDataList) {
        List<int> matchRows;
        List<List<dynamic>> candleListList;
        if (symbol == 'SPY' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.spyMatchRows;
          candleListList = MainPresenter.to.spyCandleListList;
        } else if (symbol == 'QQQ' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.qqqMatchRows;
          candleListList = MainPresenter.to.qqqCandleListList;
        } else if (symbol == 'USO' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.usoMatchRows;
          candleListList = MainPresenter.to.usoCandleListList;
        } else if (symbol == 'GLD' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.gldMatchRows;
          candleListList = MainPresenter.to.gldCandleListList;
        } else if (symbol == 'SLV' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.slvMatchRows;
          candleListList = MainPresenter.to.slvCandleListList;
        } else if (symbol == 'IWM' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.iwmMatchRows;
          candleListList = MainPresenter.to.iwmCandleListList;
        } else if (symbol == 'XLK' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.xlkMatchRows;
          candleListList = MainPresenter.to.xlkCandleListList;
        } else if (symbol == 'AAPL' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.aaplMatchRows;
          candleListList = MainPresenter.to.aaplCandleListList;
        } else if (symbol == 'BA' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.baMatchRows;
          candleListList = MainPresenter.to.baCandleListList;
        } else if (symbol == 'BAC' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.bacMatchRows;
          candleListList = MainPresenter.to.bacCandleListList;
        } else if (symbol == 'MCD' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.mcdMatchRows;
          candleListList = MainPresenter.to.mcdCandleListList;
        } else if (symbol == 'NVDA' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.nvdaMatchRows;
          candleListList = MainPresenter.to.nvdaCandleListList;
        } else if (symbol == 'MSFT' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.msftMatchRows;
          candleListList = MainPresenter.to.msftCandleListList;
        } else if (symbol == 'GSK' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.gskMatchRows;
          candleListList = MainPresenter.to.gskCandleListList;
        } else if (symbol == 'TSLA' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.tslaMatchRows;
          candleListList = MainPresenter.to.tslaCandleListList;
        } else if (symbol == 'AMZN' && symbol != fiSymbol) {
          matchRows = MainPresenter.to.amznMatchRows;
          candleListList = MainPresenter.to.amznCandleListList;
        } else {
          matchRows = MainPresenter.to.matchRows;
          candleListList = MainPresenter.to.candleListList;
        }
        if (matchRows.isEmpty || candleListList.isEmpty) {
          continue;
        }
        if (lineBarsData.length >= 500) {
          break;
        }
        List<LineChartBarData> newLineBarsData = matchRows
            .mapIndexed((index, row) => LineChartBarData(
                spots: getSimplelineBarsData(
                  index,
                  normalized,
                  matchRows: matchRows,
                  candleListList: candleListList,
                ),
                isCurved: true,
                barWidth: 1,
                color: AppColor.greyColor))
            .take((500 - lineBarsData.length).clamp(0,
                500)) // Limit the items to the first 500 or the available number of lineBarsData
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

  List<FlSpot> getAdjustedLineData(int index,
      {List<int>? matchRows, List<List<dynamic>>? candleListList}) {
    List<FlSpot> flspotList = [];
    List<double> newLockTrendSubTrendList = [];

    matchRows ??= MainPresenter.to.matchRows;
    candleListList ??= MainPresenter.to.candleListList;

    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();

    double lastSelectedClosePrice = MainPresenter.to.candleListList.last[4];

    double lastActualDifference = lastSelectedClosePrice /
        candleListList[matchRows[index] + selectedLength.toInt()][4];

    double subLen = MainPresenter.to.subLength.value.toDouble();

    for (double i = 0; i < selectedLength + subLen + 1; i++) {
      if (i == selectedLength) {
        flspotList.add(FlSpot(i, lastSelectedClosePrice));
        newLockTrendSubTrendList.add(lastSelectedClosePrice);
      } else if (i == selectedLength + subLen) {
        double adjustedMatchedTrendClosePrice =
            candleListList[matchRows[index] + i.toInt()]
                    [4] // Close price of matched trend
                *
                lastActualDifference;

        flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
      } else {
        double adjustedMatchedTrendClosePrice =
            candleListList[matchRows[index] + i.toInt()]
                    [4] // Close price of matched trend
                *
                lastActualDifference;

        flspotList.add(FlSpot(i, adjustedMatchedTrendClosePrice));
        if (i > selectedLength) {
          newLockTrendSubTrendList.add(adjustedMatchedTrendClosePrice);
        }
      }
    }

    MainPresenter.to.lockTrendSubTrendList.add(newLockTrendSubTrendList);
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

  List<FlSpot> getCurrentPriceLine() {
    List<FlSpot> flspotList = [];

    double selectedLength =
        MainPresenter.to.selectedPeriodPercentDifferencesList.length.toDouble();
    double subLen = MainPresenter.to.subLength.value.toDouble();
    double lastSelectedClosePrice = MainPresenter.to.candleListList.last[4];

    flspotList.add(FlSpot(0, lastSelectedClosePrice));
    flspotList.add(FlSpot(selectedLength + subLen, lastSelectedClosePrice));

    return flspotList;
  }

  List<FlSpot> getClusterData(
      Map<String, dynamic> map, List<String> sortedKeys, int index) {
    List<FlSpot> flspotList = [];

    for (int i = 0; i < map.length; i++) {
      flspotList
          .add(FlSpot(i.toDouble(), map[sortedKeys[i]][index].toDouble()));
    }

    return flspotList;
  }

  LineChartData getDefaultAdjustedLineChartData({required bool isCluster}) {
    List<LineChartBarData> lineBarsData = [];
    if (!isCluster) {
      MainPresenter.to.lockTrendSubTrendList.value = [];
      if (MainPresenter.to.alwaysUseCrossData.value) {
        List<String> minuteDataList =
            List<String>.from(MainPresenter.to.minuteDataList);
        String fiSymbol = MainPresenter.to.financialInstrumentSymbol.value;
        for (String symbol in minuteDataList) {
          List<int> matchRows;
          List<List<dynamic>> candleListList;
          if (symbol == 'SPY' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.spyMatchRows;
            candleListList = MainPresenter.to.spyCandleListList;
          } else if (symbol == 'QQQ' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.qqqMatchRows;
            candleListList = MainPresenter.to.qqqCandleListList;
          } else if (symbol == 'USO' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.usoMatchRows;
            candleListList = MainPresenter.to.usoCandleListList;
          } else if (symbol == 'GLD' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.gldMatchRows;
            candleListList = MainPresenter.to.gldCandleListList;
          } else if (symbol == 'SLV' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.slvMatchRows;
            candleListList = MainPresenter.to.slvCandleListList;
          } else if (symbol == 'IWM' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.iwmMatchRows;
            candleListList = MainPresenter.to.iwmCandleListList;
          } else if (symbol == 'XLK' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.xlkMatchRows;
            candleListList = MainPresenter.to.xlkCandleListList;
          } else if (symbol == 'AAPL' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.aaplMatchRows;
            candleListList = MainPresenter.to.aaplCandleListList;
          } else if (symbol == 'BA' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.baMatchRows;
            candleListList = MainPresenter.to.baCandleListList;
          } else if (symbol == 'BAC' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.bacMatchRows;
            candleListList = MainPresenter.to.bacCandleListList;
          } else if (symbol == 'MCD' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.mcdMatchRows;
            candleListList = MainPresenter.to.mcdCandleListList;
          } else if (symbol == 'NVDA' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.nvdaMatchRows;
            candleListList = MainPresenter.to.nvdaCandleListList;
          } else if (symbol == 'MSFT' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.msftMatchRows;
            candleListList = MainPresenter.to.msftCandleListList;
          } else if (symbol == 'GSK' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.gskMatchRows;
            candleListList = MainPresenter.to.gskCandleListList;
          } else if (symbol == 'TSLA' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.tslaMatchRows;
            candleListList = MainPresenter.to.tslaCandleListList;
          } else if (symbol == 'AMZN' && symbol != fiSymbol) {
            matchRows = MainPresenter.to.amznMatchRows;
            candleListList = MainPresenter.to.amznCandleListList;
          } else {
            matchRows = MainPresenter.to.matchRows;
            candleListList = MainPresenter.to.candleListList;
          }
          if (matchRows.isEmpty || candleListList.isEmpty) {
            continue;
          }
          if (lineBarsData.length >= 500) {
            break;
          }
          List<LineChartBarData> newLineBarsData = matchRows
              .mapIndexed((index, row) => LineChartBarData(
                  spots: getAdjustedLineData(
                    index,
                    matchRows: matchRows,
                    candleListList: candleListList,
                  ),
                  isCurved: true,
                  barWidth: 1,
                  color: ThemeColor.secondary.value))
              .take((500 - lineBarsData.length).clamp(0,
                  500)) // Limit the items to the first 500 or the available number of lineBarsData
              .toList();
          lineBarsData.addAll(newLineBarsData);
        }
        lineBarsData.add(
          LineChartBarData(
            spots: getSelectedPeriodClosePrices(),
            isCurved: true,
            barWidth: 3,
            color: ThemeColor.primary.value,
          ),
        );
        lineBarsData.add(
          LineChartBarData(
            spots: getCurrentPriceLine(),
            isCurved: false,
            barWidth: 1,
            color: AppColor.blackColor,
          ),
        );
      } else {
        lineBarsData = MainPresenter.to.matchRows
            .mapIndexed((index, row) => LineChartBarData(
                spots: getAdjustedLineData(index),
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
          )
          ..add(
            LineChartBarData(
              spots: getCurrentPriceLine(),
              isCurved: false,
              barWidth: 1,
              color: AppColor.blackColor,
            ),
          );
      }
    } else {
      List cluster = MainPresenter.to.clusters;

      if (cluster.isEmpty) {
        List<String> clusterJsonList = PrefsService.to.prefs
            .getStringList(SharedPreferencesConstant.cluster)!;

        List<Map<String, List<dynamic>>>? retrieveCluster() {
          return clusterJsonList
              .map((jsonStr) =>
                  Map<String, List<dynamic>>.from(jsonDecode(jsonStr)))
              .toList();
        }

        cluster = retrieveCluster()!;
        MainPresenter.to.subsequentAnalyticsNotifier.value = true;
      }

      List<Color> colors = [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.pink,
        Colors.brown,
        Colors.grey,
        Colors.cyan,
        const Color(0xFFFF00FF), // Magenta
      ];
      double initialClosePrice = 0.0;
      int mapLength = 0;

      // Iterate over each map in the cluster list
      cluster.asMap().forEach((mapIndex, map) {
        // Assign a color based on the map index
        final color = colors[mapIndex % colors.length];

        // Collect keys and sort them
        List<String> sortedKeys = map.keys
            .where((key) =>
                key.startsWith('Close ') &&
                int.tryParse(key.split(" ")[1]) != null)
            .toList()
          ..sort((a, b) =>
              int.parse(a.split(' ')[1]).compareTo(int.parse(b.split(' ')[1])));

        // Ensure the keys are within the desired range
        sortedKeys = sortedKeys
            .where((key) => int.parse(key.split(' ')[1]) <= 20)
            .toList();

        int length = map['Close 1']!.length;
        for (int i = 0; i < length; i++) {
          lineBarsData.add(LineChartBarData(
            spots: getClusterData(map, sortedKeys, i),
            isCurved: true,
            barWidth: 1,
            color: color,
          ));
        }
        if (initialClosePrice == 0.0) {
          initialClosePrice = map['Close 1'][0];
        }
        if (mapLength == 0) {
          mapLength = map.length;
        }
      });

      // Limit to 500 items if necessary
      lineBarsData = lineBarsData.take(500).toList();

      List<FlSpot> spots = [];
      for (int i = 0; i < mapLength; i++) {
        spots.add(FlSpot(i.toDouble(), initialClosePrice));
      }
      lineBarsData.add(
        LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 1,
          color: AppColor.blackColor,
        ),
      );
      spots = [];
      int lockTrendLastRow = PrefsService.to.prefs
          .getInt(SharedPreferencesConstant.lockTrendLastRow)!;
      if (lockTrendLastRow != 0) {
        int lastRow = MainPresenter.to.candleListList.length - 1;
        for (int i = 0; i < MainPresenter.to.subLength.value + 1; i++) {
          if ((lockTrendLastRow + i) <= lastRow) {
            spots.add(FlSpot(i.toDouble(),
                MainPresenter.to.candleListList[lockTrendLastRow + i][4]));
          } else {
            break;
          }
        }
        lineBarsData.add(
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 2,
            color: AppColor.whiteColor,
          ),
        );
      }
    }
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      borderData: FlBorderData(show: false),
      lineBarsData: lineBarsData,
      titlesData: FlTitlesData(
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
                reservedSize:
                    (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 24.w
                        : 16.w),
                showTitles: true)),
      ),
    );
  }
}
