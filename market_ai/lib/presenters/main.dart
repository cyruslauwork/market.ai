import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:isar/isar.dart';

import 'package:market_ai/styles/styles.dart';
import 'package:market_ai/utils/utils.dart';
import 'package:market_ai/models/models.dart';
import 'package:market_ai/services/services.dart';
import 'package:market_ai/views/views.dart';
import 'package:market_ai/models/collections.dart';

class MainPresenter extends GetxController {
  // Singleton implementation
  static MainPresenter? _instance;
  factory MainPresenter() {
    _instance ??= MainPresenter._();
    return _instance!;
  }
  MainPresenter._();

  static MainPresenter get to => Get.find();

  List<CandleData> dummyCandle = [
    CandleData(
      timestamp: 1555939800 * 1000,
      open: 51.80,
      high: 53.94,
      low: 50.50,
      close: 52.55,
      volume: 60735500,
    ),
    CandleData(
      timestamp: 1556026200 * 1000,
      open: 43.80,
      high: 53.94,
      low: 42.50,
      close: 52.55,
      volume: 60735500,
    ),
    CandleData(
      timestamp: 1556112600 * 1000,
      open: 73.80,
      high: 83.94,
      low: 52.50,
      close: 72.55,
      volume: 60735500,
    ),
    CandleData(
      timestamp: 1556199000 * 1000,
      open: 72.55,
      high: 75.20,
      low: 70.50,
      close: 74.80,
      volume: 55000000,
    ),
    CandleData(
      timestamp: 1556285400 * 1000,
      open: 74.80,
      high: 76.50,
      low: 73.20,
      close: 75.50,
      volume: 51000000,
    ),
    CandleData(
      timestamp: 1556371800 * 1000,
      open: 75.50,
      high: 77.80,
      low: 74.50,
      close: 76.70,
      volume: 48000000,
    ),
    CandleData(
      timestamp: 1556458200 * 1000,
      open: 76.70,
      high: 77.90,
      low: 75.50,
      close: 77.20,
      volume: 46000000,
    ),
    CandleData(
      timestamp: 1556544600 * 1000,
      open: 77.20,
      high: 78.40,
      low: 76.80,
      close: 77.80,
      volume: 44000000,
    ),
    CandleData(
      timestamp: 1556631000 * 1000,
      open: 77.80,
      high: 79.20,
      low: 77.50,
      close: 78.90,
      volume: 42000000,
    ),
    CandleData(
      timestamp: 1556717400 * 1000,
      open: 78.90,
      high: 80.10,
      low: 78.20,
      close: 79.50,
      volume: 40000000,
    ),
    CandleData(
      timestamp: 1556803800 * 1000,
      open: 79.50,
      high: 81.00,
      low: 79.30,
      close: 80.70,
      volume: 38000000,
    ),
    CandleData(
      timestamp: 1556890200 * 1000,
      open: 80.70,
      high: 81.80,
      low: 80.10,
      close: 81.30,
      volume: 36000000,
    ),
    CandleData(
      timestamp: 1556976600 * 1000,
      open: 81.30,
      high: 82.50,
      low: 80.80,
      close: 82.20,
      volume: 34000000,
    ),
    CandleData(
      timestamp: 1557063000 * 1000,
      open: 82.20,
      high: 83.40,
      low: 81.60,
      close: 82.80,
      volume: 32000000,
    ),
    CandleData(
      timestamp: 1557149400 * 1000,
      open: 82.80,
      high: 84.00,
      low: 82.20,
      close: 83.50,
      volume: 30000000,
    ),
    CandleData(
      timestamp: 1557235800 * 1000,
      open: 83.50,
      high: 84.60,
      low: 82.80,
      close: 84.10,
      volume: 28000000,
    ),
    CandleData(
      timestamp: 1557495000 * 1000,
      open: 85.30,
      high: 87.10,
      low: 85.00,
      close: 86.50,
      volume: 22000000,
    ),
    CandleData(
      timestamp: 1557581400 * 1000,
      open: 86.50,
      high: 87.60,
      low: 86.00,
      close: 87.20,
      volume: 20000000,
    ),
    CandleData(
      timestamp: 1557667800 * 1000,
      open: 87.20,
      high: 88.40,
      low: 86.70,
      close: 87.80,
      volume: 18000000,
    ),
    CandleData(
      timestamp: 1557754200 * 1000,
      open: 87.80,
      high: 89.00,
      low: 87.10,
      close: 88.50,
      volume: 16000000,
    ),
    CandleData(
      timestamp: 1557840600 * 1000,
      open: 88.50,
      high: 89.80,
      low: 88.00,
      close: 89.10,
      volume: 14000000,
    ),
    CandleData(
      timestamp: 1557927000 * 1000,
      open: 89.10,
      high: 90.20,
      low: 88.40,
      close: 89.70,
      volume: 12000000,
    ),
    CandleData(
      timestamp: 1558013400 * 1000,
      open: 89.70,
      high: 90.90,
      low: 88.90,
      close: 90.40,
      volume: 10000000,
    ),
    CandleData(
      timestamp: 1558099800 * 1000,
      open: 90.40,
      high: 91.60,
      low: 89.70,
      close: 91.10,
      volume: 8000000,
    ),
    CandleData(
      timestamp: 1558186200 * 1000,
      open: 91.10,
      high: 92.30,
      low: 90.40,
      close: 91.80,
      volume: 6000000,
    ),
    CandleData(
      timestamp: 1558272600 * 1000,
      open: 91.80,
      high: 93.00,
      low: 91.10,
      close: 92.50,
      volume: 4000000,
    ),
    CandleData(
      timestamp: 1558359000 * 1000,
      open: 92.50,
      high: 93.70,
      low: 91.80,
      close: 93.20,
      volume: 2000000,
    ),
    CandleData(
      timestamp: 1558445400 * 1000,
      open: 93.20,
      high: 94.40,
      low: 92.50,
      close: 93.90,
      volume: 1000000,
    ),
    CandleData(
      timestamp: 1558531800 * 1000,
      open: 93.90,
      high: 95.00,
      low: 93.10,
      close: 94.50,
      volume: 900000,
    ),
    CandleData(
      timestamp: 1558618200 * 1000,
      open: 94.50,
      high: 95.70,
      low: 93.80,
      close: 95.20,
      volume: 800000,
    ),
    CandleData(
      timestamp: 1558704600 * 1000,
      open: 95.20,
      high: 96.40,
      low: 94.50,
      close: 95.90,
      volume: 700000,
    ),
    CandleData(
      timestamp: 1558791000 * 1000,
      open: 95.90,
      high: 97.10,
      low: 95.20,
      close: 96.60,
      volume: 600000,
    ),
    CandleData(
      timestamp: 1558877400 * 1000,
      open: 96.60,
      high: 97.80,
      low: 95.90,
      close: 97.30,
      volume: 500000,
    ),
    CandleData(
      timestamp: 1558963800 * 1000,
      open: 97.30,
      high: 98.50,
      low: 96.60,
      close: 98.00,
      volume: 400000,
    ),
    CandleData(
      timestamp: 1559050200 * 1000,
      open: 98.00,
      high: 99.20,
      low: 97.30,
      close: 98.70,
      volume: 300000,
    ),
    CandleData(
      timestamp: 1559136600 * 1000,
      open: 98.70,
      high: 99.90,
      low: 97.90,
      close: 99.40,
      volume: 200000,
    ),
    CandleData(
      timestamp: 1559223000 * 1000,
      open: 99.40,
      high: 100.60,
      low: 98.70,
      close: 100.10,
      volume: 100000,
    ),
    CandleData(
      timestamp: 1559309400 * 1000,
      open: 100.10,
      high: 101.30,
      low: 99.40,
      close: 100.80,
      volume: 50000,
    ),
    CandleData(
      timestamp: 1559395800 * 1000,
      open: 100.80,
      high: 102.00,
      low: 100.10,
      close: 101.50,
      volume: 25000,
    ),
    CandleData(
      timestamp: 1559482200 * 1000,
      open: 101.50,
      high: 102.70,
      low: 100.80,
      close: 102.20,
      volume: 10000,
    ),
  ];
  bool isInit = false;

  /* Preference */
  RxBool darkMode =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.darkMode) ??
              false)
          .obs;
  bool isDarkModeInit = false;
  RxBool devMode = false.obs;
  ValueNotifier<bool> devModeNotifier = ValueNotifier<bool>(false);
  bool isDevModeListenerAdded = false;
  ValueNotifier<bool> isEnNotifier = ValueNotifier<bool>(
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.isEn) ?? true));
  bool isEnListenerAdded = false;
  RxBool alwaysShowAnalytics = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowAnalytics) ??
          false)
      .obs;
  RxBool alwaysShowSdDistPlot = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowSdDistPlot) ??
          false)
      .obs;
  RxList<String> watchlist = (PrefsService.to.prefs
              .getStringList(SharedPreferencesConstant.watchlist) ??
          [])
      .obs;
  late Rx<IconData> bookmarked =
      (watchlist.contains(financialInstrumentSymbol.value)
              ? Icons.bookmark_outlined
              : Icons.bookmark_border_outlined)
          .obs;
  RxString apiKey =
      (PrefsService.to.prefs.getString(SharedPreferencesConstant.apiKey) ?? '')
          .obs;
  RxString apiKeyErr =
      (PrefsService.to.prefs.getString(SharedPreferencesConstant.apiKeyErr) ??
              '')
          .obs;
  RxString jumpServerUrl = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.jumpServerUrl) ??
          '35.212.154.124')
      .obs;
  RxBool alwaysShowMinuteData = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysShowMinuteData) ??
          false)
      .obs;
  late Rx<IconData> dataGranularity =
      (alwaysShowMinuteData.value ? Icons.timer_outlined : Icons.today).obs;
  RxBool alwaysUseCrossData = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysUseCrossData) ??
          false)
      .obs;
  late Rx<IconData> crossData =
      (alwaysUseCrossData.value ? Icons.dataset_linked_rounded : Icons.dataset)
          .obs;
  RxBool closePosWhenReachedMedian = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.closePosWhenReachedMedian) ??
          false)
      .obs;

  /* Candlestick-related */
  RxString financialInstrumentSymbol = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.financialInstrumentSymbol) ??
          'SPY')
      .obs;
  RxString financialInstrumentName = (PrefsService.to.prefs
              .getString(SharedPreferencesConstant.financialInstrumentName) ??
          'SPDR S&P 500 ETF Trust')
      .obs;
  RxInt candledownloadTime = 0.obs;
  RxList<List<dynamic>> candleListList = [[]].obs;
  RxList<List<dynamic>> spyCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> qqqCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> usoCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> gldCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> slvCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> iwmCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> xlkCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> aaplCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> baCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> bacCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> mcdCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> nvdaCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> msftCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> gskCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> tslaCandleListList = [[]].obs; // Cross-data
  RxList<List<dynamic>> amznCandleListList = [[]].obs; // Cross-data
  late Rx<Future<List<CandleData>>> futureListCandledata = init().obs;
  late RxList<CandleData> listCandledata = dummyCandle.obs;
  late RxList<CandleData> spyListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> qqqListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> usoListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> gldListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> slvListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> iwmListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> xlkListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> aaplListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> baListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> bacListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> mcdListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> nvdaListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> msftListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> gskListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> tslaListCandledata = dummyCandle.obs; // Cross-data
  late RxList<CandleData> amznListCandledata = dummyCandle.obs; // Cross-data
  ValueNotifier<bool> showAverageNotifier = ValueNotifier<bool>(true);
  bool isShowAverageListenerAdded = false;
  late RxString marketDataProviderMsg = Rx('mkt_data'.tr)().obs;
  RxBool isMarketDataProviderErr = false.obs;
  RxList<String> minuteDataList = [
    'SPY',
    'QQQ',
    'USO',
    'GLD',
    'SLV',
    'IWM',
    'XLK',
    'AAPL',
    'BA',
    'BAC',
    'MCD',
    'NVDA',
    'MSFT',
    'GSK',
    'TSLA',
    'AMZN',
  ].obs;
  RxBool hasMinuteData = false.obs;
  late Rx<String> lastDatetime = 'Loading last datetime...'.obs;
  RxBool hasCandleData = false.obs;
  late RxString legends = (alwaysShowMinuteData.value
          ? '🟠EMA5 🔴EMA10 🟢EMA15 🔵EMA20'
          : '🟠MA5 🔴MA20 🟢MA60 🔵MA120 🟣MA240')
      .obs;
  RxBool hasSpyMinuteData = false.obs;
  RxBool hasQqqMinuteData = false.obs;
  RxBool hasUsoMinuteData = false.obs;
  RxBool hasGldMinuteData = false.obs;
  RxBool hasSlvMinuteData = false.obs;
  RxBool hasIwmMinuteData = false.obs;
  RxBool hasXlkMinuteData = false.obs;
  RxBool hasAaplMinuteData = false.obs;
  RxBool hasBaMinuteData = false.obs;
  RxBool hasBacMinuteData = false.obs;
  RxBool hasMcdMinuteData = false.obs;
  RxBool hasNvdaMinuteData = false.obs;
  RxBool hasMsftMinuteData = false.obs;
  RxBool hasGskMinuteData = false.obs;
  RxBool hasTslaMinuteData = false.obs;
  RxBool hasAmznMinuteData = false.obs;

  /* Listings */
  RxInt listingsDownloadTime = 0.obs;
  RxList<SymbolAndName> listSymbolAndName =
      [const SymbolAndName(symbol: '', name: '')].obs;
  RxString listingErr = ''.obs;
  RxBool isListingInit = false.obs;
  late RxString listingsProviderMsg = Rx('listings'.tr)().obs;
  RxBool isListingsProviderErr = false.obs;

  /* Search */
  ValueNotifier<int> searchCountNotifier = ValueNotifier<int>(0);
  bool isSearchCountListenerAdded = false;
  RxBool alwaysSkipSymbolInSearch = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysSkipSymbolInSearch) ??
          false)
      .obs;
  RxBool alwayStrictMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwayStrictMatchCriteria) ??
          false)
      .obs;
  RxBool strictMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwayStrictMatchCriteria) ??
          false)
      .obs;
  RxBool alwaysMaMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysMaMatchCriteria) ??
          false)
      .obs;
  RxBool maMatchCriteria = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysMaMatchCriteria) ??
          false)
      .obs;

  /* Chat */
  RxList<String> messages = (PrefsService.to.prefs
              .getStringList(SharedPreferencesConstant.messages) ??
          [
            "Hi! I'm your dedicated News AI, here to assist you in analyzing news related to your preferred stocks or ETFs! ^_^"
          ])
      .obs;
  RxBool isWaitingForReply = false.obs;
  RxInt aiResponseTime = 0.obs;
  RxBool firstQuestion = true.obs;
  ValueNotifier<bool> waitingForReplyNotifier = ValueNotifier<bool>(false);
  bool isWaitingForReplyNotifierAdded = false;

  /* Trend match */
  RxInt length =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.length) ?? 4).obs;
  RxInt candleTolerance = (PrefsService.to.prefs
              .getInt(SharedPreferencesConstant.candleTolerance) ??
          40)
      .obs;
  RxInt priceTolerance =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.priceTolerance) ??
              40)
          .obs;
  RxInt firstMaTolerance = (PrefsService.to.prefs
              .getInt(SharedPreferencesConstant.firstMaTolerance) ??
          40)
      .obs;
  RxInt maTolerance =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.maTolerance) ??
              40)
          .obs;
  RxList<double> selectedPeriodPercentDifferencesList = [0.0].obs;
  // RxList<double> selectedPeriodActualDifferencesList = [0.0].obs;
  // RxList<double> selectedPeriodActualPricesList = [0.0].obs;
  // RxList<List<double>> comparePeriodPercentDifferencesListList = [
  //   [0.0]
  // ].obs;
  // RxList<List<double>> comparePeriodActualDifferencesListList = [
  //   [0.0]
  // ].obs;
  // RxList<List<double>> comparePeriodActualPricesListList = [
  //   [0.0]
  // ].obs;
  // RxList<List<double>> matchPercentDifferencesListList = [
  //   [0.0]
  // ].obs;
  // RxList<List<double>> matchActualDifferencesListList = [
  //   [0.0]
  // ].obs;
  // RxList<List<double>> matchActualPricesListList = [
  //   [0.0]
  // ].obs;
  RxList<int> trendMatchOutput = [0, 0, 0, 0, 0].obs;
  RxList<int> matchRows = [0].obs;
  RxList<int> spyMatchRows = [0].obs; // Cross-data
  RxList<int> qqqMatchRows = [0].obs; // Cross-data
  RxList<int> usoMatchRows = [0].obs; // Cross-data
  RxList<int> gldMatchRows = [0].obs; // Cross-data
  RxList<int> slvMatchRows = [0].obs; // Cross-data
  RxList<int> iwmMatchRows = [0].obs; // Cross-data
  RxList<int> xlkMatchRows = [0].obs; // Cross-data
  RxList<int> aaplMatchRows = [0].obs; // Cross-data
  RxList<int> baMatchRows = [0].obs; // Cross-data
  RxList<int> bacMatchRows = [0].obs; // Cross-data
  RxList<int> mcdMatchRows = [0].obs; // Cross-data
  RxList<int> nvdaMatchRows = [0].obs; // Cross-data
  RxList<int> msftMatchRows = [0].obs; // Cross-data
  RxList<int> gskMatchRows = [0].obs; // Cross-data
  RxList<int> tslaMatchRows = [0].obs; // Cross-data
  RxList<int> amznMatchRows = [0].obs; // Cross-data
  RxBool trendMatched = false.obs;
  RxBool showAnalytics = false.obs;
  ValueNotifier<bool> showAnalyticsNotifier = ValueNotifier<bool>(false);
  bool isShowAnalyticsNotifierAdded = false;
  late RxDouble candleChartHeight = (showAnalytics.value ? 50.h : 100.h).obs;
  ValueNotifier<bool> chartExpandNotifier = ValueNotifier<bool>(true);
  bool isChartExpandNotifierAdded = false;
  Rx<IconData> expandOrShrinkIcon = Icons.vertical_align_center_rounded.obs;
  Rx<Widget> sidePlot = (const SizedBox.shrink()).obs;
  late RxDouble tmChartWidth =
      (Platform.isWindows || Platform.isLinux || Platform.isMacOS
          ? (Get.width - 5.w).obs
          : 135.w.obs);
  RxInt subLength =
      (PrefsService.to.prefs.getInt(SharedPreferencesConstant.subLength) ?? 12)
          .obs;
  RxInt maxMa = 240.obs;
  /* Lock-in Trend */
  RxBool isLockTrend =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.lockTrend) ??
              false)
          .obs;
  RxBool isFirstThirtyMins = true.obs;
  RxBool hitCeilingOrFloor = true.obs;
  RxBool goOpposite = true.obs;
  RxBool lowReturn =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.lowReturn) ??
              true)
          .obs;
  RxBool lowProb =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.lowProb) ?? true)
          .obs;
  RxBool trendsLessThanFive = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.trendsLessThanFive) ??
          true)
      .obs;
  RxBool trendsOneSidedButLessThanFour = (PrefsService.to.prefs.getBool(
              SharedPreferencesConstant.trendsOneSidedButLessThanFour) ??
          true)
      .obs;
  RxBool trendsNotOneSided = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.trendsNotOneSided) ??
          true)
      .obs;
  RxString instruction = 'Awaiting for instruction...'.obs;
  RxDouble expectedProb = (PrefsService.to.prefs
              .getDouble(SharedPreferencesConstant.expectedProb) ??
          0.0)
      .obs;
  RxDouble returnRate =
      (PrefsService.to.prefs.getDouble(SharedPreferencesConstant.returnRate) ??
              0.0)
          .obs;
  RxString expectedMdd =
      (PrefsService.to.prefs.getString(SharedPreferencesConstant.expectedMdd) ??
              '±0')
          .obs;
  RxBool isLong =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.isLong) ?? false)
          .obs;
  RxBool isShort =
      (PrefsService.to.prefs.getBool(SharedPreferencesConstant.isShort) ??
              false)
          .obs;
  Rx<TextStyle> instructionTextStyle =
      const TextTheme().sp10.tertiarythemeTextColor.w700.obs;
  late Rx<TextStyle> lockTrendTextStyle = (darkMode.value
          ? const TextTheme().sp4.whiteColor.w700
          : const TextTheme().sp4.blackColor.w700)
      .obs;
  RxList clusters = [].obs;
  RxBool hasCluster = false.obs;
  RxString lockTrendDatetimeString = ''.obs;
  RxList<List<double>> lockTrendSubTrendList = [
    [0.0]
  ].obs;
  RxBool over = true.obs;
  RxInt trackingSubLen = 0.obs;
  RxDouble expectedTrackingProb = 0.0.obs;
  RxBool trackingHits = true.obs;
  RxBool trackingHitsOnesided = true.obs;
  RxList<List<double>> lockTrendTrackingSubTrendList = [
    [0.0]
  ].obs;
  RxList<int> trackingMatchRows = [0].obs;
  RxList<int> trackingSpyMatchRows = [0].obs; // Cross-data
  RxList<int> trackingQqqMatchRows = [0].obs; // Cross-data
  RxList<int> trackingUsoMatchRows = [0].obs; // Cross-data
  RxList<int> trackingGldMatchRows = [0].obs; // Cross-data
  RxList<int> trackingSlvMatchRows = [0].obs; // Cross-data
  RxList<int> trackingIwmMatchRows = [0].obs; // Cross-data
  RxList<int> trackingXlkMatchRows = [0].obs; // Cross-data
  RxList<int> trackingAaplMatchRows = [0].obs; // Cross-data
  RxList<int> trackingBaMatchRows = [0].obs; // Cross-data
  RxList<int> trackingBacMatchRows = [0].obs; // Cross-data
  RxList<int> trackingMcdMatchRows = [0].obs; // Cross-data
  RxList<int> trackingNvdaMatchRows = [0].obs; // Cross-data
  RxList<int> trackingMsftMatchRows = [0].obs; // Cross-data
  RxList<int> trackingGskMatchRows = [0].obs; // Cross-data
  RxList<int> trackingTslaMatchRows = [0].obs; // Cross-data
  RxList<int> trackingAmznMatchRows = [0].obs; // Cross-data

  /* Subsequent analytics */
  RxInt lastClosePriceAndSubsequentTrendsExeTime = 0.obs;
  RxInt cloudSubsequentAnalyticsTime = 0.obs;
  RxBool hasSubsequentAnalytics = false.obs;
  Rx<Uint8List> img1Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img2Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img3Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img4Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img5Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img6Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img7Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img8Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img9Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  Rx<Uint8List> img10Bytes = Rx<Uint8List>(Uint8List.fromList([0]));
  RxString subsequentAnalyticsErr = ''.obs;
  RxInt numOfClusters = 0.obs;
  RxString maxSilhouetteScore = '0'.obs;
  ValueNotifier<bool> subsequentAnalyticsNotifier = ValueNotifier<bool>(false);
  bool isSubsequentAnalyticsNotifierAdded = false;
  RxInt saCount = 0.obs;

  // Backtest
  RxBool isButtonDisabled = false.obs;
  RxString backtestingSymbol = ''.obs;
  RxInt backtestDataLen1 = 0.obs;
  RxInt backtestDataLen2 = 0.obs;
  RxInt backtestDataLen3 = 0.obs;
  RxInt backtestDataLen4 = 0.obs;
  RxInt backtestDataLen5 = 0.obs;
  RxInt backtestDataRan1 = 0.obs;
  RxInt backtestDataRan2 = 0.obs;
  RxInt backtestDataRan3 = 0.obs;
  RxInt backtestDataRan4 = 0.obs;
  RxInt backtestDataRan5 = 0.obs;
  RxBool alwaysThousandthsData = (PrefsService.to.prefs
              .getBool(SharedPreferencesConstant.alwaysThousandthsData) ??
          false)
      .obs;
  RxDouble probThreshold = (PrefsService.to.prefs
              .getDouble(SharedPreferencesConstant.probThreshold) ??
          0.7)
      .obs;
  RxDouble minReturnRateThreshold = (PrefsService.to.prefs
              .getDouble(SharedPreferencesConstant.minReturnRateThreshold) ??
          0.0005)
      .obs;
  RxBool reachedMedian = true.obs;

  // A 2nd initialization will be triggered when starting the app
  @override
  void onInit() {
    if (!isInit) {
      // PrefsService.to.prefs
      //     .setString(SharedPreferencesConstant.financialInstrumentSymbol, 'QQQ');
      // PrefsService.to.prefs.setString(
      //     SharedPreferencesConstant.financialInstrumentName,
      //     'Invesco QQQ Trust, Series 1');
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.range, 5);
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.candleTolerance, 40);
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.priceTolerance, 40);
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.firstMaTolerance, 40);
      // PrefsService.to.prefs.setInt(SharedPreferencesConstant.maTolerance, 40);
      // PrefsService.to.prefs
      //     .setStringList(SharedPreferencesConstant.watchlist, []);
      // PrefsService.to.prefs
      //     .setBool(SharedPreferencesConstant.alwaysShowMinuteData, false);
      alwaysUseCrossData.value = false;
      PrefsService.to.prefs
          .setBool(SharedPreferencesConstant.alwaysUseCrossData, false);

      matchRows.value = [];
      spyMatchRows.value = []; // Cross-data
      qqqMatchRows.value = []; // Cross-data
      usoMatchRows.value = []; // Cross-data
      gldMatchRows.value = []; // Cross-data
      slvMatchRows.value = []; // Cross-data
      iwmMatchRows.value = []; // Cross-data
      xlkMatchRows.value = []; // Cross-data
      aaplMatchRows.value = []; // Cross-data
      baMatchRows.value = []; // Cross-data
      bacMatchRows.value = []; // Cross-data
      mcdMatchRows.value = []; // Cross-data
      nvdaMatchRows.value = []; // Cross-data
      msftMatchRows.value = []; // Cross-data
      gskMatchRows.value = []; // Cross-data
      tslaMatchRows.value = []; // Cross-data
      amznMatchRows.value = []; // Cross-data

      // isLockTrend.value = false;
      // PrefsService.to.prefs.setBool(SharedPreferencesConstant.lockTrend, false);
      // PrefsService.to.prefs
      //     .setStringList(SharedPreferencesConstant.cluster, []);
      // isShort.value = false;
      // PrefsService.to.prefs.setBool(SharedPreferencesConstant.isShort, false);

      isInit = true;
    }

    super.onInit();
    if (!isDarkModeInit) {
      if (darkMode.value) {
        AppColor.primaryTextColor = Colors.white;
      } else {
        AppColor.primaryTextColor = Colors.black;
      }
      isDarkModeInit = true;
    }

    if (!isShowAverageListenerAdded) {
      showAverageNotifier.addListener(showAverageListener);
      isShowAverageListenerAdded = true;
    }

    if (!isDevModeListenerAdded) {
      devModeNotifier.addListener(devModeListener);
      isDevModeListenerAdded = true;
    }

    if (!isEnListenerAdded) {
      isEnNotifier.addListener(isEnListener);
      isEnListenerAdded = true;
    }

    if (!isSearchCountListenerAdded) {
      searchCountNotifier.addListener(isSearchCountListener);
      isSearchCountListenerAdded = true;
    }

    if (!isListingInit.value) {
      isListingInit.value =
          true; // Must set the value to true before invoking the method
      Listing().init();
    }

    if (!isShowAnalyticsNotifierAdded) {
      showAnalyticsNotifier.addListener(showAnalyticsListener);
      isShowAnalyticsNotifierAdded = true;
    }

    if (!isChartExpandNotifierAdded) {
      chartExpandNotifier.addListener(chartExpandListener);
      isChartExpandNotifierAdded = true;
    }

    if (!isSubsequentAnalyticsNotifierAdded) {
      subsequentAnalyticsNotifier.addListener(subsequentAnalyticsListener);
      isSubsequentAnalyticsNotifierAdded = true;
    }

    if (!isWaitingForReplyNotifierAdded) {
      waitingForReplyNotifier.addListener(waitingForReplyListener);
      isWaitingForReplyNotifierAdded = true;
    }
  }

  void showAverageListener() {
    // Perform actions based on the new value of showAverage
    if (showAverageNotifier.value) {
      // Show the average
      Candle().computeTrendLines();
    } else {
      // Hide the average
      Candle().removeTrendLines();
    }
  }

  void devModeListener() {
    devMode.toggle();
    if (devModeNotifier.value) {
      Get.snackbar(
          'system_info'.tr,
          colorText: AppColor.whiteColor,
          backgroundColor: AppColor.greyColor,
          icon: const Icon(Icons.settings),
          'dev_mode'.tr);
      showAnalyticsNotifier.value = true;
    }
  }

  void isEnListener() {
    if (isEnNotifier.value) {
      LangService.to.changeLanguage(Lang.en);
      if (!isLockTrend.value) {
        SubsequentAnalytics().init();
      }
    } else {
      LangService.to.changeLanguage(Lang.zh);
      if (!isLockTrend.value) {
        SubsequentAnalytics().init();
      }
    }
  }

  void isSearchCountListener() {
    bookmarked.value = watchlist.contains(financialInstrumentSymbol.value)
        ? Icons.bookmark_outlined
        : Icons.bookmark_border_outlined;
    futureListCandledata.value = init();
  }

  void showAnalyticsListener() {
    if (showAnalyticsNotifier.value) {
      showAnalytics.value = true;
      chartExpandNotifier.value = false;
    } else {
      showAnalytics.value = false;
      chartExpandNotifier.value = true;
    }
  }

  void chartExpandListener() {
    if (chartExpandNotifier.value) {
      candleChartHeight.value = 100.h;
      expandOrShrinkIcon.value = Icons.vertical_align_center_rounded;
    } else {
      candleChartHeight.value = 50.h;
      expandOrShrinkIcon.value = Icons.expand;
    }
  }

  void subsequentAnalyticsListener() {
    double width = (Platform.isWindows || Platform.isLinux || Platform.isMacOS
        ? (Get.width - 5.w)
        : 135.w);
    if (subsequentAnalyticsNotifier.value &&
        subsequentAnalyticsErr.value != '') {
      hasSubsequentAnalytics.value = true;
      sidePlot.value = const SizedBox.shrink();
      tmChartWidth.value = width;
    } else if (subsequentAnalyticsNotifier.value &&
        subsequentAnalyticsErr.value == '') {
      hasSubsequentAnalytics.value = true;
      String? img10 =
          PrefsService.to.prefs.getString(SharedPreferencesConstant.img10);
      Uint8List img10Bytes = ((img10 != null || img10 != '')
          ? base64Decode(img10!)
          : this.img10Bytes.value);
      if (img10Bytes.isEmpty ||
          img10Bytes.toString() == Uint8List.fromList([0]).toString()) {
        sidePlot.value = const SizedBox.shrink();
        tmChartWidth.value = width;
      } else {
        sidePlot.value = SizedBox(
            child: Padding(
          padding: EdgeInsets.only(
              top: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                  ? 11.h
                  : 8.h)),
          child: Image.memory(
            img10Bytes,
            width: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? ((Get.width - 5.w) * 0.25)
                : 35.6.w),
            height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? 109.h
                : 82.h),
            fit: BoxFit.fill,
          ),
        ));
        tmChartWidth.value =
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? ((Get.width - 5.w) * 0.75)
                : 106.8.w);
      }
    } else {
      sidePlot.value = const SizedBox.shrink();
      tmChartWidth.value = width;
      hasSubsequentAnalytics.value = false;
    }
  }

  void waitingForReplyListener() {
    if (waitingForReplyNotifier.value) {
      isWaitingForReply.value = true;
    } else {
      isWaitingForReply.value = false;
    }
  }

  @override
  void dispose() {
    Get.delete<MainPresenter>();
    super.dispose();
  }

  Future<List<CandleData>> init() async {
    if (!alwaysShowAnalytics.value) {
      showAnalyticsNotifier.value = false;
    } else {
      showAnalyticsNotifier.value = true;
    }
    if (apiKey.value == '' && alwaysShowMinuteData.value) {
      marketDataProviderMsg.value = 'No API key to access Firestore with';
      isMarketDataProviderErr.value = true;
    } else {
      // listCandledata.value = dummyCandle;
      await Candle().init();
      // for (final data in listCandledata) {
      //   if (data.open == 463.39) {
      //     print(data.toString());
      //     print(data.timestamp.toString());
      //   }
      // }
      if (showAverageNotifier.value) {
        await Candle().computeTrendLines();
      }
      if (listCandledata.isNotEmpty &&
          !isLockTrend.value &&
          listCandledata.length != dummyCandle.length) {
        await TrendMatch().init();
        if (apiKey.value != '') {
          SubsequentAnalytics().init();
        }
      }
    }
    checkMinuteData();
    return listCandledata;
  }

  void checkMinuteData() async {
    final isar = await IsarService().getIsarInstance();
    var spyData = await isar.spyDatas.where().findFirst();
    var qqqData = await isar.qqqDatas.where().findFirst();
    var usoData = await isar.usoDatas.where().findFirst();
    var gldData = await isar.gldDatas.where().findFirst();
    var slvData = await isar.slvDatas.where().findFirst();
    var iwmData = await isar.iwmDatas.where().findFirst();
    var xlkData = await isar.xlkDatas.where().findFirst();
    var aaplData = await isar.aaplDatas.where().findFirst();
    var baData = await isar.baDatas.where().findFirst();
    var bacData = await isar.bacDatas.where().findFirst();
    var mcdData = await isar.mcdDatas.where().findFirst();
    var nvdaData = await isar.nvdaDatas.where().findFirst();
    var msftData = await isar.msftDatas.where().findFirst();
    var gskData = await isar.gskDatas.where().findFirst();
    var tslaData = await isar.tslaDatas.where().findFirst();
    var amznData = await isar.amznDatas.where().findFirst();
    if (spyData == null) {
      hasSpyMinuteData.value = false;
    } else {
      hasSpyMinuteData.value = true;
    }
    if (qqqData == null) {
      hasQqqMinuteData.value = false;
    } else {
      hasQqqMinuteData.value = true;
    }
    if (usoData == null) {
      hasUsoMinuteData.value = false;
    } else {
      hasUsoMinuteData.value = true;
    }
    if (gldData == null) {
      hasGldMinuteData.value = false;
    } else {
      hasGldMinuteData.value = true;
    }
    if (slvData == null) {
      hasSlvMinuteData.value = false;
    } else {
      hasSlvMinuteData.value = true;
    }
    if (iwmData == null) {
      hasIwmMinuteData.value = false;
    } else {
      hasIwmMinuteData.value = true;
    }
    if (xlkData == null) {
      hasXlkMinuteData.value = false;
    } else {
      hasXlkMinuteData.value = true;
    }
    if (aaplData == null) {
      hasAaplMinuteData.value = false;
    } else {
      hasAaplMinuteData.value = true;
    }
    if (baData == null) {
      hasBaMinuteData.value = false;
    } else {
      hasBaMinuteData.value = true;
    }
    if (bacData == null) {
      hasBacMinuteData.value = false;
    } else {
      hasBacMinuteData.value = true;
    }
    if (mcdData == null) {
      hasMcdMinuteData.value = false;
    } else {
      hasMcdMinuteData.value = true;
    }
    if (nvdaData == null) {
      hasNvdaMinuteData.value = false;
    } else {
      hasNvdaMinuteData.value = true;
    }
    if (msftData == null) {
      hasMsftMinuteData.value = false;
    } else {
      hasMsftMinuteData.value = true;
    }
    if (gskData == null) {
      hasGskMinuteData.value = false;
    } else {
      hasGskMinuteData.value = true;
    }
    if (tslaData == null) {
      hasTslaMinuteData.value = false;
    } else {
      hasTslaMinuteData.value = true;
    }
    if (amznData == null) {
      hasAmznMinuteData.value = false;
    } else {
      hasAmznMinuteData.value = true;
    }
  }

  double findMedianOfLastValues(List<List<double>> list) {
    List<double> lastValues = [];
    if (list.isNotEmpty) {
      int middle = list.length ~/ 2;
      for (List<double> innerList in list) {
        if (innerList.isNotEmpty) {
          lastValues.add(innerList.last);
        }
      }
      lastValues.sort();
      if (list.length <= 2) {
        return lastValues.first;
      } else {
        return lastValues[middle];
      }
    } else {
      return 0.0;
    }
  }

  double findMaxOfValues(List<List<double>> list) {
    double max = double.negativeInfinity;
    if (list.isNotEmpty) {
      for (List<double> innerList in list) {
        if (innerList.isNotEmpty) {
          for (double innerValue in innerList) {
            if (innerValue > max) {
              max = innerValue;
            }
          }
        }
      }
    } else {
      return 0.0;
    }
    return max;
  }

  double findMinOfValues(List<List<double>> list) {
    double min = double.infinity;
    if (list.isNotEmpty) {
      for (List<double> innerList in list) {
        if (innerList.isNotEmpty) {
          for (double innerValue in innerList) {
            if (innerValue < min) {
              min = innerValue;
            }
          }
        }
      }
    } else {
      return 0.0;
    }
    return min;
  }

  void checkLockTrend() {
    int lockTrendDatetime = PrefsService.to.prefs
        .getInt(SharedPreferencesConstant.lockTrendLastDatetime)!;
    List<List<double>> upper = [];
    List<List<double>> lower = [];
    int lockTrendLastRow = PrefsService.to.prefs
        .getInt(SharedPreferencesConstant.lockTrendLastRow)!;
    double startingClosePrice = candleListList[lockTrendLastRow][4];
    double thisMinReturnRateThreshold = minReturnRateThreshold.value;
    int subLen = subLength.value;

    bool thisIsFirstThirtyMins = isFirstThirtyMins.value;
    bool thisLowProb = lowProb.value;
    bool thisLowReturn = lowReturn.value;
    bool thisTrendsNotOneSided = trendsNotOneSided.value;
    bool thisTrendsLessThanFive = trendsLessThanFive.value;
    bool thisTrendsOneSidedButLessThanFour =
        trendsOneSidedButLessThanFour.value;
    bool thisHitCeilingOrFloor = hitCeilingOrFloor.value;
    bool thisGoOpposite = goOpposite.value;
    bool thisIsLong = isLong.value;
    bool thisIsShort = isShort.value;
    bool thisOver = over.value;
    double thisReturnRate = returnRate.value;
    double thisExpectedProb = expectedProb.value;
    String thisExpectedMdd = expectedMdd.value;
    bool thisReachedMedian = reachedMedian.value;
    bool thisTrackingHits = trackingHits.value;
    bool thisTrackingHitsOnesided = trackingHitsOnesided.value;

    if (lockTrendDatetime != 0) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
          lockTrendDatetime * 1000,
          isUtc: true);
      DateTime subtractedDateTime =
          TimeService.to.subtractHoursBasedOnTimezone(dateTime);
      String lastDatetime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
      String timezone =
          TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
      Future.microtask(() {
        lockTrendDatetimeString.value = '$lastDatetime $timezone';
      });
      // Define trading start time
      DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
          subtractedDateTime.month, subtractedDateTime.day, 9, 30);
      // Check if the dateTime is within the first 30 minutes of trading
      DateTime tradingEndTimeUTC =
          tradingStartTime.add(const Duration(minutes: 30));
      bool isWithinFirst30Minutes =
          subtractedDateTime.isAfter(tradingStartTime) &&
              subtractedDateTime.isBefore(tradingEndTimeUTC);
      if (isWithinFirst30Minutes) {
        thisIsFirstThirtyMins = true;
        Future.microtask(() {
          isFirstThirtyMins.value = true;
        });
      } else {
        thisIsFirstThirtyMins = false;
        Future.microtask(() {
          isFirstThirtyMins.value = false;
        });
      }
    } else {
      Future.microtask(() {
        instruction.value = 'Error: lockTrendDatetime == 0';
      });
      return;
    }

    if (!isLockTrend.value) {
      if (lockTrendSubTrendList.length < 5) {
        thisTrendsLessThanFive = true;
        Future.microtask(() {
          trendsLessThanFive.value = true;
        });
      } else {
        thisTrendsLessThanFive = false;
        Future.microtask(() {
          trendsLessThanFive.value = false;
        });
      }
      int baseline = 0;
      if (lockTrendSubTrendList.isNotEmpty) {
        // logger.d(lockTrendSubTrendList);
        for (var values in lockTrendSubTrendList) {
          if (values.last > values.first) {
            upper.add(values);
          } else if (values.last < values.first) {
            lower.add(values);
          } else {
            baseline++;
          }
        }
      }

      thisIsLong = false;
      thisIsShort = false;
      if (upper.isNotEmpty || lower.isNotEmpty) {
        double upperProb =
            upper.length / (upper.length + lower.length + baseline);
        double lowerProb =
            lower.length / (upper.length + lower.length + baseline);
        thisExpectedProb = max(upperProb, lowerProb);
        if (upperProb > probThreshold.value) {
          thisIsLong = true;
          thisLowProb = false;
          Future.microtask(() {
            isLong.value = true;
            lowProb.value = false;
          });
          if (upperProb == 1.0) {
            thisTrendsNotOneSided = false;
            Future.microtask(() {
              trendsNotOneSided.value = false;
            });
            if (upper.length < 4) {
              thisTrendsOneSidedButLessThanFour = true;
              Future.microtask(() {
                trendsOneSidedButLessThanFour.value = true;
              });
            } else {
              thisTrendsOneSidedButLessThanFour = false;
              Future.microtask(() {
                trendsOneSidedButLessThanFour.value = false;
              });
            }
          } else {
            thisTrendsNotOneSided = true;
            Future.microtask(() {
              trendsNotOneSided.value = true;
            });
          }
        } else if (lowerProb > probThreshold.value) {
          thisIsShort = true;
          thisLowProb = false;
          Future.microtask(() {
            isShort.value = true;
            lowProb.value = false;
          });
          if (lowerProb == 1.0) {
            thisTrendsNotOneSided = false;
            Future.microtask(() {
              trendsNotOneSided.value = false;
            });
            if (lower.length < 4) {
              thisTrendsOneSidedButLessThanFour = true;
              Future.microtask(() {
                trendsOneSidedButLessThanFour.value = true;
              });
            } else {
              thisTrendsOneSidedButLessThanFour = false;
              Future.microtask(() {
                trendsOneSidedButLessThanFour.value = false;
              });
            }
          } else {
            thisTrendsNotOneSided = true;
            Future.microtask(() {
              trendsNotOneSided.value = true;
            });
          }
        } else {
          thisLowProb = true;
          thisTrendsNotOneSided = true;
          thisIsLong = false;
          thisIsShort = false;
          Future.microtask(() {
            lowProb.value = true;
            trendsNotOneSided.value = true;
            isLong.value = false;
            isShort.value = false;
          });
        }
      } else {
        thisExpectedProb = 0.0;
        thisLowProb = true;
        thisTrendsNotOneSided = true;
        Future.microtask(() {
          lowProb.value = true;
          trendsNotOneSided.value = true;
          isLong.value = false;
          isShort.value = false;
        });
      }

      if (thisIsLong) {
        double medianOfLastCloses = findMedianOfLastValues(upper);
        if (medianOfLastCloses != 0.0 || medianOfLastCloses != 0) {
          thisReturnRate =
              (medianOfLastCloses - startingClosePrice) / startingClosePrice;
          if (thisReturnRate >= thisMinReturnRateThreshold) {
            thisLowReturn = false;
            Future.microtask(() {
              lowReturn.value = false;
            });
          } else {
            thisLowReturn = true;
            Future.microtask(() {
              lowReturn.value = true;
            });
          }
        } else {
          thisReturnRate = 0.0;
          thisLowReturn = true;
          Future.microtask(() {
            lowReturn.value = true;
          });
        }
        double min = findMinOfValues(lower);
        if (min != 0.0) {
          double minPercentageDifference =
              (min - startingClosePrice) / startingClosePrice;
          thisExpectedMdd = '-${minPercentageDifference.abs()}';
          Future.microtask(() {
            expectedMdd.value = '-${minPercentageDifference.abs()}';
          });
        } else {
          thisExpectedMdd = '-$min';
          Future.microtask(() {
            expectedMdd.value = '-$min';
          });
        }
      } else if (thisIsShort) {
        double medianOfLastCloses = findMedianOfLastValues(lower);
        if (medianOfLastCloses != 0.0 || medianOfLastCloses != 0) {
          thisReturnRate =
              (medianOfLastCloses - startingClosePrice) / startingClosePrice;
          if (thisReturnRate <= -thisMinReturnRateThreshold) {
            thisLowReturn = false;
            Future.microtask(() {
              lowReturn.value = false;
            });
          } else {
            thisLowReturn = true;
            Future.microtask(() {
              lowReturn.value = true;
            });
          }
        } else {
          thisReturnRate = 0.0;
          thisLowReturn = true;
          Future.microtask(() {
            lowReturn.value = true;
          });
        }
        double max = findMaxOfValues(upper);
        if (max != 0.0) {
          double maxPercentageDifference =
              (max - startingClosePrice) / startingClosePrice;
          thisExpectedMdd = '+$maxPercentageDifference';
          Future.microtask(() {
            expectedMdd.value = '+$maxPercentageDifference';
          });
        } else {
          thisExpectedMdd = '+$max';
          Future.microtask(() {
            expectedMdd.value = '+$max';
          });
        }
      } else {
        double medianOfLastCloses =
            findMedianOfLastValues(lockTrendSubTrendList);
        if (medianOfLastCloses != 0.0 || medianOfLastCloses != 0) {
          thisReturnRate =
              (medianOfLastCloses - startingClosePrice) / startingClosePrice;
          if (thisReturnRate.abs() >= thisMinReturnRateThreshold) {
            thisLowReturn = false;
            Future.microtask(() {
              lowReturn.value = false;
            });
          } else {
            thisLowReturn = true;
            Future.microtask(() {
              lowReturn.value = true;
            });
          }
        } else {
          thisReturnRate = 0.0;
          thisLowReturn = true;
          Future.microtask(() {
            lowReturn.value = true;
          });
        }
        double maxPercentageDifferenceAbs = 0;
        double minPercentageDifferenceAbs = 0;
        double max = findMaxOfValues(upper);
        double min = findMinOfValues(lower);
        if (max != 0.0 && min != 0.0) {
          maxPercentageDifferenceAbs =
              ((max - startingClosePrice) / startingClosePrice).abs();
          minPercentageDifferenceAbs =
              ((min - startingClosePrice) / startingClosePrice).abs();
          if (maxPercentageDifferenceAbs > minPercentageDifferenceAbs) {
            thisExpectedMdd = '±$maxPercentageDifferenceAbs';
            Future.microtask(() {
              expectedMdd.value = '±$maxPercentageDifferenceAbs';
            });
          } else if (minPercentageDifferenceAbs > maxPercentageDifferenceAbs) {
            thisExpectedMdd = '±$minPercentageDifferenceAbs';
            Future.microtask(() {
              expectedMdd.value = '±$minPercentageDifferenceAbs';
            });
          }
        } else {
          thisExpectedMdd = '±$max';
          Future.microtask(() {
            expectedMdd.value = '±$max';
          });
        }
      }
      thisHitCeilingOrFloor = false;
      thisGoOpposite = false;
      thisOver = false;
      if (closePosWhenReachedMedian.value) {
        thisReachedMedian = false;
      }
      thisTrackingHits = false;
      thisTrackingHitsOnesided = false;
      Future.microtask(() {
        expectedProb.value = thisExpectedProb;
        returnRate.value = thisReturnRate.abs();
        hitCeilingOrFloor.value = thisHitCeilingOrFloor;
        goOpposite.value = thisGoOpposite;
        over.value = thisOver;
        if (closePosWhenReachedMedian.value) {
          reachedMedian.value = thisReachedMedian;
        }
        trackingHits.value = thisTrackingHits;
        trackingHitsOnesided.value = thisTrackingHitsOnesided;
        trackingSubLen.value = subLength.value;
        expectedTrackingProb.value = -1.0;

        PrefsService.to.prefs
            .setBool(SharedPreferencesConstant.lowReturn, thisLowReturn);
        PrefsService.to.prefs
            .setBool(SharedPreferencesConstant.lowProb, thisLowProb);
        PrefsService.to.prefs.setBool(
            SharedPreferencesConstant.trendsLessThanFive,
            thisTrendsLessThanFive);
        PrefsService.to.prefs.setBool(
            SharedPreferencesConstant.trendsOneSidedButLessThanFour,
            thisTrendsOneSidedButLessThanFour);
        PrefsService.to.prefs.setBool(
            SharedPreferencesConstant.trendsNotOneSided, thisTrendsNotOneSided);
        PrefsService.to.prefs.setDouble(
            SharedPreferencesConstant.expectedProb, thisExpectedProb);
        PrefsService.to.prefs
            .setDouble(SharedPreferencesConstant.returnRate, thisReturnRate);
        PrefsService.to.prefs
            .setString(SharedPreferencesConstant.expectedMdd, thisExpectedMdd);
        PrefsService.to.prefs
            .setBool(SharedPreferencesConstant.isLong, thisIsLong);
        PrefsService.to.prefs
            .setBool(SharedPreferencesConstant.isShort, thisIsShort);
      });
    } else {
      List<double> spots = [];
      if (lockTrendLastRow != 0) {
        int lastRow = candleListList.length - 1;
        for (int i = 0; i < subLen + 1; i++) {
          if ((lockTrendLastRow + i) <= lastRow) {
            spots.add(candleListList[lockTrendLastRow + i][4]);
          } else {
            break;
          }
        }
      } else {
        Future.microtask(() {
          instruction.value = 'Error: lockTrendLastRow == 0';
        });
        return;
      }

      if (expectedMdd.value == '0.0') {
        thisHitCeilingOrFloor = false;
        Future.microtask(() {
          hitCeilingOrFloor.value = false;
        });
      } else {
        double mdd = double.parse(expectedMdd.value.substring(1));
        int hitOppositeCeilingOrBottomCount = 0;
        if (isLong.value) {
          for (double value in spots) {
            value = ((value - startingClosePrice) / startingClosePrice);
            if (value <= -mdd) {
              hitOppositeCeilingOrBottomCount++;
            }
          }
        } else if (isShort.value) {
          for (double value in spots) {
            value = ((value - startingClosePrice) / startingClosePrice);
            if (value >= mdd) {
              hitOppositeCeilingOrBottomCount++;
            }
          }
        } else {
          for (double value in spots) {
            value = ((value - startingClosePrice) / startingClosePrice);
            if (value <= -mdd || value >= mdd) {
              hitOppositeCeilingOrBottomCount++;
            }
          }
        }
        if (hitOppositeCeilingOrBottomCount >= subLen ~/ 3) {
          thisHitCeilingOrFloor = true;
          Future.microtask(() {
            hitCeilingOrFloor.value = true;
          });
        } else {
          thisHitCeilingOrFloor = false;
          Future.microtask(() {
            hitCeilingOrFloor.value = false;
          });
        }
      }

      int goOppositeCount = 0;
      if (isLong.value) {
        for (double value in spots) {
          if (value < startingClosePrice) {
            goOppositeCount++;
          }
        }
      } else if (isShort.value) {
        for (double value in spots) {
          if (value > startingClosePrice) {
            goOppositeCount++;
          }
        }
      }
      int halfSubLength = subLen ~/ 2;
      if (goOppositeCount >= halfSubLength) {
        thisGoOpposite = true;
        Future.microtask(() {
          goOpposite.value = true;
        });
      } else {
        thisGoOpposite = false;
        Future.microtask(() {
          goOpposite.value = false;
        });
      }

      // Check if the lock-in trend is over
      const int yFinMinuteDelay = 1;
      if (spots.length - 1 >= subLen - yFinMinuteDelay) {
        thisOver = true;
        Future.microtask(() {
          over.value = true;
        });
      } else {
        thisOver = false;
        Future.microtask(() {
          over.value = false;
        });
      }

      // Check whether the lock-in trend return rate has reaches the median return rate in matched trends
      if (closePosWhenReachedMedian.value) {
        thisReachedMedian = false;
        final double spot = spots.last;
        final double thisReturnRate =
            (spot - startingClosePrice) / startingClosePrice;
        if (thisIsLong) {
          if (thisReturnRate >= thisMinReturnRateThreshold) {
            thisReachedMedian = true;
          }
        } else if (thisIsShort) {
          if (thisReturnRate <= -thisMinReturnRateThreshold) {
            thisReachedMedian = true;
          }
        }
        if (thisReachedMedian) {
          Future.microtask(() {
            reachedMedian.value = true;
          });
        } else {
          Future.microtask(() {
            reachedMedian.value = false;
          });
        }
      }

      if (lockTrendLastRow == candleListList.length - 1) {
        thisTrackingHits = false;
        thisTrackingHitsOnesided = false;
        Future.microtask(() {
          trackingHits.value = thisTrackingHits;
          trackingHitsOnesided.value = thisTrackingHitsOnesided;
          expectedTrackingProb.value = -1.0;
        });
      } else {
        // Calculation and redefine global expectedTrackingProb
        List<List<double>> trackingUpper = [];
        List<List<double>> trackingLower = [];
        int trackingBaseline = 0;
        if (lockTrendTrackingSubTrendList.isNotEmpty) {
          for (var values in lockTrendTrackingSubTrendList) {
            if (values.last > values.first) {
              trackingUpper.add(values);
            } else if (values.last < values.first) {
              trackingLower.add(values);
            } else {
              trackingBaseline++;
            }
          }
        }
        if (trackingUpper.isNotEmpty || trackingLower.isNotEmpty) {
          double upperProb = trackingUpper.length /
              (trackingUpper.length + trackingLower.length + trackingBaseline);
          double lowerProb = trackingLower.length /
              (trackingUpper.length + trackingLower.length + trackingBaseline);
          if (upperProb > probThreshold.value) {
            if (isShort.value) {
              if (upperProb == 1.0) {
                if (trackingUpper.length >= 4) {
                  thisTrackingHits = false;
                  thisTrackingHitsOnesided = true;
                } else {
                  thisTrackingHits = false;
                  thisTrackingHitsOnesided = false;
                }
              } else {
                if (trackingUpper.length >= 5) {
                  thisTrackingHits = true;
                  thisTrackingHitsOnesided = false;
                } else {
                  thisTrackingHits = false;
                  thisTrackingHitsOnesided = false;
                }
              }
            } else {
              thisTrackingHits = false;
              thisTrackingHitsOnesided = false;
            }
            Future.microtask(() {
              trackingHits.value = thisTrackingHits;
              trackingHitsOnesided.value = thisTrackingHitsOnesided;
              expectedTrackingProb.value = upperProb;
            });
          } else if (lowerProb > probThreshold.value) {
            if (isLong.value) {
              if (lowerProb == 1.0) {
                if (trackingLower.length >= 4) {
                  thisTrackingHits = false;
                  thisTrackingHitsOnesided = true;
                } else {
                  thisTrackingHits = false;
                  thisTrackingHitsOnesided = false;
                }
              } else {
                if (trackingLower.length >= 5) {
                  thisTrackingHits = true;
                  thisTrackingHitsOnesided = false;
                } else {
                  thisTrackingHits = false;
                  thisTrackingHitsOnesided = false;
                }
              }
            } else {
              thisTrackingHits = false;
              thisTrackingHitsOnesided = false;
            }
            Future.microtask(() {
              trackingHits.value = thisTrackingHits;
              trackingHitsOnesided.value = thisTrackingHitsOnesided;
              expectedTrackingProb.value = lowerProb;
            });
          } else {
            thisTrackingHits = false;
            thisTrackingHitsOnesided = false;
            Future.microtask(() {
              trackingHits.value = thisTrackingHits;
              trackingHitsOnesided.value = thisTrackingHitsOnesided;
              expectedTrackingProb.value = max(upperProb, lowerProb);
            });
          }
        } else {
          thisTrackingHits = false;
          thisTrackingHitsOnesided = false;
          Future.microtask(() {
            trackingHits.value = thisTrackingHits;
            trackingHitsOnesided.value = thisTrackingHitsOnesided;
            expectedTrackingProb.value = -1.0;
          });
        }
      }
    }

    if ((!thisIsFirstThirtyMins &&
            !thisLowProb &&
            !thisLowReturn &&
            thisTrendsNotOneSided &&
            !thisTrendsLessThanFive &&
            !thisHitCeilingOrFloor &&
            !thisGoOpposite &&
            !thisOver &&
            !thisTrackingHits &&
            !thisTrackingHitsOnesided) ||
        (!thisIsFirstThirtyMins &&
            !thisLowProb &&
            !thisLowReturn &&
            !thisTrendsNotOneSided &&
            !thisTrendsOneSidedButLessThanFour &&
            !thisHitCeilingOrFloor &&
            !thisGoOpposite &&
            !thisOver &&
            !thisTrackingHits &&
            !thisTrackingHitsOnesided)) {
      if (closePosWhenReachedMedian.value) {
        if (thisReachedMedian) {
          Future.microtask(() {
            instruction.value = 'close_pos_or_wait_n_see'.tr;
            instructionTextStyle.value =
                const TextTheme().sp10.tertiarythemeTextColor.w700;
          });
          return;
        }
      }
      if (thisIsLong) {
        Future.microtask(() {
          instruction.value = 'long'.tr;
          instructionTextStyle.value = const TextTheme().sp10.greenColor.w700;
        });
      } else if (thisIsShort) {
        Future.microtask(() {
          instruction.value = 'short'.tr;
          instructionTextStyle.value = const TextTheme().sp10.redColor.w700;
        });
      }
    } else {
      Future.microtask(() {
        instruction.value = 'close_pos_or_wait_n_see'.tr;
        instructionTextStyle.value =
            const TextTheme().sp10.tertiarythemeTextColor.w700;
      });
    }
  }

  void backtest(String symbol, BuildContext context) async {
    scheduleMicrotask(() async {
      // printInfo(info: 'Length: ${length.value}');
      // printInfo(info: 'Candle Tolerance: ${candleTolerance.value}');
      // printInfo(info: 'Price Tolerance: ${priceTolerance.value}');
      // printInfo(info: 'First MA Tolerance: ${firstMaTolerance.value}');
      // printInfo(info: 'MA Tolerance: ${maTolerance.value}');
      // printInfo(info: 'MA matching: True');
      // printInfo(info: 'Strict matching: ${strictMatchCriteria.value}');

      if (!alwaysShowMinuteData.value || !hasMinuteData.value) {
        showScaffoldMessenger(
            context: context, localizedMsg: 'backtest_no_minute_data'.tr);
        return;
      }

      List<List<dynamic>> listList = [];
      List<CandleData> candle = [];

      int initIndex = 20; // Assume that the backtest must be minute data
      int len = length.value;
      double commissionsAndFees = (0.25 * 2) + (0.021 * 2);
      int yFinMinuteDelay = 1;
      int hitCount = 0;
      int missCount = 0;
      // int outsideTimeCount = 0;
      int subsequentLen = subLength.value;
      double thisProbThreshold = probThreshold.value;
      double minMedianReturnRate = minReturnRateThreshold.value;
      int minMatchCount = 5;
      int minOneSidedMatchCount = 4;

      if (len <= 1) {
        throw ArgumentError('Selected period must greater than 1 time unit.');
      }

      // CSV headers
      listList.add([
        'ID',
        'Datetime',
        'Selected',
        'Probability',
        'Median Return Rate',
        'Expected Undelayed Return Rate (random trend)',
        'Expected Actual Return Rate (random trend)',
        'Matched Trend Count',
        'Interrupted Trend',
        'Interrupted Trend Undelayed Return Rate',
        'Interrupted Trend Actual Return Rate',
        'Hit Rate (after first 30 mins)',
        'MDD (all the time)',
        'Undelayed Fund Remaining (commns. and fees deducted)',
        'Fund Remaining (commns. and fees deducted)',
        'Commns. and Fees (2 contracts)',
        'yFin Minute Delay',
        ...List.generate(subsequentLen, (index) => 'Close Price ${index + 1}'),
      ]);

      // Make sure data is from the expected financial instrument
      if (symbol == financialInstrumentSymbol.value) {
        candle = listCandledata;
      } else {
        showScaffoldMessenger(
            context: context, localizedMsg: 'search_symbol_before_backtest'.tr);
        return;
      }

      // printInfo(info: 'Backtesting started');

      // Start backtest loading effect
      isButtonDisabled.value = true;
      backtestingSymbol.value = symbol;

      bool hasMa = candle.last.trends.isNotEmpty;
      int maLength = candle.last.trends.length;

      // Assume it must be an MA trend matching
      if (!hasMa) {
        await Candle().computeTrendLines();
        hasMa = candle.last.trends.isNotEmpty;
        maLength = candle.last.trends.length;
      }

      candle =
          candle.sublist(initIndex); // Remove trends that don't have all MAs
      // printInfo(info: 'Candle data length: ${candle.length}');

      // Split the candle list of list
      List<List<CandleData>> splitCandleLists = [];
      List<int> splitCandleListsLastRows = [];
      int splits = 1000;
      final int sublistSize = (candle.length / splits).ceil();

      for (int i = 0; i < candle.length; i += sublistSize) {
        final end =
            (i + sublistSize < candle.length) ? i + sublistSize : candle.length;
        final sublist = candle.sublist(i, end);
        splitCandleLists.add(sublist);
        splitCandleListsLastRows.add(end - 1);
      }
      // printInfo(info: 'Split candle list length: ${splitCandleLists.length}');

      // Show the remaining number of backtest data
      if (!alwaysThousandthsData.value) {
        backtestDataLen1.value = candle.length;
      }

      // Randomly pick a list to run backtest
      final random = Random();
      final double candleTol = candleTolerance.value / 100;
      final double priceTol = priceTolerance.value / 100;
      final double firstMaTol = firstMaTolerance.value / 100;
      final double maTol = maTolerance.value / 100;

      double hitRate = 0.0;
      double roundedHitRate = 0.0;
      double mdd = 0.0;
      double initialFund = 10000;
      double undelayedInitialFund = 10000;
      int oneThirdSubLength = subsequentLen ~/ 3;
      int halfSubLength = subsequentLen ~/ 2;

      while (splitCandleLists.isNotEmpty) {
        final randomIndex = random.nextInt(splitCandleLists.length);
        final sublist = splitCandleLists[randomIndex];
        final subLen = sublist.length;
        if (alwaysThousandthsData.value) {
          backtestDataLen1.value = subLen;
        }

        // printInfo(info: 'Current split candle list no.: $randomIndex');
        // printInfo(info: 'Current split candle list length: $subLen');

        for (int l = 0; l < subLen - len + 1 - yFinMinuteDelay; l++) {
          await Future.delayed(const Duration(milliseconds: 0));

          // Show the remaining number of backtest data
          backtestDataRan1.value += 1;

          int id = l;
          List<String> datetime = [];
          double prob;
          double medianReturnRate = 0.0;
          int matchedTrendCount;

          // logger.d(
          //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: $id/$subLen');

          // Check if the dateTime is within the first 30 minutes of trading
          int timestamp = sublist[l].timestamp;
          if (timestamp != 0) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                timestamp * 1000,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            // Define trading start time
            DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                subtractedDateTime.month, subtractedDateTime.day, 9, 30);
            // Check if the dateTime is within the first 30 minutes of trading
            DateTime tradingEndTimeUTC =
                tradingStartTime.add(const Duration(minutes: 30));
            bool isWithinFirst30Minutes =
                subtractedDateTime.isAfter(tradingStartTime) &&
                    subtractedDateTime.isBefore(tradingEndTimeUTC);
            if (isWithinFirst30Minutes) {
              // outsideTimeCount++;
              continue;
            }
          } else {
            // logger.d('Error: timestamp == 0');
            splitCandleLists = [];
            break;
          }
          // printInfo(info: '✅ Outside first 30 mins');

          // Selecting a trend
          double startingClosePrice = sublist[l].close!;
          double lastClosePrice = sublist[l + len - 1].close!;
          double actualLastClosePrice =
              sublist[l + len - 1 + yFinMinuteDelay].close!;
          List<double> selectedPeriodPercentDifferencesList = [];
          // For MA matching
          List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
          List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
          // For candle matching
          List<List<double>>
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
          // Loop selected data
          for (int i = 0; i < len; i++) {
            // Candle
            List<double>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
            double close = sublist[l + i].close!;
            double openAndClosePercentDiff =
                (sublist[l + i].open! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(openAndClosePercentDiff);
            double highAndClosePercentDiff =
                (sublist[l + i].high! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(highAndClosePercentDiff);
            double lowAndClosePercentDiff =
                (sublist[l + i].low! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(lowAndClosePercentDiff);
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
          }
          for (int i = 0; i < len - 1; i++) {
            // Price
            double newVal = sublist[l + i + 1].close!;
            double oriVal = sublist[l + i].close!;
            double percentDiff = (newVal - oriVal) / oriVal;
            selectedPeriodPercentDifferencesList.add(percentDiff);

            // MA
            List<double> selectedPeriodMaPercentDifferencesList = [];
            for (int n = 0; n < maLength; n++) {
              double newVal = sublist[l + i + 1].trends[n]!;
              double oriVal = sublist[l + i].trends[n]!;
              double maPercentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
            }
            selectedPeriodMaPercentDifferencesListList
                .add(selectedPeriodMaPercentDifferencesList);
          }
          // MA
          for (int m = 0; m < maLength; m++) {
            selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                (sublist[l].trends[m]! - startingClosePrice) /
                    startingClosePrice);
          }
          // printInfo(info: '✅ Selected a trend');

          List<List<double>> upper = [];
          List<List<double>> lower = [];
          int baseline = 0;
          List<List<double>> subClosePrices = [];
          List<int> subClosePricesRowID = [];
          bool isLong = false;
          bool isShort = false;
          List<double> actualLastDifferenceList = [];

          // Look for similar trend(s)
          for (int m = 0;
              m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
              // Minus yFinMinuteDelay for actualReturn calculation
              m++) {
            // For candle matching
            List<List<double>>
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[m + i].close!;
              double openAndClosePercentDiff =
                  (candle[m + i].open! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[m + i].high! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[m + i].low! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              comparePeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
            }

            // For price matching
            List<double> comparePeriodPercentDifferencesList = [];
            for (int i = 0; i < len - 1; i++) {
              double percentDiff =
                  (candle[m + i + 1].close! - candle[m + i].close!) /
                      (candle[m + i].close!);
              comparePeriodPercentDifferencesList.add(percentDiff);
            }

            (bool, List<double>) comparisonResult = TrendMatch()
                .areDifferencesLessThanOrEqualToCertainPercent(
                    selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    candleTol,
                    selectedPeriodPercentDifferencesList,
                    comparePeriodPercentDifferencesList,
                    priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

            if (comparisonResult.$1) {
              // printInfo(info: '✅ A trend percentage changes matched');
              List<double> comparePeriodFirstMaAndPricePercentDifferencesList =
                  [];
              List<List<double>> comparePeriodMaPercentDifferencesListList = [];
              double compareFirstPrice = candle[m].close!;

              for (int n = 0; n < len - 1; n++) {
                List<double> comparePeriodMaPercentDifferencesList = [];
                for (int i = 0; i < maLength; i++) {
                  double newVal = candle[m + n + 1].trends[i]!;
                  double oriVal = candle[m + n].trends[i]!;
                  double maPercentDiff = (newVal - oriVal) / oriVal;
                  comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                }
                comparePeriodMaPercentDifferencesListList
                    .add(comparePeriodMaPercentDifferencesList);
              }
              for (int i = 0; i < maLength; i++) {
                comparePeriodFirstMaAndPricePercentDifferencesList.add(
                    (candle[m].trends[i]! - compareFirstPrice) /
                        compareFirstPrice);
              }

              bool isMaMatched = TrendMatch()
                  .maDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodFirstMaAndPricePercentDifferencesList,
                      selectedPeriodMaPercentDifferencesListList,
                      comparePeriodFirstMaAndPricePercentDifferencesList,
                      comparePeriodMaPercentDifferencesListList,
                      maTol,
                      firstMaTol);
              if (isMaMatched) {
                // printInfo(info: '✅ A trend MAs matched');
                // Store the adjusted close prices into different lists
                List<double> matchedAdjustedSubsequentCloseList = [];
                double lastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                double actualLastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                actualLastDifferenceList.add(actualLastDifference);
                for (int i = 0; i < subsequentLen; i++) {
                  double adjustedSubsequentClose =
                      candle[m + len + i].close! * lastDifference;
                  matchedAdjustedSubsequentCloseList
                      .add(adjustedSubsequentClose);
                }
                if (matchedAdjustedSubsequentCloseList.last > lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  upper.add(matchedAdjustedSubsequentCloseList);
                } else if (matchedAdjustedSubsequentCloseList.last <
                    lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  lower.add(matchedAdjustedSubsequentCloseList);
                } else {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  baseline++;
                }
              }
              // else {
              //   printInfo(info: '❌ A trend MAs not matched');
              // }
            }
            // else {
            //   printInfo(info: '❌ A trend percentage changes not matched');
            // }
          }

          // Division by zero is mathematically undefined, but in programming,
          // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
          // This way, skip when both lists are empty
          if (upper.isEmpty && lower.isEmpty) {
            missCount++;
            // printInfo(info: '❌ upper and lower are empty');
            continue;
          }
          // Probability calculation and amount of matched trends
          double upperProb =
              upper.length / (upper.length + lower.length + baseline);
          double lowerProb =
              lower.length / (upper.length + lower.length + baseline);
          // Round to 3 decimal places
          upperProb = double.parse(upperProb.toStringAsFixed(4));
          lowerProb = double.parse(lowerProb.toStringAsFixed(4));
          if (upperProb >= thisProbThreshold) {
            if (upperProb.toInt() == 1) {
              if (upper.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 4');
                continue;
              }
            } else {
              if (upper.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 5');
                continue;
              }
            }
            isLong = true;
            // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
          } else if (lowerProb >= thisProbThreshold) {
            if (lowerProb.toInt() == 1) {
              if (lower.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 4');
                continue;
              }
            } else {
              if (lower.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 5');
                continue;
              }
            }
            isShort = true;
            // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
          } else {
            missCount++;
            // printInfo(info: '❌ No majority list');
            continue;
          }

          // Return rate median
          double thisMdd = 0.0;
          if (isLong) {
            double medianOfLastCloses = findMedianOfLastValues(upper);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate <= minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate <= $minMedianReturnRate in long');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in long');
              continue;
            }
            double thisMin = findMinOfValues(lower);
            if (thisMin != 0.0) {
              double minPercentageDifference =
                  (thisMin - lastClosePrice) / lastClosePrice;
              double minPercentageDifferenceAbs = minPercentageDifference.abs();
              mdd = max(mdd, minPercentageDifferenceAbs);
              thisMdd = minPercentageDifferenceAbs;
            } else {
              thisMdd = thisMin;
            }
          } else if (isShort) {
            double medianOfLastCloses = findMedianOfLastValues(lower);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate >= -minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate >= -$minMedianReturnRate in short');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in short');
              continue;
            }
            double thisMax = findMaxOfValues(upper);
            if (thisMax != 0.0) {
              double maxPercentageDifference =
                  (thisMax - lastClosePrice) / lastClosePrice;
              double maxPercentageDifferenceAbs = maxPercentageDifference.abs();
              mdd = max(mdd, maxPercentageDifferenceAbs);
              thisMdd = maxPercentageDifferenceAbs;
            } else {
              thisMdd = thisMax;
            }
          }
          hitCount++;
          // printInfo(
          //     info:
          //         '✅ Minimum median return rate has been passed: $medianReturnRate');

          // Pick up a trend randomly from upper/lower by overall probability
          int randomIndex = random.nextInt(subClosePrices.length);
          // Get the randomly selected trend from the combinedList
          List<double> randomTrend = subClosePrices[randomIndex];
          // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
          // and the exit price is always on time
          double actualReturnRate = ((randomTrend.last - actualLastClosePrice) /
              actualLastClosePrice);
          double undelayedReturnRate =
              ((randomTrend.last - lastClosePrice) / lastClosePrice);
          double roundedActualReturnRate =
              double.parse(actualReturnRate.toStringAsFixed(4));
          double roundedUndelayedReturnRate =
              double.parse(undelayedReturnRate.toStringAsFixed(4));
          int contractVal =
              5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
          int diffFromEtfAndFuture =
              10; // The difference in value scale between ETF and Future
          matchedTrendCount = subClosePrices.length;

          double interruptActualReturn = 0.0;
          double interruptActualReturnRate = 0.0;
          double interruptUndelayedReturn = 0.0;
          double interruptUndelayedReturnRate = 0.0;
          bool interrupt = false;

          // Check whether the trend return rate has reaches the median return rate in matched trends
          int medianHitID = -1;
          if (closePosWhenReachedMedian.value) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

          // Check the number of trend go to the opposite side
          int goOppositeCount = 0;
          int goOppoHitID = -1;
          if (isLong) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] < lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          } else if (isShort) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] > lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

          // Check if hit the opposite side ceiling or bottom
          int hitOppositeCeilingOrBottomCount = 0;
          int hitOppoBottomOrCeilingHitID = -1;
          if (thisMdd != 0.0) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= -thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

          for (var element in subClosePricesRowID) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                candle[element].timestamp,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            String lastDatetime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
            String timezone =
                TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
            datetime.add('$lastDatetime $timezone');
          }

          if (!interrupt) {
            // Fund value changes due to the return of transaction
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                (((randomTrend.last - actualLastClosePrice) *
                        diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                (((randomTrend.last - lastClosePrice) * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          } else {
            int firstHitID = -1;
            final List<int> hitList = [
              medianHitID,
              goOppoHitID,
              hitOppoBottomOrCeilingHitID,
            ];
            for (final int hitID in hitList) {
              if (hitID != -1) {
                if (firstHitID == -1) {
                  firstHitID = hitID;
                } else if (hitID <= firstHitID) {
                  firstHitID = hitID;
                }
              }
            }

            if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
              double newVal = candle[subClosePricesRowID[randomIndex] +
                          firstHitID +
                          yFinMinuteDelay]
                      .close! *
                  actualLastDifferenceList[randomIndex];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            } else {
              double newVal = randomTrend[firstHitID + yFinMinuteDelay];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            }
            double newVal = randomTrend[firstHitID];
            interruptUndelayedReturn = newVal - lastClosePrice;
            interruptUndelayedReturnRate =
                (newVal - lastClosePrice) / lastClosePrice;

            // Get the failed trend last close price return and change the fund value
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                ((interruptActualReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          }

          prob =
              double.parse((isLong ? upperProb : lowerProb).toStringAsFixed(4));
          medianReturnRate = double.parse(medianReturnRate.toStringAsFixed(4));
          hitRate = hitCount / (hitCount + missCount);
          roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
          double roundedMdd = double.parse(mdd.toStringAsFixed(4));
          double roundedInitialFund =
              double.parse(initialFund.toStringAsFixed(4));
          double roundedUndelayedInitialFund =
              double.parse(undelayedInitialFund.toStringAsFixed(4));

          // Save results one by one into listList
          subClosePrices.asMap().entries.forEach((entry) {
            listList.add([
              id,
              datetime[entry.key],
              len,
              prob,
              medianReturnRate,
              roundedUndelayedReturnRate,
              roundedActualReturnRate,
              matchedTrendCount,
              interrupt,
              interruptUndelayedReturnRate,
              interruptActualReturnRate,
              roundedHitRate,
              roundedMdd,
              roundedUndelayedInitialFund,
              roundedInitialFund,
              commissionsAndFees,
              yFinMinuteDelay,
              ...entry.value
            ]);
          });

          // logger.d(listList);

          // printInfo(info: 'Matched count: $matchedTrendCount');
          // printInfo(info: 'Prob.: $prob');
          // printInfo(info: 'Undelayed return rate: $roundedUndelayedReturnRate');
          // printInfo(
          //     info:
          //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
          // printInfo(info: 'Final return rate: $roundedActualReturnRate');
          // printInfo(info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
        }

        // Check if the sublist can be looped through the last row or not
        if (splitCandleListsLastRows[randomIndex] != candle.length - 1) {
          final int sublistLastCandleRow =
              splitCandleListsLastRows[randomIndex];
          // Loop through remaining rows in sublist if possible
          int remainder = subLen - (subLen - len + 1 - yFinMinuteDelay);
          for (int l = subLen - len + 1 - yFinMinuteDelay; l < subLen; l++) {
            final int thisCandleRow = sublistLastCandleRow - remainder;
            remainder--;

            await Future.delayed(const Duration(milliseconds: 0));

            // Show the remaining number of backtest data
            backtestDataRan1.value += 1;

            int id = l;
            List<String> datetime = [];
            double prob;
            double medianReturnRate = 0.0;
            int matchedTrendCount;

            // logger.d(
            //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: ${id + 1}/$subLen');

            // Check if the dateTime is within the first 30 minutes of trading
            int timestamp = sublist[l].timestamp;
            if (timestamp != 0) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              // Define trading start time
              DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                  subtractedDateTime.month, subtractedDateTime.day, 9, 30);
              // Check if the dateTime is within the first 30 minutes of trading
              DateTime tradingEndTimeUTC =
                  tradingStartTime.add(const Duration(minutes: 30));
              bool isWithinFirst30Minutes =
                  subtractedDateTime.isAfter(tradingStartTime) &&
                      subtractedDateTime.isBefore(tradingEndTimeUTC);
              if (isWithinFirst30Minutes) {
                // outsideTimeCount++;
                continue;
              }
            } else {
              // logger.d('Error: timestamp == 0');
              splitCandleLists = [];
              break;
            }
            // printInfo(info: '✅ Outside first 30 mins');

            // Selecting a trend
            double startingClosePrice = sublist[l].close!;
            double lastClosePrice = candle[thisCandleRow + len - 1].close!;
            double actualLastClosePrice =
                candle[thisCandleRow + len - 1 + yFinMinuteDelay].close!;
            List<double> selectedPeriodPercentDifferencesList = [];
            // For MA matching
            List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
            List<double> selectedPeriodFirstMaAndPricePercentDifferencesList =
                [];
            // For candle matching
            List<List<double>>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList =
                [];
            // Loop selected data
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[thisCandleRow + i].close!;
              double openAndClosePercentDiff =
                  (candle[thisCandleRow + i].open! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[thisCandleRow + i].high! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[thisCandleRow + i].low! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
            }
            for (int i = 0; i < len - 1; i++) {
              double newVal = candle[thisCandleRow + i + 1].close!;
              double oriVal = candle[thisCandleRow + i].close!;
              double percentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodPercentDifferencesList.add(percentDiff);

              // MA
              List<double> selectedPeriodMaPercentDifferencesList = [];
              for (int n = 0; n < maLength; n++) {
                double newVal = candle[thisCandleRow + i + 1].trends[n]!;
                double oriVal = candle[thisCandleRow + i].trends[n]!;
                double maPercentDiff = (newVal - oriVal) / oriVal;
                selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
              }
              selectedPeriodMaPercentDifferencesListList
                  .add(selectedPeriodMaPercentDifferencesList);
            }
            // MA
            for (int m = 0; m < maLength; m++) {
              selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                  (sublist[l].trends[m]! - startingClosePrice) /
                      startingClosePrice);
            }
            // printInfo(info: '✅ Selected a trend');

            List<List<double>> upper = [];
            List<List<double>> lower = [];
            int baseline = 0;
            List<List<double>> subClosePrices = [];
            List<int> subClosePricesRowID = [];
            bool isLong = false;
            bool isShort = false;
            List<double> actualLastDifferenceList = [];

            // Look for similar trend(s)
            for (int m = 0;
                m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
                // Minus yFinMinuteDelay for actualReturn calculation
                m++) {
              // For candle matching
              List<List<double>>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseListList =
                  [];
              for (int i = 0; i < len; i++) {
                // Candle
                List<double>
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
                double close = candle[m + i].close!;
                double openAndClosePercentDiff =
                    (candle[m + i].open! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(openAndClosePercentDiff);
                double highAndClosePercentDiff =
                    (candle[m + i].high! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(highAndClosePercentDiff);
                double lowAndClosePercentDiff =
                    (candle[m + i].low! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(lowAndClosePercentDiff);
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList.add(
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
              }

              // For price matching
              List<double> comparePeriodPercentDifferencesList = [];
              for (int i = 0; i < len - 1; i++) {
                double percentDiff =
                    (candle[m + i + 1].close! - candle[m + i].close!) /
                        (candle[m + i].close!);
                comparePeriodPercentDifferencesList.add(percentDiff);
              }

              (bool, List<double>) comparisonResult = TrendMatch()
                  .areDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      candleTol,
                      selectedPeriodPercentDifferencesList,
                      comparePeriodPercentDifferencesList,
                      priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

              if (comparisonResult.$1) {
                // printInfo(info: '✅ A trend percentage changes matched');
                List<double>
                    comparePeriodFirstMaAndPricePercentDifferencesList = [];
                List<List<double>> comparePeriodMaPercentDifferencesListList =
                    [];
                double compareFirstPrice = candle[m].close!;

                for (int n = 0; n < len - 1; n++) {
                  List<double> comparePeriodMaPercentDifferencesList = [];
                  for (int i = 0; i < maLength; i++) {
                    double newVal = candle[m + n + 1].trends[i]!;
                    double oriVal = candle[m + n].trends[i]!;
                    double maPercentDiff = (newVal - oriVal) / oriVal;
                    comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                  }
                  comparePeriodMaPercentDifferencesListList
                      .add(comparePeriodMaPercentDifferencesList);
                }
                for (int i = 0; i < maLength; i++) {
                  comparePeriodFirstMaAndPricePercentDifferencesList.add(
                      (candle[m].trends[i]! - compareFirstPrice) /
                          compareFirstPrice);
                }

                bool isMaMatched = TrendMatch()
                    .maDifferencesLessThanOrEqualToCertainPercent(
                        selectedPeriodFirstMaAndPricePercentDifferencesList,
                        selectedPeriodMaPercentDifferencesListList,
                        comparePeriodFirstMaAndPricePercentDifferencesList,
                        comparePeriodMaPercentDifferencesListList,
                        maTol,
                        firstMaTol);
                if (isMaMatched) {
                  // printInfo(info: '✅ A trend MAs matched');
                  // Store the adjusted close prices into different lists
                  List<double> matchedAdjustedSubsequentCloseList = [];
                  double lastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  double actualLastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  actualLastDifferenceList.add(actualLastDifference);
                  for (int i = 0; i < subsequentLen; i++) {
                    double adjustedSubsequentClose =
                        candle[m + len + i].close! * lastDifference;
                    matchedAdjustedSubsequentCloseList
                        .add(adjustedSubsequentClose);
                  }
                  if (matchedAdjustedSubsequentCloseList.last >
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    upper.add(matchedAdjustedSubsequentCloseList);
                  } else if (matchedAdjustedSubsequentCloseList.last <
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    lower.add(matchedAdjustedSubsequentCloseList);
                  } else {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    baseline++;
                  }
                }
                // else {
                //   printInfo(info: '❌ A trend MAs not matched');
                // }
              }
              // else {
              //   printInfo(info: '❌ A trend percentage changes not matched');
              // }
            }

            // Division by zero is mathematically undefined, but in programming,
            // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
            // This way, skip when both lists are empty
            if (upper.isEmpty && lower.isEmpty) {
              missCount++;
              // printInfo(info: '❌ upper and lower are empty');
              continue;
            }
            // Probability calculation and amount of matched trends
            double upperProb =
                upper.length / (upper.length + lower.length + baseline);
            double lowerProb =
                lower.length / (upper.length + lower.length + baseline);
            // Round to 3 decimal places
            upperProb = double.parse(upperProb.toStringAsFixed(4));
            lowerProb = double.parse(lowerProb.toStringAsFixed(4));
            if (upperProb >= thisProbThreshold) {
              if (upperProb.toInt() == 1) {
                if (upper.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 4');
                  continue;
                }
              } else {
                if (upper.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 5');
                  continue;
                }
              }
              isLong = true;
              // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
            } else if (lowerProb >= thisProbThreshold) {
              if (lowerProb.toInt() == 1) {
                if (lower.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 4');
                  continue;
                }
              } else {
                if (lower.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 5');
                  continue;
                }
              }
              isShort = true;
              // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
            } else {
              missCount++;
              // printInfo(info: '❌ No majority list');
              continue;
            }

            // Return rate median
            double thisMdd = 0.0;
            if (isLong) {
              double medianOfLastCloses = findMedianOfLastValues(upper);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate <= minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate <= $minMedianReturnRate in long');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in long');
                continue;
              }
              double thisMin = findMinOfValues(lower);
              if (thisMin != 0.0) {
                double minPercentageDifference =
                    (thisMin - lastClosePrice) / lastClosePrice;
                double minPercentageDifferenceAbs =
                    minPercentageDifference.abs();
                mdd = max(mdd, minPercentageDifferenceAbs);
                thisMdd = minPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMin is 0.0 in long');
                continue;
              }
            } else if (isShort) {
              double medianOfLastCloses = findMedianOfLastValues(lower);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate >= -minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate >= -$minMedianReturnRate in short');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in short');
                continue;
              }
              double thisMax = findMaxOfValues(upper);
              if (thisMax != 0.0) {
                double maxPercentageDifference =
                    (thisMax - lastClosePrice) / lastClosePrice;
                double maxPercentageDifferenceAbs =
                    maxPercentageDifference.abs();
                mdd = max(mdd, maxPercentageDifferenceAbs);
                thisMdd = maxPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMax is 0.0 in short');
                continue;
              }
            }
            hitCount++;
            // printInfo(
            //     info:
            //         '✅ Minimum median return rate has been passed: $medianReturnRate');

            // Pick up a trend randomly from upper/lower by overall probability
            int randomIndex = random.nextInt(subClosePrices.length);
            // Get the randomly selected trend from the combinedList
            List<double> randomTrend = subClosePrices[randomIndex];
            // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
            // and the exit price is always on time
            double actualReturnRate =
                ((randomTrend.last - actualLastClosePrice) /
                    actualLastClosePrice);
            double undelayedReturnRate =
                ((randomTrend.last - lastClosePrice) / lastClosePrice);
            double roundedActualReturnRate =
                double.parse(actualReturnRate.toStringAsFixed(4));
            double roundedUndelayedReturnRate =
                double.parse(undelayedReturnRate.toStringAsFixed(4));
            int contractVal =
                5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
            int diffFromEtfAndFuture =
                10; // The difference in value scale between ETF and Future
            matchedTrendCount = subClosePrices.length;

            double interruptActualReturn = 0.0;
            double interruptActualReturnRate = 0.0;
            double interruptUndelayedReturn = 0.0;
            double interruptUndelayedReturnRate = 0.0;
            bool interrupt = false;

            // Check whether the trend return rate has reaches the median return rate in matched trends
            int medianHitID = -1;
            if (closePosWhenReachedMedian.value) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

            // Check the number of trend go to the opposite side
            int goOppositeCount = 0;
            int goOppoHitID = -1;
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] < lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] > lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

            // Check if hit the opposite side ceiling or bottom
            int hitOppositeCeilingOrBottomCount = 0;
            int hitOppoBottomOrCeilingHitID = -1;
            if (thisMdd != 0.0) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= -thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

            for (var element in subClosePricesRowID) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  candle[element].timestamp,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              String lastDatetime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
              String timezone = TimeService.to.isEasternDaylightTime(dateTime)
                  ? 'EDT'
                  : 'EST';
              datetime.add('$lastDatetime $timezone');
            }

            if (!interrupt) {
              // Fund value changes due to the return of transaction
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  (((randomTrend.last - actualLastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  (((randomTrend.last - lastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            } else {
              int firstHitID = -1;
              final List<int> hitList = [
                medianHitID,
                goOppoHitID,
                hitOppoBottomOrCeilingHitID,
              ];
              for (final int hitID in hitList) {
                if (hitID != -1) {
                  if (firstHitID == -1) {
                    firstHitID = hitID;
                  } else if (hitID <= firstHitID) {
                    firstHitID = hitID;
                  }
                }
              }

              if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
                double newVal = candle[subClosePricesRowID[randomIndex] +
                            firstHitID +
                            yFinMinuteDelay]
                        .close! *
                    actualLastDifferenceList[randomIndex];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              } else {
                double newVal = randomTrend[firstHitID + yFinMinuteDelay];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              }
              double newVal = randomTrend[firstHitID];
              interruptUndelayedReturn = newVal - lastClosePrice;
              interruptUndelayedReturnRate =
                  (newVal - lastClosePrice) / lastClosePrice;

              // Get the failed trend last close price return and change the fund value
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  ((interruptActualReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            }

            prob = double.parse(
                (isLong ? upperProb : lowerProb).toStringAsFixed(4));
            medianReturnRate =
                double.parse(medianReturnRate.toStringAsFixed(4));
            hitRate = hitCount / (hitCount + missCount);
            roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
            double roundedMdd = double.parse(mdd.toStringAsFixed(4));
            double roundedInitialFund =
                double.parse(initialFund.toStringAsFixed(4));
            double roundedUndelayedInitialFund =
                double.parse(undelayedInitialFund.toStringAsFixed(4));

            // Save results one by one into listList
            subClosePrices.asMap().entries.forEach((entry) {
              listList.add([
                id,
                datetime[entry.key],
                len,
                prob,
                medianReturnRate,
                roundedUndelayedReturnRate,
                roundedActualReturnRate,
                matchedTrendCount,
                interrupt,
                interruptUndelayedReturnRate,
                interruptActualReturnRate,
                roundedHitRate,
                roundedMdd,
                roundedUndelayedInitialFund,
                roundedInitialFund,
                commissionsAndFees,
                yFinMinuteDelay,
                ...entry.value
              ]);
            });

            // logger.d(listList);

            // printInfo(info: 'Matched count: $matchedTrendCount');
            // printInfo(info: 'Prob.: $prob');
            // printInfo(
            //     info: 'Undelayed return rate: $roundedUndelayedReturnRate');
            // printInfo(
            //     info:
            //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
            // printInfo(info: 'Final return rate: $roundedActualReturnRate');
            // printInfo(
            //     info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
          }
        }

        if (!alwaysThousandthsData.value) {
          splitCandleLists.removeAt(randomIndex);
        } else {
          splitCandleLists = [];
        }
      }

      // printInfo(info: 'Backtesting ended');
      // printInfo(info: 'Export backtesting results CSV...');
      int randomID = 100000 + random.nextInt(900000);
      // Export CSV to device's local file directory
      String fileName =
          '${randomID}_${symbol}_cTol${candleTolerance.value}_pTol${priceTolerance.value}_fMaTol${firstMaTolerance.value}_maTol${maTolerance.value}_len${len}_subLen${subsequentLen}_probThres${thisProbThreshold}_maTrue_strict${strictMatchCriteria.value}_outF30m_minMatchC${minMatchCount}_minSidedMatchC${minOneSidedMatchCount}_minR${minMedianReturnRate}_reachedMed${closePosWhenReachedMedian.value}_hitCeOrBoOneThirdSubLen_goOpHalfSubLen';
      exportCsv(listList, fileName);

      // printInfo(info: 'Exported backtesting results CSV');

      // Stop backtest loading effect
      isButtonDisabled.value = false;
      backtestingSymbol.value = '';

      // Reset the remaining number of backtest data
      backtestDataLen1.value = 0;
      backtestDataRan1.value = 0;
    });
    scheduleMicrotask(() async {
      // printInfo(info: 'Length: ${length.value}');
      // printInfo(info: 'Candle Tolerance: ${candleTolerance.value}');
      // printInfo(info: 'Price Tolerance: ${priceTolerance.value}');
      // printInfo(info: 'First MA Tolerance: ${firstMaTolerance.value}');
      // printInfo(info: 'MA Tolerance: ${maTolerance.value}');
      // printInfo(info: 'MA matching: True');
      // printInfo(info: 'Strict matching: ${strictMatchCriteria.value}');

      if (!alwaysShowMinuteData.value || !hasMinuteData.value) {
        showScaffoldMessenger(
            context: context, localizedMsg: 'backtest_no_minute_data'.tr);
        return;
      }

      List<List<dynamic>> listList = [];
      List<CandleData> candle = [];

      int initIndex = 20; // Assume that the backtest must be minute data
      int len = length.value;
      double commissionsAndFees = (0.25 * 2) + (0.021 * 2);
      int yFinMinuteDelay = 1;
      int hitCount = 0;
      int missCount = 0;
      // int outsideTimeCount = 0;
      int subsequentLen = subLength.value;
      double thisProbThreshold = probThreshold.value;
      double minMedianReturnRate = minReturnRateThreshold.value;
      int minMatchCount = 5;
      int minOneSidedMatchCount = 4;

      if (len <= 1) {
        throw ArgumentError('Selected period must greater than 1 time unit.');
      }

      // CSV headers
      listList.add([
        'ID',
        'Datetime',
        'Selected',
        'Probability',
        'Median Return Rate',
        'Expected Undelayed Return Rate (random trend)',
        'Expected Actual Return Rate (random trend)',
        'Matched Trend Count',
        'Interrupted Trend',
        'Interrupted Trend Undelayed Return Rate',
        'Interrupted Trend Actual Return Rate',
        'Hit Rate (after first 30 mins)',
        'MDD (all the time)',
        'Undelayed Fund Remaining (commns. and fees deducted)',
        'Fund Remaining (commns. and fees deducted)',
        'Commns. and Fees (2 contracts)',
        'yFin Minute Delay',
        ...List.generate(subsequentLen, (index) => 'Close Price ${index + 1}'),
      ]);

      // Make sure data is from the expected financial instrument
      if (symbol == financialInstrumentSymbol.value) {
        candle = listCandledata;
      } else {
        showScaffoldMessenger(
            context: context, localizedMsg: 'search_symbol_before_backtest'.tr);
        return;
      }

      // printInfo(info: 'Backtesting started');

      // Start backtest loading effect
      isButtonDisabled.value = true;
      backtestingSymbol.value = symbol;

      bool hasMa = candle.last.trends.isNotEmpty;
      int maLength = candle.last.trends.length;

      // Assume it must be an MA trend matching
      if (!hasMa) {
        await Candle().computeTrendLines();
        hasMa = candle.last.trends.isNotEmpty;
        maLength = candle.last.trends.length;
      }

      candle =
          candle.sublist(initIndex); // Remove trends that don't have all MAs
      // printInfo(info: 'Candle data length: ${candle.length}');

      // Split the candle list of list
      List<List<CandleData>> splitCandleLists = [];
      List<int> splitCandleListsLastRows = [];
      int splits = 1000;
      final int sublistSize = (candle.length / splits).ceil();

      for (int i = 0; i < candle.length; i += sublistSize) {
        final end =
            (i + sublistSize < candle.length) ? i + sublistSize : candle.length;
        final sublist = candle.sublist(i, end);
        splitCandleLists.add(sublist);
        splitCandleListsLastRows.add(end - 1);
      }
      // printInfo(info: 'Split candle list length: ${splitCandleLists.length}');

      // Show the remaining number of backtest data
      if (!alwaysThousandthsData.value) {
        backtestDataLen2.value = candle.length;
      }

      // Randomly pick a list to run backtest
      final random = Random();
      final double candleTol = candleTolerance.value / 100;
      final double priceTol = priceTolerance.value / 100;
      final double firstMaTol = firstMaTolerance.value / 100;
      final double maTol = maTolerance.value / 100;

      double hitRate = 0.0;
      double roundedHitRate = 0.0;
      double mdd = 0.0;
      double initialFund = 10000;
      double undelayedInitialFund = 10000;
      int oneThirdSubLength = subsequentLen ~/ 3;
      int halfSubLength = subsequentLen ~/ 2;

      while (splitCandleLists.isNotEmpty) {
        final randomIndex = random.nextInt(splitCandleLists.length);
        final sublist = splitCandleLists[randomIndex];
        final subLen = sublist.length;
        if (alwaysThousandthsData.value) {
          backtestDataLen2.value = subLen;
        }

        // printInfo(info: 'Current split candle list no.: $randomIndex');
        // printInfo(info: 'Current split candle list length: $subLen');

        for (int l = 0; l < subLen - len + 1 - yFinMinuteDelay; l++) {
          await Future.delayed(const Duration(milliseconds: 0));

          // Show the remaining number of backtest data
          backtestDataRan2.value += 1;

          int id = l;
          List<String> datetime = [];
          double prob;
          double medianReturnRate = 0.0;
          int matchedTrendCount;

          // logger.d(
          //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: $id/$subLen');

          // Check if the dateTime is within the first 30 minutes of trading
          int timestamp = sublist[l].timestamp;
          if (timestamp != 0) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                timestamp * 1000,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            // Define trading start time
            DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                subtractedDateTime.month, subtractedDateTime.day, 9, 30);
            // Check if the dateTime is within the first 30 minutes of trading
            DateTime tradingEndTimeUTC =
                tradingStartTime.add(const Duration(minutes: 30));
            bool isWithinFirst30Minutes =
                subtractedDateTime.isAfter(tradingStartTime) &&
                    subtractedDateTime.isBefore(tradingEndTimeUTC);
            if (isWithinFirst30Minutes) {
              // outsideTimeCount++;
              continue;
            }
          } else {
            // logger.d('Error: timestamp == 0');
            splitCandleLists = [];
            break;
          }
          // printInfo(info: '✅ Outside first 30 mins');

          // Selecting a trend
          double startingClosePrice = sublist[l].close!;
          double lastClosePrice = sublist[l + len - 1].close!;
          double actualLastClosePrice =
              sublist[l + len - 1 + yFinMinuteDelay].close!;
          List<double> selectedPeriodPercentDifferencesList = [];
          // For MA matching
          List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
          List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
          // For candle matching
          List<List<double>>
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
          // Loop selected data
          for (int i = 0; i < len; i++) {
            // Candle
            List<double>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
            double close = sublist[l + i].close!;
            double openAndClosePercentDiff =
                (sublist[l + i].open! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(openAndClosePercentDiff);
            double highAndClosePercentDiff =
                (sublist[l + i].high! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(highAndClosePercentDiff);
            double lowAndClosePercentDiff =
                (sublist[l + i].low! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(lowAndClosePercentDiff);
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
          }
          for (int i = 0; i < len - 1; i++) {
            // Price
            double newVal = sublist[l + i + 1].close!;
            double oriVal = sublist[l + i].close!;
            double percentDiff = (newVal - oriVal) / oriVal;
            selectedPeriodPercentDifferencesList.add(percentDiff);

            // MA
            List<double> selectedPeriodMaPercentDifferencesList = [];
            for (int n = 0; n < maLength; n++) {
              double newVal = sublist[l + i + 1].trends[n]!;
              double oriVal = sublist[l + i].trends[n]!;
              double maPercentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
            }
            selectedPeriodMaPercentDifferencesListList
                .add(selectedPeriodMaPercentDifferencesList);
          }
          // MA
          for (int m = 0; m < maLength; m++) {
            selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                (sublist[l].trends[m]! - startingClosePrice) /
                    startingClosePrice);
          }
          // printInfo(info: '✅ Selected a trend');

          List<List<double>> upper = [];
          List<List<double>> lower = [];
          int baseline = 0;
          List<List<double>> subClosePrices = [];
          List<int> subClosePricesRowID = [];
          bool isLong = false;
          bool isShort = false;
          List<double> actualLastDifferenceList = [];

          // Look for similar trend(s)
          for (int m = 0;
              m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
              // Minus yFinMinuteDelay for actualReturn calculation
              m++) {
            // For candle matching
            List<List<double>>
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[m + i].close!;
              double openAndClosePercentDiff =
                  (candle[m + i].open! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[m + i].high! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[m + i].low! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              comparePeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
            }

            // For price matching
            List<double> comparePeriodPercentDifferencesList = [];
            for (int i = 0; i < len - 1; i++) {
              double percentDiff =
                  (candle[m + i + 1].close! - candle[m + i].close!) /
                      (candle[m + i].close!);
              comparePeriodPercentDifferencesList.add(percentDiff);
            }

            (bool, List<double>) comparisonResult = TrendMatch()
                .areDifferencesLessThanOrEqualToCertainPercent(
                    selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    candleTol,
                    selectedPeriodPercentDifferencesList,
                    comparePeriodPercentDifferencesList,
                    priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

            if (comparisonResult.$1) {
              // printInfo(info: '✅ A trend percentage changes matched');
              List<double> comparePeriodFirstMaAndPricePercentDifferencesList =
                  [];
              List<List<double>> comparePeriodMaPercentDifferencesListList = [];
              double compareFirstPrice = candle[m].close!;

              for (int n = 0; n < len - 1; n++) {
                List<double> comparePeriodMaPercentDifferencesList = [];
                for (int i = 0; i < maLength; i++) {
                  double newVal = candle[m + n + 1].trends[i]!;
                  double oriVal = candle[m + n].trends[i]!;
                  double maPercentDiff = (newVal - oriVal) / oriVal;
                  comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                }
                comparePeriodMaPercentDifferencesListList
                    .add(comparePeriodMaPercentDifferencesList);
              }
              for (int i = 0; i < maLength; i++) {
                comparePeriodFirstMaAndPricePercentDifferencesList.add(
                    (candle[m].trends[i]! - compareFirstPrice) /
                        compareFirstPrice);
              }

              bool isMaMatched = TrendMatch()
                  .maDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodFirstMaAndPricePercentDifferencesList,
                      selectedPeriodMaPercentDifferencesListList,
                      comparePeriodFirstMaAndPricePercentDifferencesList,
                      comparePeriodMaPercentDifferencesListList,
                      maTol,
                      firstMaTol);
              if (isMaMatched) {
                // printInfo(info: '✅ A trend MAs matched');
                // Store the adjusted close prices into different lists
                List<double> matchedAdjustedSubsequentCloseList = [];
                double lastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                double actualLastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                actualLastDifferenceList.add(actualLastDifference);
                for (int i = 0; i < subsequentLen; i++) {
                  double adjustedSubsequentClose =
                      candle[m + len + i].close! * lastDifference;
                  matchedAdjustedSubsequentCloseList
                      .add(adjustedSubsequentClose);
                }
                if (matchedAdjustedSubsequentCloseList.last > lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  upper.add(matchedAdjustedSubsequentCloseList);
                } else if (matchedAdjustedSubsequentCloseList.last <
                    lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  lower.add(matchedAdjustedSubsequentCloseList);
                } else {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  baseline++;
                }
              }
              // else {
              //   printInfo(info: '❌ A trend MAs not matched');
              // }
            }
            // else {
            //   printInfo(info: '❌ A trend percentage changes not matched');
            // }
          }

          // Division by zero is mathematically undefined, but in programming,
          // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
          // This way, skip when both lists are empty
          if (upper.isEmpty && lower.isEmpty) {
            missCount++;
            // printInfo(info: '❌ upper and lower are empty');
            continue;
          }
          // Probability calculation and amount of matched trends
          double upperProb =
              upper.length / (upper.length + lower.length + baseline);
          double lowerProb =
              lower.length / (upper.length + lower.length + baseline);
          // Round to 3 decimal places
          upperProb = double.parse(upperProb.toStringAsFixed(4));
          lowerProb = double.parse(lowerProb.toStringAsFixed(4));
          if (upperProb >= thisProbThreshold) {
            if (upperProb.toInt() == 1) {
              if (upper.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 4');
                continue;
              }
            } else {
              if (upper.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 5');
                continue;
              }
            }
            isLong = true;
            // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
          } else if (lowerProb >= thisProbThreshold) {
            if (lowerProb.toInt() == 1) {
              if (lower.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 4');
                continue;
              }
            } else {
              if (lower.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 5');
                continue;
              }
            }
            isShort = true;
            // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
          } else {
            missCount++;
            // printInfo(info: '❌ No majority list');
            continue;
          }

          // Return rate median
          double thisMdd = 0.0;
          if (isLong) {
            double medianOfLastCloses = findMedianOfLastValues(upper);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate <= minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate <= $minMedianReturnRate in long');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in long');
              continue;
            }
            double thisMin = findMinOfValues(lower);
            if (thisMin != 0.0) {
              double minPercentageDifference =
                  (thisMin - lastClosePrice) / lastClosePrice;
              double minPercentageDifferenceAbs = minPercentageDifference.abs();
              mdd = max(mdd, minPercentageDifferenceAbs);
              thisMdd = minPercentageDifferenceAbs;
            } else {
              thisMdd = thisMin;
            }
          } else if (isShort) {
            double medianOfLastCloses = findMedianOfLastValues(lower);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate >= -minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate >= -$minMedianReturnRate in short');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in short');
              continue;
            }
            double thisMax = findMaxOfValues(upper);
            if (thisMax != 0.0) {
              double maxPercentageDifference =
                  (thisMax - lastClosePrice) / lastClosePrice;
              double maxPercentageDifferenceAbs = maxPercentageDifference.abs();
              mdd = max(mdd, maxPercentageDifferenceAbs);
              thisMdd = maxPercentageDifferenceAbs;
            } else {
              thisMdd = thisMax;
            }
          }
          hitCount++;
          // printInfo(
          //     info:
          //         '✅ Minimum median return rate has been passed: $medianReturnRate');

          // Pick up a trend randomly from upper/lower by overall probability
          int randomIndex = random.nextInt(subClosePrices.length);
          // Get the randomly selected trend from the combinedList
          List<double> randomTrend = subClosePrices[randomIndex];
          // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
          // and the exit price is always on time
          double actualReturnRate = ((randomTrend.last - actualLastClosePrice) /
              actualLastClosePrice);
          double undelayedReturnRate =
              ((randomTrend.last - lastClosePrice) / lastClosePrice);
          double roundedActualReturnRate =
              double.parse(actualReturnRate.toStringAsFixed(4));
          double roundedUndelayedReturnRate =
              double.parse(undelayedReturnRate.toStringAsFixed(4));
          int contractVal =
              5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
          int diffFromEtfAndFuture =
              10; // The difference in value scale between ETF and Future
          matchedTrendCount = subClosePrices.length;

          double interruptActualReturn = 0.0;
          double interruptActualReturnRate = 0.0;
          double interruptUndelayedReturn = 0.0;
          double interruptUndelayedReturnRate = 0.0;
          bool interrupt = false;

          // Check whether the trend return rate has reaches the median return rate in matched trends
          int medianHitID = -1;
          if (closePosWhenReachedMedian.value) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

          // Check the number of trend go to the opposite side
          int goOppositeCount = 0;
          int goOppoHitID = -1;
          if (isLong) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] < lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          } else if (isShort) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] > lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

          // Check if hit the opposite side ceiling or bottom
          int hitOppositeCeilingOrBottomCount = 0;
          int hitOppoBottomOrCeilingHitID = -1;
          if (thisMdd != 0.0) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= -thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

          for (var element in subClosePricesRowID) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                candle[element].timestamp,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            String lastDatetime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
            String timezone =
                TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
            datetime.add('$lastDatetime $timezone');
          }

          if (!interrupt) {
            // Fund value changes due to the return of transaction
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                (((randomTrend.last - actualLastClosePrice) *
                        diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                (((randomTrend.last - lastClosePrice) * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          } else {
            int firstHitID = -1;
            final List<int> hitList = [
              medianHitID,
              goOppoHitID,
              hitOppoBottomOrCeilingHitID,
            ];
            for (final int hitID in hitList) {
              if (hitID != -1) {
                if (firstHitID == -1) {
                  firstHitID = hitID;
                } else if (hitID <= firstHitID) {
                  firstHitID = hitID;
                }
              }
            }

            if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
              double newVal = candle[subClosePricesRowID[randomIndex] +
                          firstHitID +
                          yFinMinuteDelay]
                      .close! *
                  actualLastDifferenceList[randomIndex];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            } else {
              double newVal = randomTrend[firstHitID + yFinMinuteDelay];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            }
            double newVal = randomTrend[firstHitID];
            interruptUndelayedReturn = newVal - lastClosePrice;
            interruptUndelayedReturnRate =
                (newVal - lastClosePrice) / lastClosePrice;

            // Get the failed trend last close price return and change the fund value
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                ((interruptActualReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          }

          prob =
              double.parse((isLong ? upperProb : lowerProb).toStringAsFixed(4));
          medianReturnRate = double.parse(medianReturnRate.toStringAsFixed(4));
          hitRate = hitCount / (hitCount + missCount);
          roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
          double roundedMdd = double.parse(mdd.toStringAsFixed(4));
          double roundedInitialFund =
              double.parse(initialFund.toStringAsFixed(4));
          double roundedUndelayedInitialFund =
              double.parse(undelayedInitialFund.toStringAsFixed(4));

          // Save results one by one into listList
          subClosePrices.asMap().entries.forEach((entry) {
            listList.add([
              id,
              datetime[entry.key],
              len,
              prob,
              medianReturnRate,
              roundedUndelayedReturnRate,
              roundedActualReturnRate,
              matchedTrendCount,
              interrupt,
              interruptUndelayedReturnRate,
              interruptActualReturnRate,
              roundedHitRate,
              roundedMdd,
              roundedUndelayedInitialFund,
              roundedInitialFund,
              commissionsAndFees,
              yFinMinuteDelay,
              ...entry.value
            ]);
          });

          // logger.d(listList);

          // printInfo(info: 'Matched count: $matchedTrendCount');
          // printInfo(info: 'Prob.: $prob');
          // printInfo(info: 'Undelayed return rate: $roundedUndelayedReturnRate');
          // printInfo(
          //     info:
          //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
          // printInfo(info: 'Final return rate: $roundedActualReturnRate');
          // printInfo(info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
        }

        // Check if the sublist can be looped through the last row or not
        if (splitCandleListsLastRows[randomIndex] != candle.length - 1) {
          final int sublistLastCandleRow =
              splitCandleListsLastRows[randomIndex];
          // Loop through remaining rows in sublist if possible
          int remainder = subLen - (subLen - len + 1 - yFinMinuteDelay);
          for (int l = subLen - len + 1 - yFinMinuteDelay; l < subLen; l++) {
            final int thisCandleRow = sublistLastCandleRow - remainder;
            remainder--;

            await Future.delayed(const Duration(milliseconds: 0));

            // Show the remaining number of backtest data
            backtestDataRan2.value += 1;

            int id = l;
            List<String> datetime = [];
            double prob;
            double medianReturnRate = 0.0;
            int matchedTrendCount;

            // logger.d(
            //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: ${id + 1}/$subLen');

            // Check if the dateTime is within the first 30 minutes of trading
            int timestamp = sublist[l].timestamp;
            if (timestamp != 0) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              // Define trading start time
              DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                  subtractedDateTime.month, subtractedDateTime.day, 9, 30);
              // Check if the dateTime is within the first 30 minutes of trading
              DateTime tradingEndTimeUTC =
                  tradingStartTime.add(const Duration(minutes: 30));
              bool isWithinFirst30Minutes =
                  subtractedDateTime.isAfter(tradingStartTime) &&
                      subtractedDateTime.isBefore(tradingEndTimeUTC);
              if (isWithinFirst30Minutes) {
                // outsideTimeCount++;
                continue;
              }
            } else {
              // logger.d('Error: timestamp == 0');
              splitCandleLists = [];
              break;
            }
            // printInfo(info: '✅ Outside first 30 mins');

            // Selecting a trend
            double startingClosePrice = sublist[l].close!;
            double lastClosePrice = candle[thisCandleRow + len - 1].close!;
            double actualLastClosePrice =
                candle[thisCandleRow + len - 1 + yFinMinuteDelay].close!;
            List<double> selectedPeriodPercentDifferencesList = [];
            // For MA matching
            List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
            List<double> selectedPeriodFirstMaAndPricePercentDifferencesList =
                [];
            // For candle matching
            List<List<double>>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList =
                [];
            // Loop selected data
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[thisCandleRow + i].close!;
              double openAndClosePercentDiff =
                  (candle[thisCandleRow + i].open! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[thisCandleRow + i].high! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[thisCandleRow + i].low! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
            }
            for (int i = 0; i < len - 1; i++) {
              double newVal = candle[thisCandleRow + i + 1].close!;
              double oriVal = candle[thisCandleRow + i].close!;
              double percentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodPercentDifferencesList.add(percentDiff);

              // MA
              List<double> selectedPeriodMaPercentDifferencesList = [];
              for (int n = 0; n < maLength; n++) {
                double newVal = candle[thisCandleRow + i + 1].trends[n]!;
                double oriVal = candle[thisCandleRow + i].trends[n]!;
                double maPercentDiff = (newVal - oriVal) / oriVal;
                selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
              }
              selectedPeriodMaPercentDifferencesListList
                  .add(selectedPeriodMaPercentDifferencesList);
            }
            // MA
            for (int m = 0; m < maLength; m++) {
              selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                  (sublist[l].trends[m]! - startingClosePrice) /
                      startingClosePrice);
            }
            // printInfo(info: '✅ Selected a trend');

            List<List<double>> upper = [];
            List<List<double>> lower = [];
            int baseline = 0;
            List<List<double>> subClosePrices = [];
            List<int> subClosePricesRowID = [];
            bool isLong = false;
            bool isShort = false;
            List<double> actualLastDifferenceList = [];

            // Look for similar trend(s)
            for (int m = 0;
                m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
                // Minus yFinMinuteDelay for actualReturn calculation
                m++) {
              // For candle matching
              List<List<double>>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseListList =
                  [];
              for (int i = 0; i < len; i++) {
                // Candle
                List<double>
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
                double close = candle[m + i].close!;
                double openAndClosePercentDiff =
                    (candle[m + i].open! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(openAndClosePercentDiff);
                double highAndClosePercentDiff =
                    (candle[m + i].high! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(highAndClosePercentDiff);
                double lowAndClosePercentDiff =
                    (candle[m + i].low! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(lowAndClosePercentDiff);
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList.add(
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
              }

              // For price matching
              List<double> comparePeriodPercentDifferencesList = [];
              for (int i = 0; i < len - 1; i++) {
                double percentDiff =
                    (candle[m + i + 1].close! - candle[m + i].close!) /
                        (candle[m + i].close!);
                comparePeriodPercentDifferencesList.add(percentDiff);
              }

              (bool, List<double>) comparisonResult = TrendMatch()
                  .areDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      candleTol,
                      selectedPeriodPercentDifferencesList,
                      comparePeriodPercentDifferencesList,
                      priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

              if (comparisonResult.$1) {
                // printInfo(info: '✅ A trend percentage changes matched');
                List<double>
                    comparePeriodFirstMaAndPricePercentDifferencesList = [];
                List<List<double>> comparePeriodMaPercentDifferencesListList =
                    [];
                double compareFirstPrice = candle[m].close!;

                for (int n = 0; n < len - 1; n++) {
                  List<double> comparePeriodMaPercentDifferencesList = [];
                  for (int i = 0; i < maLength; i++) {
                    double newVal = candle[m + n + 1].trends[i]!;
                    double oriVal = candle[m + n].trends[i]!;
                    double maPercentDiff = (newVal - oriVal) / oriVal;
                    comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                  }
                  comparePeriodMaPercentDifferencesListList
                      .add(comparePeriodMaPercentDifferencesList);
                }
                for (int i = 0; i < maLength; i++) {
                  comparePeriodFirstMaAndPricePercentDifferencesList.add(
                      (candle[m].trends[i]! - compareFirstPrice) /
                          compareFirstPrice);
                }

                bool isMaMatched = TrendMatch()
                    .maDifferencesLessThanOrEqualToCertainPercent(
                        selectedPeriodFirstMaAndPricePercentDifferencesList,
                        selectedPeriodMaPercentDifferencesListList,
                        comparePeriodFirstMaAndPricePercentDifferencesList,
                        comparePeriodMaPercentDifferencesListList,
                        maTol,
                        firstMaTol);
                if (isMaMatched) {
                  // printInfo(info: '✅ A trend MAs matched');
                  // Store the adjusted close prices into different lists
                  List<double> matchedAdjustedSubsequentCloseList = [];
                  double lastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  double actualLastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  actualLastDifferenceList.add(actualLastDifference);
                  for (int i = 0; i < subsequentLen; i++) {
                    double adjustedSubsequentClose =
                        candle[m + len + i].close! * lastDifference;
                    matchedAdjustedSubsequentCloseList
                        .add(adjustedSubsequentClose);
                  }
                  if (matchedAdjustedSubsequentCloseList.last >
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    upper.add(matchedAdjustedSubsequentCloseList);
                  } else if (matchedAdjustedSubsequentCloseList.last <
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    lower.add(matchedAdjustedSubsequentCloseList);
                  } else {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    baseline++;
                  }
                }
                // else {
                //   printInfo(info: '❌ A trend MAs not matched');
                // }
              }
              // else {
              //   printInfo(info: '❌ A trend percentage changes not matched');
              // }
            }

            // Division by zero is mathematically undefined, but in programming,
            // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
            // This way, skip when both lists are empty
            if (upper.isEmpty && lower.isEmpty) {
              missCount++;
              // printInfo(info: '❌ upper and lower are empty');
              continue;
            }
            // Probability calculation and amount of matched trends
            double upperProb =
                upper.length / (upper.length + lower.length + baseline);
            double lowerProb =
                lower.length / (upper.length + lower.length + baseline);
            // Round to 3 decimal places
            upperProb = double.parse(upperProb.toStringAsFixed(4));
            lowerProb = double.parse(lowerProb.toStringAsFixed(4));
            if (upperProb >= thisProbThreshold) {
              if (upperProb.toInt() == 1) {
                if (upper.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 4');
                  continue;
                }
              } else {
                if (upper.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 5');
                  continue;
                }
              }
              isLong = true;
              // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
            } else if (lowerProb >= thisProbThreshold) {
              if (lowerProb.toInt() == 1) {
                if (lower.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 4');
                  continue;
                }
              } else {
                if (lower.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 5');
                  continue;
                }
              }
              isShort = true;
              // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
            } else {
              missCount++;
              // printInfo(info: '❌ No majority list');
              continue;
            }

            // Return rate median
            double thisMdd = 0.0;
            if (isLong) {
              double medianOfLastCloses = findMedianOfLastValues(upper);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate <= minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate <= $minMedianReturnRate in long');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in long');
                continue;
              }
              double thisMin = findMinOfValues(lower);
              if (thisMin != 0.0) {
                double minPercentageDifference =
                    (thisMin - lastClosePrice) / lastClosePrice;
                double minPercentageDifferenceAbs =
                    minPercentageDifference.abs();
                mdd = max(mdd, minPercentageDifferenceAbs);
                thisMdd = minPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMin is 0.0 in long');
                continue;
              }
            } else if (isShort) {
              double medianOfLastCloses = findMedianOfLastValues(lower);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate >= -minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate >= -$minMedianReturnRate in short');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in short');
                continue;
              }
              double thisMax = findMaxOfValues(upper);
              if (thisMax != 0.0) {
                double maxPercentageDifference =
                    (thisMax - lastClosePrice) / lastClosePrice;
                double maxPercentageDifferenceAbs =
                    maxPercentageDifference.abs();
                mdd = max(mdd, maxPercentageDifferenceAbs);
                thisMdd = maxPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMax is 0.0 in short');
                continue;
              }
            }
            hitCount++;
            // printInfo(
            //     info:
            //         '✅ Minimum median return rate has been passed: $medianReturnRate');

            // Pick up a trend randomly from upper/lower by overall probability
            int randomIndex = random.nextInt(subClosePrices.length);
            // Get the randomly selected trend from the combinedList
            List<double> randomTrend = subClosePrices[randomIndex];
            // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
            // and the exit price is always on time
            double actualReturnRate =
                ((randomTrend.last - actualLastClosePrice) /
                    actualLastClosePrice);
            double undelayedReturnRate =
                ((randomTrend.last - lastClosePrice) / lastClosePrice);
            double roundedActualReturnRate =
                double.parse(actualReturnRate.toStringAsFixed(4));
            double roundedUndelayedReturnRate =
                double.parse(undelayedReturnRate.toStringAsFixed(4));
            int contractVal =
                5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
            int diffFromEtfAndFuture =
                10; // The difference in value scale between ETF and Future
            matchedTrendCount = subClosePrices.length;

            double interruptActualReturn = 0.0;
            double interruptActualReturnRate = 0.0;
            double interruptUndelayedReturn = 0.0;
            double interruptUndelayedReturnRate = 0.0;
            bool interrupt = false;

            // Check whether the trend return rate has reaches the median return rate in matched trends
            int medianHitID = -1;
            if (closePosWhenReachedMedian.value) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

            // Check the number of trend go to the opposite side
            int goOppositeCount = 0;
            int goOppoHitID = -1;
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] < lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] > lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

            // Check if hit the opposite side ceiling or bottom
            int hitOppositeCeilingOrBottomCount = 0;
            int hitOppoBottomOrCeilingHitID = -1;
            if (thisMdd != 0.0) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= -thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

            for (var element in subClosePricesRowID) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  candle[element].timestamp,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              String lastDatetime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
              String timezone = TimeService.to.isEasternDaylightTime(dateTime)
                  ? 'EDT'
                  : 'EST';
              datetime.add('$lastDatetime $timezone');
            }

            if (!interrupt) {
              // Fund value changes due to the return of transaction
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  (((randomTrend.last - actualLastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  (((randomTrend.last - lastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            } else {
              int firstHitID = -1;
              final List<int> hitList = [
                medianHitID,
                goOppoHitID,
                hitOppoBottomOrCeilingHitID,
              ];
              for (final int hitID in hitList) {
                if (hitID != -1) {
                  if (firstHitID == -1) {
                    firstHitID = hitID;
                  } else if (hitID <= firstHitID) {
                    firstHitID = hitID;
                  }
                }
              }

              if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
                double newVal = candle[subClosePricesRowID[randomIndex] +
                            firstHitID +
                            yFinMinuteDelay]
                        .close! *
                    actualLastDifferenceList[randomIndex];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              } else {
                double newVal = randomTrend[firstHitID + yFinMinuteDelay];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              }
              double newVal = randomTrend[firstHitID];
              interruptUndelayedReturn = newVal - lastClosePrice;
              interruptUndelayedReturnRate =
                  (newVal - lastClosePrice) / lastClosePrice;

              // Get the failed trend last close price return and change the fund value
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  ((interruptActualReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            }

            prob = double.parse(
                (isLong ? upperProb : lowerProb).toStringAsFixed(4));
            medianReturnRate =
                double.parse(medianReturnRate.toStringAsFixed(4));
            hitRate = hitCount / (hitCount + missCount);
            roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
            double roundedMdd = double.parse(mdd.toStringAsFixed(4));
            double roundedInitialFund =
                double.parse(initialFund.toStringAsFixed(4));
            double roundedUndelayedInitialFund =
                double.parse(undelayedInitialFund.toStringAsFixed(4));

            // Save results one by one into listList
            subClosePrices.asMap().entries.forEach((entry) {
              listList.add([
                id,
                datetime[entry.key],
                len,
                prob,
                medianReturnRate,
                roundedUndelayedReturnRate,
                roundedActualReturnRate,
                matchedTrendCount,
                interrupt,
                interruptUndelayedReturnRate,
                interruptActualReturnRate,
                roundedHitRate,
                roundedMdd,
                roundedUndelayedInitialFund,
                roundedInitialFund,
                commissionsAndFees,
                yFinMinuteDelay,
                ...entry.value
              ]);
            });

            // logger.d(listList);

            // printInfo(info: 'Matched count: $matchedTrendCount');
            // printInfo(info: 'Prob.: $prob');
            // printInfo(
            //     info: 'Undelayed return rate: $roundedUndelayedReturnRate');
            // printInfo(
            //     info:
            //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
            // printInfo(info: 'Final return rate: $roundedActualReturnRate');
            // printInfo(
            //     info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
          }
        }

        if (!alwaysThousandthsData.value) {
          splitCandleLists.removeAt(randomIndex);
        } else {
          splitCandleLists = [];
        }
      }

      // printInfo(info: 'Backtesting ended');
      // printInfo(info: 'Export backtesting results CSV...');
      int randomID = 100000 + random.nextInt(900000);
      // Export CSV to device's local file directory
      String fileName =
          '${randomID}_${symbol}_cTol${candleTolerance.value}_pTol${priceTolerance.value}_fMaTol${firstMaTolerance.value}_maTol${maTolerance.value}_len${len}_subLen${subsequentLen}_probThres${thisProbThreshold}_maTrue_strict${strictMatchCriteria.value}_outF30m_minMatchC${minMatchCount}_minSidedMatchC${minOneSidedMatchCount}_minR${minMedianReturnRate}_reachedMed${closePosWhenReachedMedian.value}_hitCeOrBoOneThirdSubLen_goOpHalfSubLen';
      exportCsv(listList, fileName);

      // printInfo(info: 'Exported backtesting results CSV');

      // Stop backtest loading effect
      isButtonDisabled.value = false;
      backtestingSymbol.value = '';

      // Reset the remaining number of backtest data
      backtestDataLen2.value = 0;
      backtestDataRan2.value = 0;
    });
    scheduleMicrotask(() async {
      // printInfo(info: 'Length: ${length.value}');
      // printInfo(info: 'Candle Tolerance: ${candleTolerance.value}');
      // printInfo(info: 'Price Tolerance: ${priceTolerance.value}');
      // printInfo(info: 'First MA Tolerance: ${firstMaTolerance.value}');
      // printInfo(info: 'MA Tolerance: ${maTolerance.value}');
      // printInfo(info: 'MA matching: True');
      // printInfo(info: 'Strict matching: ${strictMatchCriteria.value}');

      if (!alwaysShowMinuteData.value || !hasMinuteData.value) {
        showScaffoldMessenger(
            context: context, localizedMsg: 'backtest_no_minute_data'.tr);
        return;
      }

      List<List<dynamic>> listList = [];
      List<CandleData> candle = [];

      int initIndex = 20; // Assume that the backtest must be minute data
      int len = length.value;
      double commissionsAndFees = (0.25 * 2) + (0.021 * 2);
      int yFinMinuteDelay = 1;
      int hitCount = 0;
      int missCount = 0;
      // int outsideTimeCount = 0;
      int subsequentLen = subLength.value;
      double thisProbThreshold = probThreshold.value;
      double minMedianReturnRate = minReturnRateThreshold.value;
      int minMatchCount = 5;
      int minOneSidedMatchCount = 4;

      if (len <= 1) {
        throw ArgumentError('Selected period must greater than 1 time unit.');
      }

      // CSV headers
      listList.add([
        'ID',
        'Datetime',
        'Selected',
        'Probability',
        'Median Return Rate',
        'Expected Undelayed Return Rate (random trend)',
        'Expected Actual Return Rate (random trend)',
        'Matched Trend Count',
        'Interrupted Trend',
        'Interrupted Trend Undelayed Return Rate',
        'Interrupted Trend Actual Return Rate',
        'Hit Rate (after first 30 mins)',
        'MDD (all the time)',
        'Undelayed Fund Remaining (commns. and fees deducted)',
        'Fund Remaining (commns. and fees deducted)',
        'Commns. and Fees (2 contracts)',
        'yFin Minute Delay',
        ...List.generate(subsequentLen, (index) => 'Close Price ${index + 1}'),
      ]);

      // Make sure data is from the expected financial instrument
      if (symbol == financialInstrumentSymbol.value) {
        candle = listCandledata;
      } else {
        showScaffoldMessenger(
            context: context, localizedMsg: 'search_symbol_before_backtest'.tr);
        return;
      }

      // printInfo(info: 'Backtesting started');

      // Start backtest loading effect
      isButtonDisabled.value = true;
      backtestingSymbol.value = symbol;

      bool hasMa = candle.last.trends.isNotEmpty;
      int maLength = candle.last.trends.length;

      // Assume it must be an MA trend matching
      if (!hasMa) {
        await Candle().computeTrendLines();
        hasMa = candle.last.trends.isNotEmpty;
        maLength = candle.last.trends.length;
      }

      candle =
          candle.sublist(initIndex); // Remove trends that don't have all MAs
      // printInfo(info: 'Candle data length: ${candle.length}');

      // Split the candle list of list
      List<List<CandleData>> splitCandleLists = [];
      List<int> splitCandleListsLastRows = [];
      int splits = 1000;
      final int sublistSize = (candle.length / splits).ceil();

      for (int i = 0; i < candle.length; i += sublistSize) {
        final end =
            (i + sublistSize < candle.length) ? i + sublistSize : candle.length;
        final sublist = candle.sublist(i, end);
        splitCandleLists.add(sublist);
        splitCandleListsLastRows.add(end - 1);
      }
      // printInfo(info: 'Split candle list length: ${splitCandleLists.length}');

      // Show the remaining number of backtest data
      if (!alwaysThousandthsData.value) {
        backtestDataLen3.value = candle.length;
      }

      // Randomly pick a list to run backtest
      final random = Random();
      final double candleTol = candleTolerance.value / 100;
      final double priceTol = priceTolerance.value / 100;
      final double firstMaTol = firstMaTolerance.value / 100;
      final double maTol = maTolerance.value / 100;

      double hitRate = 0.0;
      double roundedHitRate = 0.0;
      double mdd = 0.0;
      double initialFund = 10000;
      double undelayedInitialFund = 10000;
      int oneThirdSubLength = subsequentLen ~/ 3;
      int halfSubLength = subsequentLen ~/ 2;

      while (splitCandleLists.isNotEmpty) {
        final randomIndex = random.nextInt(splitCandleLists.length);
        final sublist = splitCandleLists[randomIndex];
        final subLen = sublist.length;
        if (alwaysThousandthsData.value) {
          backtestDataLen3.value = subLen;
        }

        // printInfo(info: 'Current split candle list no.: $randomIndex');
        // printInfo(info: 'Current split candle list length: $subLen');

        for (int l = 0; l < subLen - len + 1 - yFinMinuteDelay; l++) {
          await Future.delayed(const Duration(milliseconds: 0));

          // Show the remaining number of backtest data
          backtestDataRan3.value += 1;

          int id = l;
          List<String> datetime = [];
          double prob;
          double medianReturnRate = 0.0;
          int matchedTrendCount;

          // logger.d(
          //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: $id/$subLen');

          // Check if the dateTime is within the first 30 minutes of trading
          int timestamp = sublist[l].timestamp;
          if (timestamp != 0) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                timestamp * 1000,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            // Define trading start time
            DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                subtractedDateTime.month, subtractedDateTime.day, 9, 30);
            // Check if the dateTime is within the first 30 minutes of trading
            DateTime tradingEndTimeUTC =
                tradingStartTime.add(const Duration(minutes: 30));
            bool isWithinFirst30Minutes =
                subtractedDateTime.isAfter(tradingStartTime) &&
                    subtractedDateTime.isBefore(tradingEndTimeUTC);
            if (isWithinFirst30Minutes) {
              // outsideTimeCount++;
              continue;
            }
          } else {
            // logger.d('Error: timestamp == 0');
            splitCandleLists = [];
            break;
          }
          // printInfo(info: '✅ Outside first 30 mins');

          // Selecting a trend
          double startingClosePrice = sublist[l].close!;
          double lastClosePrice = sublist[l + len - 1].close!;
          double actualLastClosePrice =
              sublist[l + len - 1 + yFinMinuteDelay].close!;
          List<double> selectedPeriodPercentDifferencesList = [];
          // For MA matching
          List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
          List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
          // For candle matching
          List<List<double>>
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
          // Loop selected data
          for (int i = 0; i < len; i++) {
            // Candle
            List<double>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
            double close = sublist[l + i].close!;
            double openAndClosePercentDiff =
                (sublist[l + i].open! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(openAndClosePercentDiff);
            double highAndClosePercentDiff =
                (sublist[l + i].high! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(highAndClosePercentDiff);
            double lowAndClosePercentDiff =
                (sublist[l + i].low! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(lowAndClosePercentDiff);
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
          }
          for (int i = 0; i < len - 1; i++) {
            // Price
            double newVal = sublist[l + i + 1].close!;
            double oriVal = sublist[l + i].close!;
            double percentDiff = (newVal - oriVal) / oriVal;
            selectedPeriodPercentDifferencesList.add(percentDiff);

            // MA
            List<double> selectedPeriodMaPercentDifferencesList = [];
            for (int n = 0; n < maLength; n++) {
              double newVal = sublist[l + i + 1].trends[n]!;
              double oriVal = sublist[l + i].trends[n]!;
              double maPercentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
            }
            selectedPeriodMaPercentDifferencesListList
                .add(selectedPeriodMaPercentDifferencesList);
          }
          // MA
          for (int m = 0; m < maLength; m++) {
            selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                (sublist[l].trends[m]! - startingClosePrice) /
                    startingClosePrice);
          }
          // printInfo(info: '✅ Selected a trend');

          List<List<double>> upper = [];
          List<List<double>> lower = [];
          int baseline = 0;
          List<List<double>> subClosePrices = [];
          List<int> subClosePricesRowID = [];
          bool isLong = false;
          bool isShort = false;
          List<double> actualLastDifferenceList = [];

          // Look for similar trend(s)
          for (int m = 0;
              m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
              // Minus yFinMinuteDelay for actualReturn calculation
              m++) {
            // For candle matching
            List<List<double>>
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[m + i].close!;
              double openAndClosePercentDiff =
                  (candle[m + i].open! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[m + i].high! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[m + i].low! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              comparePeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
            }

            // For price matching
            List<double> comparePeriodPercentDifferencesList = [];
            for (int i = 0; i < len - 1; i++) {
              double percentDiff =
                  (candle[m + i + 1].close! - candle[m + i].close!) /
                      (candle[m + i].close!);
              comparePeriodPercentDifferencesList.add(percentDiff);
            }

            (bool, List<double>) comparisonResult = TrendMatch()
                .areDifferencesLessThanOrEqualToCertainPercent(
                    selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    candleTol,
                    selectedPeriodPercentDifferencesList,
                    comparePeriodPercentDifferencesList,
                    priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

            if (comparisonResult.$1) {
              // printInfo(info: '✅ A trend percentage changes matched');
              List<double> comparePeriodFirstMaAndPricePercentDifferencesList =
                  [];
              List<List<double>> comparePeriodMaPercentDifferencesListList = [];
              double compareFirstPrice = candle[m].close!;

              for (int n = 0; n < len - 1; n++) {
                List<double> comparePeriodMaPercentDifferencesList = [];
                for (int i = 0; i < maLength; i++) {
                  double newVal = candle[m + n + 1].trends[i]!;
                  double oriVal = candle[m + n].trends[i]!;
                  double maPercentDiff = (newVal - oriVal) / oriVal;
                  comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                }
                comparePeriodMaPercentDifferencesListList
                    .add(comparePeriodMaPercentDifferencesList);
              }
              for (int i = 0; i < maLength; i++) {
                comparePeriodFirstMaAndPricePercentDifferencesList.add(
                    (candle[m].trends[i]! - compareFirstPrice) /
                        compareFirstPrice);
              }

              bool isMaMatched = TrendMatch()
                  .maDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodFirstMaAndPricePercentDifferencesList,
                      selectedPeriodMaPercentDifferencesListList,
                      comparePeriodFirstMaAndPricePercentDifferencesList,
                      comparePeriodMaPercentDifferencesListList,
                      maTol,
                      firstMaTol);
              if (isMaMatched) {
                // printInfo(info: '✅ A trend MAs matched');
                // Store the adjusted close prices into different lists
                List<double> matchedAdjustedSubsequentCloseList = [];
                double lastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                double actualLastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                actualLastDifferenceList.add(actualLastDifference);
                for (int i = 0; i < subsequentLen; i++) {
                  double adjustedSubsequentClose =
                      candle[m + len + i].close! * lastDifference;
                  matchedAdjustedSubsequentCloseList
                      .add(adjustedSubsequentClose);
                }
                if (matchedAdjustedSubsequentCloseList.last > lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  upper.add(matchedAdjustedSubsequentCloseList);
                } else if (matchedAdjustedSubsequentCloseList.last <
                    lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  lower.add(matchedAdjustedSubsequentCloseList);
                } else {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  baseline++;
                }
              }
              // else {
              //   printInfo(info: '❌ A trend MAs not matched');
              // }
            }
            // else {
            //   printInfo(info: '❌ A trend percentage changes not matched');
            // }
          }

          // Division by zero is mathematically undefined, but in programming,
          // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
          // This way, skip when both lists are empty
          if (upper.isEmpty && lower.isEmpty) {
            missCount++;
            // printInfo(info: '❌ upper and lower are empty');
            continue;
          }
          // Probability calculation and amount of matched trends
          double upperProb =
              upper.length / (upper.length + lower.length + baseline);
          double lowerProb =
              lower.length / (upper.length + lower.length + baseline);
          // Round to 3 decimal places
          upperProb = double.parse(upperProb.toStringAsFixed(4));
          lowerProb = double.parse(lowerProb.toStringAsFixed(4));
          if (upperProb >= thisProbThreshold) {
            if (upperProb.toInt() == 1) {
              if (upper.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 4');
                continue;
              }
            } else {
              if (upper.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 5');
                continue;
              }
            }
            isLong = true;
            // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
          } else if (lowerProb >= thisProbThreshold) {
            if (lowerProb.toInt() == 1) {
              if (lower.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 4');
                continue;
              }
            } else {
              if (lower.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 5');
                continue;
              }
            }
            isShort = true;
            // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
          } else {
            missCount++;
            // printInfo(info: '❌ No majority list');
            continue;
          }

          // Return rate median
          double thisMdd = 0.0;
          if (isLong) {
            double medianOfLastCloses = findMedianOfLastValues(upper);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate <= minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate <= $minMedianReturnRate in long');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in long');
              continue;
            }
            double thisMin = findMinOfValues(lower);
            if (thisMin != 0.0) {
              double minPercentageDifference =
                  (thisMin - lastClosePrice) / lastClosePrice;
              double minPercentageDifferenceAbs = minPercentageDifference.abs();
              mdd = max(mdd, minPercentageDifferenceAbs);
              thisMdd = minPercentageDifferenceAbs;
            } else {
              thisMdd = thisMin;
            }
          } else if (isShort) {
            double medianOfLastCloses = findMedianOfLastValues(lower);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate >= -minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate >= -$minMedianReturnRate in short');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in short');
              continue;
            }
            double thisMax = findMaxOfValues(upper);
            if (thisMax != 0.0) {
              double maxPercentageDifference =
                  (thisMax - lastClosePrice) / lastClosePrice;
              double maxPercentageDifferenceAbs = maxPercentageDifference.abs();
              mdd = max(mdd, maxPercentageDifferenceAbs);
              thisMdd = maxPercentageDifferenceAbs;
            } else {
              thisMdd = thisMax;
            }
          }
          hitCount++;
          // printInfo(
          //     info:
          //         '✅ Minimum median return rate has been passed: $medianReturnRate');

          // Pick up a trend randomly from upper/lower by overall probability
          int randomIndex = random.nextInt(subClosePrices.length);
          // Get the randomly selected trend from the combinedList
          List<double> randomTrend = subClosePrices[randomIndex];
          // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
          // and the exit price is always on time
          double actualReturnRate = ((randomTrend.last - actualLastClosePrice) /
              actualLastClosePrice);
          double undelayedReturnRate =
              ((randomTrend.last - lastClosePrice) / lastClosePrice);
          double roundedActualReturnRate =
              double.parse(actualReturnRate.toStringAsFixed(4));
          double roundedUndelayedReturnRate =
              double.parse(undelayedReturnRate.toStringAsFixed(4));
          int contractVal =
              5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
          int diffFromEtfAndFuture =
              10; // The difference in value scale between ETF and Future
          matchedTrendCount = subClosePrices.length;

          double interruptActualReturn = 0.0;
          double interruptActualReturnRate = 0.0;
          double interruptUndelayedReturn = 0.0;
          double interruptUndelayedReturnRate = 0.0;
          bool interrupt = false;

          // Check whether the trend return rate has reaches the median return rate in matched trends
          int medianHitID = -1;
          if (closePosWhenReachedMedian.value) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

          // Check the number of trend go to the opposite side
          int goOppositeCount = 0;
          int goOppoHitID = -1;
          if (isLong) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] < lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          } else if (isShort) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] > lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

          // Check if hit the opposite side ceiling or bottom
          int hitOppositeCeilingOrBottomCount = 0;
          int hitOppoBottomOrCeilingHitID = -1;
          if (thisMdd != 0.0) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= -thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

          for (var element in subClosePricesRowID) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                candle[element].timestamp,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            String lastDatetime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
            String timezone =
                TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
            datetime.add('$lastDatetime $timezone');
          }

          if (!interrupt) {
            // Fund value changes due to the return of transaction
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                (((randomTrend.last - actualLastClosePrice) *
                        diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                (((randomTrend.last - lastClosePrice) * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          } else {
            int firstHitID = -1;
            final List<int> hitList = [
              medianHitID,
              goOppoHitID,
              hitOppoBottomOrCeilingHitID,
            ];
            for (final int hitID in hitList) {
              if (hitID != -1) {
                if (firstHitID == -1) {
                  firstHitID = hitID;
                } else if (hitID <= firstHitID) {
                  firstHitID = hitID;
                }
              }
            }

            if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
              double newVal = candle[subClosePricesRowID[randomIndex] +
                          firstHitID +
                          yFinMinuteDelay]
                      .close! *
                  actualLastDifferenceList[randomIndex];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            } else {
              double newVal = randomTrend[firstHitID + yFinMinuteDelay];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            }
            double newVal = randomTrend[firstHitID];
            interruptUndelayedReturn = newVal - lastClosePrice;
            interruptUndelayedReturnRate =
                (newVal - lastClosePrice) / lastClosePrice;

            // Get the failed trend last close price return and change the fund value
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                ((interruptActualReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          }

          prob =
              double.parse((isLong ? upperProb : lowerProb).toStringAsFixed(4));
          medianReturnRate = double.parse(medianReturnRate.toStringAsFixed(4));
          hitRate = hitCount / (hitCount + missCount);
          roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
          double roundedMdd = double.parse(mdd.toStringAsFixed(4));
          double roundedInitialFund =
              double.parse(initialFund.toStringAsFixed(4));
          double roundedUndelayedInitialFund =
              double.parse(undelayedInitialFund.toStringAsFixed(4));

          // Save results one by one into listList
          subClosePrices.asMap().entries.forEach((entry) {
            listList.add([
              id,
              datetime[entry.key],
              len,
              prob,
              medianReturnRate,
              roundedUndelayedReturnRate,
              roundedActualReturnRate,
              matchedTrendCount,
              interrupt,
              interruptUndelayedReturnRate,
              interruptActualReturnRate,
              roundedHitRate,
              roundedMdd,
              roundedUndelayedInitialFund,
              roundedInitialFund,
              commissionsAndFees,
              yFinMinuteDelay,
              ...entry.value
            ]);
          });

          // logger.d(listList);

          // printInfo(info: 'Matched count: $matchedTrendCount');
          // printInfo(info: 'Prob.: $prob');
          // printInfo(info: 'Undelayed return rate: $roundedUndelayedReturnRate');
          // printInfo(
          //     info:
          //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
          // printInfo(info: 'Final return rate: $roundedActualReturnRate');
          // printInfo(info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
        }

        // Check if the sublist can be looped through the last row or not
        if (splitCandleListsLastRows[randomIndex] != candle.length - 1) {
          final int sublistLastCandleRow =
              splitCandleListsLastRows[randomIndex];
          // Loop through remaining rows in sublist if possible
          int remainder = subLen - (subLen - len + 1 - yFinMinuteDelay);
          for (int l = subLen - len + 1 - yFinMinuteDelay; l < subLen; l++) {
            final int thisCandleRow = sublistLastCandleRow - remainder;
            remainder--;

            await Future.delayed(const Duration(milliseconds: 0));

            // Show the remaining number of backtest data
            backtestDataRan3.value += 1;

            int id = l;
            List<String> datetime = [];
            double prob;
            double medianReturnRate = 0.0;
            int matchedTrendCount;

            // logger.d(
            //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: ${id + 1}/$subLen');

            // Check if the dateTime is within the first 30 minutes of trading
            int timestamp = sublist[l].timestamp;
            if (timestamp != 0) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              // Define trading start time
              DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                  subtractedDateTime.month, subtractedDateTime.day, 9, 30);
              // Check if the dateTime is within the first 30 minutes of trading
              DateTime tradingEndTimeUTC =
                  tradingStartTime.add(const Duration(minutes: 30));
              bool isWithinFirst30Minutes =
                  subtractedDateTime.isAfter(tradingStartTime) &&
                      subtractedDateTime.isBefore(tradingEndTimeUTC);
              if (isWithinFirst30Minutes) {
                // outsideTimeCount++;
                continue;
              }
            } else {
              // logger.d('Error: timestamp == 0');
              splitCandleLists = [];
              break;
            }
            // printInfo(info: '✅ Outside first 30 mins');

            // Selecting a trend
            double startingClosePrice = sublist[l].close!;
            double lastClosePrice = candle[thisCandleRow + len - 1].close!;
            double actualLastClosePrice =
                candle[thisCandleRow + len - 1 + yFinMinuteDelay].close!;
            List<double> selectedPeriodPercentDifferencesList = [];
            // For MA matching
            List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
            List<double> selectedPeriodFirstMaAndPricePercentDifferencesList =
                [];
            // For candle matching
            List<List<double>>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList =
                [];
            // Loop selected data
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[thisCandleRow + i].close!;
              double openAndClosePercentDiff =
                  (candle[thisCandleRow + i].open! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[thisCandleRow + i].high! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[thisCandleRow + i].low! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
            }
            for (int i = 0; i < len - 1; i++) {
              double newVal = candle[thisCandleRow + i + 1].close!;
              double oriVal = candle[thisCandleRow + i].close!;
              double percentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodPercentDifferencesList.add(percentDiff);

              // MA
              List<double> selectedPeriodMaPercentDifferencesList = [];
              for (int n = 0; n < maLength; n++) {
                double newVal = candle[thisCandleRow + i + 1].trends[n]!;
                double oriVal = candle[thisCandleRow + i].trends[n]!;
                double maPercentDiff = (newVal - oriVal) / oriVal;
                selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
              }
              selectedPeriodMaPercentDifferencesListList
                  .add(selectedPeriodMaPercentDifferencesList);
            }
            // MA
            for (int m = 0; m < maLength; m++) {
              selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                  (sublist[l].trends[m]! - startingClosePrice) /
                      startingClosePrice);
            }
            // printInfo(info: '✅ Selected a trend');

            List<List<double>> upper = [];
            List<List<double>> lower = [];
            int baseline = 0;
            List<List<double>> subClosePrices = [];
            List<int> subClosePricesRowID = [];
            bool isLong = false;
            bool isShort = false;
            List<double> actualLastDifferenceList = [];

            // Look for similar trend(s)
            for (int m = 0;
                m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
                // Minus yFinMinuteDelay for actualReturn calculation
                m++) {
              // For candle matching
              List<List<double>>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseListList =
                  [];
              for (int i = 0; i < len; i++) {
                // Candle
                List<double>
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
                double close = candle[m + i].close!;
                double openAndClosePercentDiff =
                    (candle[m + i].open! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(openAndClosePercentDiff);
                double highAndClosePercentDiff =
                    (candle[m + i].high! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(highAndClosePercentDiff);
                double lowAndClosePercentDiff =
                    (candle[m + i].low! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(lowAndClosePercentDiff);
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList.add(
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
              }

              // For price matching
              List<double> comparePeriodPercentDifferencesList = [];
              for (int i = 0; i < len - 1; i++) {
                double percentDiff =
                    (candle[m + i + 1].close! - candle[m + i].close!) /
                        (candle[m + i].close!);
                comparePeriodPercentDifferencesList.add(percentDiff);
              }

              (bool, List<double>) comparisonResult = TrendMatch()
                  .areDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      candleTol,
                      selectedPeriodPercentDifferencesList,
                      comparePeriodPercentDifferencesList,
                      priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

              if (comparisonResult.$1) {
                // printInfo(info: '✅ A trend percentage changes matched');
                List<double>
                    comparePeriodFirstMaAndPricePercentDifferencesList = [];
                List<List<double>> comparePeriodMaPercentDifferencesListList =
                    [];
                double compareFirstPrice = candle[m].close!;

                for (int n = 0; n < len - 1; n++) {
                  List<double> comparePeriodMaPercentDifferencesList = [];
                  for (int i = 0; i < maLength; i++) {
                    double newVal = candle[m + n + 1].trends[i]!;
                    double oriVal = candle[m + n].trends[i]!;
                    double maPercentDiff = (newVal - oriVal) / oriVal;
                    comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                  }
                  comparePeriodMaPercentDifferencesListList
                      .add(comparePeriodMaPercentDifferencesList);
                }
                for (int i = 0; i < maLength; i++) {
                  comparePeriodFirstMaAndPricePercentDifferencesList.add(
                      (candle[m].trends[i]! - compareFirstPrice) /
                          compareFirstPrice);
                }

                bool isMaMatched = TrendMatch()
                    .maDifferencesLessThanOrEqualToCertainPercent(
                        selectedPeriodFirstMaAndPricePercentDifferencesList,
                        selectedPeriodMaPercentDifferencesListList,
                        comparePeriodFirstMaAndPricePercentDifferencesList,
                        comparePeriodMaPercentDifferencesListList,
                        maTol,
                        firstMaTol);
                if (isMaMatched) {
                  // printInfo(info: '✅ A trend MAs matched');
                  // Store the adjusted close prices into different lists
                  List<double> matchedAdjustedSubsequentCloseList = [];
                  double lastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  double actualLastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  actualLastDifferenceList.add(actualLastDifference);
                  for (int i = 0; i < subsequentLen; i++) {
                    double adjustedSubsequentClose =
                        candle[m + len + i].close! * lastDifference;
                    matchedAdjustedSubsequentCloseList
                        .add(adjustedSubsequentClose);
                  }
                  if (matchedAdjustedSubsequentCloseList.last >
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    upper.add(matchedAdjustedSubsequentCloseList);
                  } else if (matchedAdjustedSubsequentCloseList.last <
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    lower.add(matchedAdjustedSubsequentCloseList);
                  } else {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    baseline++;
                  }
                }
                // else {
                //   printInfo(info: '❌ A trend MAs not matched');
                // }
              }
              // else {
              //   printInfo(info: '❌ A trend percentage changes not matched');
              // }
            }

            // Division by zero is mathematically undefined, but in programming,
            // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
            // This way, skip when both lists are empty
            if (upper.isEmpty && lower.isEmpty) {
              missCount++;
              // printInfo(info: '❌ upper and lower are empty');
              continue;
            }
            // Probability calculation and amount of matched trends
            double upperProb =
                upper.length / (upper.length + lower.length + baseline);
            double lowerProb =
                lower.length / (upper.length + lower.length + baseline);
            // Round to 3 decimal places
            upperProb = double.parse(upperProb.toStringAsFixed(4));
            lowerProb = double.parse(lowerProb.toStringAsFixed(4));
            if (upperProb >= thisProbThreshold) {
              if (upperProb.toInt() == 1) {
                if (upper.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 4');
                  continue;
                }
              } else {
                if (upper.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 5');
                  continue;
                }
              }
              isLong = true;
              // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
            } else if (lowerProb >= thisProbThreshold) {
              if (lowerProb.toInt() == 1) {
                if (lower.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 4');
                  continue;
                }
              } else {
                if (lower.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 5');
                  continue;
                }
              }
              isShort = true;
              // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
            } else {
              missCount++;
              // printInfo(info: '❌ No majority list');
              continue;
            }

            // Return rate median
            double thisMdd = 0.0;
            if (isLong) {
              double medianOfLastCloses = findMedianOfLastValues(upper);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate <= minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate <= $minMedianReturnRate in long');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in long');
                continue;
              }
              double thisMin = findMinOfValues(lower);
              if (thisMin != 0.0) {
                double minPercentageDifference =
                    (thisMin - lastClosePrice) / lastClosePrice;
                double minPercentageDifferenceAbs =
                    minPercentageDifference.abs();
                mdd = max(mdd, minPercentageDifferenceAbs);
                thisMdd = minPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMin is 0.0 in long');
                continue;
              }
            } else if (isShort) {
              double medianOfLastCloses = findMedianOfLastValues(lower);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate >= -minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate >= -$minMedianReturnRate in short');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in short');
                continue;
              }
              double thisMax = findMaxOfValues(upper);
              if (thisMax != 0.0) {
                double maxPercentageDifference =
                    (thisMax - lastClosePrice) / lastClosePrice;
                double maxPercentageDifferenceAbs =
                    maxPercentageDifference.abs();
                mdd = max(mdd, maxPercentageDifferenceAbs);
                thisMdd = maxPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMax is 0.0 in short');
                continue;
              }
            }
            hitCount++;
            // printInfo(
            //     info:
            //         '✅ Minimum median return rate has been passed: $medianReturnRate');

            // Pick up a trend randomly from upper/lower by overall probability
            int randomIndex = random.nextInt(subClosePrices.length);
            // Get the randomly selected trend from the combinedList
            List<double> randomTrend = subClosePrices[randomIndex];
            // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
            // and the exit price is always on time
            double actualReturnRate =
                ((randomTrend.last - actualLastClosePrice) /
                    actualLastClosePrice);
            double undelayedReturnRate =
                ((randomTrend.last - lastClosePrice) / lastClosePrice);
            double roundedActualReturnRate =
                double.parse(actualReturnRate.toStringAsFixed(4));
            double roundedUndelayedReturnRate =
                double.parse(undelayedReturnRate.toStringAsFixed(4));
            int contractVal =
                5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
            int diffFromEtfAndFuture =
                10; // The difference in value scale between ETF and Future
            matchedTrendCount = subClosePrices.length;

            double interruptActualReturn = 0.0;
            double interruptActualReturnRate = 0.0;
            double interruptUndelayedReturn = 0.0;
            double interruptUndelayedReturnRate = 0.0;
            bool interrupt = false;

            // Check whether the trend return rate has reaches the median return rate in matched trends
            int medianHitID = -1;
            if (closePosWhenReachedMedian.value) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

            // Check the number of trend go to the opposite side
            int goOppositeCount = 0;
            int goOppoHitID = -1;
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] < lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] > lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

            // Check if hit the opposite side ceiling or bottom
            int hitOppositeCeilingOrBottomCount = 0;
            int hitOppoBottomOrCeilingHitID = -1;
            if (thisMdd != 0.0) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= -thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

            for (var element in subClosePricesRowID) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  candle[element].timestamp,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              String lastDatetime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
              String timezone = TimeService.to.isEasternDaylightTime(dateTime)
                  ? 'EDT'
                  : 'EST';
              datetime.add('$lastDatetime $timezone');
            }

            if (!interrupt) {
              // Fund value changes due to the return of transaction
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  (((randomTrend.last - actualLastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  (((randomTrend.last - lastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            } else {
              int firstHitID = -1;
              final List<int> hitList = [
                medianHitID,
                goOppoHitID,
                hitOppoBottomOrCeilingHitID,
              ];
              for (final int hitID in hitList) {
                if (hitID != -1) {
                  if (firstHitID == -1) {
                    firstHitID = hitID;
                  } else if (hitID <= firstHitID) {
                    firstHitID = hitID;
                  }
                }
              }

              if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
                double newVal = candle[subClosePricesRowID[randomIndex] +
                            firstHitID +
                            yFinMinuteDelay]
                        .close! *
                    actualLastDifferenceList[randomIndex];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              } else {
                double newVal = randomTrend[firstHitID + yFinMinuteDelay];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              }
              double newVal = randomTrend[firstHitID];
              interruptUndelayedReturn = newVal - lastClosePrice;
              interruptUndelayedReturnRate =
                  (newVal - lastClosePrice) / lastClosePrice;

              // Get the failed trend last close price return and change the fund value
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  ((interruptActualReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            }

            prob = double.parse(
                (isLong ? upperProb : lowerProb).toStringAsFixed(4));
            medianReturnRate =
                double.parse(medianReturnRate.toStringAsFixed(4));
            hitRate = hitCount / (hitCount + missCount);
            roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
            double roundedMdd = double.parse(mdd.toStringAsFixed(4));
            double roundedInitialFund =
                double.parse(initialFund.toStringAsFixed(4));
            double roundedUndelayedInitialFund =
                double.parse(undelayedInitialFund.toStringAsFixed(4));

            // Save results one by one into listList
            subClosePrices.asMap().entries.forEach((entry) {
              listList.add([
                id,
                datetime[entry.key],
                len,
                prob,
                medianReturnRate,
                roundedUndelayedReturnRate,
                roundedActualReturnRate,
                matchedTrendCount,
                interrupt,
                interruptUndelayedReturnRate,
                interruptActualReturnRate,
                roundedHitRate,
                roundedMdd,
                roundedUndelayedInitialFund,
                roundedInitialFund,
                commissionsAndFees,
                yFinMinuteDelay,
                ...entry.value
              ]);
            });

            // logger.d(listList);

            // printInfo(info: 'Matched count: $matchedTrendCount');
            // printInfo(info: 'Prob.: $prob');
            // printInfo(
            //     info: 'Undelayed return rate: $roundedUndelayedReturnRate');
            // printInfo(
            //     info:
            //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
            // printInfo(info: 'Final return rate: $roundedActualReturnRate');
            // printInfo(
            //     info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
          }
        }

        if (!alwaysThousandthsData.value) {
          splitCandleLists.removeAt(randomIndex);
        } else {
          splitCandleLists = [];
        }
      }

      // printInfo(info: 'Backtesting ended');
      // printInfo(info: 'Export backtesting results CSV...');
      int randomID = 100000 + random.nextInt(900000);
      // Export CSV to device's local file directory
      String fileName =
          '${randomID}_${symbol}_cTol${candleTolerance.value}_pTol${priceTolerance.value}_fMaTol${firstMaTolerance.value}_maTol${maTolerance.value}_len${len}_subLen${subsequentLen}_probThres${thisProbThreshold}_maTrue_strict${strictMatchCriteria.value}_outF30m_minMatchC${minMatchCount}_minSidedMatchC${minOneSidedMatchCount}_minR${minMedianReturnRate}_reachedMed${closePosWhenReachedMedian.value}_hitCeOrBoOneThirdSubLen_goOpHalfSubLen';
      exportCsv(listList, fileName);

      // printInfo(info: 'Exported backtesting results CSV');

      // Stop backtest loading effect
      isButtonDisabled.value = false;
      backtestingSymbol.value = '';

      // Reset the remaining number of backtest data
      backtestDataLen3.value = 0;
      backtestDataRan3.value = 0;
    });
    scheduleMicrotask(() async {
      // printInfo(info: 'Length: ${length.value}');
      // printInfo(info: 'Candle Tolerance: ${candleTolerance.value}');
      // printInfo(info: 'Price Tolerance: ${priceTolerance.value}');
      // printInfo(info: 'First MA Tolerance: ${firstMaTolerance.value}');
      // printInfo(info: 'MA Tolerance: ${maTolerance.value}');
      // printInfo(info: 'MA matching: True');
      // printInfo(info: 'Strict matching: ${strictMatchCriteria.value}');

      if (!alwaysShowMinuteData.value || !hasMinuteData.value) {
        showScaffoldMessenger(
            context: context, localizedMsg: 'backtest_no_minute_data'.tr);
        return;
      }

      List<List<dynamic>> listList = [];
      List<CandleData> candle = [];

      int initIndex = 20; // Assume that the backtest must be minute data
      int len = length.value;
      double commissionsAndFees = (0.25 * 2) + (0.021 * 2);
      int yFinMinuteDelay = 1;
      int hitCount = 0;
      int missCount = 0;
      // int outsideTimeCount = 0;
      int subsequentLen = subLength.value;
      double thisProbThreshold = probThreshold.value;
      double minMedianReturnRate = minReturnRateThreshold.value;
      int minMatchCount = 5;
      int minOneSidedMatchCount = 4;

      if (len <= 1) {
        throw ArgumentError('Selected period must greater than 1 time unit.');
      }

      // CSV headers
      listList.add([
        'ID',
        'Datetime',
        'Selected',
        'Probability',
        'Median Return Rate',
        'Expected Undelayed Return Rate (random trend)',
        'Expected Actual Return Rate (random trend)',
        'Matched Trend Count',
        'Interrupted Trend',
        'Interrupted Trend Undelayed Return Rate',
        'Interrupted Trend Actual Return Rate',
        'Hit Rate (after first 30 mins)',
        'MDD (all the time)',
        'Undelayed Fund Remaining (commns. and fees deducted)',
        'Fund Remaining (commns. and fees deducted)',
        'Commns. and Fees (2 contracts)',
        'yFin Minute Delay',
        ...List.generate(subsequentLen, (index) => 'Close Price ${index + 1}'),
      ]);

      // Make sure data is from the expected financial instrument
      if (symbol == financialInstrumentSymbol.value) {
        candle = listCandledata;
      } else {
        showScaffoldMessenger(
            context: context, localizedMsg: 'search_symbol_before_backtest'.tr);
        return;
      }

      // printInfo(info: 'Backtesting started');

      // Start backtest loading effect
      isButtonDisabled.value = true;
      backtestingSymbol.value = symbol;

      bool hasMa = candle.last.trends.isNotEmpty;
      int maLength = candle.last.trends.length;

      // Assume it must be an MA trend matching
      if (!hasMa) {
        await Candle().computeTrendLines();
        hasMa = candle.last.trends.isNotEmpty;
        maLength = candle.last.trends.length;
      }

      candle =
          candle.sublist(initIndex); // Remove trends that don't have all MAs
      // printInfo(info: 'Candle data length: ${candle.length}');

      // Split the candle list of list
      List<List<CandleData>> splitCandleLists = [];
      List<int> splitCandleListsLastRows = [];
      int splits = 1000;
      final int sublistSize = (candle.length / splits).ceil();

      for (int i = 0; i < candle.length; i += sublistSize) {
        final end =
            (i + sublistSize < candle.length) ? i + sublistSize : candle.length;
        final sublist = candle.sublist(i, end);
        splitCandleLists.add(sublist);
        splitCandleListsLastRows.add(end - 1);
      }
      // printInfo(info: 'Split candle list length: ${splitCandleLists.length}');

      // Show the remaining number of backtest data
      if (!alwaysThousandthsData.value) {
        backtestDataLen4.value = candle.length;
      }

      // Randomly pick a list to run backtest
      final random = Random();
      final double candleTol = candleTolerance.value / 100;
      final double priceTol = priceTolerance.value / 100;
      final double firstMaTol = firstMaTolerance.value / 100;
      final double maTol = maTolerance.value / 100;

      double hitRate = 0.0;
      double roundedHitRate = 0.0;
      double mdd = 0.0;
      double initialFund = 10000;
      double undelayedInitialFund = 10000;
      int oneThirdSubLength = subsequentLen ~/ 3;
      int halfSubLength = subsequentLen ~/ 2;

      while (splitCandleLists.isNotEmpty) {
        final randomIndex = random.nextInt(splitCandleLists.length);
        final sublist = splitCandleLists[randomIndex];
        final subLen = sublist.length;
        if (alwaysThousandthsData.value) {
          backtestDataLen4.value = subLen;
        }

        // printInfo(info: 'Current split candle list no.: $randomIndex');
        // printInfo(info: 'Current split candle list length: $subLen');

        for (int l = 0; l < subLen - len + 1 - yFinMinuteDelay; l++) {
          await Future.delayed(const Duration(milliseconds: 0));

          // Show the remaining number of backtest data
          backtestDataRan4.value += 1;

          int id = l;
          List<String> datetime = [];
          double prob;
          double medianReturnRate = 0.0;
          int matchedTrendCount;

          // logger.d(
          //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: $id/$subLen');

          // Check if the dateTime is within the first 30 minutes of trading
          int timestamp = sublist[l].timestamp;
          if (timestamp != 0) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                timestamp * 1000,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            // Define trading start time
            DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                subtractedDateTime.month, subtractedDateTime.day, 9, 30);
            // Check if the dateTime is within the first 30 minutes of trading
            DateTime tradingEndTimeUTC =
                tradingStartTime.add(const Duration(minutes: 30));
            bool isWithinFirst30Minutes =
                subtractedDateTime.isAfter(tradingStartTime) &&
                    subtractedDateTime.isBefore(tradingEndTimeUTC);
            if (isWithinFirst30Minutes) {
              // outsideTimeCount++;
              continue;
            }
          } else {
            // logger.d('Error: timestamp == 0');
            splitCandleLists = [];
            break;
          }
          // printInfo(info: '✅ Outside first 30 mins');

          // Selecting a trend
          double startingClosePrice = sublist[l].close!;
          double lastClosePrice = sublist[l + len - 1].close!;
          double actualLastClosePrice =
              sublist[l + len - 1 + yFinMinuteDelay].close!;
          List<double> selectedPeriodPercentDifferencesList = [];
          // For MA matching
          List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
          List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
          // For candle matching
          List<List<double>>
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
          // Loop selected data
          for (int i = 0; i < len; i++) {
            // Candle
            List<double>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
            double close = sublist[l + i].close!;
            double openAndClosePercentDiff =
                (sublist[l + i].open! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(openAndClosePercentDiff);
            double highAndClosePercentDiff =
                (sublist[l + i].high! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(highAndClosePercentDiff);
            double lowAndClosePercentDiff =
                (sublist[l + i].low! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(lowAndClosePercentDiff);
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
          }
          for (int i = 0; i < len - 1; i++) {
            // Price
            double newVal = sublist[l + i + 1].close!;
            double oriVal = sublist[l + i].close!;
            double percentDiff = (newVal - oriVal) / oriVal;
            selectedPeriodPercentDifferencesList.add(percentDiff);

            // MA
            List<double> selectedPeriodMaPercentDifferencesList = [];
            for (int n = 0; n < maLength; n++) {
              double newVal = sublist[l + i + 1].trends[n]!;
              double oriVal = sublist[l + i].trends[n]!;
              double maPercentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
            }
            selectedPeriodMaPercentDifferencesListList
                .add(selectedPeriodMaPercentDifferencesList);
          }
          // MA
          for (int m = 0; m < maLength; m++) {
            selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                (sublist[l].trends[m]! - startingClosePrice) /
                    startingClosePrice);
          }
          // printInfo(info: '✅ Selected a trend');

          List<List<double>> upper = [];
          List<List<double>> lower = [];
          int baseline = 0;
          List<List<double>> subClosePrices = [];
          List<int> subClosePricesRowID = [];
          bool isLong = false;
          bool isShort = false;
          List<double> actualLastDifferenceList = [];

          // Look for similar trend(s)
          for (int m = 0;
              m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
              // Minus yFinMinuteDelay for actualReturn calculation
              m++) {
            // For candle matching
            List<List<double>>
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[m + i].close!;
              double openAndClosePercentDiff =
                  (candle[m + i].open! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[m + i].high! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[m + i].low! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              comparePeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
            }

            // For price matching
            List<double> comparePeriodPercentDifferencesList = [];
            for (int i = 0; i < len - 1; i++) {
              double percentDiff =
                  (candle[m + i + 1].close! - candle[m + i].close!) /
                      (candle[m + i].close!);
              comparePeriodPercentDifferencesList.add(percentDiff);
            }

            (bool, List<double>) comparisonResult = TrendMatch()
                .areDifferencesLessThanOrEqualToCertainPercent(
                    selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    candleTol,
                    selectedPeriodPercentDifferencesList,
                    comparePeriodPercentDifferencesList,
                    priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

            if (comparisonResult.$1) {
              // printInfo(info: '✅ A trend percentage changes matched');
              List<double> comparePeriodFirstMaAndPricePercentDifferencesList =
                  [];
              List<List<double>> comparePeriodMaPercentDifferencesListList = [];
              double compareFirstPrice = candle[m].close!;

              for (int n = 0; n < len - 1; n++) {
                List<double> comparePeriodMaPercentDifferencesList = [];
                for (int i = 0; i < maLength; i++) {
                  double newVal = candle[m + n + 1].trends[i]!;
                  double oriVal = candle[m + n].trends[i]!;
                  double maPercentDiff = (newVal - oriVal) / oriVal;
                  comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                }
                comparePeriodMaPercentDifferencesListList
                    .add(comparePeriodMaPercentDifferencesList);
              }
              for (int i = 0; i < maLength; i++) {
                comparePeriodFirstMaAndPricePercentDifferencesList.add(
                    (candle[m].trends[i]! - compareFirstPrice) /
                        compareFirstPrice);
              }

              bool isMaMatched = TrendMatch()
                  .maDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodFirstMaAndPricePercentDifferencesList,
                      selectedPeriodMaPercentDifferencesListList,
                      comparePeriodFirstMaAndPricePercentDifferencesList,
                      comparePeriodMaPercentDifferencesListList,
                      maTol,
                      firstMaTol);
              if (isMaMatched) {
                // printInfo(info: '✅ A trend MAs matched');
                // Store the adjusted close prices into different lists
                List<double> matchedAdjustedSubsequentCloseList = [];
                double lastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                double actualLastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                actualLastDifferenceList.add(actualLastDifference);
                for (int i = 0; i < subsequentLen; i++) {
                  double adjustedSubsequentClose =
                      candle[m + len + i].close! * lastDifference;
                  matchedAdjustedSubsequentCloseList
                      .add(adjustedSubsequentClose);
                }
                if (matchedAdjustedSubsequentCloseList.last > lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  upper.add(matchedAdjustedSubsequentCloseList);
                } else if (matchedAdjustedSubsequentCloseList.last <
                    lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  lower.add(matchedAdjustedSubsequentCloseList);
                } else {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  baseline++;
                }
              }
              // else {
              //   printInfo(info: '❌ A trend MAs not matched');
              // }
            }
            // else {
            //   printInfo(info: '❌ A trend percentage changes not matched');
            // }
          }

          // Division by zero is mathematically undefined, but in programming,
          // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
          // This way, skip when both lists are empty
          if (upper.isEmpty && lower.isEmpty) {
            missCount++;
            // printInfo(info: '❌ upper and lower are empty');
            continue;
          }
          // Probability calculation and amount of matched trends
          double upperProb =
              upper.length / (upper.length + lower.length + baseline);
          double lowerProb =
              lower.length / (upper.length + lower.length + baseline);
          // Round to 3 decimal places
          upperProb = double.parse(upperProb.toStringAsFixed(4));
          lowerProb = double.parse(lowerProb.toStringAsFixed(4));
          if (upperProb >= thisProbThreshold) {
            if (upperProb.toInt() == 1) {
              if (upper.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 4');
                continue;
              }
            } else {
              if (upper.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 5');
                continue;
              }
            }
            isLong = true;
            // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
          } else if (lowerProb >= thisProbThreshold) {
            if (lowerProb.toInt() == 1) {
              if (lower.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 4');
                continue;
              }
            } else {
              if (lower.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 5');
                continue;
              }
            }
            isShort = true;
            // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
          } else {
            missCount++;
            // printInfo(info: '❌ No majority list');
            continue;
          }

          // Return rate median
          double thisMdd = 0.0;
          if (isLong) {
            double medianOfLastCloses = findMedianOfLastValues(upper);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate <= minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate <= $minMedianReturnRate in long');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in long');
              continue;
            }
            double thisMin = findMinOfValues(lower);
            if (thisMin != 0.0) {
              double minPercentageDifference =
                  (thisMin - lastClosePrice) / lastClosePrice;
              double minPercentageDifferenceAbs = minPercentageDifference.abs();
              mdd = max(mdd, minPercentageDifferenceAbs);
              thisMdd = minPercentageDifferenceAbs;
            } else {
              thisMdd = thisMin;
            }
          } else if (isShort) {
            double medianOfLastCloses = findMedianOfLastValues(lower);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate >= -minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate >= -$minMedianReturnRate in short');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in short');
              continue;
            }
            double thisMax = findMaxOfValues(upper);
            if (thisMax != 0.0) {
              double maxPercentageDifference =
                  (thisMax - lastClosePrice) / lastClosePrice;
              double maxPercentageDifferenceAbs = maxPercentageDifference.abs();
              mdd = max(mdd, maxPercentageDifferenceAbs);
              thisMdd = maxPercentageDifferenceAbs;
            } else {
              thisMdd = thisMax;
            }
          }
          hitCount++;
          // printInfo(
          //     info:
          //         '✅ Minimum median return rate has been passed: $medianReturnRate');

          // Pick up a trend randomly from upper/lower by overall probability
          int randomIndex = random.nextInt(subClosePrices.length);
          // Get the randomly selected trend from the combinedList
          List<double> randomTrend = subClosePrices[randomIndex];
          // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
          // and the exit price is always on time
          double actualReturnRate = ((randomTrend.last - actualLastClosePrice) /
              actualLastClosePrice);
          double undelayedReturnRate =
              ((randomTrend.last - lastClosePrice) / lastClosePrice);
          double roundedActualReturnRate =
              double.parse(actualReturnRate.toStringAsFixed(4));
          double roundedUndelayedReturnRate =
              double.parse(undelayedReturnRate.toStringAsFixed(4));
          int contractVal =
              5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
          int diffFromEtfAndFuture =
              10; // The difference in value scale between ETF and Future
          matchedTrendCount = subClosePrices.length;

          double interruptActualReturn = 0.0;
          double interruptActualReturnRate = 0.0;
          double interruptUndelayedReturn = 0.0;
          double interruptUndelayedReturnRate = 0.0;
          bool interrupt = false;

          // Check whether the trend return rate has reaches the median return rate in matched trends
          int medianHitID = -1;
          if (closePosWhenReachedMedian.value) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

          // Check the number of trend go to the opposite side
          int goOppositeCount = 0;
          int goOppoHitID = -1;
          if (isLong) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] < lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          } else if (isShort) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] > lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

          // Check if hit the opposite side ceiling or bottom
          int hitOppositeCeilingOrBottomCount = 0;
          int hitOppoBottomOrCeilingHitID = -1;
          if (thisMdd != 0.0) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= -thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

          for (var element in subClosePricesRowID) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                candle[element].timestamp,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            String lastDatetime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
            String timezone =
                TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
            datetime.add('$lastDatetime $timezone');
          }

          if (!interrupt) {
            // Fund value changes due to the return of transaction
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                (((randomTrend.last - actualLastClosePrice) *
                        diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                (((randomTrend.last - lastClosePrice) * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          } else {
            int firstHitID = -1;
            final List<int> hitList = [
              medianHitID,
              goOppoHitID,
              hitOppoBottomOrCeilingHitID,
            ];
            for (final int hitID in hitList) {
              if (hitID != -1) {
                if (firstHitID == -1) {
                  firstHitID = hitID;
                } else if (hitID <= firstHitID) {
                  firstHitID = hitID;
                }
              }
            }

            if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
              double newVal = candle[subClosePricesRowID[randomIndex] +
                          firstHitID +
                          yFinMinuteDelay]
                      .close! *
                  actualLastDifferenceList[randomIndex];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            } else {
              double newVal = randomTrend[firstHitID + yFinMinuteDelay];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            }
            double newVal = randomTrend[firstHitID];
            interruptUndelayedReturn = newVal - lastClosePrice;
            interruptUndelayedReturnRate =
                (newVal - lastClosePrice) / lastClosePrice;

            // Get the failed trend last close price return and change the fund value
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                ((interruptActualReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          }

          prob =
              double.parse((isLong ? upperProb : lowerProb).toStringAsFixed(4));
          medianReturnRate = double.parse(medianReturnRate.toStringAsFixed(4));
          hitRate = hitCount / (hitCount + missCount);
          roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
          double roundedMdd = double.parse(mdd.toStringAsFixed(4));
          double roundedInitialFund =
              double.parse(initialFund.toStringAsFixed(4));
          double roundedUndelayedInitialFund =
              double.parse(undelayedInitialFund.toStringAsFixed(4));

          // Save results one by one into listList
          subClosePrices.asMap().entries.forEach((entry) {
            listList.add([
              id,
              datetime[entry.key],
              len,
              prob,
              medianReturnRate,
              roundedUndelayedReturnRate,
              roundedActualReturnRate,
              matchedTrendCount,
              interrupt,
              interruptUndelayedReturnRate,
              interruptActualReturnRate,
              roundedHitRate,
              roundedMdd,
              roundedUndelayedInitialFund,
              roundedInitialFund,
              commissionsAndFees,
              yFinMinuteDelay,
              ...entry.value
            ]);
          });

          // logger.d(listList);

          // printInfo(info: 'Matched count: $matchedTrendCount');
          // printInfo(info: 'Prob.: $prob');
          // printInfo(info: 'Undelayed return rate: $roundedUndelayedReturnRate');
          // printInfo(
          //     info:
          //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
          // printInfo(info: 'Final return rate: $roundedActualReturnRate');
          // printInfo(info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
        }

        // Check if the sublist can be looped through the last row or not
        if (splitCandleListsLastRows[randomIndex] != candle.length - 1) {
          final int sublistLastCandleRow =
              splitCandleListsLastRows[randomIndex];
          // Loop through remaining rows in sublist if possible
          int remainder = subLen - (subLen - len + 1 - yFinMinuteDelay);
          for (int l = subLen - len + 1 - yFinMinuteDelay; l < subLen; l++) {
            final int thisCandleRow = sublistLastCandleRow - remainder;
            remainder--;

            await Future.delayed(const Duration(milliseconds: 0));

            // Show the remaining number of backtest data
            backtestDataRan4.value += 1;

            int id = l;
            List<String> datetime = [];
            double prob;
            double medianReturnRate = 0.0;
            int matchedTrendCount;

            // logger.d(
            //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: ${id + 1}/$subLen');

            // Check if the dateTime is within the first 30 minutes of trading
            int timestamp = sublist[l].timestamp;
            if (timestamp != 0) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              // Define trading start time
              DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                  subtractedDateTime.month, subtractedDateTime.day, 9, 30);
              // Check if the dateTime is within the first 30 minutes of trading
              DateTime tradingEndTimeUTC =
                  tradingStartTime.add(const Duration(minutes: 30));
              bool isWithinFirst30Minutes =
                  subtractedDateTime.isAfter(tradingStartTime) &&
                      subtractedDateTime.isBefore(tradingEndTimeUTC);
              if (isWithinFirst30Minutes) {
                // outsideTimeCount++;
                continue;
              }
            } else {
              // logger.d('Error: timestamp == 0');
              splitCandleLists = [];
              break;
            }
            // printInfo(info: '✅ Outside first 30 mins');

            // Selecting a trend
            double startingClosePrice = sublist[l].close!;
            double lastClosePrice = candle[thisCandleRow + len - 1].close!;
            double actualLastClosePrice =
                candle[thisCandleRow + len - 1 + yFinMinuteDelay].close!;
            List<double> selectedPeriodPercentDifferencesList = [];
            // For MA matching
            List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
            List<double> selectedPeriodFirstMaAndPricePercentDifferencesList =
                [];
            // For candle matching
            List<List<double>>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList =
                [];
            // Loop selected data
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[thisCandleRow + i].close!;
              double openAndClosePercentDiff =
                  (candle[thisCandleRow + i].open! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[thisCandleRow + i].high! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[thisCandleRow + i].low! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
            }
            for (int i = 0; i < len - 1; i++) {
              double newVal = candle[thisCandleRow + i + 1].close!;
              double oriVal = candle[thisCandleRow + i].close!;
              double percentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodPercentDifferencesList.add(percentDiff);

              // MA
              List<double> selectedPeriodMaPercentDifferencesList = [];
              for (int n = 0; n < maLength; n++) {
                double newVal = candle[thisCandleRow + i + 1].trends[n]!;
                double oriVal = candle[thisCandleRow + i].trends[n]!;
                double maPercentDiff = (newVal - oriVal) / oriVal;
                selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
              }
              selectedPeriodMaPercentDifferencesListList
                  .add(selectedPeriodMaPercentDifferencesList);
            }
            // MA
            for (int m = 0; m < maLength; m++) {
              selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                  (sublist[l].trends[m]! - startingClosePrice) /
                      startingClosePrice);
            }
            // printInfo(info: '✅ Selected a trend');

            List<List<double>> upper = [];
            List<List<double>> lower = [];
            int baseline = 0;
            List<List<double>> subClosePrices = [];
            List<int> subClosePricesRowID = [];
            bool isLong = false;
            bool isShort = false;
            List<double> actualLastDifferenceList = [];

            // Look for similar trend(s)
            for (int m = 0;
                m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
                // Minus yFinMinuteDelay for actualReturn calculation
                m++) {
              // For candle matching
              List<List<double>>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseListList =
                  [];
              for (int i = 0; i < len; i++) {
                // Candle
                List<double>
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
                double close = candle[m + i].close!;
                double openAndClosePercentDiff =
                    (candle[m + i].open! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(openAndClosePercentDiff);
                double highAndClosePercentDiff =
                    (candle[m + i].high! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(highAndClosePercentDiff);
                double lowAndClosePercentDiff =
                    (candle[m + i].low! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(lowAndClosePercentDiff);
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList.add(
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
              }

              // For price matching
              List<double> comparePeriodPercentDifferencesList = [];
              for (int i = 0; i < len - 1; i++) {
                double percentDiff =
                    (candle[m + i + 1].close! - candle[m + i].close!) /
                        (candle[m + i].close!);
                comparePeriodPercentDifferencesList.add(percentDiff);
              }

              (bool, List<double>) comparisonResult = TrendMatch()
                  .areDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      candleTol,
                      selectedPeriodPercentDifferencesList,
                      comparePeriodPercentDifferencesList,
                      priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

              if (comparisonResult.$1) {
                // printInfo(info: '✅ A trend percentage changes matched');
                List<double>
                    comparePeriodFirstMaAndPricePercentDifferencesList = [];
                List<List<double>> comparePeriodMaPercentDifferencesListList =
                    [];
                double compareFirstPrice = candle[m].close!;

                for (int n = 0; n < len - 1; n++) {
                  List<double> comparePeriodMaPercentDifferencesList = [];
                  for (int i = 0; i < maLength; i++) {
                    double newVal = candle[m + n + 1].trends[i]!;
                    double oriVal = candle[m + n].trends[i]!;
                    double maPercentDiff = (newVal - oriVal) / oriVal;
                    comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                  }
                  comparePeriodMaPercentDifferencesListList
                      .add(comparePeriodMaPercentDifferencesList);
                }
                for (int i = 0; i < maLength; i++) {
                  comparePeriodFirstMaAndPricePercentDifferencesList.add(
                      (candle[m].trends[i]! - compareFirstPrice) /
                          compareFirstPrice);
                }

                bool isMaMatched = TrendMatch()
                    .maDifferencesLessThanOrEqualToCertainPercent(
                        selectedPeriodFirstMaAndPricePercentDifferencesList,
                        selectedPeriodMaPercentDifferencesListList,
                        comparePeriodFirstMaAndPricePercentDifferencesList,
                        comparePeriodMaPercentDifferencesListList,
                        maTol,
                        firstMaTol);
                if (isMaMatched) {
                  // printInfo(info: '✅ A trend MAs matched');
                  // Store the adjusted close prices into different lists
                  List<double> matchedAdjustedSubsequentCloseList = [];
                  double lastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  double actualLastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  actualLastDifferenceList.add(actualLastDifference);
                  for (int i = 0; i < subsequentLen; i++) {
                    double adjustedSubsequentClose =
                        candle[m + len + i].close! * lastDifference;
                    matchedAdjustedSubsequentCloseList
                        .add(adjustedSubsequentClose);
                  }
                  if (matchedAdjustedSubsequentCloseList.last >
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    upper.add(matchedAdjustedSubsequentCloseList);
                  } else if (matchedAdjustedSubsequentCloseList.last <
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    lower.add(matchedAdjustedSubsequentCloseList);
                  } else {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    baseline++;
                  }
                }
                // else {
                //   printInfo(info: '❌ A trend MAs not matched');
                // }
              }
              // else {
              //   printInfo(info: '❌ A trend percentage changes not matched');
              // }
            }

            // Division by zero is mathematically undefined, but in programming,
            // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
            // This way, skip when both lists are empty
            if (upper.isEmpty && lower.isEmpty) {
              missCount++;
              // printInfo(info: '❌ upper and lower are empty');
              continue;
            }
            // Probability calculation and amount of matched trends
            double upperProb =
                upper.length / (upper.length + lower.length + baseline);
            double lowerProb =
                lower.length / (upper.length + lower.length + baseline);
            // Round to 3 decimal places
            upperProb = double.parse(upperProb.toStringAsFixed(4));
            lowerProb = double.parse(lowerProb.toStringAsFixed(4));
            if (upperProb >= thisProbThreshold) {
              if (upperProb.toInt() == 1) {
                if (upper.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 4');
                  continue;
                }
              } else {
                if (upper.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 5');
                  continue;
                }
              }
              isLong = true;
              // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
            } else if (lowerProb >= thisProbThreshold) {
              if (lowerProb.toInt() == 1) {
                if (lower.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 4');
                  continue;
                }
              } else {
                if (lower.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 5');
                  continue;
                }
              }
              isShort = true;
              // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
            } else {
              missCount++;
              // printInfo(info: '❌ No majority list');
              continue;
            }

            // Return rate median
            double thisMdd = 0.0;
            if (isLong) {
              double medianOfLastCloses = findMedianOfLastValues(upper);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate <= minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate <= $minMedianReturnRate in long');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in long');
                continue;
              }
              double thisMin = findMinOfValues(lower);
              if (thisMin != 0.0) {
                double minPercentageDifference =
                    (thisMin - lastClosePrice) / lastClosePrice;
                double minPercentageDifferenceAbs =
                    minPercentageDifference.abs();
                mdd = max(mdd, minPercentageDifferenceAbs);
                thisMdd = minPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMin is 0.0 in long');
                continue;
              }
            } else if (isShort) {
              double medianOfLastCloses = findMedianOfLastValues(lower);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate >= -minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate >= -$minMedianReturnRate in short');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in short');
                continue;
              }
              double thisMax = findMaxOfValues(upper);
              if (thisMax != 0.0) {
                double maxPercentageDifference =
                    (thisMax - lastClosePrice) / lastClosePrice;
                double maxPercentageDifferenceAbs =
                    maxPercentageDifference.abs();
                mdd = max(mdd, maxPercentageDifferenceAbs);
                thisMdd = maxPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMax is 0.0 in short');
                continue;
              }
            }
            hitCount++;
            // printInfo(
            //     info:
            //         '✅ Minimum median return rate has been passed: $medianReturnRate');

            // Pick up a trend randomly from upper/lower by overall probability
            int randomIndex = random.nextInt(subClosePrices.length);
            // Get the randomly selected trend from the combinedList
            List<double> randomTrend = subClosePrices[randomIndex];
            // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
            // and the exit price is always on time
            double actualReturnRate =
                ((randomTrend.last - actualLastClosePrice) /
                    actualLastClosePrice);
            double undelayedReturnRate =
                ((randomTrend.last - lastClosePrice) / lastClosePrice);
            double roundedActualReturnRate =
                double.parse(actualReturnRate.toStringAsFixed(4));
            double roundedUndelayedReturnRate =
                double.parse(undelayedReturnRate.toStringAsFixed(4));
            int contractVal =
                5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
            int diffFromEtfAndFuture =
                10; // The difference in value scale between ETF and Future
            matchedTrendCount = subClosePrices.length;

            double interruptActualReturn = 0.0;
            double interruptActualReturnRate = 0.0;
            double interruptUndelayedReturn = 0.0;
            double interruptUndelayedReturnRate = 0.0;
            bool interrupt = false;

            // Check whether the trend return rate has reaches the median return rate in matched trends
            int medianHitID = -1;
            if (closePosWhenReachedMedian.value) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

            // Check the number of trend go to the opposite side
            int goOppositeCount = 0;
            int goOppoHitID = -1;
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] < lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] > lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

            // Check if hit the opposite side ceiling or bottom
            int hitOppositeCeilingOrBottomCount = 0;
            int hitOppoBottomOrCeilingHitID = -1;
            if (thisMdd != 0.0) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= -thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

            for (var element in subClosePricesRowID) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  candle[element].timestamp,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              String lastDatetime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
              String timezone = TimeService.to.isEasternDaylightTime(dateTime)
                  ? 'EDT'
                  : 'EST';
              datetime.add('$lastDatetime $timezone');
            }

            if (!interrupt) {
              // Fund value changes due to the return of transaction
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  (((randomTrend.last - actualLastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  (((randomTrend.last - lastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            } else {
              int firstHitID = -1;
              final List<int> hitList = [
                medianHitID,
                goOppoHitID,
                hitOppoBottomOrCeilingHitID,
              ];
              for (final int hitID in hitList) {
                if (hitID != -1) {
                  if (firstHitID == -1) {
                    firstHitID = hitID;
                  } else if (hitID <= firstHitID) {
                    firstHitID = hitID;
                  }
                }
              }

              if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
                double newVal = candle[subClosePricesRowID[randomIndex] +
                            firstHitID +
                            yFinMinuteDelay]
                        .close! *
                    actualLastDifferenceList[randomIndex];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              } else {
                double newVal = randomTrend[firstHitID + yFinMinuteDelay];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              }
              double newVal = randomTrend[firstHitID];
              interruptUndelayedReturn = newVal - lastClosePrice;
              interruptUndelayedReturnRate =
                  (newVal - lastClosePrice) / lastClosePrice;

              // Get the failed trend last close price return and change the fund value
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  ((interruptActualReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            }

            prob = double.parse(
                (isLong ? upperProb : lowerProb).toStringAsFixed(4));
            medianReturnRate =
                double.parse(medianReturnRate.toStringAsFixed(4));
            hitRate = hitCount / (hitCount + missCount);
            roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
            double roundedMdd = double.parse(mdd.toStringAsFixed(4));
            double roundedInitialFund =
                double.parse(initialFund.toStringAsFixed(4));
            double roundedUndelayedInitialFund =
                double.parse(undelayedInitialFund.toStringAsFixed(4));

            // Save results one by one into listList
            subClosePrices.asMap().entries.forEach((entry) {
              listList.add([
                id,
                datetime[entry.key],
                len,
                prob,
                medianReturnRate,
                roundedUndelayedReturnRate,
                roundedActualReturnRate,
                matchedTrendCount,
                interrupt,
                interruptUndelayedReturnRate,
                interruptActualReturnRate,
                roundedHitRate,
                roundedMdd,
                roundedUndelayedInitialFund,
                roundedInitialFund,
                commissionsAndFees,
                yFinMinuteDelay,
                ...entry.value
              ]);
            });

            // logger.d(listList);

            // printInfo(info: 'Matched count: $matchedTrendCount');
            // printInfo(info: 'Prob.: $prob');
            // printInfo(
            //     info: 'Undelayed return rate: $roundedUndelayedReturnRate');
            // printInfo(
            //     info:
            //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
            // printInfo(info: 'Final return rate: $roundedActualReturnRate');
            // printInfo(
            //     info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
          }
        }

        if (!alwaysThousandthsData.value) {
          splitCandleLists.removeAt(randomIndex);
        } else {
          splitCandleLists = [];
        }
      }

      // printInfo(info: 'Backtesting ended');
      // printInfo(info: 'Export backtesting results CSV...');
      int randomID = 100000 + random.nextInt(900000);
      // Export CSV to device's local file directory
      String fileName =
          '${randomID}_${symbol}_cTol${candleTolerance.value}_pTol${priceTolerance.value}_fMaTol${firstMaTolerance.value}_maTol${maTolerance.value}_len${len}_subLen${subsequentLen}_probThres${thisProbThreshold}_maTrue_strict${strictMatchCriteria.value}_outF30m_minMatchC${minMatchCount}_minSidedMatchC${minOneSidedMatchCount}_minR${minMedianReturnRate}_reachedMed${closePosWhenReachedMedian.value}_hitCeOrBoOneThirdSubLen_goOpHalfSubLen';
      exportCsv(listList, fileName);

      // printInfo(info: 'Exported backtesting results CSV');

      // Stop backtest loading effect
      isButtonDisabled.value = false;
      backtestingSymbol.value = '';

      // Reset the remaining number of backtest data
      backtestDataLen4.value = 0;
      backtestDataRan4.value = 0;
    });
    scheduleMicrotask(() async {
      // printInfo(info: 'Length: ${length.value}');
      // printInfo(info: 'Candle Tolerance: ${candleTolerance.value}');
      // printInfo(info: 'Price Tolerance: ${priceTolerance.value}');
      // printInfo(info: 'First MA Tolerance: ${firstMaTolerance.value}');
      // printInfo(info: 'MA Tolerance: ${maTolerance.value}');
      // printInfo(info: 'MA matching: True');
      // printInfo(info: 'Strict matching: ${strictMatchCriteria.value}');

      if (!alwaysShowMinuteData.value || !hasMinuteData.value) {
        showScaffoldMessenger(
            context: context, localizedMsg: 'backtest_no_minute_data'.tr);
        return;
      }

      List<List<dynamic>> listList = [];
      List<CandleData> candle = [];

      int initIndex = 20; // Assume that the backtest must be minute data
      int len = length.value;
      double commissionsAndFees = (0.25 * 2) + (0.021 * 2);
      int yFinMinuteDelay = 1;
      int hitCount = 0;
      int missCount = 0;
      // int outsideTimeCount = 0;
      int subsequentLen = subLength.value;
      double thisProbThreshold = probThreshold.value;
      double minMedianReturnRate = minReturnRateThreshold.value;
      int minMatchCount = 5;
      int minOneSidedMatchCount = 4;

      if (len <= 1) {
        throw ArgumentError('Selected period must greater than 1 time unit.');
      }

      // CSV headers
      listList.add([
        'ID',
        'Datetime',
        'Selected',
        'Probability',
        'Median Return Rate',
        'Expected Undelayed Return Rate (random trend)',
        'Expected Actual Return Rate (random trend)',
        'Matched Trend Count',
        'Interrupted Trend',
        'Interrupted Trend Undelayed Return Rate',
        'Interrupted Trend Actual Return Rate',
        'Hit Rate (after first 30 mins)',
        'MDD (all the time)',
        'Undelayed Fund Remaining (commns. and fees deducted)',
        'Fund Remaining (commns. and fees deducted)',
        'Commns. and Fees (2 contracts)',
        'yFin Minute Delay',
        ...List.generate(subsequentLen, (index) => 'Close Price ${index + 1}'),
      ]);

      // Make sure data is from the expected financial instrument
      if (symbol == financialInstrumentSymbol.value) {
        candle = listCandledata;
      } else {
        showScaffoldMessenger(
            context: context, localizedMsg: 'search_symbol_before_backtest'.tr);
        return;
      }

      // printInfo(info: 'Backtesting started');

      // Start backtest loading effect
      isButtonDisabled.value = true;
      backtestingSymbol.value = symbol;

      bool hasMa = candle.last.trends.isNotEmpty;
      int maLength = candle.last.trends.length;

      // Assume it must be an MA trend matching
      if (!hasMa) {
        await Candle().computeTrendLines();
        hasMa = candle.last.trends.isNotEmpty;
        maLength = candle.last.trends.length;
      }

      candle =
          candle.sublist(initIndex); // Remove trends that don't have all MAs
      // printInfo(info: 'Candle data length: ${candle.length}');

      // Split the candle list of list
      List<List<CandleData>> splitCandleLists = [];
      List<int> splitCandleListsLastRows = [];
      int splits = 1000;
      final int sublistSize = (candle.length / splits).ceil();

      for (int i = 0; i < candle.length; i += sublistSize) {
        final end =
            (i + sublistSize < candle.length) ? i + sublistSize : candle.length;
        final sublist = candle.sublist(i, end);
        splitCandleLists.add(sublist);
        splitCandleListsLastRows.add(end - 1);
      }
      // printInfo(info: 'Split candle list length: ${splitCandleLists.length}');

      // Show the remaining number of backtest data
      if (!alwaysThousandthsData.value) {
        backtestDataLen5.value = candle.length;
      }

      // Randomly pick a list to run backtest
      final random = Random();
      final double candleTol = candleTolerance.value / 100;
      final double priceTol = priceTolerance.value / 100;
      final double firstMaTol = firstMaTolerance.value / 100;
      final double maTol = maTolerance.value / 100;

      double hitRate = 0.0;
      double roundedHitRate = 0.0;
      double mdd = 0.0;
      double initialFund = 10000;
      double undelayedInitialFund = 10000;
      int oneThirdSubLength = subsequentLen ~/ 3;
      int halfSubLength = subsequentLen ~/ 2;

      while (splitCandleLists.isNotEmpty) {
        final randomIndex = random.nextInt(splitCandleLists.length);
        final sublist = splitCandleLists[randomIndex];
        final subLen = sublist.length;
        if (alwaysThousandthsData.value) {
          backtestDataLen5.value = subLen;
        }

        // printInfo(info: 'Current split candle list no.: $randomIndex');
        // printInfo(info: 'Current split candle list length: $subLen');

        for (int l = 0; l < subLen - len + 1 - yFinMinuteDelay; l++) {
          await Future.delayed(const Duration(milliseconds: 0));

          // Show the remaining number of backtest data
          backtestDataRan5.value += 1;

          int id = l;
          List<String> datetime = [];
          double prob;
          double medianReturnRate = 0.0;
          int matchedTrendCount;

          // logger.d(
          //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: $id/$subLen');

          // Check if the dateTime is within the first 30 minutes of trading
          int timestamp = sublist[l].timestamp;
          if (timestamp != 0) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                timestamp * 1000,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            // Define trading start time
            DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                subtractedDateTime.month, subtractedDateTime.day, 9, 30);
            // Check if the dateTime is within the first 30 minutes of trading
            DateTime tradingEndTimeUTC =
                tradingStartTime.add(const Duration(minutes: 30));
            bool isWithinFirst30Minutes =
                subtractedDateTime.isAfter(tradingStartTime) &&
                    subtractedDateTime.isBefore(tradingEndTimeUTC);
            if (isWithinFirst30Minutes) {
              // outsideTimeCount++;
              continue;
            }
          } else {
            // logger.d('Error: timestamp == 0');
            splitCandleLists = [];
            break;
          }
          // printInfo(info: '✅ Outside first 30 mins');

          // Selecting a trend
          double startingClosePrice = sublist[l].close!;
          double lastClosePrice = sublist[l + len - 1].close!;
          double actualLastClosePrice =
              sublist[l + len - 1 + yFinMinuteDelay].close!;
          List<double> selectedPeriodPercentDifferencesList = [];
          // For MA matching
          List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
          List<double> selectedPeriodFirstMaAndPricePercentDifferencesList = [];
          // For candle matching
          List<List<double>>
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
          // Loop selected data
          for (int i = 0; i < len; i++) {
            // Candle
            List<double>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
            double close = sublist[l + i].close!;
            double openAndClosePercentDiff =
                (sublist[l + i].open! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(openAndClosePercentDiff);
            double highAndClosePercentDiff =
                (sublist[l + i].high! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(highAndClosePercentDiff);
            double lowAndClosePercentDiff =
                (sublist[l + i].low! - close) / close;
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                .add(lowAndClosePercentDiff);
            selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
          }
          for (int i = 0; i < len - 1; i++) {
            // Price
            double newVal = sublist[l + i + 1].close!;
            double oriVal = sublist[l + i].close!;
            double percentDiff = (newVal - oriVal) / oriVal;
            selectedPeriodPercentDifferencesList.add(percentDiff);

            // MA
            List<double> selectedPeriodMaPercentDifferencesList = [];
            for (int n = 0; n < maLength; n++) {
              double newVal = sublist[l + i + 1].trends[n]!;
              double oriVal = sublist[l + i].trends[n]!;
              double maPercentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
            }
            selectedPeriodMaPercentDifferencesListList
                .add(selectedPeriodMaPercentDifferencesList);
          }
          // MA
          for (int m = 0; m < maLength; m++) {
            selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                (sublist[l].trends[m]! - startingClosePrice) /
                    startingClosePrice);
          }
          // printInfo(info: '✅ Selected a trend');

          List<List<double>> upper = [];
          List<List<double>> lower = [];
          int baseline = 0;
          List<List<double>> subClosePrices = [];
          List<int> subClosePricesRowID = [];
          bool isLong = false;
          bool isShort = false;
          List<double> actualLastDifferenceList = [];

          // Look for similar trend(s)
          for (int m = 0;
              m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
              // Minus yFinMinuteDelay for actualReturn calculation
              m++) {
            // For candle matching
            List<List<double>>
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList = [];
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[m + i].close!;
              double openAndClosePercentDiff =
                  (candle[m + i].open! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[m + i].high! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[m + i].low! - close) / close;
              comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              comparePeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
            }

            // For price matching
            List<double> comparePeriodPercentDifferencesList = [];
            for (int i = 0; i < len - 1; i++) {
              double percentDiff =
                  (candle[m + i + 1].close! - candle[m + i].close!) /
                      (candle[m + i].close!);
              comparePeriodPercentDifferencesList.add(percentDiff);
            }

            (bool, List<double>) comparisonResult = TrendMatch()
                .areDifferencesLessThanOrEqualToCertainPercent(
                    selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                    candleTol,
                    selectedPeriodPercentDifferencesList,
                    comparePeriodPercentDifferencesList,
                    priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

            if (comparisonResult.$1) {
              // printInfo(info: '✅ A trend percentage changes matched');
              List<double> comparePeriodFirstMaAndPricePercentDifferencesList =
                  [];
              List<List<double>> comparePeriodMaPercentDifferencesListList = [];
              double compareFirstPrice = candle[m].close!;

              for (int n = 0; n < len - 1; n++) {
                List<double> comparePeriodMaPercentDifferencesList = [];
                for (int i = 0; i < maLength; i++) {
                  double newVal = candle[m + n + 1].trends[i]!;
                  double oriVal = candle[m + n].trends[i]!;
                  double maPercentDiff = (newVal - oriVal) / oriVal;
                  comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                }
                comparePeriodMaPercentDifferencesListList
                    .add(comparePeriodMaPercentDifferencesList);
              }
              for (int i = 0; i < maLength; i++) {
                comparePeriodFirstMaAndPricePercentDifferencesList.add(
                    (candle[m].trends[i]! - compareFirstPrice) /
                        compareFirstPrice);
              }

              bool isMaMatched = TrendMatch()
                  .maDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodFirstMaAndPricePercentDifferencesList,
                      selectedPeriodMaPercentDifferencesListList,
                      comparePeriodFirstMaAndPricePercentDifferencesList,
                      comparePeriodMaPercentDifferencesListList,
                      maTol,
                      firstMaTol);
              if (isMaMatched) {
                // printInfo(info: '✅ A trend MAs matched');
                // Store the adjusted close prices into different lists
                List<double> matchedAdjustedSubsequentCloseList = [];
                double lastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                double actualLastDifference =
                    lastClosePrice / candle[m + len - 1].close!;
                actualLastDifferenceList.add(actualLastDifference);
                for (int i = 0; i < subsequentLen; i++) {
                  double adjustedSubsequentClose =
                      candle[m + len + i].close! * lastDifference;
                  matchedAdjustedSubsequentCloseList
                      .add(adjustedSubsequentClose);
                }
                if (matchedAdjustedSubsequentCloseList.last > lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  upper.add(matchedAdjustedSubsequentCloseList);
                } else if (matchedAdjustedSubsequentCloseList.last <
                    lastClosePrice) {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  lower.add(matchedAdjustedSubsequentCloseList);
                } else {
                  subClosePrices.add(matchedAdjustedSubsequentCloseList);
                  subClosePricesRowID.add(m + len);
                  baseline++;
                }
              }
              // else {
              //   printInfo(info: '❌ A trend MAs not matched');
              // }
            }
            // else {
            //   printInfo(info: '❌ A trend percentage changes not matched');
            // }
          }

          // Division by zero is mathematically undefined, but in programming,
          // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
          // This way, skip when both lists are empty
          if (upper.isEmpty && lower.isEmpty) {
            missCount++;
            // printInfo(info: '❌ upper and lower are empty');
            continue;
          }
          // Probability calculation and amount of matched trends
          double upperProb =
              upper.length / (upper.length + lower.length + baseline);
          double lowerProb =
              lower.length / (upper.length + lower.length + baseline);
          // Round to 3 decimal places
          upperProb = double.parse(upperProb.toStringAsFixed(4));
          lowerProb = double.parse(lowerProb.toStringAsFixed(4));
          if (upperProb >= thisProbThreshold) {
            if (upperProb.toInt() == 1) {
              if (upper.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 4');
                continue;
              }
            } else {
              if (upper.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ upper.length < 5');
                continue;
              }
            }
            isLong = true;
            // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
          } else if (lowerProb >= thisProbThreshold) {
            if (lowerProb.toInt() == 1) {
              if (lower.length < minOneSidedMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 4');
                continue;
              }
            } else {
              if (lower.length < minMatchCount) {
                missCount++;
                // printInfo(info: '❌ lower.length < 5');
                continue;
              }
            }
            isShort = true;
            // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
          } else {
            missCount++;
            // printInfo(info: '❌ No majority list');
            continue;
          }

          // Return rate median
          double thisMdd = 0.0;
          if (isLong) {
            double medianOfLastCloses = findMedianOfLastValues(upper);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate <= minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate <= $minMedianReturnRate in long');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in long');
              continue;
            }
            double thisMin = findMinOfValues(lower);
            if (thisMin != 0.0) {
              double minPercentageDifference =
                  (thisMin - lastClosePrice) / lastClosePrice;
              double minPercentageDifferenceAbs = minPercentageDifference.abs();
              mdd = max(mdd, minPercentageDifferenceAbs);
              thisMdd = minPercentageDifferenceAbs;
            } else {
              thisMdd = thisMin;
            }
          } else if (isShort) {
            double medianOfLastCloses = findMedianOfLastValues(lower);
            if (medianOfLastCloses != 0.0) {
              medianReturnRate =
                  (medianOfLastCloses - lastClosePrice) / lastClosePrice;
              if (medianReturnRate >= -minMedianReturnRate) {
                missCount++;
                // printInfo(
                //     info:
                //         '❌ Median return rate >= -$minMedianReturnRate in short');
                continue;
              }
            } else {
              missCount++;
              // printInfo(info: '❌ Median return rate is 0.0 in short');
              continue;
            }
            double thisMax = findMaxOfValues(upper);
            if (thisMax != 0.0) {
              double maxPercentageDifference =
                  (thisMax - lastClosePrice) / lastClosePrice;
              double maxPercentageDifferenceAbs = maxPercentageDifference.abs();
              mdd = max(mdd, maxPercentageDifferenceAbs);
              thisMdd = maxPercentageDifferenceAbs;
            } else {
              thisMdd = thisMax;
            }
          }
          hitCount++;
          // printInfo(
          //     info:
          //         '✅ Minimum median return rate has been passed: $medianReturnRate');

          // Pick up a trend randomly from upper/lower by overall probability
          int randomIndex = random.nextInt(subClosePrices.length);
          // Get the randomly selected trend from the combinedList
          List<double> randomTrend = subClosePrices[randomIndex];
          // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
          // and the exit price is always on time
          double actualReturnRate = ((randomTrend.last - actualLastClosePrice) /
              actualLastClosePrice);
          double undelayedReturnRate =
              ((randomTrend.last - lastClosePrice) / lastClosePrice);
          double roundedActualReturnRate =
              double.parse(actualReturnRate.toStringAsFixed(4));
          double roundedUndelayedReturnRate =
              double.parse(undelayedReturnRate.toStringAsFixed(4));
          int contractVal =
              5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
          int diffFromEtfAndFuture =
              10; // The difference in value scale between ETF and Future
          matchedTrendCount = subClosePrices.length;

          double interruptActualReturn = 0.0;
          double interruptActualReturnRate = 0.0;
          double interruptUndelayedReturn = 0.0;
          double interruptUndelayedReturnRate = 0.0;
          bool interrupt = false;

          // Check whether the trend return rate has reaches the median return rate in matched trends
          int medianHitID = -1;
          if (closePosWhenReachedMedian.value) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= medianReturnRate) {
                  interrupt = true;
                  medianHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

          // Check the number of trend go to the opposite side
          int goOppositeCount = 0;
          int goOppoHitID = -1;
          if (isLong) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] < lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          } else if (isShort) {
            for (int v = 0; v < randomTrend.length; v++) {
              if (randomTrend[v] > lastClosePrice) {
                goOppositeCount++;
                if (goOppositeCount >= halfSubLength) {
                  interrupt = true;
                  goOppoHitID = v;
                  break;
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

          // Check if hit the opposite side ceiling or bottom
          int hitOppositeCeilingOrBottomCount = 0;
          int hitOppoBottomOrCeilingHitID = -1;
          if (thisMdd != 0.0) {
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange <= -thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                double percentChange =
                    (randomTrend[v] - lastClosePrice) / lastClosePrice;
                if (percentChange >= thisMdd) {
                  hitOppositeCeilingOrBottomCount++;
                  if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                    interrupt = true;
                    hitOppoBottomOrCeilingHitID = v;
                    break;
                  }
                }
              }
            }
          }
          // printInfo(
          //     info:
          //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

          for (var element in subClosePricesRowID) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                candle[element].timestamp,
                isUtc: true);
            DateTime subtractedDateTime =
                TimeService.to.subtractHoursBasedOnTimezone(dateTime);
            String lastDatetime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
            String timezone =
                TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
            datetime.add('$lastDatetime $timezone');
          }

          if (!interrupt) {
            // Fund value changes due to the return of transaction
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                (((randomTrend.last - actualLastClosePrice) *
                        diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                (((randomTrend.last - lastClosePrice) * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          } else {
            int firstHitID = -1;
            final List<int> hitList = [
              medianHitID,
              goOppoHitID,
              hitOppoBottomOrCeilingHitID,
            ];
            for (final int hitID in hitList) {
              if (hitID != -1) {
                if (firstHitID == -1) {
                  firstHitID = hitID;
                } else if (hitID <= firstHitID) {
                  firstHitID = hitID;
                }
              }
            }

            if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
              double newVal = candle[subClosePricesRowID[randomIndex] +
                          firstHitID +
                          yFinMinuteDelay]
                      .close! *
                  actualLastDifferenceList[randomIndex];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            } else {
              double newVal = randomTrend[firstHitID + yFinMinuteDelay];
              interruptActualReturn = newVal - actualLastClosePrice;
              interruptActualReturnRate =
                  (newVal - actualLastClosePrice) / actualLastClosePrice;
            }
            double newVal = randomTrend[firstHitID];
            interruptUndelayedReturn = newVal - lastClosePrice;
            interruptUndelayedReturnRate =
                (newVal - lastClosePrice) / lastClosePrice;

            // Get the failed trend last close price return and change the fund value
            // - Index points (0.25) contract value (5 USD)
            // - Commission fee
            // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
            initialFund = initialFund +
                ((interruptActualReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
            undelayedInitialFund = undelayedInitialFund +
                ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                    0.25 *
                    contractVal) -
                commissionsAndFees;
          }

          prob =
              double.parse((isLong ? upperProb : lowerProb).toStringAsFixed(4));
          medianReturnRate = double.parse(medianReturnRate.toStringAsFixed(4));
          hitRate = hitCount / (hitCount + missCount);
          roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
          double roundedMdd = double.parse(mdd.toStringAsFixed(4));
          double roundedInitialFund =
              double.parse(initialFund.toStringAsFixed(4));
          double roundedUndelayedInitialFund =
              double.parse(undelayedInitialFund.toStringAsFixed(4));

          // Save results one by one into listList
          subClosePrices.asMap().entries.forEach((entry) {
            listList.add([
              id,
              datetime[entry.key],
              len,
              prob,
              medianReturnRate,
              roundedUndelayedReturnRate,
              roundedActualReturnRate,
              matchedTrendCount,
              interrupt,
              interruptUndelayedReturnRate,
              interruptActualReturnRate,
              roundedHitRate,
              roundedMdd,
              roundedUndelayedInitialFund,
              roundedInitialFund,
              commissionsAndFees,
              yFinMinuteDelay,
              ...entry.value
            ]);
          });

          // logger.d(listList);

          // printInfo(info: 'Matched count: $matchedTrendCount');
          // printInfo(info: 'Prob.: $prob');
          // printInfo(info: 'Undelayed return rate: $roundedUndelayedReturnRate');
          // printInfo(
          //     info:
          //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
          // printInfo(info: 'Final return rate: $roundedActualReturnRate');
          // printInfo(info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
        }

        // Check if the sublist can be looped through the last row or not
        if (splitCandleListsLastRows[randomIndex] != candle.length - 1) {
          final int sublistLastCandleRow =
              splitCandleListsLastRows[randomIndex];
          // Loop through remaining rows in sublist if possible
          int remainder = subLen - (subLen - len + 1 - yFinMinuteDelay);
          for (int l = subLen - len + 1 - yFinMinuteDelay; l < subLen; l++) {
            final int thisCandleRow = sublistLastCandleRow - remainder;
            remainder--;

            await Future.delayed(const Duration(milliseconds: 0));

            // Show the remaining number of backtest data
            backtestDataRan5.value += 1;

            int id = l;
            List<String> datetime = [];
            double prob;
            double medianReturnRate = 0.0;
            int matchedTrendCount;

            // logger.d(
            //     '[Last time] Hit/miss/outside count: $hitCount/$missCount/$outsideTimeCount | Hit rate: $roundedHitRate | Current ID among the total in the split candle list: ${id + 1}/$subLen');

            // Check if the dateTime is within the first 30 minutes of trading
            int timestamp = sublist[l].timestamp;
            if (timestamp != 0) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              // Define trading start time
              DateTime tradingStartTime = DateTime.utc(subtractedDateTime.year,
                  subtractedDateTime.month, subtractedDateTime.day, 9, 30);
              // Check if the dateTime is within the first 30 minutes of trading
              DateTime tradingEndTimeUTC =
                  tradingStartTime.add(const Duration(minutes: 30));
              bool isWithinFirst30Minutes =
                  subtractedDateTime.isAfter(tradingStartTime) &&
                      subtractedDateTime.isBefore(tradingEndTimeUTC);
              if (isWithinFirst30Minutes) {
                // outsideTimeCount++;
                continue;
              }
            } else {
              // logger.d('Error: timestamp == 0');
              splitCandleLists = [];
              break;
            }
            // printInfo(info: '✅ Outside first 30 mins');

            // Selecting a trend
            double startingClosePrice = sublist[l].close!;
            double lastClosePrice = candle[thisCandleRow + len - 1].close!;
            double actualLastClosePrice =
                candle[thisCandleRow + len - 1 + yFinMinuteDelay].close!;
            List<double> selectedPeriodPercentDifferencesList = [];
            // For MA matching
            List<List<double>> selectedPeriodMaPercentDifferencesListList = [];
            List<double> selectedPeriodFirstMaAndPricePercentDifferencesList =
                [];
            // For candle matching
            List<List<double>>
                selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList =
                [];
            // Loop selected data
            for (int i = 0; i < len; i++) {
              // Candle
              List<double>
                  selectedPeriodOpenHighLowTheirDiffInRelationToCloseList = [];
              double close = candle[thisCandleRow + i].close!;
              double openAndClosePercentDiff =
                  (candle[thisCandleRow + i].open! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(openAndClosePercentDiff);
              double highAndClosePercentDiff =
                  (candle[thisCandleRow + i].high! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(highAndClosePercentDiff);
              double lowAndClosePercentDiff =
                  (candle[thisCandleRow + i].low! - close) / close;
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseList
                  .add(lowAndClosePercentDiff);
              selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList
                  .add(selectedPeriodOpenHighLowTheirDiffInRelationToCloseList);
            }
            for (int i = 0; i < len - 1; i++) {
              double newVal = candle[thisCandleRow + i + 1].close!;
              double oriVal = candle[thisCandleRow + i].close!;
              double percentDiff = (newVal - oriVal) / oriVal;
              selectedPeriodPercentDifferencesList.add(percentDiff);

              // MA
              List<double> selectedPeriodMaPercentDifferencesList = [];
              for (int n = 0; n < maLength; n++) {
                double newVal = candle[thisCandleRow + i + 1].trends[n]!;
                double oriVal = candle[thisCandleRow + i].trends[n]!;
                double maPercentDiff = (newVal - oriVal) / oriVal;
                selectedPeriodMaPercentDifferencesList.add(maPercentDiff);
              }
              selectedPeriodMaPercentDifferencesListList
                  .add(selectedPeriodMaPercentDifferencesList);
            }
            // MA
            for (int m = 0; m < maLength; m++) {
              selectedPeriodFirstMaAndPricePercentDifferencesList.add(
                  (sublist[l].trends[m]! - startingClosePrice) /
                      startingClosePrice);
            }
            // printInfo(info: '✅ Selected a trend');

            List<List<double>> upper = [];
            List<List<double>> lower = [];
            int baseline = 0;
            List<List<double>> subClosePrices = [];
            List<int> subClosePricesRowID = [];
            bool isLong = false;
            bool isShort = false;
            List<double> actualLastDifferenceList = [];

            // Look for similar trend(s)
            for (int m = 0;
                m < candle.length - len - subsequentLen + 1 - yFinMinuteDelay;
                // Minus yFinMinuteDelay for actualReturn calculation
                m++) {
              // For candle matching
              List<List<double>>
                  comparePeriodOpenHighLowTheirDiffInRelationToCloseListList =
                  [];
              for (int i = 0; i < len; i++) {
                // Candle
                List<double>
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList = [];
                double close = candle[m + i].close!;
                double openAndClosePercentDiff =
                    (candle[m + i].open! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(openAndClosePercentDiff);
                double highAndClosePercentDiff =
                    (candle[m + i].high! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(highAndClosePercentDiff);
                double lowAndClosePercentDiff =
                    (candle[m + i].low! - close) / close;
                comparePeriodOpenHighLowTheirDiffInRelationToCloseList
                    .add(lowAndClosePercentDiff);
                comparePeriodOpenHighLowTheirDiffInRelationToCloseListList.add(
                    comparePeriodOpenHighLowTheirDiffInRelationToCloseList);
              }

              // For price matching
              List<double> comparePeriodPercentDifferencesList = [];
              for (int i = 0; i < len - 1; i++) {
                double percentDiff =
                    (candle[m + i + 1].close! - candle[m + i].close!) /
                        (candle[m + i].close!);
                comparePeriodPercentDifferencesList.add(percentDiff);
              }

              (bool, List<double>) comparisonResult = TrendMatch()
                  .areDifferencesLessThanOrEqualToCertainPercent(
                      selectedPeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      comparePeriodOpenHighLowTheirDiffInRelationToCloseListList,
                      candleTol,
                      selectedPeriodPercentDifferencesList,
                      comparePeriodPercentDifferencesList,
                      priceTol); // Record data type in Dart is equivalent to Tuple in Java and Python

              if (comparisonResult.$1) {
                // printInfo(info: '✅ A trend percentage changes matched');
                List<double>
                    comparePeriodFirstMaAndPricePercentDifferencesList = [];
                List<List<double>> comparePeriodMaPercentDifferencesListList =
                    [];
                double compareFirstPrice = candle[m].close!;

                for (int n = 0; n < len - 1; n++) {
                  List<double> comparePeriodMaPercentDifferencesList = [];
                  for (int i = 0; i < maLength; i++) {
                    double newVal = candle[m + n + 1].trends[i]!;
                    double oriVal = candle[m + n].trends[i]!;
                    double maPercentDiff = (newVal - oriVal) / oriVal;
                    comparePeriodMaPercentDifferencesList.add(maPercentDiff);
                  }
                  comparePeriodMaPercentDifferencesListList
                      .add(comparePeriodMaPercentDifferencesList);
                }
                for (int i = 0; i < maLength; i++) {
                  comparePeriodFirstMaAndPricePercentDifferencesList.add(
                      (candle[m].trends[i]! - compareFirstPrice) /
                          compareFirstPrice);
                }

                bool isMaMatched = TrendMatch()
                    .maDifferencesLessThanOrEqualToCertainPercent(
                        selectedPeriodFirstMaAndPricePercentDifferencesList,
                        selectedPeriodMaPercentDifferencesListList,
                        comparePeriodFirstMaAndPricePercentDifferencesList,
                        comparePeriodMaPercentDifferencesListList,
                        maTol,
                        firstMaTol);
                if (isMaMatched) {
                  // printInfo(info: '✅ A trend MAs matched');
                  // Store the adjusted close prices into different lists
                  List<double> matchedAdjustedSubsequentCloseList = [];
                  double lastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  double actualLastDifference =
                      lastClosePrice / candle[m + len - 1].close!;
                  actualLastDifferenceList.add(actualLastDifference);
                  for (int i = 0; i < subsequentLen; i++) {
                    double adjustedSubsequentClose =
                        candle[m + len + i].close! * lastDifference;
                    matchedAdjustedSubsequentCloseList
                        .add(adjustedSubsequentClose);
                  }
                  if (matchedAdjustedSubsequentCloseList.last >
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    upper.add(matchedAdjustedSubsequentCloseList);
                  } else if (matchedAdjustedSubsequentCloseList.last <
                      lastClosePrice) {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    lower.add(matchedAdjustedSubsequentCloseList);
                  } else {
                    subClosePrices.add(matchedAdjustedSubsequentCloseList);
                    subClosePricesRowID.add(m + len);
                    baseline++;
                  }
                }
                // else {
                //   printInfo(info: '❌ A trend MAs not matched');
                // }
              }
              // else {
              //   printInfo(info: '❌ A trend percentage changes not matched');
              // }
            }

            // Division by zero is mathematically undefined, but in programming,
            // dividing by zero often results in NaN (Not a Number) for floating-point numbers.
            // This way, skip when both lists are empty
            if (upper.isEmpty && lower.isEmpty) {
              missCount++;
              // printInfo(info: '❌ upper and lower are empty');
              continue;
            }
            // Probability calculation and amount of matched trends
            double upperProb =
                upper.length / (upper.length + lower.length + baseline);
            double lowerProb =
                lower.length / (upper.length + lower.length + baseline);
            // Round to 3 decimal places
            upperProb = double.parse(upperProb.toStringAsFixed(4));
            lowerProb = double.parse(lowerProb.toStringAsFixed(4));
            if (upperProb >= thisProbThreshold) {
              if (upperProb.toInt() == 1) {
                if (upper.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 4');
                  continue;
                }
              } else {
                if (upper.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ upper.length < 5');
                  continue;
                }
              }
              isLong = true;
              // printInfo(info: '✅ Is long: ${upper.length}/${lower.length}');
            } else if (lowerProb >= thisProbThreshold) {
              if (lowerProb.toInt() == 1) {
                if (lower.length < minOneSidedMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 4');
                  continue;
                }
              } else {
                if (lower.length < minMatchCount) {
                  missCount++;
                  // printInfo(info: '❌ lower.length < 5');
                  continue;
                }
              }
              isShort = true;
              // printInfo(info: '✅ Is short: ${upper.length}/${lower.length}');
            } else {
              missCount++;
              // printInfo(info: '❌ No majority list');
              continue;
            }

            // Return rate median
            double thisMdd = 0.0;
            if (isLong) {
              double medianOfLastCloses = findMedianOfLastValues(upper);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate <= minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate <= $minMedianReturnRate in long');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in long');
                continue;
              }
              double thisMin = findMinOfValues(lower);
              if (thisMin != 0.0) {
                double minPercentageDifference =
                    (thisMin - lastClosePrice) / lastClosePrice;
                double minPercentageDifferenceAbs =
                    minPercentageDifference.abs();
                mdd = max(mdd, minPercentageDifferenceAbs);
                thisMdd = minPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMin is 0.0 in long');
                continue;
              }
            } else if (isShort) {
              double medianOfLastCloses = findMedianOfLastValues(lower);
              if (medianOfLastCloses != 0.0) {
                medianReturnRate =
                    (medianOfLastCloses - lastClosePrice) / lastClosePrice;
                if (medianReturnRate >= -minMedianReturnRate) {
                  missCount++;
                  // printInfo(
                  //     info:
                  //         '❌ Median return rate >= -$minMedianReturnRate in short');
                  continue;
                }
              } else {
                missCount++;
                // printInfo(info: '❌ Median return rate is 0.0 in short');
                continue;
              }
              double thisMax = findMaxOfValues(upper);
              if (thisMax != 0.0) {
                double maxPercentageDifference =
                    (thisMax - lastClosePrice) / lastClosePrice;
                double maxPercentageDifferenceAbs =
                    maxPercentageDifference.abs();
                mdd = max(mdd, maxPercentageDifferenceAbs);
                thisMdd = maxPercentageDifferenceAbs;
              } else {
                missCount++;
                // printInfo(info: '❌ thisMax is 0.0 in short');
                continue;
              }
            }
            hitCount++;
            // printInfo(
            //     info:
            //         '✅ Minimum median return rate has been passed: $medianReturnRate');

            // Pick up a trend randomly from upper/lower by overall probability
            int randomIndex = random.nextInt(subClosePrices.length);
            // Get the randomly selected trend from the combinedList
            List<double> randomTrend = subClosePrices[randomIndex];
            // Envisaged that the entry price is always delayed, the delay time is denoted as yFinMinuteDelay,
            // and the exit price is always on time
            double actualReturnRate =
                ((randomTrend.last - actualLastClosePrice) /
                    actualLastClosePrice);
            double undelayedReturnRate =
                ((randomTrend.last - lastClosePrice) / lastClosePrice);
            double roundedActualReturnRate =
                double.parse(actualReturnRate.toStringAsFixed(4));
            double roundedUndelayedReturnRate =
                double.parse(undelayedReturnRate.toStringAsFixed(4));
            int contractVal =
                5; // Micro E-mini Futures: Index points (0.25) contract value (5 USD)
            int diffFromEtfAndFuture =
                10; // The difference in value scale between ETF and Future
            matchedTrendCount = subClosePrices.length;

            double interruptActualReturn = 0.0;
            double interruptActualReturnRate = 0.0;
            double interruptUndelayedReturn = 0.0;
            double interruptUndelayedReturnRate = 0.0;
            bool interrupt = false;

            // Check whether the trend return rate has reaches the median return rate in matched trends
            int medianHitID = -1;
            if (closePosWhenReachedMedian.value) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= medianReturnRate) {
                    interrupt = true;
                    medianHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'medianHitID: $medianHitID, medianReturnRate: $medianReturnRate, interrupt: $interrupt');

            // Check the number of trend go to the opposite side
            int goOppositeCount = 0;
            int goOppoHitID = -1;
            if (isLong) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] < lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            } else if (isShort) {
              for (int v = 0; v < randomTrend.length; v++) {
                if (randomTrend[v] > lastClosePrice) {
                  goOppositeCount++;
                  if (goOppositeCount >= halfSubLength) {
                    interrupt = true;
                    goOppoHitID = v;
                    break;
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'goOppoHitID: $goOppoHitID, goOppositeCount/halfSubLength: $goOppositeCount/$halfSubLength, interrupt: $interrupt');

            // Check if hit the opposite side ceiling or bottom
            int hitOppositeCeilingOrBottomCount = 0;
            int hitOppoBottomOrCeilingHitID = -1;
            if (thisMdd != 0.0) {
              if (isLong) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange <= -thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              } else if (isShort) {
                for (int v = 0; v < randomTrend.length; v++) {
                  double percentChange =
                      (randomTrend[v] - lastClosePrice) / lastClosePrice;
                  if (percentChange >= thisMdd) {
                    hitOppositeCeilingOrBottomCount++;
                    if (hitOppositeCeilingOrBottomCount >= oneThirdSubLength) {
                      interrupt = true;
                      hitOppoBottomOrCeilingHitID = v;
                      break;
                    }
                  }
                }
              }
            }
            // printInfo(
            //     info:
            //         'hitOppoBottomOrCeilingHitID: $hitOppoBottomOrCeilingHitID, hitOppositeCeilingOrBottomCount/oneThirdSubLength: $hitOppositeCeilingOrBottomCount/$oneThirdSubLength, interrupt: $interrupt');

            for (var element in subClosePricesRowID) {
              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                  candle[element].timestamp,
                  isUtc: true);
              DateTime subtractedDateTime =
                  TimeService.to.subtractHoursBasedOnTimezone(dateTime);
              String lastDatetime =
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
              String timezone = TimeService.to.isEasternDaylightTime(dateTime)
                  ? 'EDT'
                  : 'EST';
              datetime.add('$lastDatetime $timezone');
            }

            if (!interrupt) {
              // Fund value changes due to the return of transaction
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  (((randomTrend.last - actualLastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  (((randomTrend.last - lastClosePrice) *
                          diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            } else {
              int firstHitID = -1;
              final List<int> hitList = [
                medianHitID,
                goOppoHitID,
                hitOppoBottomOrCeilingHitID,
              ];
              for (final int hitID in hitList) {
                if (hitID != -1) {
                  if (firstHitID == -1) {
                    firstHitID = hitID;
                  } else if (hitID <= firstHitID) {
                    firstHitID = hitID;
                  }
                }
              }

              if (firstHitID >= randomTrend.length - yFinMinuteDelay) {
                double newVal = candle[subClosePricesRowID[randomIndex] +
                            firstHitID +
                            yFinMinuteDelay]
                        .close! *
                    actualLastDifferenceList[randomIndex];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              } else {
                double newVal = randomTrend[firstHitID + yFinMinuteDelay];
                interruptActualReturn = newVal - actualLastClosePrice;
                interruptActualReturnRate =
                    (newVal - actualLastClosePrice) / actualLastClosePrice;
              }
              double newVal = randomTrend[firstHitID];
              interruptUndelayedReturn = newVal - lastClosePrice;
              interruptUndelayedReturnRate =
                  (newVal - lastClosePrice) / lastClosePrice;

              // Get the failed trend last close price return and change the fund value
              // - Index points (0.25) contract value (5 USD)
              // - Commission fee
              // https://www.futunn.com/en/stock/MESMAIN-US/contract-specs
              initialFund = initialFund +
                  ((interruptActualReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
              undelayedInitialFund = undelayedInitialFund +
                  ((interruptUndelayedReturn * diffFromEtfAndFuture) ~/
                      0.25 *
                      contractVal) -
                  commissionsAndFees;
            }

            prob = double.parse(
                (isLong ? upperProb : lowerProb).toStringAsFixed(4));
            medianReturnRate =
                double.parse(medianReturnRate.toStringAsFixed(4));
            hitRate = hitCount / (hitCount + missCount);
            roundedHitRate = double.parse(hitRate.toStringAsFixed(4));
            double roundedMdd = double.parse(mdd.toStringAsFixed(4));
            double roundedInitialFund =
                double.parse(initialFund.toStringAsFixed(4));
            double roundedUndelayedInitialFund =
                double.parse(undelayedInitialFund.toStringAsFixed(4));

            // Save results one by one into listList
            subClosePrices.asMap().entries.forEach((entry) {
              listList.add([
                id,
                datetime[entry.key],
                len,
                prob,
                medianReturnRate,
                roundedUndelayedReturnRate,
                roundedActualReturnRate,
                matchedTrendCount,
                interrupt,
                interruptUndelayedReturnRate,
                interruptActualReturnRate,
                roundedHitRate,
                roundedMdd,
                roundedUndelayedInitialFund,
                roundedInitialFund,
                commissionsAndFees,
                yFinMinuteDelay,
                ...entry.value
              ]);
            });

            // logger.d(listList);

            // printInfo(info: 'Matched count: $matchedTrendCount');
            // printInfo(info: 'Prob.: $prob');
            // printInfo(
            //     info: 'Undelayed return rate: $roundedUndelayedReturnRate');
            // printInfo(
            //     info:
            //         'Undelayed fund remaining: US\$$roundedUndelayedInitialFund/US\$10000');
            // printInfo(info: 'Final return rate: $roundedActualReturnRate');
            // printInfo(
            //     info: 'Fund remaining: US\$$roundedInitialFund/US\$10000');
          }
        }

        if (!alwaysThousandthsData.value) {
          splitCandleLists.removeAt(randomIndex);
        } else {
          splitCandleLists = [];
        }
      }

      // printInfo(info: 'Backtesting ended');
      // printInfo(info: 'Export backtesting results CSV...');
      int randomID = 100000 + random.nextInt(900000);
      // Export CSV to device's local file directory
      String fileName =
          '${randomID}_${symbol}_cTol${candleTolerance.value}_pTol${priceTolerance.value}_fMaTol${firstMaTolerance.value}_maTol${maTolerance.value}_len${len}_subLen${subsequentLen}_probThres${thisProbThreshold}_maTrue_strict${strictMatchCriteria.value}_outF30m_minMatchC${minMatchCount}_minSidedMatchC${minOneSidedMatchCount}_minR${minMedianReturnRate}_reachedMed${closePosWhenReachedMedian.value}_hitCeOrBoOneThirdSubLen_goOpHalfSubLen';
      exportCsv(listList, fileName);

      // printInfo(info: 'Exported backtesting results CSV');

      // Stop backtest loading effect
      isButtonDisabled.value = false;
      backtestingSymbol.value = '';

      // Reset the remaining number of backtest data
      backtestDataLen5.value = 0;
      backtestDataRan5.value = 0;
    });
  }

  /* Route */
  void route(String path) {
    Get.toNamed(path);
  }

  void back() {
    Get.back();
  }

  /* UI Logic (mainly focused on show/hide) */
  List<Widget> buildListingRelatedIcons({required BuildContext context}) {
    if (isListingInit.value) {
      return [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (!isLockTrend.value) {
              route(RouteName.searchView.path);
            } else {
              showScaffoldMessenger(
                  context: context, localizedMsg: 'lock_trend_alert'.tr);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.contact_support),
          onPressed: () {
            route(RouteName.chatView.path);
          },
        ),
      ];
    } else {
      return [];
    }
  }

  Widget showTm() {
    return Obx(() {
      if (trendMatched.value && showAnalytics.value) {
        return TrendMatchView().showAdjustedLineChart();
      } else if (showAnalytics.value) {
        return TrendMatchView().showCircularProgressIndicator();
      }
      return const SizedBox.shrink();
    });
  }

  Widget showStartBtn() {
    return Obx(() {
      if (showAnalytics.value) {
        return const SizedBox.shrink();
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: ElevatedButton.icon(
            onPressed: () {
              showAnalyticsNotifier.value = true;
            },
            icon: Icon(
              Icons.analytics_outlined,
              size: 20.h,
            ),
            label: Text(
              'btn_tm_sa'.tr,
              style: const TextTheme().sp5.w700,
            ),
          ),
        );
      }
    });
  }

  Widget showDevModeViewOne(bool devMode, BuildContext context) {
    if (devMode) {
      return MainView().devModeViewOne(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showDevModeViewTwo(bool devMode) {
    if (devMode) {
      return MainView().devModeViewTwo();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showSa() {
    return Obx(() {
      if ((hasSubsequentAnalytics.value &&
              showAnalytics.value &&
              devMode.value &&
              apiKey.value != '') ||
          (showAnalytics.value &&
              devMode.value &&
              apiKey.value != '' &&
              isLockTrend.value)) {
        if (subsequentAnalyticsErr.value == '' && apiKeyErr.value == '') {
          return Column(
            children: [
              SubsequentAnalyticsView().showSaChart(),
              SubsequentAnalyticsView().showSaDevChart(),
            ],
          );
        } else if (apiKeyErr.value == '') {
          return SubsequentAnalyticsView().showError();
        } else {
          return Column(
            children: [
              SubsequentAnalyticsView().showError(),
              showApiKeyReminder(),
            ],
          );
        }
      } else if ((hasSubsequentAnalytics.value &&
              showAnalytics.value &&
              apiKey.value != '') ||
          (showAnalytics.value && apiKey.value != '' && isLockTrend.value)) {
        if (subsequentAnalyticsErr.value == '' && apiKeyErr.value == '') {
          return SubsequentAnalyticsView().showSaChart();
        } else if (apiKeyErr.value == '') {
          return SubsequentAnalyticsView().showError();
        } else {
          return Column(
            children: [
              SubsequentAnalyticsView().showError(),
              showApiKeyReminder(),
            ],
          );
        }
      } else if (showAnalytics.value && apiKey.value != '') {
        return SubsequentAnalyticsView().showCircularProgressIndicator();
      } else if (showAnalytics.value) {
        showApiKeyInput();
        return showApiKeyReminder();
      }
      return const SizedBox.shrink();
    });
  }

  Widget buildListingSourceRichText() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/nasdaq.png',
            height: 6.h,
          ),
        ),
      ),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.imageDefaultBgColor,
          ),
          child: Image.asset(
            'images/nyse.png',
            height: 7.h,
          ),
        ),
      ),
    );
    final imageSpan3 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColor.imageDefaultBgColor,
            ),
            child: Image.asset(
              'images/amex.png',
              height: 12.h,
            ),
          ),
        ),
      ),
    );

    return RichText(
      text: TextSpan(
        text: listingsProviderMsg.value,
        children: [imageSpan, imageSpan2, imageSpan3],
        style: const TextTheme().sp4.greyColor,
      ),
    );
  }

  Widget buildMktDataProviderRichText() {
    return Obx(
      () => Row(
        children: [
          if (alwaysShowMinuteData.value) ...[
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColor.imageDefaultBgColor,
                ),
                child: Image.asset(
                  'images/futubull.png',
                  height: (Platform.isWindows ||
                          Platform.isLinux ||
                          Platform.isMacOS
                      ? 8.h
                      : 6.h), // Adjust the height as needed
                ),
              ),
            )
          ],
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.imageDefaultBgColor,
              ),
              child: Image.asset(
                'images/yahoofinance.png',
                height:
                    (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                        ? 8.h
                        : 6.h), // Adjust the height as needed
              ),
            ),
          ),
          Text(
            marketDataProviderMsg.value,
            style: const TextTheme().sp4.greyColor,
          ),
        ],
      ),
    );
  }

  Widget buildCloudFunctionCol() {
    final imageSpan = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/cloudfunction.png',
            height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? 25.h
                : 18.h), // Adjust the height as needed
          ),
        ),
      ),
    );
    final textSpan = WidgetSpan(
      child: Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Text(
            'x',
            style: const TextTheme().sp10.greyColor,
          )),
    );
    final imageSpan2 = WidgetSpan(
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Transform.translate(
          offset: Offset(0.0, 3.h),
          child: Image.asset(
            'images/hsuhk_cs_dept.png',
            height: (Platform.isWindows || Platform.isLinux || Platform.isMacOS
                ? 25.h
                : 18.h), // Adjust the height as needed
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'power_from'.tr,
            style: const TextTheme().sp4.greyColor,
          ),
        ),
        Center(
          child: RichText(
            text: TextSpan(
              children: [imageSpan, textSpan, imageSpan2],
              style: const TextTheme().sp4.greyColor,
            ),
          ),
        ),
        SizedBox(height: 50.h),
      ],
    );
  }

  void changeAppearance() {
    darkMode.toggle();
    if (darkMode.value) {
      AppColor.primaryTextColor = Colors.white;
      lockTrendTextStyle.value = const TextTheme().sp4.whiteColor.w700;
    } else {
      AppColor.primaryTextColor = Colors.black;
      lockTrendTextStyle.value = const TextTheme().sp4.blackColor.w700;
    }
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.darkMode, darkMode.value);
  }

  clearMsg() {
    messages.value = messages.sublist(0, 1); // newList will be ["first"]
    PrefsService.to.prefs
        .setStringList(SharedPreferencesConstant.messages, messages);
    firstQuestion.value = true;
  }

  void bookmarkThis({required BuildContext context}) {
    if (watchlist.contains(financialInstrumentSymbol.value)) {
      bookmarked.value = Icons.bookmark_border_outlined;
      watchlist.remove(financialInstrumentSymbol.value);
      PrefsService.to.prefs
          .setStringList(SharedPreferencesConstant.watchlist, watchlist);
    } else {
      if (watchlist.length >= 16) {
        Get.snackbar(
            'notice'.tr,
            colorText: AppColor.whiteColor,
            backgroundColor: AppColor.errorColor,
            icon: const Icon(Icons.error),
            'watchlist_max'.tr);
      } else {
        bookmarked.value = Icons.bookmark_outlined;
        watchlist.add(financialInstrumentSymbol.value);
        PrefsService.to.prefs
            .setStringList(SharedPreferencesConstant.watchlist, watchlist);
        showScaffoldMessenger(
          context: context,
          localizedMsg: 'bookmarked'.tr,
        );
      }
    }
  }

  List<PopupMenuEntry<String>> popMenuItems() {
    List<PopupMenuEntry<String>> watchlistMenuItems;
    if (watchlist.isEmpty) {
      watchlistMenuItems = [
        PopupMenuItem<String>(
          value: 'watchlistEmpty',
          child: Text(
            'watchlistEmpty'.tr,
            style: const TextTheme().sp4.primaryTextColor,
          ),
        ),
      ];
    } else {
      watchlistMenuItems = watchlist.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: ListTile(
            leading: Icon(
              Icons.bookmark_outlined,
              color: ThemeColor.primary.value,
            ),
            title: Text(
              item,
              style: const TextTheme().sp4.primaryTextColor,
            ),
          ),
        );
      }).toList();
    }
    return watchlistMenuItems;
  }

  refreshIndicator() {
    futureListCandledata.value = init();
  }

  alwaysShowAnalyticsToggle(bool value) {
    alwaysShowAnalytics.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysShowAnalytics, value);
  }

  alwaysShowSdDistPlotToggle(bool value) {
    alwaysShowSdDistPlot.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysShowSdDistPlot, value);
  }

  alwaysSkipSymbolInSearchToggle(bool value) {
    alwaysSkipSymbolInSearch.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysSkipSymbolInSearch, value);
  }

  alwayStrictMatchCriteriaToggle(bool value) {
    alwayStrictMatchCriteria.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwayStrictMatchCriteria, value);
    strictMatchCriteria.value = value;
  }

  alwayMaMatchCriteriaToggle(bool value) {
    alwaysMaMatchCriteria.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysMaMatchCriteria, value);
    maMatchCriteria.value = value;
  }

  alwaysThousandthsDataToggle(bool value) {
    alwaysThousandthsData.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysThousandthsData, value);
  }

  alwaysShowMinuteDataToggle(bool value, BuildContext context) {
    if (!isLockTrend.value) {
      alwaysShowMinuteData.value = value;
      PrefsService.to.prefs
          .setBool(SharedPreferencesConstant.alwaysShowMinuteData, value);
      dataGranularity.value = (value ? Icons.timer_outlined : Icons.today);
      if (value) {
        legends.value = '🟠EMA5 🔴EMA10 🟢EMA15 🔵EMA20';
        showScaffoldMessenger(
            context: context, localizedMsg: 'show_one_minute');
      } else {
        legends.value = '🟠SMA5 🔴SMA20 🟢SMA60 🔵SMA120 🟣SMA240';
        showScaffoldMessenger(context: context, localizedMsg: 'show_one_day');
        alwaysUseCrossDataToggle(value, context);
      }
      futureListCandledata.value = init();
    } else {
      showScaffoldMessenger(
          context: context, localizedMsg: 'lock_trend_alert'.tr);
    }
  }

  alwaysUseCrossDataToggle(bool value, BuildContext context) {
    alwaysUseCrossData.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.alwaysUseCrossData, value);
    crossData.value = (value ? Icons.dataset_linked : Icons.dataset);
    if (value) {
      showScaffoldMessenger(context: context, localizedMsg: 'cross_data');
    } else {
      showScaffoldMessenger(context: context, localizedMsg: 'cross_data_off');
    }
    futureListCandledata.value = init();
  }

  closePosWhenReachedMedianToggle(bool value) {
    closePosWhenReachedMedian.value = value;
    PrefsService.to.prefs
        .setBool(SharedPreferencesConstant.closePosWhenReachedMedian, value);
    checkLockTrend();
  }

  showApiKeyInput() {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'notice'.tr,
        colorText: AppColor.whiteColor,
        backgroundColor: AppColor.errorColor,
        icon: const Icon(Icons.error),
        'api_key'.tr,
        duration: const Duration(seconds: 60),
        userInputForm: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: apiKey.value,
                  decoration: InputDecoration(
                    errorStyle: const TextTheme().sp4.whiteColor,
                    hintText: 'api_key'.tr,
                    hintStyle: const TextTheme().sp5.whiteColor,
                    prefixIcon: const Icon(Icons.key),
                    prefixIconColor: AppColor.whiteColor,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'api_key_validation'.tr;
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    apiKey.value = value!;
                    PrefsService.to.prefs.setString(
                        SharedPreferencesConstant.apiKey, apiKey.value);
                    apiKeyErr.value = '';
                    PrefsService.to.prefs
                        .setString(SharedPreferencesConstant.apiKeyErr, '');
                    if (!isLockTrend.value) {
                      TrendMatch().init();
                      SubsequentAnalytics().init();
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Get.closeCurrentSnackbar();
                  }
                },
                child: Text(
                  'submit'.tr,
                  style: const TextTheme().sp5,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget showApiKeyReminder() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ElevatedButton.icon(
        onPressed: () {
          showApiKeyInput();
        },
        icon: Icon(
          Icons.key_off,
          size: 5.h,
        ),
        label: Text(
          'apikey_reminder'.tr,
          style: const TextTheme().sp5.w700,
        ),
      ),
    );
  }

  Widget showMinuteDataToggleBtn({required BuildContext context}) {
    if (hasMinuteData.value) {
      return IconButton(
        onPressed: () =>
            alwaysShowMinuteDataToggle(!alwaysShowMinuteData.value, context),
        icon: Obx(
          () => Icon(
            dataGranularity.value,
          ),
        ),
        color: ThemeColor.primary.value,
        iconSize: 10.h,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget showCrossDataToggleBtn({required BuildContext context}) {
    if (hasMinuteData.value && alwaysShowMinuteData.value) {
      return IconButton(
        onPressed: isButtonDisabled.value
            ? () => showScaffoldMessenger(
                context: context,
                localizedMsg: 'backtesting_disturbance_detected'.tr)
            : () =>
                alwaysUseCrossDataToggle(!alwaysUseCrossData.value, context),
        icon: Obx(
          () => Icon(
            crossData.value,
          ),
        ),
        color: ThemeColor.primary.value,
        iconSize: 10.h,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void showScaffoldMessenger(
      {required BuildContext context, required String localizedMsg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(
        child: Text(
          localizedMsg.tr,
          style: const TextTheme().sp5.greyColor,
        ),
      ),
    ));
  }

  String getLastDatetime() {
    if (candleListList.isNotEmpty) {
      var lastDatetime = candleListList.last[0];
      // print(lastDatetime);
      try {
        if (alwaysShowMinuteData.value && hasMinuteData.value) {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              lastDatetime.toInt() * 1000,
              isUtc: true);
          DateTime subtractedDateTime =
              TimeService.to.subtractHoursBasedOnTimezone(dateTime);
          lastDatetime =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(subtractedDateTime);
          String timezone =
              TimeService.to.isEasternDaylightTime(dateTime) ? 'EDT' : 'EST';
          return '${'as_of'.tr} $lastDatetime $timezone';
        } else {
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              lastDatetime.toInt() * 1000,
              isUtc: true);
          DateTime subtractedDateTime =
              TimeService.to.subtractHoursBasedOnTimezone(dateTime);
          lastDatetime = DateFormat('yyyy-MM-dd').format(subtractedDateTime);
          return '${'as_of'.tr} $lastDatetime.';
        }
      } catch (e) {
        return 'Failed to fetch datetime';
      }
    } else {
      return 'Loading';
    }
  }

  String showCandleListListLastItem({required int i}) {
    if (candleListList.isNotEmpty) {
      return candleListList.last[i].toStringAsFixed(4);
    } else {
      return 'Loading';
    }
  }

  Widget showCandlestickChart(
      {required AsyncSnapshot<List<CandleData>> snapshot}) {
    if (hasCandleData.value) {
      return Obx(
        () => SizedBox(
          width: 393.w,
          height: candleChartHeight.value,
          child: InteractiveChart(
            candles: (snapshot.data!.length > 1000
                ? snapshot.data!
                    .sublist(snapshot.data!.length - 999, snapshot.data!.length)
                : snapshot.data!),
            style: ChartStyle(
              trendLineStyles: [
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.orange,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.red,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.green,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.blue[700]!,
                Paint()
                  ..strokeWidth = 1.0
                  ..strokeCap = StrokeCap.round
                  ..color = Colors.purple[300]!,
                // Paint()
                //   ..strokeWidth = 1.0
                //   ..strokeCap = StrokeCap.round
                //   ..color = Colors.yellow,
              ],
              selectionHighlightColor: Colors.red.withOpacity(0.75),
              overlayBackgroundColor: Colors.red.withOpacity(0.75),
              overlayTextStyle: const TextStyle(color: AppColor.whiteColor),
            ),
            /** Callbacks */
            // onTap: (candle) => print("user tapped on $candle"),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: ThemeColor.primary.value,
              size: 25.w,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child:
                  Text('downloading_candle'.tr, style: const TextTheme().sp5),
            ),
          ],
        ),
      );
    }
  }

  Widget showMatchedCandlestickChart(
      {required AsyncSnapshot<List<CandleData>> snapshot}) {
    List<CandleData> listCandle = snapshot.data!;
    if (hasCandleData.value) {
      return SizedBox(
        width: 393.w,
        height: candleChartHeight.value,
        child: InteractiveChart(
          candles: listCandle,
          style: ChartStyle(
            trendLineStyles: [
              Paint()
                ..strokeWidth = 1.0
                ..strokeCap = StrokeCap.round
                ..color = Colors.orange,
              Paint()
                ..strokeWidth = 1.0
                ..strokeCap = StrokeCap.round
                ..color = Colors.red,
              Paint()
                ..strokeWidth = 1.0
                ..strokeCap = StrokeCap.round
                ..color = Colors.green,
              Paint()
                ..strokeWidth = 1.0
                ..strokeCap = StrokeCap.round
                ..color = Colors.blue[700]!,
              Paint()
                ..strokeWidth = 1.0
                ..strokeCap = StrokeCap.round
                ..color = Colors.purple[300]!,
            ],
            selectionHighlightColor: Colors.red.withOpacity(0.75),
            overlayBackgroundColor: Colors.red.withOpacity(0.75),
            overlayTextStyle: const TextStyle(color: AppColor.whiteColor),
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: ThemeColor.primary.value,
              size: 25.w,
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child:
                  Text('downloading_candle'.tr, style: const TextTheme().sp5),
            ),
          ],
        ),
      );
    }
  }

  Widget showMatchesExceededMsg() {
    if (matchRows.length > 500) {
      return Text('more_than_500_matches'.tr, style: const TextTheme().sp5);
    } else {
      return const SizedBox.shrink();
    }
  }
}
